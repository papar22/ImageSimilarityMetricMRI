%% Function to impelement local binary pattern

% Reference: Gray Scale and Rotation Invariant Texture Classification with Local Binary Patterns
% This script has been inspired by the material in
% "http://www.mathworks.com/matlabcentral/fileexchange/36484-local-binary-patterns"
%  by Nikolay S.

 


% Input Parameters:     - inImg: input image, a 2D matrix (3D color images will be converted to 2D intensity
%                         value images)
%                       - filtR: a 2D matrix representing a round/radial filter. It can be generated using
%                         generateRadialFilterLBP function.
%                       - isRotInv : a logical flag. When enabled generated rotation invariant LBP accuired via
%                         fining an angle at whihc the LBP og a given pixelis minimal. Icreases run time, and
%                         results in a relatively sparce hsitogram (as many combinations disappear).
%                       - % isChanWiseRot: a logical flag, when enabled (default value) allowes channel wise
%                         rotation. When disabled/false rotation carried out based on roation of first color
%                         channel. Supported only when "isEfficent" is enabled. When  "isEfficent" is
%                         disabled "isChanWiseRot" is true.



% Output Parameter:     - LBP: LBP image



function LBP= LBP(inImg, varargin) % filtR, isRotInv, isChanWiseRot



%% Deafult params
isRotInv=false;
isChanWiseRot=false;
filtR=generateRadialFilterLBP(8, 1);

%% Get user inputs overriding default values
funcParamsNames={'filtR', 'isRotInv', 'isChanWiseRot'};
assignUserInputs(funcParamsNames, varargin{:});

% In case of file name input- read graphical file

if ischar(inImg) && exist(inImg, 'file')==2 
    inImg=imread(inImg);
end

nClrChans=size(inImg, 3);

inImgType=class(inImg);
calcClass='single';

isCalcClassInput=strcmpi(inImgType, calcClass);
if ~isCalcClassInput
    inImg=cast(inImg, calcClass);
end
imgSize=size(inImg);

nNeigh=size(filtR, 3);

if nNeigh<=8
    outClass='uint8';
elseif nNeigh>8 && nNeigh<=16
    outClass='uint16';
elseif nNeigh>16 && nNeigh<=32
    outClass='uint32';
elseif nNeigh>32 && nNeigh<=64
    outClass='uint64';
else
    outClass=calcClass;
end

if isRotInv
    nRotLBP=nNeigh;
    nPixelsSingleChan=imgSize(1)*imgSize(2);
    iSingleChan=reshape( 1:nPixelsSingleChan, imgSize(1), imgSize(2) );
else
    nRotLBP=1;
end

nEps=-3;
weigthVec=reshape(2.^( (1:nNeigh) -1), 1, 1, nNeigh);
weigthMat=repmat( weigthVec, imgSize([1, 2]) );
binaryWord=zeros(imgSize(1), imgSize(2), nNeigh, calcClass);
LBP=zeros(imgSize, outClass);
possibleLBP=zeros(imgSize(1), imgSize(2), nRotLBP);
for iChan=1:nClrChans  
    % Initiate neighbours relation filter and LBP's matrix
    for iFiltElem=1:nNeigh
        % Rotate filter- to compare center to next neigbour
        filtNeight=filtR(:, :, iFiltElem);
        
        % calculate relevant LBP elements via filtering
        binaryWord(:, :, iFiltElem)=cast( ...
            roundn(filter2( filtNeight, inImg(:, :, iChan), 'same' ), nEps) >= 0,...
            calcClass );
        % Without rounding sometimes inaqulity happens in some pixels
        % compared to pixelwiseLBP
    end % for iFiltElem=1:nNeigh

    for iRot=1:nRotLBP
        % find all relevant LBP candidates
        possibleLBP(:, :, iRot)=sum(binaryWord.*weigthMat, 3);
        if iRot < nRotLBP
            binaryWord=circshift(binaryWord, [0, 0, 1]); % shift binaryWord elements
        end
    end
    
    if isRotInv
        if iChan==1 || isChanWiseRot
            % Find minimal LBP, and the rotation applied to first color channel
            [minColroInvLBP, iMin]=min(possibleLBP, [], 3);
            
            % calculte 3D matrix index
            iCircShiftMinLBP=iSingleChan+(iMin-1)*nPixelsSingleChan;
        else
            % the above rotation of the first channel, holds to rest of the channels
            minColroInvLBP=possibleLBP(iCircShiftMinLBP);
        end % if iChan==1 || isChanWiseRot
    else
        minColroInvLBP=possibleLBP;
    end % if isRotInv
    
    if strcmpi(outClass, calcClass)
        LBP(:, :, iChan)=minColroInvLBP;
    else
        LBP(:, :, iChan)=cast(minColroInvLBP, outClass);
    end
end % for iChan=1:nClrChans