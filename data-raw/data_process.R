library(readr)


KRSA_Mapping_STK_PamChip_87102_v1 <- read.table("data-raw/KRSA_Mapping_STK_PamChip_87102_v1.txt",
                        header = TRUE, sep = "\t", as.is=T, quote = "\"",
                        check.names=FALSE, stringsAsFactors=FALSE)

KRSA_Mapping_PTK_PamChip_86402_v1 <- read.table("data-raw/KRSA_Mapping_PTK_PamChip_86402_v1.txt",
                            header = TRUE, sep = "\t", as.is=T, quote = "\"",
                            check.names=FALSE, stringsAsFactors=FALSE)

KRSA_coverage_STK_PamChip_87102_v1 <- readRDS("data-raw/KRSA_coverage_STK_PamChip_87102_v1.rds")

KRSA_layout_STK_PamChip_87102_v1 <- readr::read_tsv("data-raw/STK-87102-Array-Layout.txt")

KRSA_layout_PTK_PamChip_86402_v1 <- readr::read_tsv("data-raw/PTK-86402-Array-Layout.txt")

KRSA_uka_mapping_PTK_PamChip_86402_v1 <- readr::read_csv("data-raw/uka_pep2kinase_PTK.csv")

KRSA_uka_mapping_STK_PamChip_87102_v1 <- readr::read_csv("data-raw/uka_pep2kinase_STK.csv")

#removed pdk
KRSA_coverage_STK_PamChip_87102_v1 %>% dplyr::filter(Kin != "PDK") -> KRSA_coverage_STK_PamChip_87102_v2

KRSA_coverage_PTK_PamChip_86402_v1 <- readRDS("data-raw/KRSA_coverage_PTK_PamChip_86402_v1.rds")

ballModel_nodes <- readRDS("data-raw/FinNodes_Final_FF.rds")
ballModel_edges <- readRDS("data-raw/FinEdges_Final_FF.rds")

usethis::use_data(KRSA_Mapping_STK_PamChip_87102_v1,
                  KRSA_Mapping_PTK_PamChip_86402_v1,
                  KRSA_coverage_STK_PamChip_87102_v1,
                  KRSA_coverage_STK_PamChip_87102_v2,
                  KRSA_coverage_PTK_PamChip_86402_v1,
                  KRSA_layout_PTK_PamChip_86402_v1,
                  KRSA_layout_STK_PamChip_87102_v1,
                  KRSA_uka_mapping_PTK_PamChip_86402_v1,
                  KRSA_uka_mapping_STK_PamChip_87102_v1,
                  ballModel_nodes,
                  ballModel_edges,
                  overwrite = T)

