# Data Dictionary — ACTT Validation Study

This document describes all variables in the study dataset. Data are available at
https://doi.org/10.5281/zenodo.15315735

All analyses read from a single file: **`data/acttrust_validation_full.csv`**

---

## Raw Data Columns

### Identifiers and Metadata

| Column | Type | Units | Description |
|--------|------|-------|-------------|
| `ID` | character / integer | — | Unique participant identifier |
| `Conditions` | character | — | Treadmill condition. Values: `Rest`, `3 km/h`, `5 km/h`, `7 km/h`, `9 km/h`, `Sit-Stands`. **`Sit-Stands` is excluded from all primary analyses.** |
| `BMI` | numeric | kg/m² | Body mass index |
| `Sex` | numeric | — | Female: 1. Male: 2 |

### Metabolic Measurement

| Column | Type | Units | Description |
|--------|------|-------|-------------|
| `METs` | numeric | METs | Metabolic equivalent of task, calculated from individual VO₂ measured by indirect calorimetry (Quark CPET, Cosmed®). 1 MET ≈ 3.5 mL O₂/kg/min at rest. Values represent the mean from the central 4 minutes of each condition. |

### Accelerometry — Activity Counts

Four device × placement combinations are stored as separate columns.
GT3X+ values are vector magnitude (VM) counts; ActTrust® values are PIM (Proportional Integration Mode) counts.
Both are averaged over the central 4 minutes of each condition.

| Column | Type | Units | Description |
|--------|------|-------|-------------|
| `GT3X+ (hip)` | numeric | counts/min | ActiGraph® GT3X+ on dominant hip. **Reference level** in all models. Sampled at 30 Hz; band-pass filtered 0.25–2.5 Hz; exported from ActiLife v6.13.4. |
| `GT3X+ (wrist)` | numeric | counts/min | ActiGraph® GT3X+ on non-dominant wrist. Same hardware and processing as hip. |
| `ACTT (hip)` | numeric | counts/min | ActTrust® (Condor Instruments) on dominant hip. Sampled at 25 Hz; band-pass filtered 0.5–2.7 Hz; PIM mode; exported from Act Studio. |
| `ACTT (wrist)` | numeric | counts/min | ActTrust® on non-dominant wrist. Same hardware and processing as hip. |

> **Note:** ActTrust® (ACTT) count magnitudes are systematically higher than GT3X+ counts. The two devices are not directly comparable in absolute terms — device-specific equations and cut-points must be used (see Table 2 in manuscript).

---

## Derived Variables (Created in the Notebook)

These variables do not exist in the CSV but are computed in `ACTT_validation_study.qmd`.

| Variable | Created by | Description |
|----------|------------|-------------|
| `act` | `pivot_longer()` | Device-placement label after reshaping to long format. Factor with reference level `GT3X+ (hip)`. Values: `GT3X+ (hip)`, `GT3X+ (wrist)`, `ACTT (hip)`, `ACTT (wrist)`. |
| `act_value` | `pivot_longer()` | Activity count value for the corresponding `act` device-placement. |
| `fit_MET` | `lm() |> fitted() |> ^2` | Model-fitted METs (fitted values of `sqrt(METs)`, squared back to the MET scale). |
| `actual_class` | `cut(METs, ...)` | Observed PA intensity class from measured METs. Breaks: [0,3), [3,6), [6,9), [9,∞). |
| `predicted_class` | `calc_met_class(fit_MET)` | Predicted PA intensity class from model-fitted METs, using the same breaks as `actual_class`. |

---

## PA Intensity Classification

| Class label | MET range | Intensity |
|-------------|-----------|-----------|
| `[0,3)` | 0 ≤ METs < 3 | Light |
| `[3,6)` | 3 ≤ METs < 6 | Moderate |
| `[6,9)` | 6 ≤ METs < 9 | Vigorous |
| `[9,inf)` | METs ≥ 9 | Very Vigorous |

---

## Participant Characteristics (Reported in Table 1 of Manuscript)

These summary statistics are reported in the paper but individual-level anthropometric
data beyond `ID`, `BMI` and `Sex` are not present as separate columns in the CSV.
Full demographic data are available in the Zenodo archive.

| Characteristic | Male (n=34) | Female (n=22) |
|----------------|-------------|---------------|
| Age (years) | 28.3 ± 4.6 | 26.8 ± 5.0 |
| Height (cm) | 172 ± 6.2 | 160 ± 7.3 |
| Weight (kg) | 78.2 ± 11.9 | 59.9 ± 9.4 |
| BMI (kg/m²) | 23.1 ± 1.6 | 26.7 ± 2.5 |
