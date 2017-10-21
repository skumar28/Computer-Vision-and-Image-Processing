function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs:
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses


% TODO Implement your code here
%if image is grayscale then convert it to rgb
if(size(img, 3) ~= 3)
    img = repmat(img,[1 1 3]);
end

% converting image to double formate
if( ~isfloat(img))
    img = im2double(img);
end

%convert to Lab image
imgL = RGB2Lab(img(:,:,1), img(:,:,2), img(:,:,3));
%imshow(imgL);

%apply filters on image
sizeOfFilterBank = size(filterBank,1);
tempImg = [];
%Apply each filter on image. in my case this is of dimension HxWx3xF
for i = 1 : sizeOfFilterBank
    imgF = imfilter(imgL, filterBank{i},'symmetric');
    filterImg = cat(4,tempImg,imgF);
    tempImg = filterImg;
end
filterResponses = filterImg;
end
