Img1 = imread('../data/part1/hill/1.jpg');
Img2 = imread('../data/part1/hill/2.jpg');
I1 = im2double(Img1);
I2 = im2double(Img2);
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

%using provided harris corner detecter
%[cim, r, c] = harris(im, sigma, thresh, radius, disp) 
[cim1, row1, col1] = harris(I1, 2, .05, 2, 0);
[cim2, row2, col2] = harris(I2, 2, .05, 2, 0);

nbsize =19;
nbpixel = floor(nbsize/2);
I1_pad = padarray(I1,[nbpixel nbpixel],'replicate');
temp = [];
for i= 1:size(row1,1)     
   row_nb = row1(i) + nbpixel;
   col_nb = col1(i) + nbpixel;
   nb1 = I1_pad((row_nb- nbpixel):(row_nb + nbpixel), (col_nb- nbpixel):(col_nb + nbpixel));
   fit1 = reshape(nb1, [1,nbsize.^2]);
   fit1= cat(1, temp, fit1);
   temp = fit1;   
end
I2_pad = padarray(I2,[nbpixel nbpixel],'replicate');
temp = [];
for i= 1:size(row2,1)
   row_nb = row2(i)+ nbpixel;
   col_nb = col2(i)+ nbpixel;
   nbpixel = floor(nbsize/2);
   nb2 = I2_pad((row_nb- nbpixel):(row_nb + nbpixel), (col_nb - nbpixel):(col_nb + nbpixel));
   fit2 = reshape(nb2, [1,nbsize.^2]);
   fit2= cat(1, temp, fit2);
   temp = fit2;   
end
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
maxinlierMatchI1 = [];
maxinlierMatchI2 = [];
maxInliers = 0;
for i = 1:300    
inlier = 0;
inlierMatchI1 = [];
inlierMatchI2 = [];

%select random 4 point 
randp = randsample(size(matchesIm1,1),4);
fourmatcheI1  = matchesIm1(randp,:);
fourmatcheI2 = matchesIm2(randp,:);
H = computeHomography(fourmatcheI1(:,1),fourmatcheI1(:,2), fourmatcheI2(:,1), fourmatcheI2(:,2));

for j = 1 :  size(matchesIm1,1)
   matchI1 = [matchesIm1(j,:) 1];  
   expMatchI2 = [matchesIm2(j,:) 1];
   targetPoint = H *  matchI1';
   targetPoint = targetPoint / targetPoint(3);
   distance = sqrt((expMatchI2(1)-targetPoint(1)).^2 + (expMatchI2(2)-targetPoint(2)).^2);
   
   if distance < ssd_thresh
         inlier = inlier +1;
         inlierMatchI1 = [inlierMatchI1 ; matchI1];
         inlierMatchI2 = [inlierMatchI2 ; expMatchI2];         
   end    
end
test = [];
 if maxInliers < inlier
      maxInliers = inlier;
      homography = H;
      maxinlierMatchI1 = inlierMatchI1;
      maxinlierMatchI2 = inlierMatchI2;
  end 
end

matches = [maxinlierMatchI1(:,1:2) maxinlierMatchI2(:,1:2)];
figure; imshow([Img1 Img2]); hold on;
plot(matches(:,1), matches(:,2), '+r');
plot(matches(:,3)+size(Img1,2), matches(:,4), '+r');
line([matches(:,1) matches(:,3) + size(Img1,2)]', matches(:,[2 4])', 'Color', 'r');

T = maketform('projective',homography');
%[B,xdata_range,ydata_range]=imtransform(Img1,T);
disp(homography);
[B,xdata,ydata]=imtransform(Img1,T, 'nearest');
 xdataout=[min(1,xdata(1)) max(size(Img2,2),xdata(2))];
 ydataout=[min(1,ydata(1)) max(size(Img2,1),ydata(2))];
    
 B=imtransform(Img1,T,'nearest','XData',xdataout,'YData',ydataout);
 C=imtransform(Img2,maketform('affine',eye(3)),'nearest','XData',xdataout,'YData',ydataout);

 [finalRow, finalHieght, dim] = size(B);
  finalImage = B;

 %take the first and second image avg for overlapping areas.
for i = 1:finalRow*finalHieght*dim
            if(finalImage(i) == 0)
                finalImage(i) = C(i);
            elseif(finalImage(i) ~= 0 && C(i) ~= 0)
                finalImage(i) = B(i)/2 + C(i)/2;
            end
end
figure; imshow(finalImage);
