% for traingulation part
clear all;
I1 = imread('house1.jpg');
I2 = imread('house2.jpg');
matches = load('house_matches.txt'); 

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
   
