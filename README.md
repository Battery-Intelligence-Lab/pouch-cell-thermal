# pouch-cell-thermal
Accurate thermal modelling during fast charging in large-format Li-ion pouch cells using MATLAB and COMSOL Multiphysics.
See our paper ["Electrochemical–thermal modelling of high power Li-ion pouch cells" (Journal of Power Sources, 2026)](https://doi.org/10.1016/j.jpowsour.2025.238764).

**Authors:** Volkan Kumtepeli, Malgorzata E. Wojtala, Eloise C. Tredenick, Charles W. Monroe, David A. Howey.

# How to use 

This repository is comprised of several folders: 
- `aux_fun`: Auxillary functions to be used for running simulations, optimisation and plotting. 
- `data`: Experimental data and some parameter values and/or functions. 
- `parameter_fitting`: Optimisation functions for fitting parameters. 
- `parameter_evaluation`: Involves functions to use the optimal parameters to run all pulse and constant current simulations to generate simulation results. 
- `results`: Folder to store generated simulation results.
- `plotting`: Functions to create figures for the manuscript using the generated simulation results by `parameter_evaluation` functions. 
- `test`: Involves some individual files for sanity checks. 

## Requirements
*   MATLAB
*   COMSOL Multiphysics (v6.3 or later) with LiveLink for MATLAB


# Dependencies

This code repository requires following dependencies to be added in auxillary functions, `aux_fun` folder, mostly for plotting purposes. 

- [tight_subplot](https://uk.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w)

- [coord2norm](https://github.com/StackOverflowMATLABchat/coordinate2normalized)

- [cmocean](https://www.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps)

- [viridis](https://uk.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps)


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

