function [F, G, N] = Decomposition( I, alpha ,ii , beta, gamma)
% Layer Separation using Relative Smoothness (specific for intrinsic images)

% Image properties
I(I>1) = 1;
gray = rgb2gray(I);
[H,W,D] = size(I);

% Convolutional kernels
f1 = [1, -1];
f2 = [1; -1];
f4 = [0, -1,  0; -1,  4, -1; 0, -1,  0];

% Enhance gradient of I
[weight_x, weight_y] = Gradient_weight(I);

I_filt = imgaussfilt(gray,10);
delta_I = I - I_filt;

% main
otfFx = psf2otf(f1, [H,W]);
otfFy = psf2otf(f2, [H,W]);
otfL  = psf2otf(f4, [H,W]);

fft_double_laplace = abs(otfL).^2 ;
fft_double_grad    = abs(otfFx).^2 + abs(otfFy).^2;

if D > 1
    fft_double_grad    = repmat(fft_double_grad,[1,1,D]);
    fft_double_laplace = repmat(fft_double_laplace,[1,1,D]);
    weight_x = repmat(weight_x,[1,1,D]);
    weight_y = repmat(weight_y,[1,1,D]);
end

F = 0;
N = 0;

Ix = - imfilter(I,f1); Iy = - imfilter(I,f2);
Normin_I = fft2([Ix(:,end,:) - Ix(:,1,:), -diff(Ix,1,2)] + ...
    [Iy(end,:,:) - Iy(1,:,:); -diff(Iy,1,1)]);
Denormin_N = gamma + alpha * fft_double_laplace + beta;
Normin_gI  = fft_double_laplace .* fft2(I);

i = 0;
while true
    i = i+1;
    prev_F = F;
    
    lambda = min(2^(ii + i), 10^5);
    Denormin_F = lambda * fft_double_grad + alpha * fft_double_laplace + beta;
    
    % update q
    qx = - imfilter(F,f1,'circular') - Ix ;
    qy = - imfilter(F,f2,'circular') - Iy ;
    qx = sign(qx) .* max(abs(qx) - weight_x/lambda, 0);
    qy = sign(qy) .* max(abs(qy) - weight_y/lambda, 0);
    
    % compute fog layer (F)
    Normin_q = [qx(:,end,:) - qx(:,1,:), -diff(qx,1,2)] + ...
        [qy(end,:,:) - qy(1,:,:); -diff(qy,1,1)];
    Normin_gN = fft_double_laplace .* fft2(N);
    
    FF = (lambda * (Normin_I + fft2(Normin_q)) + ...
        alpha * (Normin_gI - Normin_gN) + beta * fft2(delta_I - N)) ...
        ./ Denormin_F;
    F  = real(ifft2(FF));
    
    % compute Noise
    Normin_F = fft_double_laplace .* fft2(F);
    B  = fft2(delta_I - F);
    NN = (alpha * (Normin_gI - Normin_F) + beta * B)./Denormin_N;
    N  = real(ifft2(NN));

    if sum(sum(sum(abs(prev_F - F))))/(H*W) < 10^(-1)
        break
    end
end

% normalize F
for c = 1:D
    Ft = F(:,:,c);
    q = numel(Ft);
    for k = 1:500
        m = sum(Ft(Ft<0));
        n = sum(Ft(Ft>1)-1);
        dt =  (m + n)/q;
        if abs(dt) < 1/q
            break;
        end
        Ft = Ft - dt;
    end
    F(:,:,c) = Ft;
end
F = abs(F);
F(F>1) = 1;

N(N>1) = 1;
N(N<0) = 0;
N = mean(N,3);
G = abs(I - F - N);
G = min(G, [], 3);
G = imgaussfilt(G,3);
F = abs(I - G - N);
F(F == 0) = 0.001;