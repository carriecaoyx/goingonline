---
  title: "Experiment analysis"
output:
  html_document:
  df_print: paged
---
  
  
  ```{r load_libraries}

library(tidyverse)
library(ggplot2)
theme_set(theme_bw())



```

#### Load data

```{r load_data}

data = read.csv("production_expectation_experiment_trials_t-processed.csv")

```

data <- data %>%
  mutate(scale = case_when(
    slider_0 == "I'm gonna lie down for a while" ~ "for a while, for a bit, for some time"
  ))

# Turn data into long format
data_long <- data %>%
  dplyr::select(workerid, response_0, response_1, response_2, 
                response_3, rt, slider_0, slider_1, slider_2, 
                slider_3, time_value, scale) %>% 
  tidyr::pivot_longer(cols = matches("response_|slider_"), 
                      names_to = c(".value", "slider"), 
                      names_pattern = "(response_|slider_)(.)", 
                      values_drop_na = TRUE) %>%
  dplyr::rename(response = response_,
                utterance = slider_)

# Map slider values to desired labels
data_long <- data_long %>%
  mutate(utterance = case_when(
    utterance == "0" ~ "a while",
    utterance == "1" ~ "a bit",
    utterance == "2" ~ "some time",
    TRUE ~ utterance  # Retain original values for any other case
  ))

# Plot the data
data_long %>%
  filter(!(workerid %in% c(11,12,37,51,61))) %>%
  dplyr::group_by(time_value, utterance, scale) %>%
  dplyr::summarize(response = mean(response)) %>%
  ggplot(aes(x = time_value, y = response, col = utterance)) + 
  geom_line() + 
  facet_wrap(~scale, ncol = 1) +
  theme(legend.position = "bottom")



