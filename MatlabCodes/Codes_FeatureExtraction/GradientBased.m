%% Function to compute the 24 metrics for image autocorrection
% (based on gradient)
% Reference paper: % "Image Metric-Based Correction of Motion Effects"


% Input Parameters:     - Image: A 2D Image


% Output Parameter:     - MetricList: A vector of (1x24) consisting 24 metrics based-on
%                         the above Paper 



function MetricList = GradientBased(Image) 

% Check for color image and convert to grayscale
  if(numel(size(Image))==3)      
    if(size(Image,3)==3)          
      Image = rgb2gray(Image);      
    end
  end
 

% 255 gray scale Image
I = Image;
Height = size(Image,1);
Width = size(Image,2);
n = Height * Width;
grayscale = 256;

%% Gradient _ Identifier code : R1

v1 = [1; 0; -1];
F1 = sum(sum(abs(conv2(v1,I))));

%% Gradient _ Identifier code : R2

v2 = [1; -1];
F2 = sum(sum(abs(conv2(v2,I))));

%% Laplacian _ Identifier code : R3

v3 = [-1; 2; -1];
F3 = sum(sum(abs(conv2(v3,I))));

%% Laplacian _ Identifier code : R4

v4 = [-1 -2 -1; -2 12 -2; -1 -2 -1];
F4 = sum(sum(abs(conv2(v4,I))));

%% Laplacian _ Identifier code : R5

v5 = [0 -1 0; -1 4 -1; 0 -1 0];
F5 = sum(sum(abs(conv2(v5,I))));

%% Entropy _ Identifier code : R6

H1 = double(I) ./ (sum(sum((double(I).^2))));
% marginal entropies
F6 = -sum(H1(H1 ~= 0) .* log(H1(H1 ~= 0)));

%% Cube of Normalized Intensities _ Identifier code : R7

F7 = sum(sum((I./sum(sum(I))).^3));

%% 4th power of Normalized Intensities _ Identifier code : R8

F8 = sum(sum((I./sum(sum(I))).^4));

%% Squared Intensities _ Identifier code : R9

F9 = sum(sum((I./n).^2));

%% Squared Gradient _ Identifier code : R10

F10 = sum(sum((conv2(v2,I).^2)))/n;

%% 4th power of Gradient _ Identifier code : R11

F11 = sum(sum((conv2(v2,I).^4)))/n;

%% Gardient Entropy _ Identifier code : R12

H2 = abs(conv2(v2,I))./sum(sum(abs(conv2(v2,I))));
% marginal entropies
F12 = -sum(H2(H2 ~= 0) .* log2(H2(H2 ~= 0)));

%% Normalized Gardient Squared _ Identifier code : R13

F13 = sum(sum((abs(conv2(v2,I))./sum(sum(abs(conv2(v2,I)))).^2)));

%% Normalized Gardient to 4th Power _ Identifier code : R13

F14 = sum(sum((abs(conv2(v2,I))./sum(sum(abs(conv2(v2,I)))).^4)));

%% Histogram Mean _ Identifier code : H1

F15 = mean(histc(I(:),0:grayscale-1));   %% notice: array index from 1:256.. values from 0:255

%% Histogram Standard Deviation _ Identifier code : H2

F16 = std(histc(I(:),0:grayscale-1));   %% notice: array index from 1:256.. values from 0:255

%% Histogram Skewness _ Identifier code : H3

F17 = skewness(histc(I(:),0:grayscale-1));   %% notice: array index from 1:256.. values from 0:255

%% Histogram Kurtosis _ Identifier code : H4

F18 = kurtosis(histc(I(:),0:grayscale-1));   %% notice: array index from 1:256.. values from 0:255

%% Histogram Energy _ Identifier code : H5

Prob = histc(I(:),0:grayscale-1) ./ sum(histc(I(:),0:grayscale-1));
% marginal entropies
F19 = sum(Prob.^2);

%% Histogram Entropy _ Identifier code : H6

Prob = H1 ./ sum(sum(H1));
% marginal entropies
F20 = -sum(Prob(Prob ~= 0) .* log2(Prob(Prob ~= 0)));

%% Standard Deviation - Identifier code : C1

F21 = std(reshape(double(I), [1 n]),0);

%% Standard Deviation of Gradient - Identifier code : C2

v6 = [-1 -1 -1; -1 9 -1; -1 -1 -1];
F22 = std(reshape(conv2(v6,I),[1 size(conv2(v6,I),1)*size(conv2(v6,I),2)]),0);

%% AutoCorrelation 1 - Identifier code : A1

p1 = sum(sum(I.^2));
for i = 1:Height
    for j = 1:Width-1
    p2(i,j) = I(i,j)*I(i,j+1);
    end
end
F23 = p1 - sum(sum(p2));

%% AutoCorrelation 2 - Identifier code : A2

for i = 1:Height
    for j = 1:Width-1
    p3(i,j) = I(i,j)*I(i,j+1);
    end
end
for i = 1:Height
    for j = 1:Width-2
    p4(i,j) = I(i,j)*I(i,j+2);
    end
end
F24 = sum(sum(p3)) - sum(sum(p4));


MetricList = [F1; F2; F3; F4; F5; F6; F7; F8; F9; F10; F11; F12; F13; F14; F15; F16; F17; F18; F19; F20; F21; F22; F23; F24];
MetricList = MetricList';
