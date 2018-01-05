% Sandeep Kumar (skumar28)
% 50248881
% this file is copy of sample_code + additional required change
%%
%% load images and match files for the first example
%%

I1 = imread('house1.jpg');
I2 = imread('house2.jpg');
matches = load('house_matches.txt'); 
% this is a N x 4 file where the first two numbers of each row
% are coordinates of corners in the first image and the last two
% are coordinates of corresponding corners in the second image: 
% matches(i,1:2) is a point in the first image
% matches(i,3:4) is a corresponding point in the second image

N = size(matches,1);

%%
%% display two images side-by-side with matches
%% this code is to help you visualize the matches, you don't need
%% to use it to produce the results for the assignment
%%
imshow([I1 I2]); hold on;
plot(matches(:,1), matches(:,2), '+r');
plot(matches(:,3)+size(I1,2), matches(:,4), '+r');
line([matches(:,1) matches(:,3) + size(I1,2)]', matches(:,[2 4])', 'Color', 'r');

%%
%% display second image with epipolar lines reprojected 
%% from the first image
%%

% first, fit fundamental matrix to the matches
F = fit_fundamental(matches); % this is a function that you should write
[pt_line_dist, L]= residuals_for_givenF( matches, F );
disp('mean residual for unnormalized algorithm: ');
disp(mean(abs(pt_line_dist)));
figure; display_results( matches, pt_line_dist, L, I2);

%Caculate fundamental matrix using normlized coordinates

F_norm = fundamental_normalized_cord(matches);
[pt_line_dist, L] = residuals_for_givenF( matches, F_norm );
disp('mean residual for normalized algorithm: ');
disp(mean(abs(pt_line_dist)));
figure; display_results( matches, pt_line_dist, L, I2);

%RANSAC implementaion to get matches


[ inliermatches , F, res] = ransac_inliers( matches );

[pt_line_dist, L] = residuals_for_givenF( inliermatches, F );
disp('Using RANSAC and Normalized,mean residual for Inliers: ');
disp(mean(abs(pt_line_dist)));
disp('no of inliers:');
disp(size(inliermatches,1));
figure; display_results( inliermatches, pt_line_dist, L, I2);


% Tangulation 
P1 = load('library1_camera.txt');
[U, S, V] = svd(P1);
 camCenter1 = V(:,end);
center1 = camCenter1';
center1 = center1/center1(4);
camCenter1 = center1(:,1:3);

P2 = load('library2_camera.txt');
[U, S, V] = svd(P2);
camCenter2 = V(:,end);
center2 = camCenter2';
center2 = center2/center2(4);
camCenter2 = center2(:,1:3);
 
%homogenize the coordinates
x1 = matches(:,1:2);
x2 = matches(:,3:4);
pad1 = ones(size(x1,1), 1);
pad2 = ones(size(x2,1), 1);
x1 = [x1 pad1];
x2 = [x2 pad2];

numMatches = size(x1,1);
t_point = [];
prjP_I1 = [];
prjP_I2 = [];

%calcualte the triangulated points, + their projections onto each img plane
for i = 1:numMatches
    pt1 = x1(i,:);
    pt2 = x2(i,:);
    mat1 = [  0   -pt1(3)  pt1(2); pt1(3)   0   -pt1(1); -pt1(2)  pt1(1)   0  ];
    mat2 = [  0   -pt2(3)  pt2(2); pt2(3)   0   -pt2(1); -pt2(2)  pt2(1)   0  ];    
    A = [ mat1*P1; mat2*P2 ];
    
    [U,S,V] = svd(A);
    triangPointHomo = V(:,end)'; 
    %save the triangulated 3d    
    point1 = triangPointHomo;
    point1 = point1/point1(4);
    t_point = [t_point; point1(:,1:3)];
    
    %project the triangulated point using both camera matrices 
     projPoint1 = (P1*triangPointHomo')';
     projPoint1 = projPoint1 / projPoint1(3);
     prjP_I1 = [prjP_I1; projPoint1(:,1:2)];
     
     projPoint2 = (P2*triangPointHomo')';
     projPoint2 = projPoint2 / projPoint2(3);
     prjP_I2 = [prjP_I2; projPoint2(:,1:2)];     
    
end

figure; axis equal;  hold on; 
plot3(-t_point(:,1), t_point(:,2), t_point(:,3), '.r');
plot3(-camCenter1(1), camCenter1(2), camCenter1(3),'*g');
plot3(-camCenter2(1), camCenter2(2), camCenter2(3),'*b');
grid on; xlabel('x'); ylabel('y'); zlabel('z'); axis equal;

dist1 = diag(dist2(matches(:,1:2), prjP_I1));
dist2 = diag(dist2(matches(:,3:4), prjP_I2));
disp('residuals between the observed 2D points and the projected 3D points Image 1');
disp(mean(dist1));
    
disp('residuals between the observed 2D points and the projected 3D points Image 2');
disp(mean(dist2));
   
