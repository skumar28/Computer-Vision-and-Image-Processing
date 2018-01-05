function [ F ] = fundamental_normalized_cord( matches )
%FUNDAMENTAL_NORMALIZED_CORD 

x1 = matches(:,1:2);
x2 = matches(:,3:4);

 pad1 = ones(size(x1,1), 1);
 pad2 = ones(size(x2,1), 1);
 
  x1 = [x1 pad1];
  x2 = [x2 pad2];
  
  center = mean(x1(:, 1:2));
  identity = eye(3);
  identity(1,3) = -center(1);
  identity(2,3) = -center(2);
  maxX = max(abs(x1(:,1)));
  maxY = max(abs(x1(:,2)));  
  scaleI = eye(3);
  scaleI(1,1) = 1/maxX;
  scaleI(2,2) = 1/maxY;
  transform1 = scaleI * identity;
  x1norm = (transform1*x1')';
  
  center = mean(x2(:, 1:2));
  identity2 = eye(3);
  identity2(1,3) = -center(1);
  identity2(2,3) = -center(2);
  maxX = max(abs(x2(:,1)));
  maxY = max(abs(x2(:,2)));  
  scaleI2 = eye(3);
  scaleI2(1,1) = 1/maxX;
  scaleI2(2,2) = 1/maxY;
  transform2 = scaleI2 * identity2;
  x2norm = (transform2*x2')';
  
  x1= x1norm;
  x2 = x2norm;
  A = [];
for i = 1:size(matches,1)
    A = [A; x1(i,1)*x2(i,1)  x2(i,2)*x2(i,1)  x2(i,1) ...
        x1(i,1)*x2(i,2) x1(i,2)*x2(i,2) x2(i,2) x1(i,1) x1(i,2) 1];    
end
%solve for findamental matrix 1
[u,s,v] = svd(A);
f = v(:,end);

%rectify fundamental mtrix
F = reshape(f,[3 3])';
[u,s,v] = svd(f);
s(end) = 0;
F1 = u*s*v';

F = reshape(F1, [3 3])';

F = transform2' * F * transform1;
end

