# =============================================================================
# data-raw/parse_array_layouts.R
#
# Purpose
#   Read PamChip-style peptide-array layout files and write a clean CSV next to
#   each input file. The files come in several flavours and are not always
#   consistently delimited, so the script reads each file's header and adapts.
#
#   Layouts seen so far (all are handled by the same code):
#
#     PTK  e.g. "PTK-86402-Array-Layout.txt"
#          Row Col ID Sequence Tyr SpotConc UniprotAccession Description Xoff Yoff
#
#     STK  e.g. "STK-87102-Array-Layout.txt"
#          Row Col ID Sequence Ser Thr SpotConc UniprotAccession Description Xoff Yoff
#
#     STK without SpotConc, properly tab-delimited with quoted fields,
#          e.g. "STK-87202-Array-Layout.txt"
#          Row Col ID Sequence Ser Thr UniprotAccession Description Xoff Yoff
#
#   Differences between flavours:
#     * the block of phospho-site columns after `Sequence` (Tyr, or Ser + Thr)
#     * whether a `SpotConc` column is present (it is optional)
#     * delimiters (tabs, runs of spaces, or a mix) and double-quoted fields
#
# Why read_tsv()/read_table() fail on some of these files
#   * Some lines use tabs, others use a variable number of spaces.
#   * Descriptions contain spaces, so "split on every space" breaks them.
#   * The site columns contain spaces inside brackets, e.g. "[383, 390]".
#   * Some lines contain invalid bytes glued to the UniProt accession.
#   * Reference spots have ID "#REF", which looks like a comment character.
#   * A few IDs contain a stray space (e.g. "H2B1B_ 27_40").
#   * Some fields are wrapped in double quotes, e.g. "[303, 304]".
#
# Strategy
#   1. NORMALIZE: fix encoding, replace junk bytes with spaces, remove the
#      double quotes, collapse every run of whitespace (tabs included) to a
#      single space, repair IDs split by a stray space.
#   2. PARSE: do not split on delimiters. Build one regular expression from the
#      file's own header and anchor on the predictable parts of each line (two
#      integers at the start, bracketed site lists, two numbers at the end).
#      The free-text Description absorbs whatever is left in the middle.
#   3. VALIDATE: fail loudly on unparsed lines; warn on suspicious content.
#   4. WRITE: save a CSV with the same file stem into data-raw/.
#
# Usage
#   Run from anywhere inside the project (here() finds the project root).
#   Input and output both live in <project root>/data-raw/.
# =============================================================================

library(here) # project-root-relative paths
library(readr) # write_csv()
library(dplyr) # mutate(), across(), filter(), count()
library(stringr) # regex helpers (ICU regex engine)
library(tibble) # as_tibble()

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

# Folder holding the raw layout files; the CSVs are written here too.
data_raw_dir <- here("data-raw")

# Which files to process: every file in data-raw/ ending in "Array-Layout.txt".
# This matches all PTK and STK files. Change it if your naming differs.
layout_pattern <- "Array-Layout\\.txt$"

# Header structure shared by all layout flavours:
#   <head_cols> <one or more site columns> [SpotConc] <tail_cols>
# SpotConc is optional; everything else is required.
head_cols <- c("Row", "Col", "ID", "Sequence")
tail_cols <- c("UniprotAccession", "Description", "Xoff", "Yoff")

# Site columns we accept between the head and the (optional) SpotConc/tail.
# Anything else in that position means a layout we have not seen, so the
# script stops rather than guessing. Add names here (e.g. "His") if a new
# array type appears.
allowed_site_cols <- c("Tyr", "Ser", "Thr")

# -----------------------------------------------------------------------------
# Step 1: normalize
# -----------------------------------------------------------------------------

