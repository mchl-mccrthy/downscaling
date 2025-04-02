% Downscale reanalysis data
%
% Michael McCarthy 2024
function downscale(foOut,dim,startDate,endDate,tpLr,lats,lons,zs,...
    dateTimes,t2m,tp,ssrd,strd,sp,u10,v10,d2m,dsLats,dsLons,dsZs,...
    demLats,demLons,demZs,demCurv,demSlope,demAspect,nCpus)

% Display initation message
disp('Downscaling initiated')

% Get indices of start and end dates
sdi = find(dateTimes == startDate);
edi = find(dateTimes == endDate);

% Get number of rows and columns in grid
[nRows,nCols] = size(dsLats);

% Get mean annual precipitation
nYrs = years(dateTimes(end)-dateTimes(1));
tpMean = sum(tp,3)/nYrs;

% Preallocate wind direction array
nTs = length(dateTimes);
theta = nan(nTs,1);

% If downscaling to grid
if strcmp(dim,'grid')
    
    % Set up main folder
    if ~exist(foOut,'file')
        mkdir(foOut)
    end

    % Set up subfolders
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
    
    % Loop through time steps
    parpool(nCpus); % Note too high memory usage causes crash
    parfor iTs = sdi:edi
        
        % Display which timestep
        disp(['Processing time step: ' num2str(iTs,'%03.f')])
        
        % Get air temperature and dewpoint temperature      
        dsT2m = downscaletemperature(lons,lats,zs,t2m(:,:,iTs),...
            dsLons,dsLats,dsZs);
        dsD2m = downscaletemperature(lons,lats,zs,d2m(:,:,iTs),...
            dsLons,dsLats,dsZs);
        
        % Get precipitation
        dsTp = downscaleprecipitation(lons,lats,zs,tp(:,:,iTs),...
            dsLons,dsLats,dsZs,tpLr,...
            tpMean);
        
        % Get incoming shortwave and longwave radiation
        dsSsrd = downscaleshortwave(lons,lats,ssrd(:,:,iTs),dsLons,dsLats);
        dsStrd = downscalelongwave(lons,lats,strd(:,:,iTs),...
            t2m(:,:,iTs),d2m(:,:,iTs),dsLons,dsLats,dsT2m,dsD2m);
        
        % Get wind speed and direction
        [dsWs10,theta(iTs)] = downscalewindspeed(lons,lats,u10(:,:,iTs),...
            v10(:,:,iTs),dsLons,dsLats,demLats,demLons,...
            demZs,demSlope,demAspect,demCurv,dim);
        
        % Get atmospheric pressure
        dsSp = downscalepressure(lons,lats,zs,sp(:,:,iTs),...
            t2m(:,:,iTs),dsLons,dsLats,dsZs,dsT2m);  
        
        % Convert to single
        dsT2m = single(dsT2m);
        dsD2m = single(dsD2m);
        dsTp = single(dsTp);
        dsSsrd = single(dsSsrd);
        dsStrd = single(dsStrd);
        dsWs10 = single(dsWs10);
        dsSp = single(dsSp);
        
        % Make date string
        date = dateTimes(iTs);
        datestr = [num2str(year(date),'%02.f') '_'...
            num2str(month(date),'%02.f') '_' num2str(day(date),'%02.f') ...
            '_' num2str(hour(date),'%02.f')];
        yr = year(date);
        
        % Create netcdf files
        nccreate([foOut '/' num2str(yr) '/t2m/t2m_' datestr '.nc'],...
            't2m',  'Dimensions',{'r',nRows,'c',nCols},'Format',...
            'netcdf4_classic','Datatype','single','DeflateLevel',2)
        nccreate([foOut '/' num2str(yr) '/d2m/d2m_' datestr '.nc'],...
            'd2m','Dimensions',{'r',nRows,'c',nCols},'Format',...
            'netcdf4_classic','Datatype','single','DeflateLevel',2)
        nccreate([foOut '/' num2str(yr) '/tp/tp_' datestr '.nc'],...
            'tp','Dimensions',{'r',nRows,'c',nCols},'Format',...
            'netcdf4_classic','Datatype','single','DeflateLevel',2)
        nccreate([foOut '/' num2str(yr) '/ssrd/ssrd_' datestr '.nc'],...
            'ssrd','Dimensions',{'r',nRows,'c',nCols},'Format',...
            'netcdf4_classic','Datatype','single','DeflateLevel',2)
        nccreate([foOut '/' num2str(yr) '/strd/strd_' datestr '.nc'],...
            'strd','Dimensions',{'r',nRows,'c',nCols},'Format',...
            'netcdf4_classic','Datatype','single','DeflateLevel',2)
        nccreate([foOut '/' num2str(yr) '/ws10/ws10_' datestr '.nc'],...
            'ws10','Dimensions',{'r',nRows,'c',nCols},'Format',...
            'netcdf4_classic','Datatype','single','DeflateLevel',2)
        nccreate([foOut '/' num2str(yr) '/sp/sp_' datestr '.nc'],...
            'sp','Dimensions',{'r',nRows,'c',nCols},'Format',...
            'netcdf4_classic','Datatype','single','DeflateLevel',2)
        
        % Write netcdf files
        ncwrite([foOut '/' num2str(yr) '/t2m/t2m_' datestr '.nc'],...
            't2m',dsT2m);
        ncwrite([foOut '/' num2str(yr) '/d2m/d2m_' datestr '.nc'],...
            'd2m',dsD2m);
        ncwrite([foOut '/' num2str(yr) '/tp/tp_' datestr '.nc'],...
            'tp',dsTp);
        ncwrite([foOut '/' num2str(yr) '/ssrd/ssrd_' datestr '.nc'],...
            'ssrd',dsSsrd);
        ncwrite([foOut '/' num2str(yr) '/strd/strd_' datestr '.nc'],...
            'strd',dsStrd);
        ncwrite([foOut '/' num2str(yr) '/ws10/ws10_' datestr '.nc'],...
            'ws10',dsWs10);
        ncwrite([foOut '/' num2str(yr) '/sp/sp_' datestr '.nc'],...
            'sp',dsSp);
    end
    
