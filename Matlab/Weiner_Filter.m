clc;
clear all;
close all;

img = im2double(imread('ori.jpg'));
figure;imshow(img);title('Original Image');
signal_var = var(img(:));
%Motion Blur- known corruption
L = 25;
Theta = 45;
PSF = fspecial('motion',L,Theta);
blurred = imfilter(img,PSF,'conv','circular');
figure;imshow(blurred);title('Blurred Image');

%Adding Noise to the blurred image
blurred_noisy = imnoise(blurred,'gaussian',0,0.00001);
figure;imshow(blurred_noisy);title('Noised added to the Blurred Image');

%Applying the weiner restoration by varying the K
estimated_noise_var = 0; %Initially

while (estimated_noise_var > 0.000001 || estimated_noise_var == 0)
    K = estimated_noise_var / signal_var; % NSR
    wnr1 = deconvwnr(blurred_noisy, PSF, K);
    figure;imshow(wnr1);title(strcat('Restored with Estimated NSR of  ',num2str(K)));
    if(estimated_noise_var==0)
        estimated_noise_var = 0.1;
    else
        estimated_noise_var = estimated_noise_var/10;
    end
end