#' Read a layout file and return clean, single-space-separated lines.
#'
#' @param path Path to the raw .txt file.
#' @return Character vector; element 1 is the header, the rest are data lines.
normalize_layout_lines <- function(path) {
    # Read as latin1 so that no byte sequence can raise an "invalid multibyte
    # string" error. Every byte maps to some character; we clean up below.
    lines <- readLines(path, encoding = "latin1", warn = FALSE)

    # Convert to plain ASCII. Anything outside ASCII (stray bytes, non-breaking
    # spaces, a byte-order mark, replacement characters) becomes a SPACE rather
    # than being deleted, so it can never glue two fields together.
    lines <- iconv(lines, from = "latin1", to = "ASCII", sub = " ")

    # Remove double quotes. Some files wrap fields that contain commas or
    # brackets in quotes (CSV-style), e.g. "[303, 304]" or a long description.
    # The quotes are only wrapping, not data, and would otherwise stop the
    # bracket groups and the Description from matching cleanly. (None of the
    # layout files contain meaningful embedded quotes.) The quotes are removed
    # before whitespace is collapsed so no extra spaces are left behind.
    lines <- str_remove_all(lines, "\"")

    # str_squish() trims both ends and collapses every run of whitespace
    # (tabs, multiple spaces, mixtures) into ONE space. After this step the
    # original delimiter chaos is gone: fields are separated by single spaces,
    # and so are the words inside descriptions. That is fine, because step 2
    # does not rely on spaces to find field boundaries.
    lines <- str_squish(lines)

    # Drop blank lines (e.g. a trailing newline at the end of the file).
    lines <- lines[lines != ""]

    # Repair IDs split by a stray space, e.g. "H2B1B_ 27_40" -> "H2B1B_27_40".
    # Without this the ID would be read as "H2B1B_" and the Sequence as "27_40".
    # The pattern is anchored to the ID position (after Row and Col), so spaces
    # inside Descriptions are never touched. The header cannot match because it
    # does not start with two integers.
    id_split <- "^(-?\\d+ -?\\d+ \\S+_) (\\d)"
    hit <- str_detect(lines, id_split)
    if (any(hit)) {
        message(
            "  repaired ", sum(hit), " ID(s) split by a stray space: ",
            paste(
                str_match(lines[hit], "^-?\\d+ -?\\d+ (\\S+_) (\\S+)")[, 2:3, drop = FALSE] |>
                    apply(1, paste, collapse = " "),
                collapse = ", "
            )
        )
        lines <- str_replace(lines, id_split, "\\1\\2")
    }

    lines
}

# -----------------------------------------------------------------------------
# Step 2: read the header, build the regex, parse
# -----------------------------------------------------------------------------

#' Validate the header line and extract the column names.
#'
#' The header must look like:
#'   Row Col ID Sequence <site cols> [SpotConc] UniprotAccession Description Xoff Yoff
#' where <site cols> is one or more of `allowed_site_cols`.
#'
#' @return list(cols = all column names, site_cols = the site columns,
#'              has_spotconc = TRUE/FALSE)
parse_header <- function(header_line, label) {
    cols <- str_split_1(header_line, " ")
    n <- length(cols)
    idx <- seq_len(n)

    head_ok <- identical(cols[seq_along(head_cols)], head_cols)
    tail_ok <- n >= length(tail_cols) &&
        identical(cols[(n - length(tail_cols) + 1):n], tail_cols)

    # Whatever sits between the head and tail columns is the "middle" block:
    # the site columns, optionally followed by SpotConc.
    middle <- cols[idx > length(head_cols) & idx <= n - length(tail_cols)]
    has_spotconc <- length(middle) > 0 && tail(middle, 1) == "SpotConc"
    site_cols <- if (has_spotconc) head(middle, -1) else middle

    if (!(head_ok && tail_ok && length(site_cols) > 0 &&
        all(site_cols %in% allowed_site_cols))) {
        stop(label, ": unexpected header.\n  found: ",
            paste(cols, collapse = " "),
            "\n  expected: ", paste(head_cols, collapse = " "),
            " <", paste(allowed_site_cols, collapse = "/"), " columns> ",
            "[SpotConc] ", paste(tail_cols, collapse = " "),
            call. = FALSE
        )
    }

    list(cols = cols, site_cols = site_cols, has_spotconc = has_spotconc)
}

