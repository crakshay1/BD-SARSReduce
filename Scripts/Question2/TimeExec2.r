library(ggplot2)

execution_times <- data.frame(
  Framework = c("Hadoop", "MongoDB", "PySpark"),
  Time = c(22.610, 0.006, 0.4927)
)

execution_times$Framework <- factor(
  execution_times$Framework,
  levels = c("Hadoop", "MongoDB", "PySpark")
)

ggplot(execution_times, aes(x = Framework, y = Time, fill = Framework)) +
  geom_col(width = 0.6) +
  geom_text(
    aes(label = paste0(Time, " s")),
    vjust = -0.5,
    size = 4
  ) +
  labs(
    title = "Execution Time Comparison",
    x = "Framework",
    y = "Execution time (seconds)"
  ) +
  scale_fill_manual(values = c(
    "Hadoop" = "#E76F51",
    "MongoDB" = "#2A9D8F",
    "PySpark" = "#457B9D"
  )) +
  theme_minimal(base_size = 12, base_family = "Courier New") +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "italic"),
    axis.title = element_text(face = "bold")
  ) +
  expand_limits(y = 22)

