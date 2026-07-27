library(httr2)
library(dplyr)
library(purrr)
library(stringr)
library(lubridate)
library(yaml)

# ---------------------------
# 1. Settings
# ---------------------------

org <- "sodascience"

# Optional, but needed for private repos
# Sys.setenv(GITHUB_PAT = "your_token_here")
token <- Sys.getenv("GITHUB_PAT")

# ---------------------------
# 2. GitHub API helper
# ---------------------------

github_get <- function(url, token = token) {
  req <- request(url) |>
    req_headers(
      "Accept" = "application/vnd.github+json",
      "X-GitHub-Api-Version" = "2022-11-28"
    )
  
  if (!is.null(token) && token != "") {
    req <- req |> req_auth_bearer_token(token)
  }
  
  req |>
    req_perform() |>
    resp_body_json(simplifyVector = FALSE)
}

# ---------------------------
# 3. Get all repos
# ---------------------------

get_all_repos <- function(org, token = "") {
  page <- 1
  all_repos <- list()
  
  repeat {
    url <- paste0(
      "https://api.github.com/orgs/", org,
      "/repos?per_page=100&type=all&page=", page
    )
    
    repos <- github_get(url, token)
    
    if (length(repos) == 0) break
    
    all_repos <- c(all_repos, repos)
    page <- page + 1
  }
  
  all_repos
}

repos <- get_all_repos(org, token)

# ---------------------------
# 4. Convert to clean table
# ---------------------------

repo_df <- map_dfr(repos, function(x) {
  tibble(
    repo = x$name,
    full_name = x$full_name,
    description = x$description %||% NA_character_,
    url = x$html_url,
    private = x$private,
    visibility = ifelse(x$private, "Private", "Public"),
    archived = x$archived,
    language = x$language %||% "Unknown",
    topics = paste(x$topics %||% character(0), collapse = "; "),
    created_at = as_date(x$created_at),
    updated_at = as_date(x$updated_at),
    pushed_at = as_date(x$pushed_at),
    stars = x$stargazers_count,
    watchers = x$watchers_count,
    forks = x$forks_count,
    size_kb = x$size,
    default_branch = x$default_branch,
    has_issues = x$has_issues,
    has_projects = x$has_projects,
    has_wiki = x$has_wiki,
    has_pages = x$has_pages,
    license = x$license$name %||% NA_character_
  )
})

# ---------------------------
# 5. Add derived variables
# ---------------------------

repo_df <- repo_df |>
  mutate(
    days_inactive = as.numeric(Sys.Date() - pushed_at),
    
    activity_status = case_when(
      is.na(pushed_at) ~ "Unknown",
      days_inactive <= 180 ~ "Active: <6 months",
      days_inactive <= 365 ~ "Inactive: 6-12 months",
      days_inactive <= 730 ~ "Inactive: 1-2 years",
      TRUE ~ "Legacy: >2 years"
    ),
    
    has_description = !is.na(description) & description != "",
    has_license = !is.na(license),
    
    topic_text = str_to_lower(coalesce(topics, "")),
    
    research_topic = case_when(
      str_detect(topic_text, "\\b(llm|nlp|machine-learning|artificial-intelligence)\\b") ~
        "AI & NLP",
      
      str_detect(topic_text, "\\b(health|mental-health|disease|vaccine|population-based)\\b") ~
        "Health & Population Studies",
      
      str_detect(topic_text, "\\b(questionnaire|social-science|psychology|whatsapp|data-donation)\\b") ~
        "Social Science & Survey Research",
      
      str_detect(topic_text, "\\b(economics|causal-inference|mediation-analysis)\\b") ~
        "Economics & Public Policy",
      
      str_detect(topic_text, "\\b(cbs|microdata|micro-data|open-data|national-statistics|official-statistics)\\b") ~
        "Official Statistics & Administrative Data",
      
      str_detect(topic_text, "\\b(infrastructure|data-pipeline|scraping|crawler|extractor|docker|cluster-computing)\\b") ~
        "Data Engineering & Infrastructure",
      
      str_detect(topic_text, "\\b(dashboard|shiny-app|shiny-apps|data-visualization)\\b") ~
        "Visualization & Applications",
      
      str_detect(topic_text, "\\b(geospatial|geospatial-data|mapping|osrm|overpass-api|sodapy)\\b") ~
        "Geospatial Analysis",
      
      str_detect(topic_text, "\\b(bayesian-inference|inference|statistical-metadata|statistics)\\b") ~
        "Statistical Methods",
      
      str_detect(topic_text, "\\b(synthetic-data|privacy|disclosure-control|metasyn)\\b") ~
        "Synthetic Data & Privacy",
      
      str_detect(topic_text, "\\b(history|art)\\b") ~
        "History & Humanities",
      
      str_detect(topic_text, "\\b(awesome-list|list|workshop|project-management)\\b") ~
        "Resources / Project Support",
      
      TRUE ~ "Other / Needs manual review"
    )
  ) |>
  select(-topic_text)

# ---------------------------
# 6. Recommendations
# ---------------------------

