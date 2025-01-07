% Downscale precipitation following Machguth et al (2009)
%
% Michael McCarthy 2024
function dsVar = downscaleprecipitation(x,y,z,var,dsX,dsY,dsZ,specLr,...
    varMean)

% Format x, y data
xys = rot90([x(:),y(:)]);
dsXys = rot90([dsX(:),dsY(:)]);

% Apply interpolation scheme to variable
fnSpline = tpaps(xys,rot90(var(:)),1);
varInt = fnval(fnSpline,dsXys);
varInt = varInt(:);
varInt = reshape(varInt,size(dsX));

fnSpline = tpaps(xys,rot90(z(:)),1);
zInt = fnval(fnSpline,dsXys);
zInt = zInt(:);
zInt = reshape(zInt,size(dsX));

fnSpline = tpaps(xys,rot90(varMean(:)),1);
varMeanInt = fnval(fnSpline,dsXys);
varMeanInt = varMeanInt(:);
varMeanInt = reshape(varMeanInt,size(dsX));

% Calculate correction factor
varCorr = (varMeanInt+((dsZ-zInt).*specLr))./varMeanInt;
dsVar = varInt.*varCorr;

% Precipitation cannot be less than zero
dsVar(dsVar < 0) = 0;

end