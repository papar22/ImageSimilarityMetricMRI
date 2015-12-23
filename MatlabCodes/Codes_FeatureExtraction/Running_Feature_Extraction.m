%% This scripts serves to extract the features after doing segmentation


%     - reads the images from a path
            % The reconstructed images have been saved in a structure so called
            %   "Struct_Final" so that there are 4 fields.
            %    FullSample : The 3D fully-sampled version of the image
            %    TestSample : The 3D reconstructed version of the image
            %    FullSampleName : The name of the 3D fully-sampled version of the image
            %    TestSampleName : The name of the 3D reconstructed version of the image
%     - calls segmentation function
%     - extracts the following features:
%           1. Gray Level Co-Occurance Matrix
%           2. Run-Length
%           3. Gabor filters
%           4. Local Binary Patterns
%           5. Fractals
%           6. Gradient-Based



clc
clear all
close all
warning off


% DirFolderToReadMatFiles Containing the Images
% LoadName is a cell which contains the name of all images

DirName = '/net/filse-sn/raidar2/d1132/Application/ReconstructedData';
SubFolders = dir((fullfile(DirName, '*.mat')));
ImageName = {SubFolders.name}';

for n=1:1:size(ImageName,1)
    if ispc
        LoadName{n,1} = strcat(DirName,'\',ImageName{n});
    elseif isunix
        LoadName{n,1} = strcat(DirName,'/',ImageName{n});
    end
end


% Parameter Setting

values = [1;2;4;8;16;32;64;128];
offset0 = [zeros(size(values,1),1) values];
offset1 = [-values values];
offset2 = [-values zeros(size(values,1),1)];
offset3 = [-values -values];
offset = [offset0 ; offset1 ; offset2 ; offset3];
GLCMParameters.DisplacementVector = offset;
GLCMParameters.NumLevels = 255;



RadialLBP = [8 1; 16 2;24 3;32 4];


counter =1;
tic

% A loop to read all images one-by-one

for k =1:1:size(LoadName,1)
    
    
    % The reconstructed images have been saved in a structure so called
    %   "Struct_Final" so that there are 4 fields.
    %    Here, we read the "TestImage"

    OriginalStruct = load (LoadName{k});
    DataLoededImage = getfield(OriginalStruct,'Struct_Final');
    
    TestImage  = DataLoededImage.TestSample;
    TestImageName = DataLoededImage.TestSampleName;
    
    for n =1:1:size(TestImage,3)
        
        % Choose one slice of the MR image
        Image2D = TestImage(:,:,n);
        
        % Segmentation
        % Input Parameters:     
%            - Image: The 2D MR slice (Image2D)
%            - Margin: Rectangular initial mask with 10 pixels from the
%              border of image
%            - Iteration: 1000
%            - Smoothness: 4
%            - FlagShow: 0 (show no results)
        [SegmentedImage BinaryImage] = Segmentation(Image2D, 10 , 1000, 4,0);
        
        % 255 level scale
        % I is the Image for feature Extraction
        I = floor(mat2gray(SegmentedImage)*255);
        
        %_________ Feature extraction ___________
        
        
        % 1. Gray Level Co-occurance Mtarix feature extraction (1x672)
        feat_cooc(counter,:) = GLCM (I, GLCMParameters);
        
        % 2. Run-Length feature extraction (1x44)
        feat_rle(counter,:) = RunLength(I);

        % 3. Gabor Filters feature extraction (1x1080)
        % 40 filters (8 orientations, 5 scales)
        GaborResult = Gabor(5,8,I,0);
        feat_gabor(counter,:) = real(GaborFilter(GaborResult));
        
        % 4. Local Binary Pattern feature extraction (1x1024)
        feat_lbp(counter,:) = LocalBinaryPattern(I, RadialLBP);
       
        % 5. Fractal feature extraction (1x30)
        feat_fractal(counter,:) = FractalDimension(I,0);
        
        % 6. Gradient-Based feature extraction (1x24)
        feat_gradient(counter,:)  = GradientBased(I);

        counter = counter+1
    end
end
time = toc

save([fullfile('Feature_RLE'),'.mat'], 'feat_rle', '-mat');
save([fullfile('Feature_Fractal'),'.mat'], 'feat_fractal', '-mat');
save([fullfile('Feature_GLCM'),'.mat'], 'feat_cooc', '-mat');
save([fullfile('Feature_Gabor'),'.mat'], 'feat_gabor', '-mat');
save([fullfile('Feature_Gradient'),'.mat'], 'feat_gradient', '-mat');
save([fullfile('Feature_LBP'),'.mat'], 'feat_lbp', '-mat');

Fetures = [feat_cooc feat_rle feat_gabor feat_lbp feat_fractal feat_gradient];