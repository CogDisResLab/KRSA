# Example of animating random sampling

krsa(sigPeps$meanLFC$`0.2`, return_count = T) -> fin

fin$count_mtx %>% rename(Kinase = Kin) %>%
  filter(Kinase %in% "DMPK") %>%
  group_by(Kinase, itr,counts) %>% summarise(n = n()) %>% ungroup() %>%
  complete(counts, nesting(Kinase,itr), fill = list(n = 0))  %>%
  group_by(Kinase,counts) %>%
  mutate(sum = cumsum(n)) %>% ungroup() %>%
  select(-n) %>%
  distinct() -> temp_anim


temp_anim %>% left_join(fin$KRSA_Table[fin$KRSA_Table$Kinase == "DMPK",1:2]) %>%
  ggplot() +
  geom_col(aes(counts, sum),position = "identity") +
  gganimate::transition_time(itr) +
  facet_wrap(~Kinase) +
  theme_bw() +
  labs(title = 'Iteration: {round(frame_time)}',
       x = "Number of mapped peptides hits",
       y = "Cumulative sum of mapped peptides hits"
  ) -> p1

p1

gganimate::anim_save("rand_sampling_DMPK.gif")

krsa_histogram_plot(fin$KRSA_Table,fin$count_mtx , "DMPK") -> p2
p2$layers[[3]] <- NULL

p2 +
  labs(x = "Number of mapped peptides hits",
       y = "Cumulative sum of mapped peptides hits")-> p2


krsa_histogram_plot(fin$KRSA_Table,fin$count_mtx , "DMPK") +
  labs(x = "Number of mapped peptides hits",
       y = "Cumulative sum of mapped peptides hits") +
  annotate(
    geom = "curve", x = 40.75, y = 250, xend = 40, yend = 250,
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  ) +
  annotate(geom = "text", x = 40.8, y = 250,
           label = "The experimental number of mapped hits", hjust = "left",
           size = 3) +
  xlim(24,50) -> p3

ggsave("rand_sampling_DMPK_1.png", p2)
ggsave("rand_sampling_DMPK_2.png", p3)
