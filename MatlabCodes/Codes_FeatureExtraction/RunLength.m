%% Function to statistical features for Run-length

% Input Parameters:     - Image: The 2D image which is the aim of
%                         computation


% Output Parameters:     - Out: A [1x44] vector carrying the 11
%                       statistical features for four different
%                       orientations


function Out = RunLength(Image)

[GLRLMS,SI] = grayrlmatrix(Image,'NumLevels',255,'G',[min(Image(:)) max(Image(:))]);
VectorDegree = grayrlprops(GLRLMS);
Out(1,:) = [VectorDegree(1,:) VectorDegree(2,:) VectorDegree(3,:) VectorDegree(4,:)];
end

        