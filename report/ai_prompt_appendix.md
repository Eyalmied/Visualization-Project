# AI Prompt Appendix

Required deliverable per the assignment's "AI Usage Documentation" section (see `PLAN.md` → Project Instructions). Each group member should append their own entries below as they work — don't wait until the end.

## Format

For each significant AI-assisted step, log:

- **Tool used**: e.g. Claude Code, ChatGPT, Copilot
- **Capability**: code generation / debugging / UI design / data analysis / visualization suggestions / refactoring / documentation / idea generation
- **Prompt (summarized or verbatim)**:
- **What was accepted as-is / what was corrected or rejected, and why**:

## Log

### Initial planning — course/lecture research and project plan

- **Tool**: Claude Code (Anthropic)
- **Capability**: Idea generation, documentation
- **Prompt (summarized)**: "Look at project.jpeg, research the lecture PDFs, and write a plan for this project" (course requirements + chart types), followed by scoping questions on tech stack, problem framing, map scope, and predictive element.
- **Validation**: The lecture summaries were cross-checked against the actual PDF content (each of the 11 lectures was read in full, not summarized from memory). The proposed predictive-price-estimator feature was reviewed against the actual assignment rubric text and dropped as unnecessary scope, since the rubric asks for an "analytics problem" with "decision-support goals," not a model.

### App implementation — R Shiny dashboard

- **Tool**: Claude Code (Anthropic)
- **Capability**: Code generation, debugging, data analysis, visualization suggestions, refactoring
- **Prompt (summarized)**: "Start implementing" (against the approved PLAN.md), followed by iterative debugging as issues surfaced during verification.
- **Validation**: Every chart function was run against real filtered data (not just visually inspected) via a headless smoke-test script, and the full reactive server logic was exercised with `shiny::testServer()`. Four real, non-obvious bugs were caught this way rather than assumed away:
  1. The scatter plot's linked-brushing selection used plotly's raw `pointNumber`, which resets per color-trace — fixed with a stable row-id `key` aesthetic.
  2. `event_data()` on the heatmap click and scatter lasso-select never fired — plotly requires an explicit `event_register()` call per event type, which was missing.
  3. The duration-range slider's default bounds used `round()`, silently excluding a couple of legitimate boundary flights even at "full range" — fixed with `floor()`/`ceiling()`.
  4. `geom_smooth(method="loess")` on the full ~300k-row dataset was a performance trap (LOESS scales very poorly with n) — fixed by aggregating to per-`days_left` means before smoothing.
- **A rejected AI-style suggestion**: a pie chart was considered for chart #3 (market share by airline) since it's the most common default for "share of a whole." It was rejected in favor of an ordered bar chart specifically because Lecture 2/3's perceptual-accuracy theory (Cleveland-McGill, Stevens' Power Law) predicts real misjudgment for 6 non-extreme-share categories — see `PLAN.md` and `Report.docx` §4.2 for the full reasoning.

### UI fix — scatter legend overlapping the x-axis

- **Tool**: Claude Code (Anthropic)
- **Capability**: Debugging, UI design
- **Prompt (summarized)**: "the scatter plot x axis is getting in the way of the legend under the scatter. fix that"
- **Validation**: Diagnosed as ggplot's own bottom-positioned legend and plotly's auto-generated legend both claiming the same vertical space. Fixed by disabling the ggplot legend and explicitly laying out plotly's legend with sufficient margin; verified programmatically via `plotly_build()` that the corrected layout values (`legend$orientation`, `margin$b`) actually take effect, since `plotly::layout()` calls are stored lazily and don't appear in the object until build time.

### Report generation

- **Tool**: Claude Code (Anthropic)
- **Capability**: Data analysis, documentation, code generation
- **Prompt (summarized)**: "make the report... do whatever explanations needed from the app, the outcomes, numbers, graphs... make a word document in the repo root"
- **Validation**: All numbers in `Report.docx` are computed directly from the actual cleaned dataset (`scripts/generate_report_assets.R` → `report/stats.json`), not invented or approximated. While computing the airline/stops price breakdowns, a genuine Anscombe's-Quartet-style confound was found (Vistara/Air_India's much higher raw average price is driven almost entirely by them being the only two carriers selling Business class, not by them being "expensive" carriers) — this was verified with an additional cross-tabulation (price by airline × class, price by stops × class) before writing it into the report, rather than accepting the first aggregate number at face value. A real encoding bug was also caught and fixed during generation: em dashes were being silently corrupted to `�` in the saved `.docx` because Python's `locale.getpreferredencoding()` on this machine resolves to `cp1255` (Hebrew Windows codepage), which can't represent that character; fixed by forcing Python's UTF-8 mode (`PYTHONUTF8=1`) and verified at the Unicode-codepoint level (not just visual inspection) that the fix worked.

<!-- Team: add your own entries below as you work on your assigned section, using the format above. -->
