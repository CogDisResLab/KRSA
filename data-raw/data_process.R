library(readr)


KRSA_Mapping_STK_PamChip_87102_v1 <- read.table("data-raw/KRSA_Mapping_STK_PamChip_87102_v1.txt",
                        header = TRUE, sep = "\t", as.is=T, quote = "\"",
                        check.names=FALSE, stringsAsFactors=FALSE)

KRSA_Mapping_PTK_PamChip_86402_v1 <- read.table("data-raw/KRSA_Mapping_PTK_PamChip_86402_v1.txt",
                            header = TRUE, sep = "\t", as.is=T, quote = "\"",
                            check.names=FALSE, stringsAsFactors=FALSE)

KRSA_coverage_STK_PamChip_87102_v1 <- readRDS("data-raw/KRSA_coverage_STK_PamChip_87102_v1.rds")
KRSA_coverage_PTK_PamChip_86402_v1 <- readRDS("data-raw/KRSA_coverage_PTK_PamChip_86402_v1.rds")

ballModel_nodes <- readRDS("data-raw/FinNodes_Final_FF.rds")
ballModel_edges <- readRDS("data-raw/FinEdges_Final_FF.rds")

usethis::use_data(KRSA_Mapping_STK_PamChip_87102_v1,
                  KRSA_Mapping_PTK_PamChip_86402_v1,
                  KRSA_coverage_STK_PamChip_87102_v1,
                  KRSA_coverage_PTK_PamChip_86402_v1,
                  ballModel_nodes,
                  ballModel_edges,
                  overwrite = T)

