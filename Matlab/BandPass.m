clc;
clear all;
close all;

[c,r] = meshgrid(1:400,1:400);
D0 = 75;
W = 7;
D = sqrt((c-200.0).^2 + (r-200.0).^2);

%Ideal BandPass Filter
bp = ((D<=D0+W/2) & (D>=D0-W/2));
figure;imshow(bp);title('Ideal BandPass');

%Butterworth BandPass
n = 1; % Order of the filter
bp = zeros(400,400);
for i=1:400
    for j=1:400
        bp(i,j) =1 - ( 1/(1+((D(i,j)*W)/(D(i,j).^2 - D0.^2)).^(2*n)));
    end
end
figure;imshow(bp);title(strcat('Butterworth BandPass of Order ',num2str(n)));

%Gaussian BandPass
bp = zeros(400,400);
for i=1:400
    for j=1:400
        bp(i,j) = exp(-((D(i,j).^2 - D0.^2)/(D(i,j)*W)).^2);
    end
end
figure;imshow(bp);title('Gaussian BandPass');
