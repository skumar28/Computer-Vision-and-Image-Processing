function [scale_space ] = downsampling_image(img, sigma, scale_factor, n);
h = size(img, 1);
w = size(img, 2);
scale_space = zeros(h,w,n);
tmp = [];

scale = 1;
for i = 1: n
   kernel = 2*ceil(3*sigma) + 1;  
   filter = fspecial('log',kernel , sigma); 
   % sigma is same in all the iteration
   filter = sigma^2 * filter;
   imgdown = imresize(img, 1/ scale);
   fimg = imfilter(imgdown, filter,'replicate');  
   fimg = imresize(fimg, [h w]);
   fimg = fimg.*fimg;
   scale_space = cat(3, tmp , fimg);
   tmp = scale_space;  
   scale = scale * scale_factor;
end