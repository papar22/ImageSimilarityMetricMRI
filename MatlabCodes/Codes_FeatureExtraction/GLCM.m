%% Function to compute the Gray level Co-occurance Matrix (GLCM)

% The function generates different GLCMs with different displacement
% vectors. A displacement vector is a vector to represent the offset and
% orientation. For example DisplacementVector = [0 1] means the orientation
% angle is 0 degree and the offset value is 1 pixel. After obtaining GLCM,
% 21 statistical features will be calculated from the matrices.


% Input Parameters:     - Image: A 2D matrix. In case of color image, it
%                         will be changed to gray scale
%                       - InputParameters : A structure containing the
%                         parameter settings as below:
%                         'DisplacementVector' -> A [nx2] vector which
%                         is composed of offset and orientation (default= [0 1])
%                         'NumLevels' -> An integer number specifying the
%                         number of gray level intensity (default=8)
%                         'GrayLimits' -> A [1x2] = [low high] vector to
%                         determine how the values in the given Image are
%                         rescaled into the 'NumLevels'.

% (Notation): For more details, see matlab function "graycomatrix"




% Output Parameter:     - Out: A [1 x n*21] vector containing all
%                               statistical parameters

%                         - 1.  Angular Second Moment or Energy (ASM)
%                         - 2.  Contrast (CO)
%                         - 3.  Correlation (CORR)
%                         - 4.  Sum of squared variance (SSV)
%                         - 5.  Inverse difference moment or homogenity (IDM)
%                         - 6.  Summed average (SA)
%                         - 7.  Summed Variance (SV)
%                         - 8.  Summed entropy (SE)
%                         - 9.  Entropy (H)
%                         - 10. Difference varience (DV)
%                         - 11. Difference entropy (DE)
%                         - 12. Information measure of correlation 1 (IMC1)
%                         - 13. Information measure of correlation 2 (IMC2)
%                         - 14. Autocorrelation (ACORR)
%                         - 15. Dissimilarity (DIS)
%                         - 16. Cluster shade (CLS)
%                         - 17. Cluster prominence (CLP)
%                         - 18. Maximum probability (MAXP)
%                         - 19. Inverse difference (INV)
%                         - 20. Inverse difference normalized (INVN)
%                         - 21. Inverse difference moment normalized (IDMN)

function [Out] = GLCM (Image, InputParameters)


% Check for color image and convert to the grayscale
if(numel(size(Image))==3)       %if image is 3D
    if(size(Image,3)==3)
        Image = rgb2gray(Image);
    end
end


% Default Parameters (Offset value= 1 pixel)

if exist('InputParameters','var') == 0 || isfield(InputParameters,'DisplacementVector') == 0
    InputParameters.DisplacementVector = [0 1];
end

if exist('InputParameters','var') == 0 || isfield(InputParameters,'NumLevels') == 0
    InputParameters.NumLevels = 8;
end

if exist('InputParameters','var') == 0 || isfield(InputParameters,'GrayLimits') == 0
    InputParameters.GrayLimits = [min(Image(:)) max(Image(:))];
end


GLCM_Matrices = graycomatrix(Image, 'offset', InputParameters.DisplacementVector,...
    'NumLevels',InputParameters.NumLevels,...
    'GrayLimits', InputParameters.GrayLimits,...
    'Symmetric', false);

