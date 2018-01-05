Img1 = imread('../data/part1/uttower/left.jpg');
Img2 = imread('../data/part1/uttower/right.jpg');
I1 = im2double(Img1);
I2 = im2double(Img2);
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

%using provided harris corner detecter
%[cim, r, c] = harris(im, sigma, thresh, radius, disp) 
[cim1, row1, col1] = harris(I1, 2, .05, 2, 0);
[cim2, row2, col2] = harris(I2, 2, .05, 2, 0);


nbsize =19;
fit1 = neighborhood_features(I1, nbsize, row1, col1);
fit2 = neighborhood_features(I2, nbsize, row2, col2);

% mean:0 std =1
fit1 = zscore(fit1')';
fit2 = zscore(fit2')';

eucDistMat = dist2(fit1 , fit2);
%get top 200 matches
[~,distanceindex] = sort(eucDistMat(:));
matchfound = distanceindex(1:200);
[pointI1, pointI2] = ind2sub(size(eucDistMat), matchfound);

matchesIm1 = [col1(pointI1(:,1)) row1(pointI1(:,1)) ];
matchesIm2 = [col2(pointI2(:,1)) row2(pointI2(:,1)) ];

%RANSAC
ssd_thresh = 10;
[homography, inlier_matches, res] = ransac_inliers( matchesIm1, matchesIm2, ssd_thresh);
%res is the square root distance between the point coordinates in one image
%and the transformed coordinates of the matching point in the other image
%draw the inlier matches
no_of_inliers = size(inlier_matches,1); 
dispInlier = ['No of inliers: ', num2str(no_of_inliers)];
disp(dispInlier);
dispAvgRes = ['Average residual for the inliers: ' num2str(res/no_of_inliers)];
disp(dispAvgRes);

matches = [inlier_matches(:,1:2) inlier_matches(:,3:4)];
figure; imshow([Img1 Img2]); hold on;
plot(matches(:,1), matches(:,2), '+r');
plot(matches(:,3)+size(Img1,2), matches(:,4), '+r');
line([matches(:,1) matches(:,3) + size(Img1,2)]', matches(:,[2 4])', 'Color', 'r');

[ finalOutputImage ] = stich_images( Img1, Img2 ,homography);

display(homography);
figure; imshow(finalOutputImage);
