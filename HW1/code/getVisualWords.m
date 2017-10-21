function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    % TODO Implement your code here
    
    filterResponse =  extractFilterResponses(img, filterBank);
    imgsize = size(img,1)*size(img,2);
    %reshape the filter response to calculate euclidean distance
    filterResponse = reshape(filterResponse,[imgsize 60]);
    % apply pdist2 over dictionary and filterResponse
    [D,Index]= pdist2(dictionary',filterResponse,'euclidean','Smallest',1);    
    Index = Index';   
    
    wordMap = reshape(Index,[size(img,1) size(img,2)]);
end
