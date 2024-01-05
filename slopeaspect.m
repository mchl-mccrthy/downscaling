% Calculate slope and aspect from a DEM (output is degrees)
%
% Michael McCarthy 2024
function [slope,aspect] = slopeaspect(DEM,pixelSize)

[dzdx,dzdy] = gradient(DEM); % Calculate DEM gradients
dzdx = dzdx/pixelSize; dzdy = dzdy/pixelSize; % Divide gradients by pixel size 
slope = atand(sqrt(dzdx.^2+dzdy.^2)); % Calculate slope
aspect = atan2d(dzdy,dzdx)-90; % Calculate aspect (zero is east in MATLAB)
aspect(aspect<0) = aspect(aspect<0)+360; % Make aspect always positive

end