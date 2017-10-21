function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
    L = layerNum -1;
    hist = cell(1,layerNum);
    %iterate over layer number, this will decide the number of cell in each
    %layer . for level 0 where all sub cells should be merge we do not need
    %to iterate
    for level = L:-1:1
    rows = size(wordMap,1);
    cols = size(wordMap,2);
    lSize = 2^level;
    %dividing in equal parts and taking the last part as remaining
    r1 = ceil(rows/lSize);
    c1 = ceil(cols/lSize);   
    %split rows    
    if(mod(rows,lSize) ~= 0)
        remaining = rows - (lSize-1)*r1;
        cell1 = ones(1, lSize-1)*r1;
        cell1 = [cell1 remaining];
    end 
    if (mod(rows,lSize) == 0)
        cell1 = ones(1, lSize)*r1;
    end
    %split column
    if(mod(cols,lSize) ~= 0)
        remaining = cols - (lSize-1)*c1;
        cell2 = ones(1,lSize-1)*c1; 
        cell2 = [cell2 remaining];
    end
    if(mod(cols,lSize)==0)
       cell2 = ones(1,lSize)*c1; 
    end
    
    totalSize = size(cell1,2)*size(cell2,2);
    %diving into cell
    finestLayer = mat2cell(wordMap, cell1, cell2);

    temp = [];
    %get image feature of all the cell and calculate hostogram for each
    %layer, normalizing each layer histograms
    for i = 1:totalSize
       hi =getImageFeatures(finestLayer{1},dictionarySize);
       hist{level+1} = cat(1, temp,hi);
       temp = hist{level+1};
    end
    hist{level+1} = hist{level+1} / sum(hist{level+1}(:));
    end
    %for level0 we do not need to calculate refctor into cell so calling it
    %outside
    hist{1} =getImageFeatures(wordMap,dictionarySize); 
    %concatinating all the hostograms
    h1 = hist{3}/4;
    h2= hist{2}/4;
    h3 = hist{1}/2;
    h1  = cat(1, h1,h2);
    %size of this hostogram would be 3150x1
    h = cat(1, h1, h3);   
    
end