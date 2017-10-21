function  warp_im  = warpA( im_gray, A, out_size )
% warp_im=warpAbilinear(im, A, out_size)
% Warps (w,h,1) image im using affine (3,3) matrix A 
% producing (out_size(1),out_size(2)) output image warp_im
% with warped  = A*input, warped spanning 1..out_size
% Uses nearest neighbor mapping.
% INPUTS:
%   im : input image
%   A : transformation matrix 
%   out_size : size the output image should be
% OUTPUTS:
%   warp_im : result of warping im by A
[row,col] = size(im_gray);
imgnew = zeros(row,col);
for i= 1:row
    for j = 1:col  
        % destination = A * Source 
       des = A*[j,i,1]';
       if(des(1,1) > 1 & des(2 , 1) > 1)
           cval = round((des(1,1)),0);
           rval = round((des(2,1)),0);
           imgnew(rval, cval) = im_gray(i,j);      
       else
          imgnew(i, j) = 0;
       end
   end
end
%imshow(imgnew);
warp_im = imgnew;
end