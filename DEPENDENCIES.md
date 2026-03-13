# Software Dependencies — ACTT Validation Study

All analyses are contained in a single Quarto notebook (`ACTT_validation_study.qmd`)
and were conducted in R v4.4.1.

---

## Core Software

| Software | Version | Purpose | Source |
|----------|---------|---------|--------|
| R | 4.4.1 | Statistical computing | https://www.r-project.org |
| Quarto | ≥ 1.4 | Notebook rendering (HTML output) | https://quarto.org |
| ActiLife | 6.13.4 | GT3X+ data retrieval and export | ActiGraph Corporation, Pensacola FL |
| Act Studio | — | ActTrust® data download and export | Condor Instruments, São Paulo, Brazil |

---

## R Packages

Install all packages in R with:

```r
install.packages(c(
  "tidyverse",
  "caret",
  "MuMIn",
  "MetBrewer",
  "broom",
  "cowplot",
  "pROC",
  "reshape2",
  "gt"
))
```

| Package | Version used | Purpose | Citation |
|---------|-------------|---------|----------|
| tidyverse | ≥ 2.0.0 | Data manipulation and ggplot2 visualisation (includes dplyr, tidyr, ggplot2, readr, purrr) | Wickham et al. (2019) J Open Source Softw 4(43):1686 |
| caret | ≥ 6.0 | Confusion matrix and per-class classification metrics | Kuhn (2008) J Stat Softw 28(5):1–26 |
| MuMIn | 1.48.4 | Multi-model inference; loaded but available for R² computation | Barton (2024) CRAN |
| MetBrewer | 0.2.0 | Colour palette — "Archambault" used throughout all figures | Mills (2022) CRAN |
| broom | 1.0.6 | Tidy model output (`tidy()` for Tukey HSD results) | Robinson, Hayes & Couch (2024) CRAN |
| cowplot | 1.1.3 | Multi-panel figure composition (`plot_grid()`) | Wilke (2024) CRAN |
| pROC | ≥ 1.18 | One-vs-rest ROC curves and AUC per intensity class | Robin et al. (2011) BMC Bioinformatics 12:77 |
| reshape2 | ≥ 1.4 | `melt()` for correlation matrix to long format (Figure 2a) | Wickham (2007) J Stat Softw 21(12) |
| gt | ≥ 0.9 | Cut-point summary table rendering in HTML output | Iannone et al. (2024) CRAN |

---

## Colour Palette

The notebook uses the **"Archambault"** palette from MetBrewer with 4 selected indices:

```r
pal <- MetBrewer::met.brewer("Archambault", 11)[c(1, 4, 6, 8)]
```

These four colours map to: `GT3X+ (hip)`, `ACTT (hip)`, `ACTT (wrist)`, `GT3X+ (wrist)`
respectively throughout all figures.

---

## Rendering

To reproduce the full HTML report:

```bash
quarto render ACTT_validation_study.qmd
```

Or open in RStudio (≥ 2022.07) and click **Render**. The output is a
self-contained HTML file (`ACTT_validation_study.html`) with all figures and
tables embedded. Chunk outputs are set to `inline`.

---

## Notes

- **ActiLife** and **Act Studio** are proprietary tools used only for device
  initialisation and raw data export. All processing and analysis from that
  point is performed in open-source R.
- `reshape2::melt()` is the only function used from `reshape2`; it could be
  replaced with `tidyr::pivot_longer()` if preferred.
- The `gt` package is used only for the cut-point table display in the HTML
  output and is not required to reproduce statistical results.
