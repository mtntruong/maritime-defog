function [Gm] = Compensation ( fog_free_layer,G)
%eps = 0.1^2;
%fog_free_layer_gray = rgb2gray(fog_free_layer);
JBack = abs(Background(fog_free_layer));
JBack(JBack > 1)= 1;
JBack(JBack == 0)= 0.001;
% JBack_1 = abs(fastguidedfilter(fog_free_layer_gray,JBack,8,eps,4));
% JBack_1(JBack_1 > 1)= 1;
% JBack_1(JBack_1 == 0)= 0.01;
% fog_free_layer(fog_free_layer == 0) = 0.001;
% GR = fog_free_layer./JBack_1;
% GR = fog_free_layer./JBack;
% GR = GR.^(1 - G.^2);
% Gm = G.*GR;
GR = G.*fog_free_layer;
Gm = GR./JBack;
end