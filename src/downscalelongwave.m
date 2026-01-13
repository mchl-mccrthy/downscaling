% Downscale longwave radiation following Cosgrove et al (2003) 
%
% Michael McCarthy 2023
function dsL = downscalelongwave(x,y,L,T,Td,dsX,dsY,dsT,dsTd)

% Format x, y data
xys = rot90([x(:),y(:)]);
dsXys = rot90([dsX(:),dsY(:)]);

% Do a simple interpolation of temperature, dewpoint and longwave
fnSpline = tpaps(xys,rot90(L(:)),1);
LInt = fnval(fnSpline,dsXys);
LInt = LInt(:);
LInt = reshape(LInt,size(dsX));

fnSpline = tpaps(xys,rot90(T(:)),1);
TInt = fnval(fnSpline,dsXys);
TInt = TInt(:);
TInt = reshape(TInt,size(dsX));

fnSpline = tpaps(xys,rot90(Td(:)),1);
TdInt = fnval(fnSpline,dsXys);
TdInt = TdInt(:);
TdInt = reshape(TdInt,size(dsX));

% Calculate interpolated and downscaled vapour pressure (hPa)
eInt = 6.112.*exp(17.27.*(TdInt-273.15)./(237.3+TdInt-273.15));
dsE = 6.112.*exp(17.27.*(dsTd-273.15)./(237.3+dsTd-273.15));

% Calculate interpolated and downscaled emmisivity
epsInt = 1.08.*(1-exp(-eInt.^(TInt./2016)));
dsEps = 1.08.*(1-exp(-dsE.^(dsT./2016)));

% Limit emissivity to between zero and one
epsInt = min(max(epsInt,0),1);
dsEps  = min(max(dsEps,0),1);

% Calculate downscaled longwave
sigma = 5.67e-8;
dsL = dsEps.*sigma./(epsInt.*sigma).*(dsT./TInt).^4.*LInt;

end
