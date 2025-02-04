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

%% 4 - bwmorph - thin and thicken

fing = imread('assets/fingerprint.tif');
f = imcomplement(fing);
level = graythresh(f);
BW = imbinarize(f, level);
imshow(BW)

g1 = bwmorph(BW, 'thin');
g2 = bwmorph(BW, 'thin', 2);
g3 = bwmorph(BW, 'thin', 3);
g4 = bwmorph(BW, 'thin', 4);
g5 = bwmorph(BW, 'thin', 5);

figure
montage({BW, g1, g2, g3, g4, g5}, "size", [2 3])
title('Original and Thinning x1 to x5')

ginf = bwmorph(BW, 'thin', inf);
figure
montage({BW,ginf})
title('Original and Infinite Thinning')

level = graythresh(fing);
h = imbinarize(fing, level);

h1 = bwmorph(h, 'thin');
h2 = bwmorph(h, 'thin', 2);
h3 = bwmorph(h, 'thin', 3);
h4 = bwmorph(h, 'thin', 4);
h5 = bwmorph(h, 'thin', 5);

figure
montage({h, h1, h2, h3, h4, h5}, "size", [2 3])
title('Inverted')

%% 5 - Connected Components and Labels

t = imread('assets/text.png');
CC = bwconncomp(t);

numPixels = cellfun(@numel, CC.PixelIdxList);
[biggest, idx] = max(numPixels);
t(CC.PixelIdxList{idx}) = 0;
figure
imshow(t)

%% 6 - Morphological Reconstruction

clear all
close all
f = imread('assets/text_bw.tif');
se = ones(17,1);
g = imerode(f, se);
fo = imopen(f, se);     % perform open to compare
fr = imreconstruct(g, f);
montage({f, g, fo, fr}, "size", [2 2])

ff = imfill(f);
figure
montage({f, ff})

%% 7 - Morphological Operations on Greyscale
clear all; close all;
f = imread('assets/headCT.tif');
se = strel('square',3);
gd = imdilate(f, se);
ge = imerode(f, se);
gg = gd - ge;
montage({f, gd, ge, gg}, 'size', [2 2])
