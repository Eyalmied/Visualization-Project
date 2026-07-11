# Indian Flights Dashboard — Visualization of Information Course Project

## Document Guide (what is where)

This file is the single source of truth for the project — written so that a person (or an LLM assistant) with **zero prior context** can read it top to bottom and know exactly what the course requires, what the group decided, and what to build. Sections, in order:

1. **Document Guide** (this section) — how to navigate the file.
2. **Project Instructions (Assignment Rubric in Full)** — the actual grading requirements, transcribed from the course's assignment slide (`Project image.jpeg`). Read this first if the question is "what does the course want us to submit?"
3. **Course Lecture Summary** — a per-lecture digest of all 11 lecture PDFs in this folder, covering the theory/tools/chart-types taught in each. Read this if the question is "why did we choose this chart/interaction/tool, and which lecture backs it up?" Every citation elsewhere in this document (e.g. "Lecture 9: violin beats boxplot") refers back to this section.
4. **Context** — the specific problem/dataset/stack decisions made for *this* project (not generic course content).
5. **Repository Structure** — the file layout of the actual R Shiny app to be built.
6. **Data Processing** — exact cleaning/feature-engineering steps for `airlines_flights_data.csv`.
7. **Chart Set** — the 9 charts to build, each with its theory justification.
8. **Interaction Design** — how the course's "9 interaction operators" concept maps to concrete Shiny widgets.
9. **Dashboard Layout** — how the two tabs are arranged on screen.
10. **Team Task Breakdown (4 people)** — ordered, dateless steps per group member.
11. **Report Structure** — how the final written report maps to the rubric, section by section.
12. **Verification** — how to manually confirm the finished app actually works.

Related files in the project folder: `airlines_flights_data.csv` (the raw dataset, 300,153 rows), `Project image.jpeg` (source of the rubric transcribed in §Project Instructions), and 11 lecture PDFs named `Visualization of Information Lecture 0X ....pdf` / `Lecture 04 2026.pdf` (source of §Course Lecture Summary). Nothing in the project folder has been built yet — no `app.R`, `R/`, `data/`, `report/`, or `scripts/` directories exist yet; §Repository Structure below describes what will be created.

## Project Instructions (Assignment Rubric in Full)

Transcribed and organized from the course's assignment slide (`Project image.jpeg`, titled "Assignment - new"). This is the literal grading rubric — every deliverable below must be present in the final submission.

**1. Problem Definition**
- Define a Data Science / analytics problem.
- Explain target users and decision-support goals.
- Explain how the interactive app helps solve the problem.

**2. Data Understanding**
- Data source and structure.
- Exploratory analysis (trends, outliers, patterns).
- Visual summaries and insights.

**3. Data Processing**
- Cleaning, transformations, feature engineering.
- Explain why transformations were needed.

**4. Visualization & Interaction Design**
- Explain visualization choices.
- Describe interactions and user flow.
- Justify design decisions.

**5. AI Usage Documentation (NEW requirement this year)**
- List AI tools used (ChatGPT, Claude, Copilot, etc.).
- Document important prompts used.
- Specify which AI capabilities/skills were used: code generation, debugging, UI design, data analysis, visualization suggestions, refactoring, documentation, idea generation.
- Explain how AI outputs were validated/corrected.

**6. Evaluation & Reflection**
- Strengths and limitations of the system.
- What AI helped with vs. human decisions.
- Lessons learned and future improvements.

**7. Deliverables**
- Report.
- Source code.
- AI prompt appendix.
- Working demo (10–15 minute presentation).

**Public dataset guidance** (from a separate slide): datasets may come from Kaggle (kaggle.com/datasets), NASDAQ market data, or similar public sources, or the course textbook (Ware, §2.4, p.73) — this project uses Kaggle's "Flight Price Prediction" dataset (Indian domestic flights), already downloaded as `airlines_flights_data.csv`.

