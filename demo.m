%  Demo sea surface image defogging algorithm
%  Thuong et al., Dongguk University, Korea

clc;
clear;
addpath('dependencies')

% Input image
foggy_image = imread('./Test_Data/20.jpg');

% Defogged image
defogged_image = Defogging(foggy_image);
 
% Showing results
imshow(defogged_image)