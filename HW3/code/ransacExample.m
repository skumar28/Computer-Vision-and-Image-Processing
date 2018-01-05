clear all;
close all;
I = imread('../data/part1/hill/1.JPG');
I1 = rgb2gray(I);
I = im2double(I1);
imshow(I,[]);

N = 11;
mask = fspecial('gaussian',N,N/4);
[gx,gy] = gradient(I);
g11 = gx.*gx;
g12=gx.*gy;
g22=gy.*gy;

g11 = imfilter(g11,mask,'same');
g12 = imfilter(g12,mask,'same');
g22 = imfilter(g22,mask,'same');

v2 = ((g11+g22) - sqrt((g11-g22).^2 +  4*g12.^2))/2;
Imax = (v2 == imdilate(v2,ones(2*N)));
[row,col] = find(Imax);
vals = v2(find(Imax));
[vals , indices] = sort(vals,'descend');
maxPt = 40;
for i = 1:maxPt
    x = col(indices(i));
    y = row(indices(i));
    rectangle('Position',[x-N/2 y-N/2 N N], 'EdgeColor','r');
    text(x+N/2,y+N/2,sprintf('%d',i),'Color','b');
end

%ransac algorithms
I2 = imread('../data/part1/hill/2.JPG');
I2 = rgb2gray(I2);
thresh = 0.8;
nPts = 0;

for i = 1: maxPt
    x = col(indices(i));
    y = row(indices(i));
    
    M = floor(N/2);
   if x<= M || x>size(I,2)-M   continue; end
   if y<= M || y>size(I,1) -M   continue; end
   
   T = I(y-M:y+M, x-M:x+M);
   C= normxcorr2(T, I2);
   
   cmax = max(C(:));
   if cmax < thresh continue; end
   
   [yp xp] = find(C==cmax);
   yp = yp-M;
   xp = xp -M;
   
   fprintf('Point %d matches with score = %f\n',i,cmax);
   
   nPts = nPts + 1;
   x1(1,nPts) = x;
   x1(2,nPts) = y;
   x1(3,nPts) = 1;
   x2(1,nPts) = xp;
   x2(2,nPts) = yp;
   x2(3,nPts) = 1;  
end

%select 8 random points 
v = randperm(length(x1));
disp('Choosing 8 random points:');
disp(v(1:8));

p1 = x1(:, v(1:8));
p2 = x2(:, v(1:8));

figure, imshow(I1, []);

for i = 1: 8
   x = p1(1,i); % p1->x1
   y = p1(2,i); 
   
   rectangle('Position',[x-N/2 y-N/2 N N], 'EdgeColor','r');
   text(x+N/2,y+N/2,sprintf('%d',v(i)),'Color','b');   %i->v(i)
end

figure, imshow(I2, []);
for i = 1: 8  %8->nPts
   x = p2(1,i); %p2->x2
   y = p2(2,i);
   
   rectangle('Position',[x-N/2 y-N/2 N N], 'EdgeColor','r');
   text(x+N/2,y+N/2,sprintf('%d',v(i)),'Color','b'); % i->v(i)   
end

%fit a fundamental matrix to a matching point
xn = p1(1:2,:);
N = size(xn,2);
t = (1/N)*sum(xn,2);
xnc = xn - t*ones(1,N);
dc = sqrt(sum(xnc.^2));
davg = (1/N) * sum(dc);
s = sqrt(2)/davg;
T1 = [s*eye(2), -s*t ; 0 0 1];
p1s = T1*p1;


xn = p2(1:2,:);
N = size(xn,2);
t = (1/N)*sum(xn,2);
xnc = xn - t*ones(1,N);
dc = sqrt(sum(xnc.^2));
davg = (1/N) * sum(dc);
s = sqrt(2)/davg;
T2 = [s*eye(2), -s*t ; 0 0 1];
p2s = T2*p2;

% compute fundamental matrix
A = [p1s(1,:)'.*p2(1,:)' p1s(1,:)'.*p2(2,:)'  p1s(1,:)' ...
        p1s(2,:)'.*p2(1,:)' p1s(2,:)'.*p2(2,:)'  p1s(2,:)' ...
         p2s(1,:)'          p2s(2,:)'        ones(length(p1s),1)];

[u, d, v] = svd(A);
x = v(:, size(v,2));

Fscale = reshape(x, 3,3)';

%force rank 2
[u, d, v] = svd(Fscale);
Escale = u*diag([d(1,1) d(2,2) 0])*v';
F= T1'* Fscale * T2;

disp('calculated fundamental matrix');
disp(F);

%check error resudual for all matching pairs of points

figure
for i = 1: length(x2)
   subplot(1,2,1), imshow(I,[]);
   % the product l = F*p2 is the equation of epipolar line corresponding
   % to p2, int the first image
   l = F * x2(:,i);
   % lets find two points on the this line. First set x= 1 snad solv for 
   % y, then set x = L and solve for y
   
   L = size(I,2);
   pLine0 = [1; (-l(3)-l(1)*(1))/l(2); 1];
   pLine1 = [L; (-l(3)-l(1)*(L))/l(2); 1];
   
   line([pLine0(1) pLine1(1)], [pLine0(2) pLine1(2)], 'Color', 'r');
   rectangle('Position',[x1(1,i)-4 x1(2,i)-4 8 8], 'EdgeColor','r');
   text(x1(1,i)+4, x1(2,i)+4, sprintf('%d', i), 'Color', 'r');
   
   subplot(1,2,2), imshow(I2,[]);
   rectangle('Position',[x2(1,i)-4 x2(2,i)-4 8 8], 'EdgeColor','g');
   text(x2(1,i)+4, x2(2,i)+4, sprintf('%d', i), 'Color', 'g');
   
   %calculate resudual error. the product p1'*F*p2 should = 0. The 
   % difference is the residual
   res = x1(:,i)' * F * x2(:,i);
   fprintf('residual is %f\n', res);
   
   pause(0.25); 
end





