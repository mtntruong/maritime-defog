function [result] = Defogging ( input )

adjust_fog_removal = 2; 
brightness = 0.5; 

input = im2double(input);
alpha = 20000;
beta = 0.1;
gamma = 10;

[~, haze_level, ~] = parameter_sel(input);
if haze_level == 0.01
    ii = 7;
end
if haze_level == 0.001
    ii = 5 ;
end
[F, G, ~] = Decomposition(input,alpha,ii,beta,gamma);
%% Dehaze the image
A = estimate_airlight(adjust_fog_removal,F);
A = reshape(A,1,1,3);
[fog_free_layer, ~] = non_local_dehazing(F,A);

%% Compensation
Gm = Compensation(fog_free_layer,G);
result = fog_free_layer +  brightness*Gm;

gray = rgb2gray(im2uint8(result));
if median(gray(:)) < 128
    result = fog_free_layer + Gm;
end
