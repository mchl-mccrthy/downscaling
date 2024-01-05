% Example showing how to use the function 'downscale' to downscale gridded 
% meteorological data to a new grid
%
% Michael McCarthy 2024

% Load reanalysis data and sample grid
load('Inputs/reanalysis_data.mat')
load('Inputs/sample_grid.mat')

% Specify some options
foOut = 'Outputs'; % Output folder
dim = 'grid'; % Grid 'grid' or points 'points'
startDate = datetime(1998,1,1,0,0,0);
endDate = datetime(1998,1,1,23,0,0);
tpLr = 0; % Lapse rate in mm yr-1 m-1
n = 1500; % Scaling length for curvature calculation (m)
nCpus = 1; % Number of CPUs

% Get slope, aspect and curvature of local topography
demCurv = getcurvature(demZs,n);
pixelSize = abs(demLats(1,1)-demLats(2,1))*111.1e3; % (m)
[demSlope,demAspect] = slopeaspect(demZs,pixelSize);

% Downscale reanalysis data
downscale(foOut,dim,startDate,endDate,tpLr,lats,lons,zs,dateTimes,...
    t2m,tp,ssrd,strd,sp,u10,v10,d2m,dsLats,dsLons,dsZs,demLats,demLons,...
    demZs,demCurv,demSlope,demAspect,nCpus)

