%% 1a Dilation
clear all
close all

% Dilation, SE is a plus
A = imread('assets/text-broken.tif');
B1 = [0 1 0;
     1 1 1;
     0 1 0];    % create structuring element
A1 = imdilate(A, B1);
figure
montage({A,A1})
title('Original and Dilation (plus)')

% SE of ones
B2 = ones(3,3);
A2 = imdilate(A, B2);

figure
montage({A,A2})
title('Original and Dilation (ones)')

% Bigger SE and cross
Bx = [1 0 1;
      0 1 0;
      1 0 1];

Bx_L = [1 0 0 1;
        0 1 1 0;
        1 0 0 1];

Ax = imdilate(A, Bx);
Ax_L = imdilate(A, Bx_L);

figure
montage({Ax,Ax_L})
title('Dilate Cross, 3x3 and 4x4')

% Apply multiple times
figure
A11 = imdilate(A1, B1);
montage({A, A1, A11})
title('Dilation (plus) applied x0, x1, x2')

% generate strel, r = 4
SE = strel('disk',4);
SE.Neighborhood         % print the SE neighborhood contents

%% 1b - Erosion

clear all
close all

A = imread('assets/wirebond-mask.tif');

% Generate strels
SE2 = strel('disk',2);
SE10 = strel('disk',10);
SE20 = strel('disk',20);

% erode
E2 = imerode(A,SE2);
E10 = imerode(A,SE10);
E20 = imerode(A,SE20);

montage({A, E2, E10, E20}, "size", [2 2])
title('Original & Erosion by SE disk, radius = 2,10,20')

%% 2 - Morphological Filtering with Open and Close

clear all
close all

f = imread('assets/fingerprint-noisy.tif');
SE = strel('square', 3);

fe = imerode(f,SE); % erode
fed = imdilate(fe,SE); % dilate

fo = imopen(f, SE);

figure
montage({f, fe, fed, fo}, "size", [2 2])
title('Original, Erode, Erode + Dilate, Open')

foc = imclose(fo, SE);
figure
montage({f, fo, foc}, "Size", [1 3])
title('Original, Open, Open + Close')

%  Open Close vs Gaussian
w_gauss = fspecial('Gaussian', [3 3], 1.0);
g_gauss = imfilter(f, w_gauss, 0);

figure
montage({f, foc, g_gauss}, "Size", [1 3])
title('Comparing Open+Close and Gaussian filter')

%% 3 - Boundary Detection

clear all
close all

I = imread('assets/blobs.tif');
I = imcomplement(I);
level = graythresh(I);
BW = imbinarize(I, level);
imshow(BW)

SE = ones(3,3);
BWe = imerode(BW,SE); % erode
bound_det = BW - BWe;

figure
montage({I, BW, BWe, bound_det}, "size", [2 2])
title('Original, Inverted, Eroded, Boundary Detected')