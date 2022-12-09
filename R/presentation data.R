library(tidyverse)

options(scipen=999)

data <- data.frame(search = c("compare","compare","topic","topic"),
                      query	= c("simple","filterNHP","simple","filterNHP"),
                      pubMed	= c(79312,249606,1299,2856),
                      psycINFO	= c(35131,56107,747,1038),
                      WoS	= c(94474,279877,1501,3008))

data2 <- data %>%
  gather(key = "source",
         value = "numPubs",-search,-query)

data2$query <- ordered(data2$query, levels = c("simple", "filterNHP"))

ggplot(subset(data2,search == "compare"), aes(source,numPubs,fill = query)) +
  geom_bar(stat="identity", position=position_dodge()) +
  scale_y_continuous("Number of publications",breaks = c(75000,150000,225000)) +
  scale_x_discrete("Bibliographic source",
                   labels = c("psycINFO" = "PsycINFO",
                              "WoS" = "Web of\nScience",
                              "pubMed" = "PubMed")) +
  scale_fill_manual(name = "Search\nmethod",
                     values = c("#99d8c9","#2ca25f"), labels = c("Simple", "NHP search\nfilter"))+
 labs(tag = "(a)")+
  theme_bw()+
  theme(axis.title.x = element_text(lineheight = 5,size = 24, family = "Arial"),
        axis.title.y = element_text(size = 24, family = "Arial"),
        axis.text.y = element_text(size = 20, family = "Arial"),
        legend.title = element_text(size = 20, family = "Arial"),
        plot.tag = element_text(size = 20, family = "Arial"),
        legend.key.height=unit(2,"line"),
        legend.text = element_text(size = 18, family = "Arial"),
        axis.text.x = element_text(size = 20, family = "Arial"),
        panel.grid.minor = element_blank())


ggsave(plot = last_plot(),paste0("comparison figure_",
                                 format(as.Date(Sys.time()),"%Y%m%d"),".tiff"),
       width = 20, height = 14, units = "cm")


ggplot(subset(data2,search == "topic"), aes(source,numPubs,fill = query)) +
  geom_bar(stat="identity", position=position_dodge()) +
  scale_y_continuous("Number of publications") +
  scale_x_discrete("Bibliographic source",
                   labels = c("psycINFO" = "PsycINFO",
                              "WoS" = "Web of\nScience",
                              "pubMed" = "PubMed")) +
  scale_fill_manual(name = "Search\nmethod",
                    values = c("#99d8c9","#2ca25f"), labels = c("Simple", "NHP search\nfilter"))+
  labs(tag = "(b)")+
  theme_bw()+
  theme(axis.title.x = element_text(lineheight = 5,size = 24, family = "Arial"),
        axis.title.y = element_text(size = 24, family = "Arial"),
        axis.text.y = element_text(size = 20, family = "Arial"),
        axis.text.x = element_text(size = 20, family = "Arial"),
        legend.title = element_text(size = 20, family = "Arial"),
        plot.tag = element_text(size = 20, family = "Arial"),
        legend.key.height=unit(2,"line"),
        legend.text = element_text(size = 14, family = "Arial"),
        panel.grid.minor = element_blank())


ggsave(plot = last_plot(),paste0("topic figure_",
                                 format(as.Date(Sys.time()),"%Y%m%d"),".tiff"),
       width = 20, height = 14, units = "cm")
