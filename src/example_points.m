% Example showing how to use the function 'downscale' to downscale gridded 
% meteorological data to point(s)
%
% Michael McCarthy 2024

% Get parent folder and add paths
foParent = fileparts(pwd);
addpath([foParent '/src'])
addpath([foParent '/third_party'])
addpath([foParent '/inputs'])
addpath([foParent '/outputs'])

% Load reanalysis data and sample point(s)
load('inputs/reanalysis_data.mat')
load('inputs/sample_points.mat')

% Specify some options
foOut = 'outputs'; % Output folder
dim = 'points'; % Grid 'grid' or points 'points'
startDate = datetime(1998,1,1,0,0,0);
endDate = datetime(1998,1,7,23,0,0);
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

% Plot temperature at first point
T = readtable([foOut '/point_001.csv']);
figure()
plot(T.dateTime,T.t2m-273.15)
ylabel('Temperature (\circC)')
formatfigure(gcf,7,3,2)
