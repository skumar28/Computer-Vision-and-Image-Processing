function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

filterBank  = createFilterBank();
alpha = 100;
K = 150;
% TODO Implement your code here
temp = [];
%iterate over all the trainning images and building dictionary
for i = 1: length(imPaths)
    image = imread(imPaths{i});
    
    filterResponse = extractFilterResponses(image,filterBank);
    iSize = size(image,1)*size(image,2);
    %select alpha random no within image dimensions
    p = randperm(iSize, alpha);
    newReshape = reshape(filterResponse, [iSize,60]);
    %selecting alpha pixel from filtered image
    alphaResponse = newReshape(p,:,:);
    filterResponses = cat(1, temp,alphaResponse);
    temp = filterResponses;
end

%calculate k means of all the responses, creating clustering over of K
%size.
[~, dictionary] = kmeans(filterResponses, K, 'EmptyAction', 'drop');

dictionary = dictionary';
end
