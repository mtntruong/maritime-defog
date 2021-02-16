function [weight_x, weight_y] = Gradient_weight(I)
%eps = 10;
I = rgb2gray(I);
lambda = 10;
f1 = [1, -1];
f2 = [1; -1];
Gx = - imfilter(I,f1,'circular');
Gy = - imfilter(I,f2,'circular');

ax = exp(-lambda*abs(Gx));
thx = Gx < 0.01;
ax(thx)=0;
weight_x = 1 + ax;
% weight_x(thx) = 1;
ay = exp(-lambda*abs(Gy));
thy = Gy < 0.01;
ay(thy)=0;
weight_y = 1 + ay;























end