function [homography, inlier_matches, res] = ransac_inliers( matchesIm1, matchesIm2, ssd_thresh)
%RANSAC_INLIERS 

maxinlierMatchI1 = [];
maxinlierMatchI2 = [];
maxInliers = 0;
residual_inliers = 0.0;
for i = 1:300    
inlier = 0;
residual = 0.0;
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
         residual = residual + distance;
         inlierMatchI1 = [inlierMatchI1 ; matchI1];
         inlierMatchI2 = [inlierMatchI2 ; expMatchI2];         
   end    
end
 if maxInliers < inlier
      maxInliers = inlier;
      residual_inliers = residual;
      homography = H;
      maxinlierMatchI1 = inlierMatchI1;
      maxinlierMatchI2 = inlierMatchI2;
  end 
end

inlier_matches = [maxinlierMatchI1(:,1:2) maxinlierMatchI2(:,1:2)];
res = residual_inliers;
end

