% this is for Q1.1 , applying filter on a single file and collaging into
% single image
filterBank = createFilterBank();

img = imread('../data/ice_skating/sun_advbapyfkehgemjf.jpg');

filterResponses = extractFilterResponses(img, filterBank);

for i = 1: 20
    imwrite(filterResponses(:,:,:,i),sprintf('../../testCollage/im_%d.jpg',i+10));
end
dirOutput = dir('../../testCollage/*.jpg');
fileNames = {dirOutput.name};
montage(fileNames,'Size',[4 5]);