**Logistics** (from Lecture 11's final slide, dated 2026-07-11 in-class): submission deadline is **Sunday, 2026-07-19**. No regular class 14:00–16:00 on 2026-07-15; instead there are two possible **presentation slots**: **2026-07-15, 18:00–20:00** or **2026-07-16, 20:00–21:00**. The 10–15 minute demo requirement is satisfied by presenting the live Shiny app in one of these slots.

**What this means concretely**: the group must (a) pick a real analytics problem framed around real target users, (b) show genuine exploratory/data-understanding work (not just charts — actual insight-finding), (c) justify every cleaning/transformation step, (d) build a working interactive app (not static charts) and justify every visualization/interaction choice against course theory, (e) keep an honest running log of AI tool usage with prompts and how AI output was checked/corrected, (f) critically reflect on the result, and (g) hand in a report + code + AI-prompt appendix + present the live app for 10–15 minutes.

## Course Lecture Summary

Digest of all 11 lecture PDFs in the project folder, in order. Use this section to understand *why* a given chart type, encoding, or interaction was chosen elsewhere in this document — every "Cite: Lecture N ..." reference throughout this file points back here.

**Lecture 1 — Data Visualization in Data Science (Intro)**
Frames visualization as a communication channel (transmitter → channel → receiver, with noise/bias) and stresses *visual integrity*: a chart must answer "compared to what?" (Tufte's Connecticut traffic-deaths example shows how adding context/comparison groups prevents misleading charts). Introduces **Anscombe's Quartet** to prove "statistics is not the data" — identical means/variance/correlation can produce very different scatterplots, i.e. always look at the data visually, not just its summary stats. Covers the "7 Steps of Machine Learning" and where visualization fits at each step. Chart types shown: line/time-series, scatterplots, SPLOM, heatmaps, dendrograms, density-cluster plots, contour/perspective plots, profit curves, cumulative gains, ROC/AUC, SHAP summary plots. Tools: R (`igraph`), PowerBI, gen-AI viz tools mentioned as a course topic. Also covers model interpretability (glass-box vs black-box, SHAP vs LIME). This lecture contains the **first appearance of the course project rubric**: use real data, real coding, document AI-assisted development, tie the work to the 7 ML steps.

**Lecture 2 — Introduction: Why/What/How, Semiology, Visual Variables, Taxonomy**
Core visualization pipeline: raw data → data tables → visual structures → visualization. History: Minard's Napoleon map, Playfair's national debt chart, Nightingale's coxcomb chart. **Bertin's Semiology of Graphics**: marks (points/lines/areas), positional vs. retinal variables, and the **8 visual variables** — position, size, shape, value, orientation, color, texture, motion — each rated on selectivity/associativity/quantitativeness/order/length. **Cleveland & McGill's ranking of graphical-perception accuracy**: position on a common scale > position non-aligned > length/angle > area > volume > shading. This ranking is the single most-cited piece of theory in this project — it's the direct justification for preferring bars/position over pie slices/area/volume. Also: Mackinlay's APT, Colin Ware's perception model, pre-attentive processing, Shneiderman's 7 data types, and **Shneiderman's Visual Information Seeking Mantra**: "Overview first, zoom/filter, details-on-demand."

**Lecture 3 — Human Perception & Information Processing**
Psychophysics: Weber's Law (just-noticeable-difference ∝ stimulus intensity) and **Stevens' Power Law** (perceived magnitude = stimulus^exponent), with concrete exponents: bar length ≈1.0 (accurate), area ≈0.7 (underestimated), volume ≈0.6 (discouraged), color saturation ≈0.3–0.5. This is a direct, numeric rubric for choosing encodings — it's why this project avoids pie/bubble/3D-volume charts in favor of bar length and position. Also covers mental models, cognitive offload, information foraging theory, and pre-attentive vs. attentive processing theories (Feature Integration Theory, Texton theory, Similarity theory, Guided Search).

**Lecture 4 — Data Sources and Data Processing**
Data types (nominal/categorical, ordinal, binary/discrete/continuous) and data structures (scalars/vectors/tensors, time-series granularity). Preprocessing techniques: missing-value handling, normalization, dimensionality reduction (PCA, MDS), detrending, time-series decomposition, smoothing (moving averages, LOESS/LOWESS, splines), and **log-transforming skewed/exponential data** (`scale_y_log10()` in ggplot2) to make trends linearly perceivable — directly informs this project's log-scale toggle on the price histogram, since `price` is right-skewed (1,105–123,071). Tools taught: **R/RStudio installation, ggplot2 code examples** (`geom_smooth`, `scale_y_log10`). Public data sources: Kaggle, NASDAQ. This lecture has the **updated project rubric**: Problem Definition, Data Understanding, Data Processing, Visualization & Interaction Design, AI-usage documentation, Evaluation & Reflection.

**Lecture 5 — Visualization Methods for Temporal and Multi-Dimensional Data**
Aigner's What/Why/How model for time-oriented data. Covers time-axis mapping (classic linear, spirals/3D for cycles), affine transformations, static vs. dynamic (animated) representations. Chart types: line charts, **TimeWheel** (radial parallel-coordinates for multivariate time data), parallel coordinates. Color-coding principles for skewed data. Introduces **Shneiderman's mantra + Keim's extended mantra** (Analyze First — Show the Important — Zoom/Filter/Analyze Further — Details on Demand) and first lists the **9 interaction operators**: Select, Explore, Reconfigure, Encode, Abstract/Elaborate, Filter, Connect, Undo/Redo, Change configuration — the framework this project's entire Interaction Design section is built on.

**Lecture 6 — Interactive Visualizations with Shiny R / PowerBI / AI tools**
The lecture this project's tech-stack choice is based on. Shows a **full R Shiny `app.R` structure**: `ui`/`server`/`shinyApp(ui, server)`, `fluidPage`, `sidebarLayout`, control widgets (`actionButton`, `sliderInput`, `selectInput`, `dateInput`), reactive rendering (`renderPlot`). Full worked examples: a **choropleth map** (`percent_map()`, `maps`/`mapproj` packages) and a **stockVis** app (`quantmod::getSymbols`). Also covers MCP (Model Context Protocol), AI-generated dashboards, and PowerBI/Python-Dash as alternatives. Contains the **rubric slide requiring AI usage documentation** for the first time (list tools, document prompts, explain capabilities used, explain validation).

**Lecture 7 — In-Depth Interaction Principles/Methods**
Deep dive on each of the 9 interaction operators with concrete R/Shiny/Plotly code examples: **jittering** (Reconfigure, `jitter()`), **zoom/pan/brush** (Plotly demos), **linked brushing** across parallel coordinates + scatterplot matrix (Shiny demo, iris dataset) — directly informs this project's "Connect" operator implementation. Introduces the **interaction-space framework** (Focus, Extents, Transformation, Blender parameters) used to describe any interaction operator formally. Uses real COVID-19 dashboards to show Reconfigure/Encode/Abstract-Elaborate/Filter/Connect operators in practice.

**Lecture 8 — From Lie & Truth in Information Presentation to Dashboards**
**Tufte's Lie Factor**: size of effect shown ÷ size of effect in the data; >1.05 or <0.95 means the chart is distorting reality. **Data-ink ratio** ("above all else show the data") — minimize non-data pixels, avoid chart junk. Then **Stephen Few's dashboard theory**: a dashboard is "the most important information, consolidated on a single screen, monitored at a glance." Covers dashboard categorization (role, data type, span, frequency, interactivity), common mistakes (excessive detail, poor arrangement, misused color, meaningless decoration). This is the direct source of this project's single-screen, no-scroll-chasing dashboard layout.

**Lecture 9 — Visualization of Statistical Information & Visual Analytics in ML**
A **"directory of visualizations organized by task"** — the primary reference used to pick this project's 9 charts: Amounts (bar, dot plot, heatmap), Distributions (histogram, density/KDE, boxplot, **violin/sina/ridgeline** — explicitly better than boxplot for bimodal/many-group data), Proportions (pie, stacked/grouped bar, mosaic, treemap, parallel sets), x-y relationships (scatterplot, **bubble chart — criticized** for dual position+size encoding, SPLOM, correlogram, slopegraph), Uncertainty (error bars, confidence bands). Also explicitly notes heatmaps are good for broad trend but weak for exact-value readout. **This lecture contains the exact "Assignment - new" slide transcribed in full in §Project Instructions above**, plus the "Public Data Sets" slide (Kaggle/NASDAQ) and the "R for next class" install slide.

**Lecture 10 — Text/Document Visualizations & Graphs, Networks, Trees**
Vector space model, TF-IDF, Zipf's Law, tokenization. Chart types: word clouds, word trees, TextArc, ThemeRiver (temporal text); force-directed node-link graphs, adjacency matrices, tree layouts (node-link, treemap, radial/icicle), fisheye lens for focus+context. **Not directly applicable to this project** — the flights dataset has no text/document or network/graph structure — but included here for completeness since it's part of the full course.

**Lecture 11 — Comparison and Evaluation of Visualizations + Story Telling**
Contains the **course logistics slide** (submission deadline, presentation slot options — see §Project Instructions). Evaluation methods: usability tests, expert/domain-expert review, field tests, case studies, benchmarking (hypothesis → experiment → execution → analysis) — relevant to this project's Evaluation & Reflection report section (noting these formal methods weren't performed due to time, only informal team walkthroughs). Effective-design steps: match encoding to data type, intuitive mappings, color best practices (grayscale-safe, accessible, semantic). **Pyramid Principle** (Minto/McKinsey) for storytelling — lead with the main message/answer, then MECE-structured supporting arguments, then evidence — this project's recommended structure for both the report's Evaluation section and the live 10–15 min demo.

## Context

This is a course project for "Visualization of Information." The assignment slide (`Project image.jpeg`) requires building an **interactive app** around a real dataset, with a report covering: Problem Definition, Data Understanding, Data Processing, Visualization & Interaction Design, AI Usage Documentation, Evaluation & Reflection, and Deliverables (report, source code, AI prompt appendix, 10–15 min working demo).

The chosen dataset is `airlines_flights_data.csv` — the Kaggle "Flight Price Prediction" dataset: 300,153 rows of Indian domestic flights across 6 airlines and 6 cities (30 routes), columns `index, airline, flight, source_city, departure_time, stops, arrival_time, destination_city, class, duration, days_left, price`. No real dates (only `days_left`, a 1–49 booking-lead-time integer) and no lat/long (city names only).

Eleven lecture PDFs were surveyed to ground every visualization/interaction decision in the course's own taught theory (Bertin's visual variables, Cleveland–McGill perceptual ranking, Stevens' Power Law, Tufte's Lie Factor/data-ink ratio, Shneiderman's mantra, the 9 interaction operators, Lecture 9's chart-directory-by-task, Stephen Few's dashboard principles, and Lecture 11's Pyramid Principle for storytelling). Citing this theory explicitly in the report is how this project earns credit beyond "charts that look nice."