#' Build the line regex for a layout.
#'
#' Reading left to right (every group is separated by a single space, which
#' step 1 guarantees):
#'
#'   Row, Col     integers, possibly negative (reference spots use negatives)
#'   ID           one token with no spaces (may contain "#", "(", ")" ...)
#'   Sequence     one token with no spaces (may contain "(pS)", "(pY)", ...)
#'   site cols    n_site groups, each "[...]" (may hold spaces/commas or be
#'                empty "[]") or the literal NA. One group for PTK (Tyr),
#'                two for STK (Ser, Thr).
#'   SpotConc     a number or NA   (only if the header has this column)
#'   Uniprot      one token with no spaces (or NA); may include an isoform
#'                suffix such as "P05771-2"
#'   Description  anything at all, matched LAZILY so it stops as early as
#'                possible while still letting the two trailing numbers match;
#'                wrapped in an optional group so a missing description gives NA
#'   Xoff, Yoff   two numbers anchored at the END of the line
build_line_pattern <- function(n_site, has_spotconc) {
    site_group <- " (\\[[^\\]]*\\]|NA)"
    spotconc_group <- if (has_spotconc) " (\\d+(?:\\.\\d+)?|NA)" else ""

    paste0(
        "^(-?\\d+)", # Row
        " (-?\\d+)", # Col
        " (\\S+)", # ID
        " (\\S+)", # Sequence
        strrep(site_group, n_site), # Tyr  -or-  Ser, Thr
        spotconc_group, # SpotConc (if present)
        " (\\S+)", # UniprotAccession
        "(?: (.*?))?", # Description (lazy, optional)
        " (-?\\d+(?:\\.\\d+)?)", # Xoff
        " (-?\\d+(?:\\.\\d+)?)$" # Yoff
    )
}

#' Parse normalized data lines into a tibble.
#'
#' @param data_lines Character vector of normalized data lines (no header).
#' @param cols       Column names from the header (length must equal the
#'                   number of capture groups in the pattern).
#' @param pattern    Regex from build_line_pattern().
#' @return list(parsed = tibble, failed = indices of unmatched lines)
parse_layout_lines <- function(data_lines, cols, pattern) {
    # str_match() returns a character matrix: column 1 is the full match,
    # columns 2.. are the capture groups. Lines that do not match are all-NA.
    m <- str_match(data_lines, pattern)

    failed <- which(is.na(m[, 1]))
    ok <- !is.na(m[, 1])

    parsed <- m[ok, -1, drop = FALSE] |> # drop the "full match" column
        as_tibble(.name_repair = "minimal") |>
        setNames(cols) |>
        mutate(
            # Numeric columns: the literal string "NA" converts to NA with a
            # harmless coercion warning, so suppress only that expected warning.
            # any_of() makes SpotConc optional.
            across(c(Row, Col), ~ suppressWarnings(as.integer(.x))),
            across(
                any_of(c("SpotConc", "Xoff", "Yoff")),
                ~ suppressWarnings(as.numeric(.x))
            ),

            # Character columns: convert the literal "NA"/"" to real missing values
            # so they are written (and re-read) consistently. Note that "[]" is
            # kept as-is: it means "no site of this residue type", which is
            # different from NA ("not applicable", e.g. reference spots).
            across(where(is.character), ~ na_if(.x, "NA")),
            across(where(is.character), ~ na_if(.x, ""))
        )

    list(parsed = parsed, failed = failed)
}

# -----------------------------------------------------------------------------
# Step 3: validate
# -----------------------------------------------------------------------------

#' Sanity-check a parsed layout and report anything odd.
#' Hard problems stop() the script; soft problems only warn().
validate_layout <- function(df, file_label) {
    # Reference spots have negative Row/Col and ID "#REF"; real peptides do not.
    peptides <- filter(df, Row > 0, Col > 0)

    # (a) Each real (Row, Col) position must be unique: two spots can't share a
    #     location on the array.
    dup_pos <- peptides |>
        count(Row, Col) |>
        filter(n > 1)
    if (nrow(dup_pos) > 0) {
        warning(file_label, ": ", nrow(dup_pos),
            " duplicated Row/Col position(s).",
            call. = FALSE
        )
        print(dup_pos)
    }

    # (b) Duplicate IDs are not necessarily wrong (a peptide can be spotted
    #     twice), but they are worth knowing about.
    dup_ids <- peptides |>
        count(ID) |>
        filter(n > 1)
    if (nrow(dup_ids) > 0) {
        message(file_label, ": ", nrow(dup_ids), " ID(s) appear more than once.")
    }

    # (c) The array is a rectangle: every Row should have the same number of
    #     spots (14 for the PTK array, 12 for the STK arrays). A ragged result
    #     usually means a line was merged or lost.
    per_row <- peptides |> count(Row)
    if (n_distinct(per_row$n) > 1) {
        warning(file_label, ": rows do not all have the same number of spots:\n",
            paste(capture.output(print(per_row)), collapse = "\n"),
            call. = FALSE
        )
    }

    # (d) Peptide sequences should be one-token amino-acid strings. Flag
    #     anything containing characters other than letters, "(" and ")".
    #     Phospho-residues such as "(pS)" are legitimate.
    odd_seq <- peptides |> filter(!str_detect(Sequence, "^[A-Za-z()]+$"))
    if (nrow(odd_seq) > 0) {
        warning(file_label, ": ", nrow(odd_seq),
            " sequence(s) contain unexpected characters.",
            call. = FALSE
        )
        print(odd_seq |> select(Row, Col, ID, Sequence))
    }

    # (e) Coordinates should be numeric everywhere.
    bad_num <- df |> filter(is.na(Row) | is.na(Col) | is.na(Xoff) | is.na(Yoff))
    if (nrow(bad_num) > 0) {
        stop(file_label, ": ", nrow(bad_num),
            " line(s) have non-numeric Row/Col/Xoff/Yoff.",
            call. = FALSE
        )
    }

    invisible(df)
}

