% this file is for Q1.3
filterBank = createFilterBank();

img = imread('../data/ice_skating/sun_advbapyfkehgemjf.jpg');
img2 = imread('../data/ocean/sun_aoudjmafzqzmgesx.jpg');
img3 = imread('../data/mountain/sun_ahmajnuemkwwrubr.jpg');
img = im2double(img);
img2 = im2double(img2);
img3 = im2double(img3);
load('dictionary.mat');

%test for get ImageFeatures
%   imshow(image);
fprintf('[Getting Visual Words..]\n');
visualWordImage = getVisualWords(img2, filterBank, dictionary);
visualWordImage2 = getVisualWords(img2, filterBank, dictionary);
visualWordImage3 = getVisualWords(img3, filterBank, dictionary);

imagesc(visualWordImage);
set(gca,'XTick',[])
set(gca,'YTick',[])
saveas(gca, '../../wordMap/ice_skating.jpg','jpg');
imagesc(visualWordImage2);
set(gca,'XTick',[])
set(gca,'YTick',[])
saveas(gca, '../../wordMap/ocean.jpg','jpg');
imagesc(visualWordImage3);
set(gca,'XTick',[])
set(gca,'YTick',[])
saveas(gca, '../../wordMap/mountain.jpg','jpg');
