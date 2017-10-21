% Blob Detection
%
% Usage:  [r, c] = blob_detection(im, sigma, scale_factor, threshold, n)
%
% Arguments:   
%            im     - image to be processed.
%            sigma  - standard deviation of smoothing Gaussian.%                     
%            thresh - threshold (optional)
%            scale_factor - factor by which either increasing sigma/kernel
%                           OR downsampling image 
%            n   - number of iteration for scale space
%
% Returns:            
%            r        - row coordinates of blob points.
%            c        - col coordinates of blob points.
% Author: 
% skumar28 

function [r, c] = blob_detection(im, sigma, scale_factor, thresh, n)
im = rgb2gray(im);
im = im2double(im);

% 1st implementation 
disp('For filtering Image with increasing sigma/kernel');
tic()
scale_space = increasing_sigma(im, sigma, scale_factor, n);
[r1, c1, rad1] = nonmaximum_supressed_values(scale_space, sigma, scale_factor,thresh, n);
toc()

%2nd implemetation

disp('For filtering Image by downsampling');
tic()
scale_space_d = downsampling_image(im, sigma, scale_factor, n);
[r2, c2, rad2] = nonmaximum_supressed_values(scale_space_d, sigma, scale_factor,thresh, n);
toc()
figure('Name','With Increasing Sigma Values'), show_all_circles(im, r1, c1, rad1,'r', 1.5);
figure('Name','With Downsampling Image'), show_all_circles(im, r2, c2, rad2,'r', 1.5);
end    