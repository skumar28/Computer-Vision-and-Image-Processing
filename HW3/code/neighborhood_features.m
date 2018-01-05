function [ fit ] = neighborhood_features( I1, nbsize,row1, col1)
%NEIGHBORHOOD_FEATURES return feature point of appropriate neighborhood
% size (nbsize)
nbpixel = floor(nbsize/2);
I1_pad = padarray(I1,[nbpixel nbpixel],'replicate');
temp = [];
for i= 1:size(row1,1)     
   row_nb = row1(i) + nbpixel;
   col_nb = col1(i) + nbpixel;
   nb1 = I1_pad((row_nb- nbpixel):(row_nb + nbpixel), (col_nb- nbpixel):(col_nb + nbpixel));
   fit1 = reshape(nb1, [1,nbsize.^2]);
   fit1= cat(1, temp, fit1);
   temp = fit1;   
end
fit = fit1;
end

