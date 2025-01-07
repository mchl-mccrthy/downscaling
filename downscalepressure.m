% Downscale atmospheric pressure following Cosgrove et al (2003)
% 
% Michael McCarthy 2024
function dsP = downscalepressure(x,y,z,P,T,dsX,dsY,dsZ,dsT)

% Format x, y data
xys = rot90([x(:),y(:)]);
dsXys = rot90([dsX(:),dsY(:)]);

fnSpline = tpaps(xys,rot90(z(:)),1);
zInt = fnval(fnSpline,dsXys);
zInt = zInt(:);
zInt = reshape(zInt,size(dsX));

fnSpline = tpaps(xys,rot90(T(:)),1);
tInt = fnval(fnSpline,dsXys);
tInt = tInt(:);
tInt = reshape(tInt,size(dsX));

fnSpline = tpaps(xys,rot90(P(:)),1);
pInt = fnval(fnSpline,dsXys);
pInt = pInt(:);
pInt = reshape(pInt,size(dsX));

% Get T_m
Tm = (dsT+tInt)/2;

% Get downscaled pressure (note a*exp(-b) = a/exp(b))
dsP = pInt.*exp(-9.81.*(dsZ-zInt)./(287*Tm));

end