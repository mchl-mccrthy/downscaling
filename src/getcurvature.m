% Calculate curvature following Liston and Elder (2006)
%
% n is a scaling length (m) which is the typical distance between ridge 
% crests and valley bottoms in the study area
% 
% Michael McCarthy 2023
function curvature = getcurvature(dem,n)

% Compute curvature for each grid cell in turn
[nRows,nCols] = size(dem);
nRows = nRows+2;
nCols = nCols+2;
dem2 = nan(nRows,nCols);
dem2(2:end-1,2:end-1) = dem;
dem2 = inpaint_nans(dem2);
curvature = nan(nRows,nCols);
for iRow = 2:nRows-1
    for iCol = 2:nCols-1
        z = dem2(iRow,iCol);
        zN = dem2(iRow+1,iCol);
        zE = dem2(iRow,iCol+1);
        zS = dem2(iRow-1,iCol);
        zW = dem2(iRow,iCol-1);
        zNE = dem2(iRow+1,iCol+1);
        zSE = dem2(iRow-1,iCol+1);
        zSW = dem2(iRow-1,iCol-1);
        zNW = dem2(iRow+1,iCol-1);
        c1 = (z-0.5*(zW+zE))/(2*n);  
        c2 = (z-0.5*(zS+zN))/(2*n);  
        c3 = (z-0.5*(zSW+zNE))/(2*sqrt(2*n));  
        c4 = (z-0.5*(zNW+zSE))/(2*sqrt(2*n));  
        curvature(iRow,iCol) = 0.25*(c1+c2+c3+c4);
    end
end
curvature = curvature(2:end-1,2:end-1);

end 