for n=1:1:size(GLCM_Matrices,3)
    
    G = GLCM_Matrices(:,:,n);
    SumOfGLCM = sum(sum(G));
    GNormalized = G ./ SumOfGLCM;
    MeanOfGLCM = mean2(GNormalized);
    
    
    % Initialization
    p_x   = zeros(size(G,1),1); 
    p_y   = zeros(size(G,2),1); 
    u_x   = 0;
    u_y   = 0;
    HXY1  = 0;
    HXY2  = 0;
    Hx    = 0;
    Hy    = 0;
    sigma_x = 0;
    sigma_y = 0;
    p_xplusy = zeros((size(G,1)*2 - 1),1);
    p_xminusy = zeros(size(G,1),1); 
    
    
    ASM     = 0;
    CO      = 0;
    CORR    = 0;
    SSV     = 0;
    IDM     = 0;
    SA      = 0;
    SV      = 0;
    SE      = 0;
    H       = 0;
    DV      = 0;
    DE      = 0;
    IMC1    = 0;
    IMC2    = 0;
    ACORR   = 0;
    DIS     = 0;
    CLS     = 0;
    CLP     = 0;
    MAXP    = 0;
    INV     = 0;
    INVN     = 0;
    IDMN     = 0;
    CORR_nomi = 0;
    

    for i = 1:size(G,1)
        for j = 1:size(G,2)
            
            % Marginal Probability
            p_x(i) = p_x(i) + GNormalized(i,j);
            p_y(i) = p_y(i) + GNormalized(j,i);
            
            % p(x+y)
            if (ismember((i + j),[2:2*(size(G,1))]))
                p_xplusy((i+j)-1) = p_xplusy((i+j)-1) + GNormalized(i,j);
            end
            % p(x-y)
            if (ismember(abs(i-j),[0:((size(G,1))-1)]))
                p_xminusy((abs(i-j))+1) = p_xminusy((abs(i-j))+1) + GNormalized(i,j);
            end
        end
    end
    
    
    for i=1:1:size(G,1)
        for j=1:1:size(G,2)
            
            % 1.  Angular Second Moment or Energy (ASM)
            ASM = (GNormalized(i,j).^2) + ASM;
            
            % 2.  Contrast (CO)
            CO = (abs(i - j))^2.*GNormalized(i,j) + CO;
            
            
            % 4.  Sum of squared variance (SSV)
            SSV = GNormalized(i,j)*((i - MeanOfGLCM)^2) + SSV;
            
            % 5.  Inverse difference moment or homogenity (IDM)
            IDM = (GNormalized(i,j)/( 1 + (i - j)^2)) + IDM;
            
            
            % 9.  Entropy (H)
            H = - (GNormalized(i,j)*log(GNormalized(i,j))) + H;
            
           
            
  
            % 15. Dissimilarity (DIS)
            DIS = (abs(i - j)*GNormalized(i,j)) + DIS;
            
            % 19. Inverse difference (INV)
            INV = INV + (GNormalized(i,j)/( 1 + abs(i - j)));
            
            % 20. Inverse difference normalized (INVN)
            INVN = INVN + (GNormalized(i,j)/( 1 + (abs(i-j)/(size(G,1))) ));
            
            % 21. Inverse difference moment normalized (IDMN)
            IDMN = IDMN + (GNormalized(i,j)/( 1 + ((i-j)/(size(G,1)))^2));
            
            
            u_x = u_x + (i)*GNormalized(i,j);
            u_y = u_y + (j)*GNormalized(i,j);
            
        end
    end
    
 
    for i = 1:size(G,1)
        for j = 1:size(G,2)
            
            sigma_x  = sigma_x  + ((((i) - u_x)^2)*GNormalized(i,j));
            sigma_y  = sigma_y  + ((((j) - u_y)^2)*GNormalized(i,j));
            
            % 16. Cluster shade (CLS)
            CLS = CLS + (((i + j - u_x - u_y)^3)*GNormalized(i,j));
            
            % 17. Cluster prominence (CLP)
            CLP = CLP + (((i + j - u_x - u_y)^4)*GNormalized(i,j));
            
            % 14. Autocorrelation (ACORR)
            ACORR = ACORR + ((i)*(j)*GNormalized(i,j));
         
        end
    end
    
    
    % 3.  Correlation (CORR)
    CORR = (ACORR - (u_x*u_y)) / (sqrt(sigma_x)*sqrt(sigma_y));
    
    for i = 1:(2*(size(G,1))-1)
        % 6.  Summed average (SA)
        SA = SA + (i+1)*p_xplusy(i);
        % 8.  Summed entropy (SE)
        SE = SE - (p_xplusy(i)*log(p_xplusy(i)));
    end
    
    for i = 1:(2*(size(G,1))-1)
        % 7.  Summed Variance (SV)
        SV = SV + (((i+1) - SE)^2)*p_xplusy(i);
    end
    
    
    for i = 0:((size(G,1))-1)
        % 10. Difference varience (DV)
        DV = DV + (i^2)*p_xminusy(i+1);
        
        % 11. Difference entropy (DE)
        DE = DE - (p_xminusy(i+1)*log(p_xminusy(i+1)));
    end
    
    HXY = H;
    
    for i = 1:size(G,1)
        for j = 1:size(G,1)
            HXY1 = HXY1 - (GNormalized(i,j)*log(p_x(i)*p_y(j)));
            HXY2 = HXY2 - (p_x(i)*p_y(j)*log(p_x(i)*p_y(j)));
        end
        Hx = Hx - (p_x(i)*log(p_x(i)));
        Hy = Hy - (p_y(i)*log(p_y(i)));
    end
    
    % 12. Information measure of correlation 1 (IMC1)
    % 13. Information measure of correlation 2 (IMC2)
    IMC1 = ( HXY - HXY1) / ( max([Hx,Hy]) );
    IMC2 = ( 1 - exp(-2*(HXY2 - HXY)))^0.5;

    % 18. Maximum probability (MAXP)
    MAXP = max(GNormalized(:));
    
    out(n,:) = [ACORR , CO, CORR, CLP, CLS ,  DIS, ASM, H, IDM, MAXP, SSV, SA, SV, SE, ...
        DV, DE, IMC1, IMC2, INV,INVN, IDMN];
    
end
 
    Out = reshape(out, [1,size(out,1)*size(out,2)]);

end

