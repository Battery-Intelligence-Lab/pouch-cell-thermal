# pouch-cell-thermal
Accurate thermal modelling during fast charging in large-format Li-ion pouch cells


# Data: 

- `Expivium.mat`: Basic measurements, N x 4 matrix with columns: Sample, voltage (V), current (A), mean temperature (degC).
- `ExpIR.mat`: Surface temperature (degC), Ny x Nz x N tensor where Ny and Nz are spatial dimensions (single precision).

- 1C CC data is omitted due to bad camera calibration.

|                   | File path (inside data/exp) | Experiment                  | Remarks        |
|-------------------|-----------------------------|-----------------------------|----------------|
| Constant Current  | CC/2C/ch                    | CC- 2C  charge              |                |
|                   | CC/2C/dch                   | CC- 2C  discharge           |                |
|                   | CC/4C/ch                    | CC- 4C  charge              |                |
|                   | CC/4C/dch                   | CC- 4C  discharge           |                |
|                   | CC/6C/ch                    | CC- 6C  charge              |                |
|                   | CC/6C/dch                   | CC- 6C  discharge           |                |
|                   | CC/8C/ch                    | CC- 8C  charge              |                |
|                   | CC/8C/dch                   | CC- 8C  discharge           |                |
|                   | CC/10C/ch                   | CC- 10C charge              |                |
|                   | CC/10C/dch                  | CC- 10C discharge           |                |
| Square Wave Pulse | pulse/30SOC/2C/100s         | Pulse - 30% SOC - 2C - 100s |                |
|                   | pulse/30SOC/4C/100s         | Pulse - 30% SOC - 4C-  100s |                |
|                   | pulse/30SOC/8C/50s          | Pulse - 30% SOC - 8C - 50s  |                |
|                   | pulse/50SOC/2C/100s         | Pulse - 50% SOC - 2C - 100s |                |
|                   | pulse/50SOC/4C/100s         | Pulse - 50% SOC - 4C - 100s |                |
|                   | pulse/50SOC/8C/50s          | Pulse - 50% SOC - 8C - 50s  |                |
|                   | pulse/70SOC/2C/100s         | Pulse - 70% SOC - 2C - 100s |                |
|                   | pulse/70SOC/4C/100s         | Pulse - 70% SOC - 4C - 100s |                |
|                   | pulse/70SOC/8C/50s          | Pulse - 70% SOC - 8C - 50s  |                |
