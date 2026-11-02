library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)

N_CORES <- 16  # from `nproc` linux command hehe

# Before Execution = base_stats (idle); In Execution = each framework's own scenario only
stats <- tribble(
  ~framework, ~state,             ~cpu,   ~mem,
  "PySpark",  "Before Execution",    1.56,  14.46,
  "PySpark",  "In Execution",     1106.50,  22.56,
  "MongoDB",  "Before Execution",    1.30,   0.46,
  "MongoDB",  "In Execution",       25.81,   0.67,
  "Hadoop",   "Before Execution",    3.48,  10.47,
  "Hadoop",   "In Execution",      296.75,  14.62
) %>%
  mutate(framework = factor(framework, levels = c("PySpark", "MongoDB", "Hadoop")),
         state = factor(state, levels = c("Before Execution", "In Execution")))

long <- stats %>%
  pivot_longer(c(cpu, mem), names_to = "metric", values_to = "value") %>%
  mutate(metric = factor(metric, levels = c("cpu", "mem"),
                         labels = c("CPU %  (100% = 1 core)", "Memory %  (of 14.96 GiB)")))

# Reference lines only on the CPU panel
cpu_panel <- factor("CPU %  (100% = 1 core)", levels = levels(long$metric))
core_lines <- tibble(metric = cpu_panel,
                     y = c(100, N_CORES * 100),
                     label = c("1 core", paste0(N_CORES, " cores")))

p <- ggplot(long, aes(x = framework, y = value, fill = state)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  geom_hline(data = core_lines, aes(yintercept = y),
             linetype = "dashed", colour = "grey40", linewidth = 0.4) +
  geom_text(data = core_lines, aes(x = 0.45, y = y, label = label),
            inherit.aes = FALSE, hjust = 0, vjust = -0.5,
            size = 3, colour = "grey30", family = "Courier New") +
  geom_text(aes(label = round(value, 1)),
            position = position_dodge(width = 0.8),
            vjust = -0.5, size = 3.4, family = "Courier New") +
  facet_wrap(~ metric, scales = "free_y") +
  scale_fill_manual(values = c("Before Execution" = "#BDBDBD", "In Execution" = "#E8420F")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  
  labs(title = "Container resource usage: Before vs. In Execution",
       x = NULL, y = NULL, fill = NULL) +
  theme_minimal(base_size = 12, base_family = "Courier New") +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "italic", size = 9),
        strip.text = element_text(face = "bold", hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "grey40", fill = NA, linewidth = 0.6),
        panel.spacing.x = unit(1.5, "lines"))

print(p)