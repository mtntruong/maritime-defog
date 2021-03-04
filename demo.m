%  Single Maritime Image Defogging Based on Illumination Decomposition Using Texture and Structure Priors
%  Thuong Van Nguyen, Truong Thanh Nhat Mai, Chul Lee
%  Dongguk University, Korea

clc;
clear;
addpath('dependencies')

% Input image
foggy_image = imread('./Test_Data/V_07_01_0016.jpg');

% Defogged image
defogged_image = Defogging(foggy_image);
 
% Showing results
imshow(defogged_image)
