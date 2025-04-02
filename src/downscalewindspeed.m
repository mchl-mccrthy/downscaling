% Downscale wind speed following Liston and Elder (2006), such that 
% wind speeds are higher on ridges and upwind slopes, lower in valley 
% bottoms and on downwind slopes
%
% Michael McCarthy 2023
function [dsW,theta] = downscalewindspeed(x,y,u,v,dsX,dsY,demY,demX,...
    demZ,slope,aspect,curvature,dim)

% Format x, y data
xys = rot90([x(:),y(:)]);
dsXys = rot90([dsX(:),dsY(:)]);

% Interpolate u, v, and calculate and interpolate wind speed
fnSpline = tpaps(xys,rot90(u(:)),1);
uInt = fnval(fnSpline,dsXys);
uInt = uInt(:);
uInt = reshape(uInt,size(dsX));
fnSpline = tpaps(xys,rot90(v(:)),1);
vInt = fnval(fnSpline,dsXys);
vInt = vInt(:);
vInt = reshape(vInt,size(dsX));
wInt = sqrt(vInt.^2+uInt.^2);

% Calculate mean wind direction, where theta is the direction towards 
% which the wind is blowing
theta = atan2d(uInt,vInt);
theta(theta < 0) = theta(theta < 0)+360;
thetaRad = theta*pi/180;
thetaRad = thetaRad(:);
thetaMeanRad = circ_mean(thetaRad);
thetaMean = thetaMeanRad/pi*180;
thetaMean(thetaMean < 0) = thetaMean(thetaMean < 0)+360;

% Rescale curvature
omegaC = curvature;
omegaC(omegaC > 0) =...
    omegaC(omegaC > 0)*0.5./max(max(omegaC(omegaC > 0)));
omegaC(omegaC < 0) =...
    -omegaC(omegaC < 0)*0.5./min(min(omegaC(omegaC < 0)));

% Calculate slope in direction of wind and rescale
omegaS = -slope.*cosd(thetaMean-aspect);
omegaS(omegaS > 0) =...
    omegaS(omegaS > 0)*0.5./max(max(omegaS(omegaS > 0)));
omegaS(omegaS < 0) =...
    -omegaS(omegaS < 0)*0.5./min(min(omegaS(omegaS < 0)));

% Calculate weighting factors
Ww = 1+0.5*omegaS+0.5*omegaC;

% If downscaling to point(s), extract weighting factors at points
if strcmp(dim,'points')
    nPts = length(dsX);
    WwTemp = nan(size(dsX));
    for iPt = 1:nPts
        [row,col] = indexofclosest(dsX(iPt),dsY(iPt),demX,demY);
        WwTemp(iPt) = Ww(row,col);
    end
    Ww = WwTemp;
end

% Downscale interpolated wind speed with weighting factors
dsW = Ww.*wInt;
theta = thetaMean;

end
