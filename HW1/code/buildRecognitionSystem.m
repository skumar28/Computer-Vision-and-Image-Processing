function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

load('dictionary.mat');
load('../data/traintest.mat');

interval= 1;
train_imagenames = train_imagenames(1:interval:end);
temp = [];
%iterating over all the training images and create histograms of
%train_features. This will be used for comparision with query image
for i = 1: length(train_imagenames)
    name = train_imagenames{i};
    %replace the .jpg with .mat , bevause during the creation of visual
    %words we saved it with same name
    name = replace(name,'.jpg','.mat');
    fileLoc = strcat(['../data/'],name);
    matFile = load(fileLoc);
    h = getImageFeaturesSPM(3, matFile.wordMap, size(dictionary,2));
    %dimension of h would be 3150x1349
    train_features = cat(2, temp, h);
    temp = train_features;
end

save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end