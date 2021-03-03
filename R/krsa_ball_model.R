#' Generates a kinase ball model using the Z score table
#'
#' This function takes in a Z score table and produces a kinase ball model
#'
#' @param kinase_hits a vector of kinases
#' @param Ztable Z score table
#' @param frq = cutoff for number of connections with other nodes
#' @param Nsize = size of nodes scale
#' @param Tsize = size of text scale
#'
#' @return igraph network
#'
#'
#' @export
#'
#' @examples
#' TRUE

krsa_ball_model <- function(kinase_hits, Ztable,frq, Nsize, Tsize) {

  Ztable %>%
    dplyr::rename(MeanZ = .data$AvgZ) %>%
    dplyr::mutate(breaks = cut(abs(.data$MeanZ), breaks = c(0, 1, 1.5, 2, Inf),
                        right = F,
                        labels = c("Z <= 1", "1 >= Z < 1.5", "1.5 >= Z < 2", "Z >= 2"))) -> Ztable

  nodes2 <- ballModel_nodes
  edges <- ballModel_edges

  nodes2 %>%
    dplyr::filter(.data$FinName %in% Ztable$Kinase) %>%
    dplyr::pull(.data$FinName) -> sigHITS

  edges %>%
    dplyr::filter(.data$Source %in% sigHITS | .data$Target %in% sigHITS, .data$Source != .data$Target) -> modEdges

  modsources <- dplyr::pull(modEdges, .data$Source)
  modtargets <- dplyr::pull(modEdges, .data$Target)

  modALL <- unique(c(modsources,modtargets))

  nodes2 %>%
    dplyr::filter(.data$FinName %in% modALL) -> nodesF

  edges %>%
    dplyr::filter(.data$Source %in% nodesF$FinName & .data$Target %in% nodesF$FinName, .data$Source != .data$Target) -> modEdges

  modEdges %>%
    dplyr::mutate(line = ifelse(.data$Source %in% sigHITS | .data$Target %in% sigHITS, 2,1 )) -> modEdges

  modsources <- dplyr::pull(modEdges, .data$Source)
  modtargets <- dplyr::pull(modEdges, .data$Target)

  modALL <- c(modsources,modtargets)
  as.data.frame(table(modALL)) -> concts

  concts %>%
    dplyr::rename(FinName = .data$modALL) -> concts

  concts$FinName <- as.character(concts$FinName)

  dplyr::right_join(nodesF,concts) -> nodesF


  nodesF %>%
    dplyr::left_join(dplyr::select(Ztable, .data$Kinase, .data$breaks) %>%
                       dplyr::distinct(), by = c("FinName"= "Kinase")) %>%
    dplyr::mutate(cl = dplyr::case_when(
      .data$breaks == "1 >= Z < 1.5" ~ "#FCAE91",
      .data$breaks == "Z <= 1" ~ "#FEE5D9",
      .data$breaks == "1.5 >= Z < 2" ~ "#FB6A4A",
      .data$breaks == "Z >= 2" ~ "#CB181D",
      T ~ "grey"
  )) -> nodesF

  nodesF %>%
    dplyr::filter(.data$Freq>=frq| !.data$cl %in% c("grey", "#FEE5D9", "#FCAE91")) %>% dplyr::pull(.data$FinName) -> FinKinases

  modEdges %>%
    dplyr::filter(.data$Source %in% FinKinases & .data$Target %in% FinKinases) -> modEdges

  nodesF %>%
    dplyr::filter(.data$FinName %in% FinKinases) %>%
    dplyr::mutate(Freq = ifelse(.data$Freq < 4, 4, .data$Freq) )-> nodesF

  net <- igraph::graph_from_data_frame(d=modEdges, vertices=nodesF, directed=T)
  net <- igraph::simplify(net,remove.loops = F, remove.multiple = F)

  igraph::V(net)$size = log2(igraph::V(net)$Freq)*Nsize
  colrs <- c("#FEE5D9", "#FCAE91", "#FB6A4A", "#CB181D", "grey")
  igraph::V(net)$color <- igraph::V(net)$cl

  colrs2 <- c("gray", "black")
  igraph::E(net)$color <- colrs2[igraph::E(net)$line]

  plot(net, edge.arrow.size=.05,vertex.label=igraph::V(net)$FinName,vertex.label.color = "black",vertex.label.cex=log2(igraph::V(net)$Freq)/Tsize, layout = igraph::layout_in_circle)

  graphics::legend("bottomleft", c("Z <= 1", "1 >= Z < 1.5", "1.5 >= Z < 2", "Z >= 2", "NA"), pch=21,
         col="#777777", pt.bg=colrs, pt.cex=2, cex=.8, bty="n", ncol=1)

}
