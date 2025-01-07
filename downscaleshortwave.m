% Downscale shortwave by simple interpolation
% 
% Michael McCarthy 2024
function dsVar = downscaleshortwave(x,y,var,dsX,dsY)

% Format x, y data
xys = rot90([x(:),y(:)]);
dsXys = rot90([dsX(:),dsY(:)]);

% Apply interpolation scheme to variable
fnSpline = tpaps(xys,rot90(var(:)),1);
varInt = fnval(fnSpline,dsXys);
varInt = varInt(:);
varInt = reshape(varInt,size(dsX));

% Get downscaled variable
dsVar = varInt;

% Can't be less than zero
dsVar(dsVar < 0) = 0;

end