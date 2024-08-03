library(tidyverse)
library(splines)
library(DescTools)

d = read.csv("C:/Users/supernova/Downloads/resultsfromProliferate/adaptation_experiment_trials_q-processed.csv")
d = d %>% 
  rename(rating_bit = response_0 , rating_while = response_1) %>%
  group_by(workerid, proliferate.condition, time_value) %>%
  summarise( rating_bit = mean(rating_bit), rating_while = mean(rating_while) )

aucs_bit = c()
aucs_while = c()

workerid_bit = d %>% filter(proliferate.condition == "30_bit") %>%
  .$workerid %>% unique(.)

workerid_while = d %>% filter(proliferate.condition == "30_while") %>%
  .$workerid %>% unique(.)

for (w in workerid_bit) {
  d.participant = d %>% filter(workerid == w)
  time_values = d.participant$time_value
  ratings_bit = d.participant$rating_bit
  ratings_while = d.participant$rating_while
  
  auc_bit= AUC(x=time_values, y=ratings_bit, method="spline")
  auc_while= AUC(x=time_values, y=ratings_while, method="spline")
  auc_diff = auc_bit - auc_while 
  aucs_bit = rbind(aucs_bit, c(auc_diff))
}

for (w in workerid_while) {
  d.participant = d %>% filter(workerid == w)
  time_values = d.participant$time_value
  ratings_bit = d.participant$rating_bit
  ratings_while = d.participant$rating_while
  
  auc_bit= AUC(x=time_values, y=ratings_bit, method="spline")
  auc_while= AUC(x=time_values, y=ratings_while, method="spline")
  auc_diff = auc_bit - auc_while 
  aucs_while = rbind(aucs_while, c(auc_diff))
}


t.test(aucs_bit, aucs_while, paired = FALSE)
