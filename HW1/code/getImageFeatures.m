function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

% TODO Implement your code here
%reshape the visual word for creating histogram
    wordMap = reshape(wordMap,[size(wordMap,1)*size(wordMap,2), 1]);
    h = hist(wordMap, dictionarySize);
    
    %L1-normalization of visual word
    h = h / sum(h(:));
    assert(numel(h) == dictionarySize);
    h  = h';
    end