**Confirmed decisions** (already made, not open questions):
1. **Stack: R + Shiny** — matches the course's own worked Lecture 6 example (`ui`/`server`/`shinyApp`), using ggplot2/plotly for charts and leaflet or maps/mapproj for the geospatial piece.
2. **Framing: combined two-persona dashboard** — Tab A "Traveler" (decision support: best price/time/route/airline to book) and Tab B "Airline Analytics" (market share, route performance, pricing strategy).
3. **Map: India route map**, not a world map — geographically honest to the domestic-only data, using a small hand-built 6-city lat/long lookup table.
4. **No predictive/ML element** — purely descriptive/exploratory. The rubric asks for a "Data Science/analytics problem" with "decision-support goals," which filtering + comparison interactivity satisfies without a model; this keeps scope demo-able in 10–15 minutes.

**Deadlines** (for awareness, not used to schedule steps below): submission Sunday 2026-07-19; presentation slot either 2026-07-15 18:00–20:00 or 2026-07-16 20:00–21:00.

---

## Repository Structure

```
Visualization project/
├── airlines_flights_data.csv
├── app.R                      # source()s R/ files, calls shinyApp(ui, server)
├── R/
│   ├── ui.R                   # navbarPage with 2 tabPanels (Traveler / Airline Analytics)
│   ├── server.R               # reactive filtered dataset + all render* calls
│   ├── data_prep.R            # load_and_clean_flights(): cleaning + factor ordering + feature engineering
│   ├── city_coords.R          # 6-row lat/lon lookup table (Delhi, Mumbai, Bangalore, Kolkata, Hyderabad, Chennai)
│   ├── helpers_traveler.R     # chart-building functions for Tab A
│   ├── helpers_airline.R      # chart-building functions for Tab B
│   └── theme.R                # shared ggplot theme + colorblind-safe palette (RColorBrewer "Set2", one color per airline reused everywhere)
├── data/
│   └── flights_clean.rds      # cached cleaned dataset (avoids re-parsing 300k rows on every runApp())
├── www/
│   └── custom.css             # minimal styling only (font/spacing/KPI tiles) — no decorative chart-junk
├── report/
│   ├── report.qmd (or .docx)  # written report, structured per §Report Structure below
│   ├── ai_prompt_appendix.md  # required deliverable
│   └── figures/                # exported chart screenshots for the report
├── scripts/
│   └── explore_eda.R          # throwaway EDA: NA/duplicate check, price skew, summary stats — evidence for Data Understanding
└── README.md                  # how to run: source("app.R"); shiny::runApp()
```

