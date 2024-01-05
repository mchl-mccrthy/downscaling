% Downscale temperature following Machguth et al (2009)
% 
% Michael McCarthy 2024
function dsVar = downscaletemperature(x,y,z,var,dsX,dsY,dsZ)

% Format x, y data
xys = rot90([x(:),y(:)]);
dsXys = rot90([dsX(:),dsY(:)]);

% Get lapse rate
Z = [ones(length(z(:)),1) z(:)];
lr = Z\var(:);
lr = lr(2);

% Use lapse rate with input elevations to calculate value of 
% variable at standard elevation (0 m a.s.l)
varSe = var-z*lr;
varSe = rot90(varSe(:));

% Apply interpolation scheme to standard elevation variable, to look at
% spatial variability of variable independent of elevation
fnSpline = tpaps(xys,varSe);
varSeInt = fnval(fnSpline,dsXys);
varSeInt = varSeInt(:);
varSeInt = reshape(varSeInt,size(dsX));

% Calculate variable value at fine grid or point elevations
dsVar = dsZ*lr+varSeInt;

end
