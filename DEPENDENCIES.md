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
  "gt",
  "lmtest",
  "car",
  "msm",
  "effectsize"
))
```

| Package | Version | Purpose | Citation |
|---------|---------|---------|----------|
| tidyverse | 2.0.0 | Data manipulation and ggplot2 visualisation (includes dplyr, tidyr, ggplot2, readr, purrr) | Wickham et al. (2019) J Open Source Softw 4(43):1686 |
| caret | 6.0.94 | Confusion matrix and per-class classification metrics | Kuhn (2008) J Stat Softw 28(5):1–26 |
| MuMIn | 1.48.4 | Multi-model inference and R² computation | Barton (2024) CRAN |
| MetBrewer | 0.2.0 | Colour palette — "Archambault" used throughout all figures | Mills (2022) CRAN |
| broom | 1.0.6 | Tidy model output (`tidy()` for Tukey HSD results) | Robinson, Hayes & Couch (2024) CRAN |
| cowplot | 1.1.3 | Multi-panel figure composition (`plot_grid()`) | Wilke (2024) CRAN |
| pROC | 1.18.5 | One-vs-rest ROC curves and AUC per intensity class | Robin et al. (2011) BMC Bioinformatics 12:77 |
| reshape2 | ≥ 1.4 | `melt()` for correlation matrix to long format (Figure 2a) | Wickham (2007) J Stat Softw 21(12) |
| gt | ≥ 0.9 | Cut-point and AUC table rendering in HTML output | Iannone et al. (2024) CRAN |
| lmtest | 0.9.40 | Breusch-Pagan test for homoscedasticity | Zeileis & Hothorn (2002) R News 2(3):7–10 |
| car | 3.1.2 | Variance inflation factors (VIF) for multicollinearity | Fox & Weisberg (2019) Sage |
| msm | 1.8.2 | Delta method for 95% CI propagation on nonlinear cut-points | Jackson (2011) J Stat Softw 38(8):1–29 |
| effectsize | ≥ 0.8 | Eta-squared with 95% CI for ANOVA effect sizes | Ben-Shachar et al. (2020) J Open Source Softw 5(56):2815 |

---

## Colour Palette

The notebook uses the **"Archambault"** palette from MetBrewer with 4 selected indices:

```r
pal <- MetBrewer::met.brewer("Archambault", 11)[c(1, 4, 6, 8)]
```

These four colours map to: `GT3X+ (hip)`, `ACTT (hip)`, `ACTT (wrist)`, `GT3X+ (wrist)`
respectively throughout all figures. A 5-colour variant is used for Bland-Altman plots:

```r
pal_ba <- MetBrewer::met.brewer("Archambault", 11)[c(1, 3, 4, 6, 8)]
```

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
- The `gt` package is used for cut-point, equation, and AUC table display in
  the HTML output and is not required to reproduce statistical results.
- `lmtest`, `car`, `msm`, and `effectsize` are used in the supplementary
  regression diagnostics and reviewer-requested analyses sections.
- Verify your exact installed versions with `packageVersion("package_name")`
  and update the table above accordingly before archiving.
