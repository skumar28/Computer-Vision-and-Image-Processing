function [H] = computeHomography(x,y,X,Y)

 temp = [];
 A = [];
 for j = 1:4
     rh1 = [-x(j) -y(j) -1 0 0 0 x(j)*X(j) y(j)*X(j) X(j)];
     rh2 = [0 0 0 -x(j) -y(j) -1 x(j)*Y(j) y(j)*Y(j) Y(j)];
     point1 = cat(1,rh1,rh2);
     A = cat(1, temp, point1);
     temp = A;
 end
 [U,S,V] = svd(A);
 H = V(:,end);
 H = H/H(9);
 H = reshape(H,[3 3]); 
 H = H';
end