# 📚 Data Dictionary — ACTT Validation Study

This document describes all data sources and variables in the study.  
Processed data are archived at: https://doi.org/10.5281/zenodo.15315735

All primary analyses read from a single file: **`data/acttrust_validation_full.csv`**

---

## 🗃️ Raw Data Sources

Raw data are stored in `raw_data/` and were processed by proprietary device software before export. All subsequent processing and analysis is performed in open-source R.

| Source | Folder | Description | Format |
|--------|--------|-------------|--------|
| **ActTrust® actigraphy** | `raw_data/ACTTRUST/` | Raw exports from ActTrust® devices (Condor Instruments, São Paulo, Brazil). Worn on the **dominant hip** and **non-dominant wrist** simultaneously. Records activity in **PIM (Proportional Integration Mode)** — a measure of the integral of acceleration above a threshold — sampled at 25 Hz, band-pass filtered 0.5–2.7 Hz, and exported at 1-s epochs via **Act Studio** software. One file per participant per placement. | Proprietary `.txt` |
| **ActiGraph® GT3X+ actigraphy** | `raw_data/Gt3x/` | Raw exports from ActiGraph® GT3X+ devices (ActiGraph Corporation, Pensacola FL). Worn on the **dominant hip** and **non-dominant wrist** simultaneously. Records activity as **vector magnitude (VM)** counts — the Euclidean norm of triaxial acceleration — sampled at 30 Hz, band-pass filtered 0.25–2.5 Hz, and exported at 1-s epochs via **ActiLife v6.13.4**. One file per participant per placement. | `.gt3x` / `.csv` |
| **Indirect calorimetry** | `raw_data/ERGO/` | Breath-by-breath oxygen uptake (VO₂) measured by a **Quark CPET metabolic cart** (Cosmed®, Rome, Italy) during each treadmill condition. METs are computed as individual VO₂ / 3.5 mL O₂/kg/min. Values represent the mean from the **central 4 minutes** of each condition to exclude transition effects. | Proprietary Cosmed export |

> **Note on count magnitude differences:** ActTrust® PIM counts are systematically higher in absolute value than ActiGraph® GT3X+ vector magnitude counts due to differences in filtering, integration method, and hardware sensitivity. The two devices must not be compared directly in absolute terms — use device-specific regression equations and cut-points from this study.

---

## 📐 Processed Dataset

### `data/acttrust_validation_full.csv`

One row per **participant × treadmill condition**. Activity counts and METs are averaged over the central 4 minutes of each condition.

#### Identifiers and Metadata

| Column | Type | Units | Description |
|--------|------|-------|-------------|
| `ID` | character | — | Unique participant identifier |
| `Conditions` | character | — | Treadmill condition. Values: `Rest`, `3 km/h`, `5 km/h`, `7 km/h`, `9 km/h`, `Sit-Stands`. **`Sit-Stands` is excluded from all primary analyses.** |
| `Sex` | numeric (raw) / character (recoded) | — | `1 = Female`, `2 = Male` in the CSV. Recoded to `Female` / `Male` on load via `dplyr::recode()`. |
| `BMI` | numeric | kg/m² | Body mass index |

#### Metabolic Measurement

| Column | Type | Units | Description |
|--------|------|-------|-------------|
| `METs` | numeric | METs | Metabolic equivalent of task from indirect calorimetry. Calculated as individual VO₂ / 3.5 mL O₂/kg/min. Values are the mean over the central 4 minutes of each condition. 1 MET ≈ 3.5 mL O₂/kg/min at rest. |

#### Accelerometry — Activity Counts

Four device × placement combinations stored as separate columns. Both are averaged over the central 4 minutes of each condition.

| Column | Type | Units | Description |
|--------|------|-------|-------------|
| `GT3X+ (hip)` | numeric | counts/min | ActiGraph® GT3X+ on dominant hip. **Reference level** in all regression models. Vector magnitude counts; 30 Hz; band-pass 0.25–2.5 Hz; 1-s epochs; exported from ActiLife v6.13.4. |
| `GT3X+ (wrist)` | numeric | counts/min | ActiGraph® GT3X+ on non-dominant wrist. Same hardware and processing as hip placement. |
| `ACTT (hip)` | numeric | counts/min | ActTrust® on dominant hip. PIM mode; 25 Hz; band-pass 0.5–2.7 Hz; 1-s epochs; exported from Act Studio. |
| `ACTT (wrist)` | numeric | counts/min | ActTrust® on non-dominant wrist. Same hardware and processing as hip placement. |

---

### `data/S1.csv`

Supplementary participant-level data. See Zenodo archive for full description.

---

## 🔧 Derived Variables

These variables do not exist in the CSV but are computed in `index.qmd`.

| Variable | Created by | Description |
|----------|------------|-------------|
| `act` | `pivot_longer()` | Device × placement label after reshaping to long format. Factor with reference level `GT3X+ (hip)`. Values: `GT3X+ (hip)`, `GT3X+ (wrist)`, `ACTT (hip)`, `ACTT (wrist)`. |
| `act_value` | `pivot_longer()` | Activity count value corresponding to the `act` device × placement column. |
| `fit_MET` | `lm() |> fitted() |> ^2` | Model-fitted METs (fitted values of `sqrt(METs)` from the linear model, squared back to the MET scale). |
| `actual_class` | `cut(METs, ...)` | Observed PA intensity class from measured METs. Breaks: [0,3), [3,6), [6,9), [9,∞). |
| `predicted_class` | `calc_met_class(fit_MET)` | Predicted PA intensity class from model-fitted METs, using the same breaks as `actual_class`. |
| `mean_val` | Bland-Altman section | Mean of `fit_MET` and `METs` — the x-axis of Bland-Altman plots. |
| `diff_val` | Bland-Altman section | Difference `fit_MET − METs` — the y-axis of Bland-Altman plots. |

---

## 🏃 PA Intensity Classification

| Class label | MET range | Intensity |
|-------------|-----------|-----------|
| `[0,3)` | 0 ≤ METs < 3 | Light |
| `[3,6)` | 3 ≤ METs < 6 | Moderate |
| `[6,9)` | 6 ≤ METs < 9 | Vigorous |
| `[9,inf)` | METs ≥ 9 | Very Vigorous |

---

## 👤 Participant Characteristics

Summary statistics reported in Table 1 of the manuscript. Individual-level anthropometric data beyond `ID`, `BMI`, and `Sex` are not present as columns in the CSV but are available in the Zenodo archive.

| Characteristic | Male (n = 34) | Female (n = 22) |
|----------------|---------------|-----------------|
| Age (years) | 28.3 ± 4.6 | 26.8 ± 5.0 |
| Height (cm) | 172 ± 6.2 | 160 ± 7.3 |
| Weight (kg) | 78.2 ± 11.9 | 59.9 ± 9.4 |
| BMI (kg/m²) | 23.1 ± 1.6 | 26.7 ± 2.5 |