## Data Processing (`R/data_prep.R`)

- **Cleaning**: drop `index` (row-number artifact); confirm/report `NA` and duplicate counts (Kaggle version is known-clean, but the report must show this was checked).
- **Factor ordering** (the single most important fix — otherwise categorical axes sort alphabetically and mislead):
  ```r
  time_levels <- c("Early_Morning","Morning","Afternoon","Evening","Night","Late_Night")
  df$departure_time <- factor(df$departure_time, levels = time_levels, ordered = TRUE)
  df$arrival_time   <- factor(df$arrival_time,   levels = time_levels, ordered = TRUE)
  df$stops <- factor(df$stops, levels = c("zero","one","two_or_more"), ordered = TRUE)
  df$class <- factor(df$class, levels = c("Economy","Business"))
  ```
- **Feature engineering**: `price_per_hour = price/duration` (value metric for travelers and pricing-efficiency for airlines); `route = paste(source_city, "→", destination_city)`; optional `days_left_bucket` (Last-minute 1–7 / 2–4 weeks / 1+ month) for coarser comparisons; `city_coords` joined onto `source_city`/`destination_city` for the map.
- **Skew handling for `price`** (range 1,105–123,071, right-skewed): don't delete outliers (high Business fares are real). Add a `checkboxInput("log_scale")` toggle wired to `scale_y_log10()` on the price histogram — this is both a citable Lecture 4 technique and a concrete interactive feature.
- Cache the cleaned frame to `data/flights_clean.rds` so the Shiny app doesn't re-clean 300k rows on every launch (important for smooth live demo).

