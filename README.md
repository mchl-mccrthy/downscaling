# A MATLAB toolbox for statistical downscaling of climate reanalysis data

This toolbox implements algorithms with which climate reanalysis data can be statistically downscaled from low to high spatial resolution. The climate variables considered include air temperature, precipitation, incoming shortwave radiation, incoming longwave radiation, atmospheric pressure, wind speed and relative humidity. Air temperature, dewpoint temperature and precipitation are downscaled following Machguth et al (2009), as described by McCarthy et al (2022). Atmospheric pressure and incoming longwave radiation are downscaled following Cosgrove et al (2003), wind speed is downscaled following Liston and Elder (2006), incoming shortwave radiation is downscaled simply using a thin-plate spline (i.e., there is no topographic correction), and relative humidity is computed from downscaled air and dewpoint temperature. The algorithms can be used to downscale to a grid or to individual points.

## Using the toolbox
The scripts example_grid.m and example_points.m show how to use the toolbox to downscale to a grid or to points, respectively.

## Input data
Example input data are provided in the folder /Inputs.

## Output data
Running the example scripts will produce example output data in a folder /Outputs.

## References
Cosgrove, B. A., Lohmann, D., Mitchell, K. E., Houser, P. R., Wood, E. F., Schaake, J. C., ... & Meng, J. (2003). Real‐time and retrospective forcing in the North American Land Data Assimilation System (NLDAS) project. Journal of Geophysical Research: Atmospheres, 108(D22).
Liston, G. E., & Elder, K. (2006). A meteorological distribution system for high-resolution terrestrial modeling (MicroMet). Journal of Hydrometeorology, 7(2), 217-234.
Machguth, H., Paul, F., Kotlarski, S., & Hoelzle, M. (2009). Calculating distributed glacier mass balance for the Swiss Alps from regional climate model output: A methodical description and interpretation of the results. Journal of Geophysical Research: Atmospheres, 114(D19).
McCarthy, M., Meier, F., Fatichi, S., Stocker, B. D., Shaw, T. E., Miles, E., ... & Pellicciotti, F. (2022). Glacier contributions to river discharge during the current Chilean megadrought. Earth's Future, 10(10), e2022EF002852.

Author: Michael McCarthy (michael.mccarthy@wsl.ch)
