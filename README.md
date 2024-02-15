# Beat Detection

A project for SMP in Matlab.

## Directory Structure

- [src/](./src/) contains all source code of the project.
- [docs/](./docs/) contains documentation written in LaTeX.
- [assets/](./assets/) contains exported images and PDFs to be displayed on this page.

## Cloning

Clone using HTTPS:

```bash
git clone https://github.com/sid115/smp-project.git
```

## Running

Navigate to `smp-project/src` and run:

```bash
octave beatDetect.m "/path/to/file.wav"
```

## Analysis

A plot showing the energy of the signal over the sample index with markers for each detected beat is exported to [assets/](../assets):

![DetectedPeaksPlot.png](../assets/DetectedPeaksPlot.png)

The estimated BPM is printed in your CLI:

```bash
$ octave beatDetect.m "../assets/techno.wav"

Estimated BPM: 147
```

## Deadlines / Dates

Date | Appointment
---|---
2023-12-15 | Consultation Hour
2023-12-21 | Project Plan
2024-01-19 | Interim Report
2024-03-07 | Final Report

We hold a weekly meeting every Tuesday from 11 am to 3 pm.
