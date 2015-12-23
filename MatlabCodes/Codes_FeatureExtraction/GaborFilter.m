%% Function to calculate Gabor features from the image which has 
% been convolved with gabor filters

%     1. Box-Counting(Haus) (BC)
%     2. Differential Box-Counting (MBC)
%     3. Triangular Prism Surface Area (TPSA)



% Input Parameters:     - GaborResult: A cell containing the filtered
%                       images. each entry of cell represents one filtered
%                       image. Here, the input parameter comes from
%                       function named "Gabor.m".



% Output Parameter:     - Out: A vector of 1x1080 real values for 27
%                       features and 40 filters.
%                       1st featurte: Variance of the filtered image
%                       2nd featurte: Mean of the filtered image
%                       3rd featurte: Energy of the filtered image
%                       4th-27th featurtes: 24 Gradient-based features by
%                       means of function "GradientBased.m"
%                       Out = [27 features of the first filtered image,]
%                              27 features of the second filtered image, ...
%                              ..., 
%                              27 features of the last filtered image]


function Out = GaborFilter(GaborResult)

m=1;
for i=1:1:size(GaborResult,1)
    for j=1:1:size(GaborResult,2)
        FilteredImage = GaborResult{i,j};
        % f1 = var(FilteredImage(:));
        f2 = var(abs(FilteredImage(:)));
        f3 = mean(abs(FilteredImage(:)));
        % f4 = var(atan(imag(FilteredImage(:))./real(FilteredImage(:))));
        % f5 = mean(atan(imag(FilteredImage(:))./real(FilteredImage(:))));
        f6 = sum(sum(FilteredImage.^2));
        GaborGradientMetric = GradientBased(FilteredImage);
        Out(m:(m+27-1)) = [f2 f3 f6 GaborGradientMetric]; % 3+24=27        
        m=27+m;        
    end
end

Out = real(Out);
