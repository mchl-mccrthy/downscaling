% Example showing how to use the function 'downscale' to downscale gridded 
% meteorological data to a new grid
%
% Michael McCarthy 2024

% Get parent folder and add paths
foParent = fileparts(pwd);
addpath([foParent '/src'])
addpath([foParent '/third_party'])
addpath([foParent '/inputs'])
addpath([foParent '/outputs'])

% Load reanalysis data and sample grid
load('Inputs/reanalysis_data.mat')
load('Inputs/sample_grid.mat')

% Specify some options
foOut = [foParent '/outputs']; % Output folder
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

% Plot temperature for first time step
date = startDate;
datestr = [num2str(year(date),'%02.f') '_'...
    num2str(month(date),'%02.f') '_' num2str(day(date),'%02.f') ...
    '_' num2str(hour(date),'%02.f')];
T = ncread([foOut '/' num2str(year(startDate)) '/t2m/t2m_' datestr ...
    '.nc'],'t2m');
figure()
cLims = linspace(-max(abs(T-273.15),[],'all'),max(abs(T-273.15),[],'all'));
[xs,ys] = meshgrid(1:size(demZs,2),fliplr(1:size(demZs,1)));
contourf(xs,ys,T-273.15,cLims,'LineColor','none'); hold on
c = colorbar;
c.Label.String = 'Temperature (\circC)';
colormap(flipud(brewermap(25,'RdBu')))
clim([cLims(1) cLims(end)])
axis equal
xlabel('Easting (km)')
ylabel('Northing (km)')
formatfigure(gcf,10,10,4)