## Chart Set (9 charts, deliberately spanning task types from Lecture 9's directory)

| # | Chart | Type | Tab | Justification |
|---|---|---|---|---|
| 1 | Price distribution by class | Violin + sina/jitter | Traveler | Lecture 9: violin/sina beats boxplot for bimodal data (Economy/Business is bimodal); boxplot would hide this. |
| 2 | Average price by airline | Ordered horizontal bar | Airline | Cleveland–McGill: position/length is the most accurate encoding; Stevens' bar-length exponent ≈1.0. |
| 3 | Market share by airline | Ordered bar (NOT pie) | Airline | 6 categories with non-extreme skew is exactly where pie-angle misjudgment causes ranking errors — see rejection note below. |
| 4 | Price vs. days_left (booking curve) | Line/scatter + `geom_smooth` | Traveler | Direct "when should I book?" answer; LOESS smoothing per Lecture 4. |
| 5 | Route price/volume heatmap | Heatmap, `source_city` × `destination_city` | Airline | Lecture 9: heatmap good for broad trend, weak for exact value — compensated with plotly hover tooltip (details-on-demand). |
| 6 | India route map | Geospatial flow map (leaflet/maps+mapproj), 6 cities + weighted route arcs | Airline (cross-tab relevant) | Confirmed India-only scope; flat 2D line-width/color encoding avoids 3D/volume distortion. |
| 7 | Duration vs. price scatter, colored by stops | Scatterplot, plotly (brushable) | Traveler | Avoids Lecture 9's bubble-chart criticism (dual position+size encoding); color-by-stops uses a qualitative Bertin variable correctly. |
| 8 | Departure-time × Airline grid | Small-multiple bar/heatmap, rows ordered by time-of-day | Traveler (primary) | Multivariate small-multiples (Bertin); main showcase for filtering/reconfigure interaction. |
| 9 | KPI tiles + route comparison | Stat tiles (avg price/duration/count) ± slopegraph (Economy vs Business per top routes) | Both, top of each tab | Stephen Few: single-screen overview-first per Shneiderman's mantra; slopegraph preserves position+slope for 2-point comparison better than grouped bars. |

