% Downscale meteo data

% Add necessary paths
addpath(['N:\gebhyd\8_Him\Personal_folders\Mike\EMERGE\Maipo\'...
    'Secondary scripts and functions'])
addpath(['N:\gebhyd\8_Him\Personal_folders\Mike\EMERGE\Maipo\'...
    'Secondary scripts and functions\CircStat2012a'])

%% Specify run name and output folder
rn = 'Maipo_94';
foOut = 'Downscaling test 1 km\';
if ~exist(foOut,'file')
    mkdir(foOut)
end

%% Load ERA5-Land data
load('ERA5-Land data/Maipo_region_era5_land_20231011.mat')
lats = data.latitudes;
lons = data.longitudes;
zs = data.elevations;
dateTimes = data.dateTimes;

% Get number of timesteps
startDate = datetime(1998,1,1,0,0,0);
endDate = datetime(2000,1,15,23,0,0);
sdi = find(dateTimes == startDate);
edi = find(dateTimes == endDate);

% Create subfolders
yrs = year(startDate):year(endDate);
nYrs = length(yrs);
for iYr = 1:nYrs
    if ~exist([foOut '/' num2str(yrs(iYr)) '/'],'file')
        mkdir([foOut '/' num2str(yrs(iYr))])
        mkdir([foOut '/' num2str(yrs(iYr)) '/t2m'])
        mkdir([foOut '/' num2str(yrs(iYr)) '/d2m'])
        mkdir([foOut '/' num2str(yrs(iYr)) '/tp'])
        mkdir([foOut '/' num2str(yrs(iYr)) '/ssrd'])
        mkdir([foOut '/' num2str(yrs(iYr)) '/strd'])
        mkdir([foOut '/' num2str(yrs(iYr)) '/ws10'])
        mkdir([foOut '/' num2str(yrs(iYr)) '/sp'])
    end
end

%% Get points or grid to sample to
% If downscaling to points, provide list of points and convert to lat, lon    
utmZone = -19;

% Load grid coordinates to sample to and convert to lat, lon
load(['Inputs/Inputs_' rn '/spatial_data.mat'],'x','y','DTM');
y = flipud(y);
DTM = flipud(DTM);
dsXs = x;
dsYs = y;
dsZs = DTM;
[nRows,nCols] = size(x);
[dsLats,dsLons] = utm2ll(dsXs(:),dsYs(:),utmZone);
dsLats = reshape(dsLats,[nRows,nCols]);
dsLons = reshape(dsLons,[nRows,nCols]);
clearvars x y DTM

%% Get mean annual precipitation and specify precipitation gradient
nYrs = years(dateTimes(end)-dateTimes(1));
tpMean = sum(tp,3)/nYrs;
tpLr = 0.17/1000;

%% Get slope, aspect and curvature of DEM
n = 1500; % Scaling length 
curvature = getcurvature(dsZs,n);
pixelSize = dsXs(1,2)-dsXs(1,1);
[slope,aspect] = slopeaspect(dsZs,pixelSize);

%% Preallocate wind direction array
nTs = length(dateTimes);
theta = nan(nTs,1);

