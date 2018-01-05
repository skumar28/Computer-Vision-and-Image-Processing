function [F] = fit_fundamental(matches)
x1 = matches(:,1:2);
x2 = matches(:,3:4);

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
end