**Pie chart decision**: explicitly not used anywhere. `airline` has 6 non-extreme-share categories — precisely the case where Cleveland–McGill/Stevens' theory (angle/area judged less accurately than length, ~0.7 exponent vs ~1.0) predicts real misjudgment. Chart #3 uses a bar instead. This rejection itself is a citable paragraph in the report — "considered and rejected a pie chart, here's the theory why" is strong evidence of applied course theory.

## Interaction Design — 9 operators mapped to concrete widgets

- **Filter**: sidebar `sliderInput` (days_left, duration), `checkboxGroupInput`/`selectInput` (airline, class, stops, source/dest city) → one central `reactive()` filtered dataset per tab, feeding all charts.
- **Select**: plotly `event_data("plotly_click"/"plotly_selected")` on the heatmap (#5) and scatter (#7).
- **Explore / Change configuration (continuous)**: slider drag → live re-render.
- **Reconfigure**: `radioButtons("metric", c("Mean Price","Flight Count"))` re-sorts/re-fills heatmap (#5) and grid (#8) by a different metric.
- **Encode**: `checkboxInput("log_scale")` on histogram (#1); `selectInput("color_by")` on scatter (#7).
- **Abstract/Elaborate**: KPI tiles (#9, abstract) sit above detail charts; click-through elaborates into filtered detail — overview-first-then-detail.
- **Connect (linked brushing)**: selection from scatter (#7) or map (#6) stored in `reactiveVal`, highlights corresponding subset in grid (#8) via opacity/border.
- **Undo/Redo**: `actionButton("reset_filters")` restores all inputs to defaults via `updateSliderInput`/`updateCheckboxGroupInput` (scoped-down single-step interpretation, noted as such in report).
- **Change configuration (persona)**: `tabsetPanel`/`navbarPage` tab switch between Traveler and Airline Analytics.

## Dashboard Layout (Stephen Few single-screen principle)

Both tabs: fixed sidebar (~25%, filters + reset button) + main panel (~75%, KPI row on top, then 2 chart rows of 2 charts each) — no vertical scroll-chasing, no decorative gradients/borders (data-ink ratio). Consistent colorblind-safe palette (`RColorBrewer::brewer.pal(6,"Set2")`) with the same airline always the same color on both tabs.

- **Tab A (Traveler)**: KPI tiles → [violin #1, booking-curve #4] → [scatter #7, time×airline grid #8].
- **Tab B (Airline Analytics)**: KPI tiles → [bar #2, share-bar #3] → [heatmap #5, India map #6].

## Team Task Breakdown (4 people)

Roles are split by dashboard area so each person owns a vertical slice (their own charts, their own interactions, their own report section) while the Integration Lead owns the shared scaffolding everyone else plugs into. Steps within each role are ordered (do step 1 before step 2, etc.) but not date-bound — the group syncs after each person finishes their "static charts" step before moving on to wiring, and again before the report-writing step. Everyone contributes to the AI Usage Documentation and Evaluation & Reflection sections with their own examples.

### Person 1 — Data Lead
- **Owns**: `R/data_prep.R`, `R/city_coords.R`, `scripts/explore_eda.R`, `data/flights_clean.rds`
- **Step 1**: Clean data (drop `index`, check/report NA and duplicate counts).
- **Step 2**: Factor-order `departure_time`/`arrival_time`/`stops`/`class`; engineer `price_per_hour`, `route`, `days_left_bucket`.
- **Step 3**: Build the 6-city lat/lon lookup table (`city_coords.R`) for the map.
- **Step 4**: Run EDA in `explore_eda.R` (price skew, summary stats, sanity checks) and cache the cleaned frame to `data/flights_clean.rds`; share column list and summary stats with the group so the other three can start building charts.
- **Step 5 (ongoing)**: Stay on call to add derived fields if teammates need them; review everyone's chart code against the cleaned columns.
- **Step 6**: Write report §Data Understanding and §Data Processing (cite Lecture 1 Anscombe's Quartet, Lecture 4 log transforms/data types, Lecture 2 order property).

### Person 2 — Traveler-View Lead
- **Owns**: `R/helpers_traveler.R`, Tab A charts — #1 price-by-class violin, #4 booking-curve, #7 duration-vs-price scatter, #8 departure-time×airline grid
- **Step 1**: Once `flights_clean.rds` is available, build static (non-reactive) versions of all 4 charts to lock encoding choices.
- **Step 2**: Wire Traveler-tab filters (days_left slider, duration slider, class/stops checkboxes) into a `reactive()` and connect to all 4 charts inside `server.R`.
- **Step 3**: Implement the Encode operator (log-scale checkbox on #1, color-by selector on #7) and the Reconfigure operator on #8 (metric radio button).
- **Step 4**: Proofread the whole app (not just Tab A) once integration is done.
- **Step 5**: Write report §Visualization & Interaction Design subsection for charts #1/#4/#7/#8 (cite Lecture 9 violin-vs-boxplot, Lecture 4 `geom_smooth`, Lecture 9 bubble-chart critique, Bertin small multiples).

### Person 3 — Airline-Analytics Lead
- **Owns**: `R/helpers_airline.R`, Tab B charts — #2 avg-price bar, #3 market-share bar, #5 route heatmap, #6 India route map
- **Step 1**: Once `flights_clean.rds` and `city_coords.R` are available, build static versions of all 4 charts, including the coordinate join for #6 (leaflet or maps/mapproj).
- **Step 2**: Wire Airline-tab filters (airline/class/route selectors) into a `reactive()` and connect to all 4 charts inside `server.R`.
- **Step 3**: Implement the Reconfigure operator (price/count metric toggle shared across #5 and #6) and the Select operator (plotly `event_data` on the heatmap).
- **Step 4**: Proofread the whole app once integration is done.
- **Step 5**: Write report §Visualization & Interaction Design subsection for charts #2/#3/#5/#6, **including the explicit pie-chart-rejection paragraph** (cite Cleveland–McGill, Stevens' Power Law) and the map's geographic-honesty note (India-only, manually curated coordinates).

### Person 4 — Integration & Interaction Lead (also Report Lead)
- **Owns**: `app.R`, `R/ui.R`, `R/server.R`, `R/theme.R`, KPI tiles (#9), cross-cutting interactions, final report assembly
- **Step 1**: Build the shared ggplot theme + colorblind-safe palette (`R/theme.R`, `RColorBrewer::brewer.pal(6,"Set2")`, one consistent color per airline across both tabs) so all four people's charts look like one system; share it with Persons 2 and 3 before they start their static charts.
- **Step 2**: Build `ui.R` skeleton — `navbarPage` with two `tabPanel`s, sidebar/main-panel layout per Stephen Few's single-screen principle — with placeholders for teammates' charts.
- **Step 3**: Build `server.R` scaffolding — the two central `reactive()` filtered datasets (one per tab) that Persons 2 and 3 plug their chart-render calls into; build `app.R` to source everything and call `shinyApp(ui, server)`.
- **Step 4**: Once Persons 2 and 3 finish wiring their own charts, implement the cross-tab/whole-app interactions: KPI tiles (#9, Abstract/Elaborate), linked brushing/Connect between charts #6/#7 and #8, and the `actionButton("reset_filters")` Undo/Redo.
- **Step 5**: Run a full group walkthrough of the finished app, collect fixes, then run a group rehearsal of the 10–15 min demo using the Pyramid Principle (lead with the headline insight, then each person covers their own slice as supporting evidence) — assign who presents which section.
- **Step 6**: Write report §Problem Definition and §Deliverables checklist; **compile** everyone's sections into the final `report/report.qmd`, check citation consistency, and assemble `report/ai_prompt_appendix.md` from all four people's prompt logs.
- **Step 7**: Coordinate §Evaluation & Reflection as a group synthesis (each person contributes one strength/limitation from their own area).

## Report Structure (maps directly to rubric)

1. **Problem Definition** — two personas, decision-support goals, why interactivity (not prediction) solves it. Cite Lecture 1 ("compared to what?"), Lecture 5 (Shneiderman/Keim mantras).
2. **Data Understanding** — source/structure, real summary stats from `explore_eda.R` (price skew, ranges). Cite Lecture 1 (Anscombe's Quartet — why visual EDA beyond summary stats), Lecture 4 (data-type framework).
3. **Data Processing** — each transformation from §Data Processing with the "why," tied to a downstream chart. Cite Lecture 4 (log transforms), Lecture 2 (order property).
4. **Visualization & Interaction Design** — chart-by-chart from the table above, the pie-chart rejection paragraph, the 9-operator mapping, the layout. Cite Lecture 2/3 (Bertin, Cleveland–McGill, Stevens), Lecture 5/7 (interaction operators, interaction-space framework), Lecture 8 (Lie Factor/data-ink ratio — note no 3D/volume charts used), Lecture 9 (chart-directory justification), Lecture 11 (color accessibility/consistency).
5. **AI Usage Documentation** — tools used, key prompts (link to appendix), capabilities used (code gen, debugging, UI design, data analysis, viz suggestions, idea generation), and at least one concrete example of a rejected/corrected AI suggestion (e.g., the pie-chart rejection).
6. **Evaluation & Reflection** — strengths (dual-persona, theory-justified encodings, taught toolchain), limitations (no real dates, no delay data, schematic map, no live pricing, no prediction by design), AI vs. human decision split, lessons/future work. Cite Lecture 11 (evaluation methods not performed due to time; Pyramid Principle structuring this section itself).
7. **Deliverables checklist** — report, source code, AI prompt appendix, live demo walkthrough.

## Verification

Since this is an R Shiny app, verification is interactive, not just `testthat`-style:
1. Run `shiny::runApp()` and manually exercise every filter/widget on both tabs — confirm every chart re-renders correctly and stays in sync with the shared `reactive()` filtered dataset.
2. Check factor ordering visually (time-of-day and stops axes must read Early_Morning → Late_Night, zero → two_or_more, not alphabetically).
3. Toggle the log-scale checkbox and confirm the price histogram genuinely switches axis scale.
4. Click/select on the heatmap and scatter to confirm linked-brushing highlights propagate to the grid chart (#8) and KPI tiles.
5. Test `actionButton("reset_filters")` restores all inputs to default and all charts revert.
6. Confirm app startup is fast using the cached `flights_clean.rds` (not re-parsing the raw 300k-row CSV each launch).