%% For each timestep
tic
%parpool(4); % Too high memory usage causes crash
for iTs = sdi:edi
    
    % Display which timestep
    disp(['Processing timestep: ' num2str(iTs)])
    
    % Get air temperature and dewpoint temperature      
    t2m = downscaletemperature(lons,lats,zs,data.t2m(:,:,iTs),...
        dsLons,dsLats,dsZs);
    d2m = downscaletemperature(lons,lats,zs,data.d2m(:,:,iTs),...
        dsLons,dsLats,dsZs);
    
    % Get precipitation
    tp = downscaleprecipitation(lons,lats,zs,data.tp(:,:,iTs),...
        dsLons,dsLats,dsZs,tpLr,...
        tpMean);
    
    % Get incoming shortwave and longwave radiation
    ssrd = downscaleradiation(lons,lats,data.ssrd(:,:,iTs),dsLons,dsLats);
    strd = downscalelongwave(lons,lats,data.strd(:,:,iTs),...
        data.t2m(:,:,iTs),data.d2m(:,:,iTs),dsLons,dsLats,t2m,d2m);
    
    % Get wind speed and direction
    [ws10,theta(iTs)] = downscalewindspeed(lons,lats,data.u10(:,:,iTs),...
        data.v10(:,:,iTs),dsLons,dsLats,slope,aspect,curvature);
    
    % Get atmospheric pressure
    sp = downscalepressure(lons,lats,zs,data.sp(:,:,iTs),...
        data.t2m(:,:,iTs),dsLons,dsLats,dsZs,t2m);  
    
    % Convert to single
    t2m = single(t2m);
    d2m = single(d2m);
    tp = single(tp);
    ssrd = single(ssrd);
    strd = single(strd);
    ws10 = single(ws10);
    sp = single(sp);
    
    % Save data in netcdf format
    date = dateTimes(iTs);
    datestr = [num2str(year(date),'%02.f') '_'...
        num2str(month(date),'%02.f') '_' num2str(day(date),'%02.f') ...
        '_' num2str(hour(date),'%02.f')];
    yr = year(date);
    
    % Create
    nccreate([foOut '/' num2str(yr) '/t2m/t2m_' datestr '.nc'],'t2m',...
          'Dimensions',{'r',nRows,'c',nCols},...
          'Format','netcdf4_classic','Datatype','single','DeflateLevel',2)
    nccreate([foOut '/' num2str(yr) '/d2m/d2m_' datestr '.nc'],'d2m',...
          'Dimensions',{'r',nRows,'c',nCols},...
          'Format','netcdf4_classic','Datatype','single','DeflateLevel',2)
    nccreate([foOut '/' num2str(yr) '/tp/tp_' datestr '.nc'],'tp',...
          'Dimensions',{'r',nRows,'c',nCols},...
          'Format','netcdf4_classic','Datatype','single','DeflateLevel',2)
    nccreate([foOut '/' num2str(yr) '/ssrd/ssrd_' datestr '.nc'],'ssrd',...
          'Dimensions',{'r',nRows,'c',nCols},...
          'Format','netcdf4_classic','Datatype','single','DeflateLevel',2)
    nccreate([foOut '/' num2str(yr) '/strd/strd_' datestr '.nc'],'strd',...
          'Dimensions',{'r',nRows,'c',nCols},...
          'Format','netcdf4_classic','Datatype','single','DeflateLevel',2)
    nccreate([foOut '/' num2str(yr) '/ws10/ws10_' datestr '.nc'],'ws10',...
          'Dimensions',{'r',nRows,'c',nCols},...
          'Format','netcdf4_classic','Datatype','single','DeflateLevel',2)
    nccreate([foOut '/' num2str(yr) '/sp/sp_' datestr '.nc'],'sp',...
          'Dimensions',{'r',nRows,'c',nCols},...
          'Format','netcdf4_classic','Datatype','single','DeflateLevel',2)
    
    % Write
    ncwrite([foOut '/' num2str(yr) '/t2m/t2m_' datestr '.nc'],'t2m',t2m);
    ncwrite([foOut '/' num2str(yr) '/d2m/d2m_' datestr '.nc'],'d2m',d2m);
    ncwrite([foOut '/' num2str(yr) '/tp/tp_' datestr '.nc'],'tp',tp);
    ncwrite([foOut '/' num2str(yr) '/ssrd/ssrd_' datestr '.nc'],'ssrd',ssrd);
    ncwrite([foOut '/' num2str(yr) '/strd/strd_' datestr '.nc'],'strd',strd);
    ncwrite([foOut '/' num2str(yr) '/ws10/ws10_' datestr '.nc'],'ws10',ws10);
    ncwrite([foOut '/' num2str(yr) '/sp/sp_' datestr '.nc'],'sp',sp);
end
toc

%% Save wind direction data
Twind = table(dateTimes(:),theta,'VariableNames',{'time','theta'});
writetable(Twind,[foOut '/wind_direction.csv'])
