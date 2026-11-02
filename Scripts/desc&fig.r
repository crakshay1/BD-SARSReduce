library(dplyr)

covid <- read.csv("Téléchargements/Projet3/ecdc_covid19_cases.xls",
                  na.strings = "", stringsAsFactors = FALSE)
# Namibia was considered as NA which is not a None value !

write.csv(
  covid,
  "Téléchargements/Projet3/covid.csv",
  row.names = FALSE,
  na = ""
) # For the MR approaches later !

# Size of dataset
summary(covid)
dim(covid)

# Names of columns and stats
str(covid)
summary(covid)

# Range of dates and number of weeks
range(covid$date)                      
n_distinct(covid$year_week)

# Countries and continent
n_distinct(covid$countriesAndTerritories)    
table(covid$continentExp)                    

# Quality of data : can lead to eventual problems for benchmark...
colSums(is.na(covid))      
sum(covid$cases_weekly < 0)                  
sum(covid$deaths_weekly < 0)                 



# Summary (Thanks to gt library), Google docs is hard to handle with tables...
library(gt)
columns <- data.frame(
  Column = colnames(covid),
  Description = c(
    "Date associated with the reported data.",
    "Year and week corresponding to the observation.",
    "Number of new COVID-19 cases reported during the week.",
    "Number of new COVID-19 deaths reported during the week.",
    "Name of the territory associated with the observation.",
    "Two-letter geographical identifier for the territory.",
    "Three-letter territory code.",
    "Estimated population of the territory in 2019.",
    "Continent assigned to the territory.",
    "COVID-19 notification rate over 14 days per 100,000 inhabitants, used to compare the spread of the virus across populations of different sizes."
  )
)

columns |>
  gt::gt() |>
  gt::cols_label(
    Column = "Column",
    Description = "Description"
  ) |>
  gt::tab_style(
    style = gt::cell_text(weight = "bold", align = "center"),
    locations = gt::cells_column_labels()
  ) |>
  gt::opt_row_striping() |>
  gt::tab_options(
    table.font.size = gt::px(13),
    data_row.padding = gt::px(6),
    table_body.hlines.style = "none",
    table.border.top.style = "none",
    table.border.bottom.style = "none",
    column_labels.border.top.style = "solid",
    column_labels.border.bottom.style = "solid"
  )


# Pearson correlation !

names(covid)[names(covid) == "notification_rate_per_100000_population_14.days"] <- "rate_14d"
# Name is too long to display on figures
vars <- c("cases_weekly", "deaths_weekly", "popData2019", "rate_14d")
# Only numerical variables

cor_matrix <- round(cor(covid[, vars], use = "pairwise.complete.obs", method = "pearson"), 3)
rownames(cor_matrix) <- c(
  "Cases weekly", "Deaths weekly", "Population", "14-day rate"
)
as.data.frame(cor_matrix)
cor_matrix |>
  as.data.frame() |>
  tibble::rownames_to_column("Variable") |>
  gt::gt() |>
  gt::fmt_number(
    columns = -Variable,
    decimals = 3
  ) |>
  gt::cols_label(
    Variable = "Variable",
    cases_weekly = "Cases weekly",
    deaths_weekly = "Deaths weekly",
    popData2019 = "Population",
    rate_14d = "14-day rate"
  ) |>
  gt::tab_style(
    style = gt::cell_text(weight = "bold"),
    locations = list(
      gt::cells_column_labels(),
      gt::cells_body(columns = Variable)
    )
  ) |>
  gt::cols_align(
    align = "center",
    columns = everything()
  ) |>
  gt::opt_row_striping() |>
  gt::tab_options(
    table.font.size = gt::px(13),
    data_row.padding = gt::px(6),
    table_body.hlines.style = "none",
    table.border.top.style = "none",
    table.border.bottom.style = "none",
    column_labels.border.top.style = "solid",
    column_labels.border.bottom.style = "solid"
  )


# Recap of questions and MapReduce approaches 
library(tibble)
approaches <- tribble(
  ~Question, ~`Research Question`, ~`MapReduce Approach`,
  
  "1",
  "Relationship between weekly cases and deaths across countries",
  "**Map**: Associate each country and week with its reported case and death counts.\n\n**Reduce**: Group observations by country and calculate the Pearson correlation between weekly cases and deaths for each country.",
  
  "2",
  "Association between population size and COVID-19 case and death counts",
  "**Map**: Associate each country with its population and reported case and death counts.\n\n**Reduce**: Aggregate case and death counts by country, retain one population value per country, and calculate the associations between population size and total cases and deaths.",
  
  "3",
  "Variation in the deaths-to-cases ratio",
  "**Map**: Associate each country and continent with its reported case and death counts.\n\n**Reduce**: Aggregate case and death counts by country and continent, then calculate the ratio of total reported deaths to total reported cases for each group.",
  
  "4",
  "Differences in reported cases and deaths across continents",
  "**Map**: Associate each continent with the reported case and death counts from each observation.\n\n**Reduce**: Aggregate reported cases and deaths by continent to compare the total numbers across geographical regions.",
  
  "5",
  "Epidemic peaks by continent",
  "**Map**: Associate each continent and week with its reported case and death counts.\n\n**Reduce**: Aggregate weekly case and death counts by continent, then identify the week or weeks with the highest values for cases and deaths in each continent."
)

approaches |>
  gt::gt() |>
  gt::cols_label(
    Question = "No.",
    `Research Question` = "Research Question",
    `MapReduce Approach` = "MapReduce Approach"
  ) |>
  gt::fmt_markdown(columns = "MapReduce Approach") |>
  gt::cols_width(
    Question ~ px(45),
    `Research Question` ~ px(230),
    `MapReduce Approach` ~ px(500)
  ) |>
  gt::cols_align(
    align = "center",
    columns = Question
  ) |>
  gt::tab_style(
    style = gt::cell_text(weight = "bold"),
    locations = list(
      gt::cells_column_labels(),
      gt::cells_body(columns = Question)
    )
  ) |>
  gt::tab_style(
    style = gt::cell_text(align = "center"),
    locations = gt::cells_column_labels()
  ) |>
  gt::tab_options(
    table.font.size = gt::px(12),
    data_row.padding = gt::px(10),
    table_body.hlines.style = "solid",
    table_body.hlines.color = "#D9D9D9",
    table.border.top.style = "solid",
    table.border.bottom.style = "solid",
    column_labels.border.top.style = "solid",
    column_labels.border.bottom.style = "solid",
  )

