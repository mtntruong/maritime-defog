function [JBack] = Background(RGB)
[height, width, ~] = size(RGB);
patchSize = 3; %the patch size is set to be 15 x 15
padSize = 1; % half the patch size to pad the image with for the array to 
%work (be centered at 1,1 as well as at height,1 and 1,width and height,width etc)
JBack = zeros(height, width); % the dark channel
imJ = padarray(RGB, [padSize padSize], Inf); % the new image
% imagesc(imJ); colormap gray; axis off image

for j = 1:height
    for i = 1:width        
        % the patch has top left corner at (jj, ii)
        patch = imJ(j:(j+patchSize-1), i:(i+patchSize-1),:);
        % the bright channel for a patch is the maximum value for all
        % channels for that patch
        JBack(j,i) = max(patch(:));
    end
end

      