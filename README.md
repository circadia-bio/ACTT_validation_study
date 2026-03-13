# From Movement to METs: A Validation of ActTrust® for Energy Expenditure Estimation and Physical Activity Classification in Young Adults

[![DOI](https://img.shields.io/badge/DOI-10.1101%2F2025.05.16.654458-blue)](https://doi.org/10.1101/2025.05.16.654458)
[![Zenodo](https://img.shields.io/badge/Data-10.5281%2Fzenodo.15315735-blue)](https://doi.org/10.5281/zenodo.15315735)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

## Overview

This repository contains all data and analysis scripts for the ActTrust® validation study. The study validates the ActTrust® actigraphy device (Condor Instruments, São Paulo, Brazil) against the widely used ActiGraph® GT3X+ accelerometer, and compares activity counts to metabolic equivalents (METs) derived from indirect calorimetry during controlled treadmill walking and running in young adults.

**Key contributions:**
- First published cut-points for physical activity intensity classification using ActTrust® devices (hip and wrist placement)
- General linear model for estimating energy expenditure (METs) from ActTrust® movement counts
- Cross-device comparison of GT3X+ and ActTrust® at hip and wrist placements
- Balanced accuracies above 0.77 for all intensity ranges, exceeding 0.90 for light and moderate activity

## Preprint

> Batista ES, Basilio Gomes SR, Morais Ferreira AB, França LGSF, Fontenele Araújo J, Mortatti AL, Leocadio-Miguel MA. *From Movement to METs: A Validation of ActTrust® for Energy Expenditure Estimation and Physical Activity Classification in Young Adults.* bioRxiv 2025. https://doi.org/10.1101/2025.05.16.654458

## Study Design

56 healthy young adults (34 men, 22 women; aged 18–35) completed a controlled laboratory protocol consisting of five 10-minute conditions on a treadmill, each separated by 5-minute rest periods:

| Condition | Speed |
|-----------|-------|
| Rest | — |
| Walking | 3 km/h |
| Walking | 5 km/h |
| Walking/Running | 7 km/h |
| Running | 9 km/h |

Participants simultaneously wore:
- **GT3X+** (hip, dominant side) — ActiLife v6.13.4, vector magnitude, 30 Hz, 1-s epochs
- **GT3X+** (non-dominant wrist)
- **ActTrust®** (hip, dominant side) — Act Studio, PIM mode, 25 Hz, 1-s epochs
- **ActTrust®** (non-dominant wrist)

Oxygen uptake was measured breath-by-breath using indirect calorimetry (Quark CPET, Cosmed®).

## Cut-points

The following movement count cut-points were derived from the linear regression model for classifying physical activity intensity:

| Device (Placement) | Equation | Light (< 3 METs) | Moderate (3–6 METs) | Vigorous (6–9 METs) | Very Vigorous (>= 9 METs) |
|--------------------|----------|:----------------:|:-------------------:|:-------------------:|:------------------------:|
| GT3X+ (hip)   | MET^0.5 = 1.06 + 0.02 * Activity^0.5 | < 1132   | 1132–4853   | 4853–9468   | >= 9468  |
| ACTT (hip)    | MET^0.5 = 1.11 + 0.01 * Activity^0.5 | < 5057   | 5057–23339  | 23339–46410 | >= 46410 |
| ACTT (wrist)  | MET^0.5 = 1.23 + 0.01 * Activity^0.5 | < 3761   | 3761–22368  | 22368–47203 | >= 47203 |
| GT3X+ (wrist) | MET^0.5 = 1.20 + 0.01 * Activity^0.5 | < 1698   | 1698–9503   | 9503–19787  | >= 19787 |

## Repository Structure

```
ACTT_validation_study/
├── data/
│   └── acttrust_validation_full.csv   # Full dataset (participants × conditions × devices)
├── ACTT_validation_study.qmd          # Quarto notebook — complete analysis and figures
├── DATA_DICTIONARY.md                 # Variable descriptions
├── DEPENDENCIES.md                    # Software and R package requirements
└── README.md                          # This file
```

## Data

All analyses read from a single file: `data/acttrust_validation_full.csv`.

Key columns (see [DATA_DICTIONARY.md](DATA_DICTIONARY.md) for full descriptions):

| Column | Description |
|--------|-------------|
| `ID` | Participant identifier |
| `Conditions` | Treadmill condition (`Rest`, `3 km/h`, `5 km/h`, `7 km/h`, `9 km/h`, `Sit-Stands`) |
| `METs` | Metabolic equivalents from indirect calorimetry |
| `BMI` | Body mass index |
| `GT3X+ (hip)` | ActiGraph GT3X+ activity counts, hip placement |
| `GT3X+ (wrist)` | ActiGraph GT3X+ activity counts, wrist placement |
| `ACTT (hip)` | ActTrust® PIM activity counts, hip placement |
| `ACTT (wrist)` | ActTrust® PIM activity counts, wrist placement |

> **Note:** The `Sit-Stands` condition is present in the raw data but excluded from all primary analyses.

## Reproducing the Analyses

### 1. Install dependencies

See [DEPENDENCIES.md](DEPENDENCIES.md) for full software requirements. In R:

```r
install.packages(c("tidyverse", "caret", "MuMIn", "MetBrewer",
                   "cowplot", "pROC", "broom", "reshape2", "gt"))
```

### 2. Render the Quarto notebook

With [Quarto](https://quarto.org) installed:

```bash
quarto render ACTT_validation_study.qmd
```

Or open `ACTT_validation_study.qmd` in RStudio and click **Render**. The notebook
is self-contained and will produce an HTML report with all figures and tables inline.

### 3. Analysis sections in the notebook

The notebook runs end-to-end in the following order:

| Section | Description |
|---------|-------------|
| Load libraries | tidyverse, caret, MuMIn, MetBrewer, broom, cowplot, pROC |
| Set theme and palette | MetBrewer "Archambault" palette; ggplot2 theme_bw |
| Load data | `data/acttrust_validation_full.csv` |
| ANOVA | `sqrt(act_value) ~ Conditions:act`; Tukey HSD post-hoc |
| Correlation matrix | Pearson correlations across all four device-placement combinations |
| Linear model | `sqrt(METs) ~ sqrt(act_value) * act`; GT3X+ (hip) as reference level |
| Regression plot | Per-device fitted lines overlaid on scatter (Figure 2b) |
| Classification metrics | Fitted METs → intensity classes → confusion matrix and AUC (Figure 2c, Table 3) |
| Device-specific confusion matrices | Per-device confusion matrix heatmaps (Figure 3) |
| Cut-point table | Count thresholds at 3, 4, 6, 8, 9 METs per device × placement (Table 2) |
| Summary plots | Figures 1a and 1b |

### 4. Model formula

The general linear model (Equation 1 in manuscript):

```r
lm(sqrt(METs) ~ sqrt(act_value) * act, data = dfm)
```

Where `act` is a factor with levels `GT3X+ (hip)` (reference), `GT3X+ (wrist)`,
`ACTT (hip)`, and `ACTT (wrist)`. The `Sit-Stands` condition is excluded before
modelling. Missing values are dropped with `tidyr::drop_na()`.

### 5. Cut-point derivation

Cut-points are derived by inverting the regression equation per device:

```r
Activity = ((sqrt(MET_threshold) - β0_device) / β1_device)^2
```

Thresholds are computed at MET = 3, 4, 6, 8, and 9.

## Ethics

This study was approved by the Human Ethics Committee of the Federal University of Rio Grande do Norte (Protocol 3.672.214; CAAE: 15857419.5.0000.5537) and conducted in accordance with the Declaration of Helsinki. All participants provided written informed consent.

## Funding

Supported by the Brazilian National Council for Scientific and Technological Development (CNPq).

## Authors

| Author | Affiliation |
|--------|-------------|
| Elias dos Santos Batista | UFRN / IFRN, Brazil |
| Stephania Ruth Basilio Gomes | UFRN, Brazil |
| Ayrton Bruno de Morais Ferreira | UFRN, Brazil |
| Lucas G. S. França | Northumbria University, UK / King's College London, UK |
| John Fontenele Araújo | UFRN, Brazil |
| Arnaldo Luis Mortatti | UFRN, Brazil |
| Mario André Leocadio-Miguel (corresponding) | Northumbria University, UK |

Corresponding author: mario.miguel@northumbria.ac.uk

## Citation

If you use this data or code, please cite:

```
Batista ES, Basilio Gomes SR, Morais Ferreira AB, França LGSF, Fontenele Araújo J,
Mortatti AL, Leocadio-Miguel MA (2025). From Movement to METs: A Validation of
ActTrust® for Energy Expenditure Estimation and Physical Activity Classification
in Young Adults. bioRxiv. https://doi.org/10.1101/2025.05.16.654458

Data archived at Zenodo: https://doi.org/10.5281/zenodo.15315735
```

## License

This work is licensed under MIT License.