repo_df <- repo_df |>
  mutate(
    recommendation = case_when(
      private == FALSE &
        days_inactive <= 365 &
        has_description &
        has_license &
        (stars >= 1 | forks >= 1 | has_pages == TRUE) ~
        "Promote",
      
      days_inactive > 365 &
        (has_description | has_license | stars >= 1 | forks >= 1) ~
        "Needs update",
      
      days_inactive > 730 ~
        "Legacy / retain for record",
      
      days_inactive <= 365 ~
        "Maintain",
      
      TRUE ~
        "Manual review"
    ),
    
    suggested_action = case_when(
      recommendation == "Promote" ~
        "Consider adding tutorial, example workflow, README improvements, or project page.",
      
      recommendation == "Needs update" ~
        "Review dependencies, documentation, reproducibility, and whether the repo is still actively useful.",
      
      recommendation == "Legacy / retain for record" ~
        "Keep for reproducibility or historical record; add a note explaining project status if needed.",
      
      recommendation == "Maintain" ~
        "Keep maintained; periodically review documentation, issues, and dependencies.",
      
      TRUE ~
        "Manually inspect purpose, ownership, topic, and current relevance."
    )
  )

# ---------------------------
# EXPORT SECTION
# 3 outputs:
# 1. github_repos_raw.yaml
# 2. github_repos_overview.yaml
# 3. github_repo_landscape.xlsx
# ---------------------------

library(yaml)
library(openxlsx)

# ---------------------------
# 1. RAW YAML
# Complete repo-level metadata
# ---------------------------

raw_df <- repo_df |>
  arrange(repo) |>
  as.data.frame()

raw_yaml <- split(raw_df, raw_df$repo)

write_yaml(
  raw_yaml,
  "output/github_repos_raw.yaml"
)


# ---------------------------
# 2. OVERVIEW YAML
# Summary-level view, similar to Excel summary sheets
# ---------------------------

overview_yaml <- list(
  metadata = list(
    organization = org,
    generated_on = as.character(Sys.Date()),
    total_repositories = nrow(repo_df)
  ),
  
  by_topic = repo_df |>
    count(research_topic, sort = TRUE) |>
    as.data.frame(),
  
  by_activity = repo_df |>
    count(activity_status, sort = TRUE) |>
    as.data.frame(),
  
  by_language = repo_df |>
    count(language, sort = TRUE) |>
    as.data.frame(),
  
  by_recommendation = repo_df |>
    count(recommendation, sort = TRUE) |>
    as.data.frame(),
  
  private_inactive = repo_df |>
    filter(private == TRUE, days_inactive > 180) |>
    arrange(desc(days_inactive)) |>
    select(
      repo,
      research_topic,
      activity_status,
      days_inactive,
      pushed_at,
      recommendation
    ) |>
    as.data.frame(),
  
  update_candidates = repo_df |>
    filter(recommendation == "Needs update") |>
    arrange(desc(days_inactive)) |>
    select(
      repo,
      research_topic,
      activity_status,
      days_inactive,
      pushed_at,
      suggested_action
    ) |>
    as.data.frame(),
  
  promotion_candidates = repo_df |>
    filter(recommendation == "Promote") |>
    arrange(research_topic, repo) |>
    select(
      repo,
      research_topic,
      language,
      stars,
      forks,
      has_pages,
      suggested_action
    ) |>
    as.data.frame()
)

write_yaml(
  overview_yaml,
  "output/github_repos_overview.yaml"
)


# ---------------------------
# 3. EXCEL EXPORT
# Human-readable dashboard-style file
# ---------------------------

wb <- createWorkbook()

addWorksheet(wb, "Inventory")
writeData(wb, "Inventory", repo_df)

addWorksheet(wb, "By Topic")
writeData(
  wb,
  "By Topic",
  repo_df |> count(research_topic, sort = TRUE)
)

addWorksheet(wb, "By Activity")
writeData(
  wb,
  "By Activity",
  repo_df |> count(activity_status, sort = TRUE)
)

addWorksheet(wb, "By Language")
writeData(
  wb,
  "By Language",
  repo_df |> count(language, sort = TRUE)
)

addWorksheet(wb, "By Recommendation")
writeData(
  wb,
  "By Recommendation",
  repo_df |> count(recommendation, sort = TRUE)
)

addWorksheet(wb, "Private Inactive")
writeData(
  wb,
  "Private Inactive",
  repo_df |>
    filter(private == TRUE, days_inactive > 180) |>
    arrange(desc(days_inactive))
)

addWorksheet(wb, "Update Candidates")
writeData(
  wb,
  "Update Candidates",
  repo_df |>
    filter(recommendation == "Needs update") |>
    arrange(desc(days_inactive))
)

addWorksheet(wb, "Promotion Candidates")
writeData(
  wb,
  "Promotion Candidates",
  repo_df |>
    filter(recommendation == "Promote") |>
    arrange(research_topic, repo)
)

saveWorkbook(
  wb,
  "output/github_repo_landscape.xlsx",
  overwrite = TRUE
)

