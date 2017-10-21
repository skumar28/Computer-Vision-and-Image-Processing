function [scale_space ] = increasing_sigma(im, scaled_sigma, scale_factor, n);
h = size(im, 1);
w = size(im, 2);
scale_space = zeros(h,w,n);
tmp = [];

for i = 1: n
   kernel = 2*ceil(3*scaled_sigma) + 1;  
   filter = fspecial('log',kernel , scaled_sigma); 
   filter = scaled_sigma^2 * filter;
   fimg = imfilter(im, filter,'replicate');    
   fimg = fimg.^2;
   scale_space = cat(3, tmp , fimg);
   tmp = scale_space;
   scaled_sigma = scale_factor * scaled_sigma;     
end

end

