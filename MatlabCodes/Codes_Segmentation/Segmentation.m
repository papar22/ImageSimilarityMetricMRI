%% Function to segment the MR images based on Chan-Vese model

% Reference: "T. F. Chan and L. A. Vese, “Active contours without edges,”
% Image processing, IEEE transactions on, vol. 10, no. 2, pp. 266–277,
% 2001."
% Implementation by matlab function named "activecontour"


% Input Parameters:     - Image: The 2D image which is the aim of
%                         segmentation. color images will be
%                         converted to grayscale.
%                       - Margin: Margin values from the edges of the image
%                         for rectangular initial masking. Binary image
%                         representing initialization. Initial state
%                         position being close to object.
%                       - Iteration: Number of iterarions to run for Chan-Vese
%                         model
%                       - Smoothness: Smoothnes Factor. Higher value leads
%                         to smoother boundaries, smooth out details.
%                       - FlagShow: It should set to 1 to visualize the
%                         results

% Output Parameter:     - SegmentedImage: The main image with black backgrounds
%                       - BinaryImage: The black and white map of segmentation.
%                         (1's foreground, 0's background)
%                         1 for the foreground and zero for the background
%                         pixels


function [SegmentedImage BinaryImage] = Segmentation(Image, Margin , Iteration, Smoothness,FlagShow)


% Check for color image and convert to the grayscale
if(numel(size(Image))==3)       %if image is 3D
    if(size(Image,3)==3)
        Image = rgb2gray(Image);
    end
end



% Initialization
MaskImage = zeros(size(Image));
MaskImage(Margin:size(Image,1)-Margin,Margin:size(Image,2)-Margin)=1;

Image2D = double(Image);
MaskImage = double(MaskImage);


% Check whether the MaskImage and original image sizes are the same and
% raise an error
if(any(size(Image)~=size(MaskImage)))
    error('Image and MaskImage Must Be in The Same Size');
end

% Perform segmentation by means of Chan-Vese model MATLAB function.
BinaryImage = activecontour(Image,MaskImage,Iteration,'Chan-Vese',Smoothness);

[a b] = find(BinaryImage==1);

SegmentedImage = zeros([abs(max(a)-min(a)) abs(max(a)-min(a))]);

% Replace the background with zeso pixels

for i=1:1:size(BinaryImage,1)
    for j=1:1:size(BinaryImage,2)
        if BinaryImage (i,j) == 1;
            SegmentedImage(i,j) = Image(i,j);
        end
    end
end

if FlagShow==1
    % display results
    figure; subplot(2,2,1)
    imagesc(Image); axis image; colormap gray;
    % title(strcat('The Sensed Reference Image + ', ImageDataPixel(PosSampleRate(end,1):end)));
    title('The Main Image');
    
    subplot(2,2,2)
    imagesc(MaskImage); axis image; colormap gray;
    title('The Initialization');
    
    subplot(2,2,3)
    imagesc(BinaryImage); axis image; colormap gray;
    title('The Final Segmenatation Output');
    
    subplot(2,2,4)
    imagesc(Image); axis image; colormap gray;
    hold on;
    contour(BinaryImage,[0 0],'b','linewidth',3);
    hold off;
    title('The Image With the Segmentation Shown in Blue');
end
