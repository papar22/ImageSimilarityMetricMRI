%% Function to calculate the LBP by calling "LBP" function and compute the gray level histogram

% The function generates different LBP circular filters by means of
% "generateRadialFilterLBP" function and calculate the LBP matrix and
% finally LBP histograms for different circular filters


% Input Parameters:     - Image: The 2D image which is the aim of
%                         computation
%                       - RadialInput: A nx2 array containing the radius
%                       and number of pixels to generate the LBP circular
%                       filter. n is the number of filters, the first
%                       column is the number of pixels and the second
%                       column is the radius.
%                       Example : RadialInput = [8 1; 16 2]




% Output Parameters:     - Out: A 1x (256*n) vector carrying the 256
%                       LBP histogram of the given image.


function Out = LocalBinaryPattern(Image, RadialInput)

m=1;
for n =1:1:size(RadialInput,1)
LBPArray = LBP(Image, 'filtR', generateRadialFilterLBP(RadialInput(n,1), RadialInput(n,2)));
LBPHist (m:(m+256-1)) = histc(LBPArray(:),0:1:255)';
m=256+m; 
end

Out = LBPHist;