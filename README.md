# A MATLAB toolbox for statistical downscaling of climate reanalysis data

This toolbox implements algorithms with which climate reanalysis data can be statistically downscaled from low to high spatial resolution for climate impact models. The climate variables considered include air temperature, precipitation, incoming shortwave radiation, incoming longwave radiation, atmospheric pressure, wind speed and relative humidity. Air temperature, dewpoint temperature and precipitation are downscaled following Machguth et al (2009), as described by McCarthy et al (2022). Atmospheric pressure and incoming longwave radiation are downscaled following Cosgrove et al (2003), wind speed is downscaled following Liston and Elder (2006), incoming shortwave radiation is downscaled simply using a thin-plate spline (i.e., there is no topographic correction as this is often done internally in climate impact models), and relative humidity is computed from downscaled air and dewpoint temperature, similar to Rouf et al (2020). The toolbox can be used to downscale to a grid or to point locations.

Author: Michael McCarthy (michael.mccarthy@wsl.ch)

## Using the toolbox
The scripts [src/example_grid.m](src/example_grid.m) and [src/example_points.m](src/example_points.m) show how to use the toolbox to downscale to a grid or to points, respectively. To run the examples, download the repository, open MATLAB, and navigate to the example scripts. Paths will be initialised based on the structure of the repository. Note that the grid example uses the MATLAB Parallel Computing Toolbox and that the toolbox has been tested in MATLAB 2022a.

## Input data
Inputs from the climate reanalysis include latitude, longitude, elevation, time, air temperature, precipitation, incoming shortwave radiation, incoming longwave radiation, atmospheric pressure, u and v components of wind, and dewpoint temperature. Latitude, longitude and elevation data of the grid or points to which the reanalysis will be downscaled must also be provided. Example input data are provided in the folder [/inputs](/outputs). 

## Output data
Outputs include downscaled air temperature, precipitation, incoming shortwave radiation, incoming longwave radiation, atmospheric pressure, wind speed and relative humidity. Running the example scripts will produce example output data in a folder [/outputs](/outputs). 

## References
Cosgrove, B. A., Lohmann, D., Mitchell, K. E., Houser, P. R., Wood, E. F., Schaake, J. C., ... & Meng, J. (2003). Real‐time and retrospective forcing in the North American Land Data Assimilation System (NLDAS) project. Journal of Geophysical Research: Atmospheres, 108(D22).

Liston, G. E., & Elder, K. (2006). A meteorological distribution system for high-resolution terrestrial modeling (MicroMet). Journal of Hydrometeorology, 7(2), 217-234.

Machguth, H., Paul, F., Kotlarski, S., & Hoelzle, M. (2009). Calculating distributed glacier mass balance for the Swiss Alps from regional climate model output: A methodical description and interpretation of the results. Journal of Geophysical Research: Atmospheres, 114(D19).

McCarthy, M., Meier, F., Fatichi, S., Stocker, B. D., Shaw, T. E., Miles, E., ... & Pellicciotti, F. (2022). Glacier contributions to river discharge during the current Chilean megadrought. Earth's Future, 10(10), e2022EF002852.

Rouf, T., Mei, Y., Maggioni, V., Houser, P., & Noonan, M. (2020). A physically based atmospheric variables downscaling technique. Journal of Hydrometeorology, 21(1), 93-108.

## Third-party dependencies
This toolbox includes third-party scripts that are licensed under different terms as follows:

[third_party/brewermap.m](third_party/brewermap.m), Stephen Cobeldick, 2014–2024, BSD 3-Clause ([third_party/LICENSE_brewermap.txt](third_party/LICENSE_brewermap.txt))

[third_party/inpaint_nans.m](third_party/inpaint_nans.m), John D'Errico, 2009, BSD 3-Clause ([third_party/LICENSE_inpaint_nans.txt](third_party/LICENSE_inpaint_nans.txt))

[third_party/circ_mean.m](third_party/circ_mean.m), Philipp Berens, 2011, Apache 2.0 ([third_party/LICENSE_circ_mean.txt](third_party/LICENSE_circ_mean.txt))