# -----------------------------------------------------------------------------
# Step 4: put it together for one file
# -----------------------------------------------------------------------------

#' Normalize, parse, validate and return one layout file as a tibble.
read_layout <- function(path) {
    label <- basename(path)
    message(label, ":")

    lines <- normalize_layout_lines(path)
    if (length(lines) < 2) stop(label, ": file has no data lines.", call. = FALSE)

    # --- header: decides which regex to build --------------------------------
    hdr <- parse_header(lines[1], label)
    pattern <- build_line_pattern(length(hdr$site_cols), hdr$has_spotconc)
    message(
        "  site columns: ", paste(hdr$site_cols, collapse = " + "),
        " | SpotConc: ", if (hdr$has_spotconc) "yes" else "no"
    )

    # --- parse ----------------------------------------------------------------
    data_lines <- lines[-1]
    res <- parse_layout_lines(data_lines, hdr$cols, pattern)

    # Any line the pattern rejected is reported with its text so it can be
    # inspected (line number refers to the normalized file, header = line 1).
    if (length(res$failed) > 0) {
        bad <- data.frame(line = res$failed + 1, text = data_lines[res$failed])
        print(bad, right = FALSE)
        stop(label, ": ", length(res$failed),
            " line(s) could not be parsed (listed above).",
            call. = FALSE
        )
    }

    # --- validate -------------------------------------------------------------
    validate_layout(res$parsed, label)

    message(
        "  parsed ", nrow(res$parsed), " rows (",
        sum(res$parsed$Row < 0), " reference spots)."
    )

    res$parsed
}

# -----------------------------------------------------------------------------
# Step 5: run over all layout files and write CSVs
# -----------------------------------------------------------------------------

layout_files <- list.files(data_raw_dir,
    pattern = layout_pattern,
    full.names = TRUE
)

if (length(layout_files) == 0) {
    stop("No files matching '", layout_pattern, "' found in ", data_raw_dir,
        call. = FALSE
    )
}

for (path in layout_files) {
    layout <- read_layout(path)

    # Output goes next to the input: data-raw/<same stem>.csv
    out_path <- here(
        "data-raw",
        paste0(tools::file_path_sans_ext(basename(path)), ".csv")
    )

    # write_csv() quotes fields containing commas or quotes automatically
    # (the site and Description columns need this) and writes NA as "NA".
    write_csv(layout, out_path)
    message("  -> wrote ", out_path)
}

# -----------------------------------------------------------------------------
# Notes
# -----------------------------------------------------------------------------
# * Reference spots (ID "#REF", negative Row/Col) are kept in the CSV so the
#   output is a faithful copy of the layout. Drop them downstream with
#   dplyr::filter(Row > 0).
# * Site columns (Tyr, or Ser and Thr) are kept as the original bracketed
#   strings, e.g. "[1974, 1981, 1983]". "[]" means no site of that type and
#   NA means not applicable.
# * Layouts without a SpotConc column produce a CSV without that column. If
#   you later bind several layouts together, dplyr::bind_rows() fills the
#   missing column with NA.
# * Descriptions are stored as found. Many have fused words (e.g.
#   "heavychain", "Complementcomponent") because line wraps in the source were
#   removed without a space. That is a property of the source data.
# * The script edits source text in two places, both in step 1: it removes
#   wrapping double quotes, and it repairs IDs split by a stray space (e.g.
#   "H2B1B_ 27_40" becomes "H2B1B_27_40"; each repair is reported).
# * To re-read a CSV later: readr::read_csv(here("data-raw", "<file>.csv")).