% If downscaling to point(s)
elseif strcmp(dim,'points')

    % Preallocate space for downscaled data
    nPts = length(dsLats);
    [dsT2m,dsD2m,dsTp,dsSsrd,dsStrd,dsWs10,dsSp] = deal(nan(nTs,nPts));

    % Loop through time steps
    %parpool(nCpus); % Note too high memory usage causes crash
    for iTs = sdi:edi
        
        % Display which timestep
        disp(['Processing time step: ' num2str(iTs,'%03.f')])
        
        % Get air temperature and dewpoint temperature      
        dsT2m(iTs,:) = downscaletemperature(lons,lats,zs,t2m(:,:,iTs),...
            dsLons,dsLats,dsZs);
        dsD2m(iTs,:) = downscaletemperature(lons,lats,zs,d2m(:,:,iTs),...
            dsLons,dsLats,dsZs);
        
        % Get precipitation
        dsTp(iTs,:) = downscaleprecipitation(lons,lats,zs,tp(:,:,iTs),...
            dsLons,dsLats,dsZs,tpLr,...
            tpMean);
        
        % Get incoming shortwave and longwave radiation
        dsSsrd(iTs,:) = downscaleshortwave(lons,lats,ssrd(:,:,iTs),dsLons,dsLats);
        dsStrd(iTs,:) = downscalelongwave(lons,lats,strd(:,:,iTs),...
            t2m(:,:,iTs),d2m(:,:,iTs),dsLons,dsLats,dsT2m(iTs,:),dsD2m(iTs,:));
        
        % Get wind speed and direction
        [dsWs10(iTs,:),theta(iTs)] = downscalewindspeed(lons,lats,u10(:,:,iTs),...
            v10(:,:,iTs),dsLons,dsLats,demLats,demLons,demZs,demSlope,demAspect,demCurv,dim);
        
        % Get atmospheric pressure
        dsSp(iTs,:) = downscalepressure(lons,lats,zs,sp(:,:,iTs),...
            t2m(:,:,iTs),dsLons,dsLats,dsZs,dsT2m(iTs,:));  
    end

    % Convert to single
    dsT2m = single(dsT2m);
    dsD2m = single(dsD2m);
    dsTp = single(dsTp);
    dsSsrd = single(dsSsrd);
    dsStrd = single(dsStrd);
    dsWs10 = single(dsWs10);
    dsSp = single(dsSp);
    
    % Make table for each point
    for iPt = 1:nPts
        T = table;
        T.dateTime = dateTimes';
        T.t2m = dsT2m(:,iPt);
        T.d2m = dsD2m(:,iPt);
        T.tp = dsTp(:,iPt);
        T.ssrd = dsSsrd(:,iPt);
        T.strd = dsStrd(:,iPt);
        T.ws10 = dsWs10(:,iPt);
        T.sp = dsSp(:,iPt);
        writetable(T,[foOut '/point_' num2str(iPt,'%03.f') '.csv'])
    end
end

% Save wind direction
Twind = table(dateTimes(:),theta,'VariableNames',{'time','theta'});
writetable(Twind,[foOut '/wind_direction.csv'])

% Display completion message
disp('Downscaling completed')

end
