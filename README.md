# ⚡ From Movement to METs: ActTrust® Validation Study

A fully reproducible R/Quarto analysis pipeline validating the **ActTrust® actigraphy device** for energy expenditure estimation and physical activity intensity classification in young adults, benchmarked against the ActiGraph® GT3X+ and indirect calorimetry.

[![DOI](https://img.shields.io/badge/bioRxiv-10.1101%2F2025.05.16.654458-b31b1b)](https://doi.org/10.1101/2025.05.16.654458)
[![Zenodo](https://img.shields.io/badge/Data-10.5281%2Fzenodo.15315735-blue)](https://doi.org/10.5281/zenodo.15315735)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![R 4.4.1](https://img.shields.io/badge/R-4.4.1-276DC3.svg)](https://www.r-project.org/)
[![Quarto](https://img.shields.io/badge/Quarto-≥1.4-75AADB.svg)](https://quarto.org)

---

## 📖 About

This repository contains all data and analysis code for a controlled laboratory validation of the **ActTrust® actigraphy device** (Condor Instruments, São Paulo, Brazil). The study compares ActTrust® activity counts to those from the widely used ActiGraph® GT3X+ accelerometer, and relates both to metabolic equivalents (METs) measured by indirect calorimetry during a treadmill protocol in healthy young adults.

> **Batista ES, Basilio Gomes SR, Morais Ferreira AB, França LGSF, Fontenele Araújo J, Mortatti AL, Leocadio-Miguel MA.**  
> *From Movement to METs: A Validation of ActTrust® for Energy Expenditure Estimation and Physical Activity Classification in Young Adults.*  
> bioRxiv 2025. https://doi.org/10.1101/2025.05.16.654458

---

## 🔬 Study Overview

**56 healthy young adults** (34 men, 22 women; aged 18–35) completed a controlled treadmill protocol in a single laboratory session. Participants simultaneously wore four devices — two ActiGraph® GT3X+ and two ActTrust® units at hip and wrist — while oxygen uptake was measured breath-by-breath by indirect calorimetry (Quark CPET, Cosmed®).

### Protocol

| Condition | Speed | Description |
|-----------|-------|-------------|
| Rest | — | Seated, no movement |
| Walking | 3 km/h | Slow walk |
| Walking | 5 km/h | Brisk walk |
| Walking/Running | 7 km/h | Fast walk / slow run |
| Running | 9 km/h | Running |

Each condition lasted **10 minutes**, separated by **5-minute rest periods**. Activity counts and METs were averaged over the **central 4 minutes** of each condition to exclude transition effects.

### Devices

| Device | Placement | Mode | Sample rate | Export software |
|--------|-----------|------|-------------|-----------------|
| ActiGraph® GT3X+ | Dominant hip | Vector magnitude | 30 Hz, 1-s epochs | ActiLife v6.13.4 |
| ActiGraph® GT3X+ | Non-dominant wrist | Vector magnitude | 30 Hz, 1-s epochs | ActiLife v6.13.4 |
| ActTrust® | Dominant hip | PIM | 25 Hz, 1-s epochs | Act Studio |
| ActTrust® | Non-dominant wrist | PIM | 25 Hz, 1-s epochs | Act Studio |

> ActTrust® (ACTT) PIM counts are systematically higher in magnitude than GT3X+ vector magnitude counts. The two devices are not directly comparable in absolute terms — use device-specific equations and cut-points.

---

## ✨ Key Contributions

- 🥇 **First published cut-points** for physical activity intensity classification using ActTrust® devices (hip and wrist placement)
- 📐 **General linear model** for estimating energy expenditure (METs) from ActTrust® activity counts, with device × placement interaction terms
- 🔁 **Cross-device comparison** of GT3X+ and ActTrust® at hip and wrist placements across the full intensity spectrum
- 📊 **Balanced accuracies above 0.77** for all intensity ranges, exceeding **0.90 for light and moderate activity**
- 🧪 **Bland-Altman analysis** of predicted vs measured METs per device × placement
- 👥 **Sex-stratified supplementary analysis** addressing body composition differences in energy expenditure

---

## 🎯 Cut-points

Physical activity intensity cut-points derived by inverting the regression model at MET thresholds of 3, 6, and 9:

| Device (Placement) | Regression equation | Light (< 3 METs) | Moderate (3–6 METs) | Vigorous (6–9 METs) | Very Vigorous (≥ 9 METs) |
|--------------------|---------------------|:----------------:|:-------------------:|:-------------------:|:------------------------:|
| GT3X+ (hip) | MET⁰·⁵ = 1.06 + 0.02 × Activity⁰·⁵ | < 1132 | 1132–4853 | 4853–9468 | ≥ 9468 |
| ACTT (hip) | MET⁰·⁵ = 1.11 + 0.01 × Activity⁰·⁵ | < 5057 | 5057–23339 | 23339–46410 | ≥ 46410 |
| ACTT (wrist) | MET⁰·⁵ = 1.23 + 0.01 × Activity⁰·⁵ | < 3761 | 3761–22368 | 22368–47203 | ≥ 47203 |
| GT3X+ (wrist) | MET⁰·⁵ = 1.20 + 0.01 × Activity⁰·⁵ | < 1698 | 1698–9503 | 9503–19787 | ≥ 19787 |

All units in counts/min. 95% CIs via delta method (`msm::deltamethod`) are reported in the notebook output.

---

## 🗂️ Repository Structure

```
ACTT_validation_study/
├── data/
│   ├── acttrust_validation_full.csv   # Full dataset (participants × conditions × devices)
│   └── S1.csv                         # Supplementary data
├── raw_data/
│   ├── ACTTRUST/                      # Raw ActTrust® exports (.txt, Act Studio)
│   ├── Gt3x/                          # Raw ActiGraph® GT3X+ exports (.gt3x / .csv, ActiLife)
│   └── ERGO/                          # Indirect calorimetry exports (Quark CPET)
├── index.qmd                          # Quarto notebook — complete analysis and figures
├── ACTT_validation_study.Rproj        # RStudio project file
├── DATA_DICTIONARY.md                 # Variable descriptions and raw data sources
├── DEPENDENCIES.md                    # Software and R package requirements
├── Dockerfile                         # Reproducible R environment (rocker/r-base)
├── docker-compose.yml                 # Docker Compose configuration
└── README.md                          # This file
```

---

## 🚀 Reproducing the Analysis

### Option A — RStudio (recommended)

#### 1. Install R dependencies

```r
install.packages(c(
  "tidyverse", "caret", "MuMIn", "MetBrewer",
  "broom", "cowplot", "pROC", "reshape2", "gt",
  "lmtest", "car", "msm"
))
```

#### 2. Render the Quarto notebook

Open `ACTT_validation_study.Rproj` in RStudio, then open `index.qmd` and click **Render**, or from the terminal:

```bash
quarto render index.qmd
```

This produces a self-contained HTML report (`index.html`) with all figures, tables, and statistical output inline.

---

### Option B — Docker (fully reproducible environment)

```bash
docker-compose up
```

This builds the rocker/r-base:4.0.4 environment with all dependencies installed and renders the notebook.

---

## 📊 Analysis Sections

The notebook (`index.qmd`) runs end-to-end in the following order:

| Section | Description |
|---------|-------------|
| 📦 Load libraries | tidyverse, caret, MuMIn, MetBrewer, broom, cowplot, pROC, lmtest, car |
| 🎨 Set theme and palette | MetBrewer "Archambault" palette; ggplot2 theme_bw |
| 📁 Load data | `data/acttrust_validation_full.csv` |
| ⚖️ ANOVA | `sqrt(act_value) ~ Conditions:act`; Tukey HSD post-hoc |
| 🔗 Correlation matrix | Pearson correlations across all four device × placement combinations (Figure 2a) |
| 📈 Linear model | `sqrt(METs) ~ sqrt(act_value) * act`; GT3X+ (hip) as reference level |
| 📊 Regression plot | Device-specific fitted lines overlaid on scatter (Figure 2b) |
| 🤖 Classification metrics | Fitted METs → intensity classes → confusion matrix and AUC (Figure 2c, Table 3) |
| 🧮 Cut-point derivation | Count thresholds at 3, 6, 9 METs per device × placement with 95% CIs via delta method (Table 2) |
| 📊 Summary plots | Activity counts and METs by condition (Figure 1a, 1b) |
| 🔲 Device-specific confusion matrices | Per-device 2×2 panel confusion matrix heatmaps (Figure 3) |
| 👥 Sex-stratified analysis | Confusion matrices and AUC per sex (supplementary) |
| 📉 Bland-Altman plots | Predicted vs measured METs: bias and limits of agreement per device × placement |
| 🔍 Model diagnostics | Shapiro-Wilk (normality), Breusch-Pagan (homoscedasticity), VIF (multicollinearity) |

---

## 🧮 Model Details

### General linear model (Equation 1)

```r
lm(sqrt(METs) ~ sqrt(act_value) * act, data = dfm)
```

Where `act` is a factor with four levels — `GT3X+ (hip)` (reference), `GT3X+ (wrist)`, `ACTT (hip)`, `ACTT (wrist)`. The `*` operator includes main effects and interaction, allowing each device × placement to have its own slope and intercept.

### Cut-point derivation

Cut-points are derived by inverting the regression equation per device:

```r
Activity = ((sqrt(MET_threshold) - β0_device) / β1_device)^2
```

95% confidence intervals use the delta method (`msm::deltamethod`) to propagate uncertainty from the coefficient covariance matrix.

### PA intensity classification

| Class | MET range | Intensity |
|-------|-----------|-----------|
| `[0,3)` | 0 ≤ METs < 3 | Light |
| `[3,6)` | 3 ≤ METs < 6 | Moderate |
| `[6,9)` | 6 ≤ METs < 9 | Vigorous |
| `[9,∞)` | METs ≥ 9 | Very Vigorous |

---

## 👥 Authors

| Author | Affiliation |
|--------|-------------|
| Elias dos Santos Batista | UFRN / IFRN, Brazil |
| Stephania Ruth Basilio Gomes | UFRN, Brazil |
| Ayrton Bruno de Morais Ferreira | UFRN, Brazil |
| Lucas G. S. França | Northumbria University, UK / King's College London, UK |
| John Fontenele Araújo | UFRN, Brazil |
| Arnaldo Luis Mortatti | UFRN, Brazil |
| Mario André Leocadio-Miguel *(corresponding)* | Northumbria University, UK |

Correspondence: mario.miguel@northumbria.ac.uk

---

## ⚖️ Ethics

Approved by the Human Ethics Committee of the Federal University of Rio Grande do Norte (Protocol 3.672.214; CAAE: 15857419.5.0000.5537) and conducted in accordance with the Declaration of Helsinki. All participants provided written informed consent.

---

## 💰 Funding

Supported by the Brazilian National Council for Scientific and Technological Development (CNPq).

---

## 📄 Citation

```bibtex
@article{batista_2025_acttrust,
  author  = {Batista, Elias dos Santos and Basilio Gomes, Stephania Ruth and
             Morais Ferreira, Ayrton Bruno de and França, Lucas G. S. and
             Fontenele Araújo, John and Mortatti, Arnaldo Luis and
             Leocadio-Miguel, Mario André},
  title   = {From Movement to METs: A Validation of ActTrust® for Energy
             Expenditure Estimation and Physical Activity Classification in
             Young Adults},
  journal = {bioRxiv},
  year    = {2025},
  doi     = {10.1101/2025.05.16.654458},
  url     = {https://doi.org/10.1101/2025.05.16.654458}
}
```

Data archived at Zenodo: https://doi.org/10.5281/zenodo.15315735

---

## 🤝 Related Tools

- 🌀 [**nonparametric-actigraphy-clustering**](https://github.com/Pugliane/nonparametric-actigraphy-clustering) — Python pipeline for circadian feature extraction and clustering from ActTrust® data
- 🌙 [**Sleep Diaries**](https://github.com/circadia-bio/SleepDiaries) — open-source React Native sleep diary app
- 🔬 [**circadia-bio**](https://github.com/circadia-bio) — the Circadia Lab GitHub organisation

---

## 📄 Licence

Released under the [MIT License](./LICENSE).
