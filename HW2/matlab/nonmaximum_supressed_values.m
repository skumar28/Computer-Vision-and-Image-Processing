function [r, c, rad] = nonmaximum_supressed_values(scale_space, sigma, scale_factor, thresh, n)
%get Maximum value in scale space
tmp = [];
for i = 1: n    
    cim = scale_space(:,:,i);   
    mx = ordfilt2(cim,9,ones(3,3));  %size of the mask is [3x3]
	scale_space_max_sup = cat(3,tmp,mx);
    tmp = scale_space_max_sup;
end

%find max value across 3D layers
max_response = max(scale_space_max_sup, [],3);
scale_space_max_sup = scale_space_max_sup.*(scale_space_max_sup == max_response);

% do thresholding and calculate max
tmp1 = [];
tmp2 = [];
tmp3 = [];
for i = 1 : n    
    radius = sigma * sqrt(2);  
    x1 = scale_space(:,:,i);
    x2 = scale_space_max_sup(:,:,i);
    cim = (x1 == x2) & (x1 > thresh);
     
	[r,c] = find(cim);                  % Find row,col coords.
    row = cat(1,tmp1,r);
    tmp1= row;
    col = cat(1,tmp2,c);
    tmp2= col;
    radius = ones(size(r,1),1)*radius;
    rad = cat(1,tmp3,radius);
    tmp3 = rad;    
    sigma = scale_factor * sigma;  
end
r = col;
c = row;
end