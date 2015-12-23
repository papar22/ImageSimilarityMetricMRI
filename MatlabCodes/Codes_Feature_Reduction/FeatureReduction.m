%% Function for feature dimensionality reduction based on PCA

% Implementation by matlab function named "princomp"


% Input Parameters:     - ObservationMatrix: A 2D matrix in which each row
%                       represents the sample and each column corresponds
%                       to one feature/variable. (example: a 100x9 observation
%                       matrix includes 100 samples and each sample can be 
%                       represented with 9 dimensions.


% Output Parameter:     - PCAOut: A structure containing the PCA
%                         coefficients, PCs and the corresponding eigenvalues
%                       - PCAOut.coefficents: Principal component coefficients
%                       - PCAOut.transformeddata: The representation of 
%                         ObservationMatrixin the principal component space
%                       - PCAOut.eigenvalues: Sorted eigenvalues


function PCAOut = FeatureReduction(ObservationMatrix)

% At first, the observation matrix is normalized to zero mean and unit
% variance
OB = ObservationMatrix;
NormOB = zscore(OB);


[COEFF,SCORE,latent,tsquare] = princomp(NormOB);

PCAOut.PCs = COEFF;
PCAOut.transformeddata = SCORE;
PCAOut.eigenvalues = latent;

save([fullfile('PCAResults'),'.mat'], 'PCAOut', '-mat');

% 
% S = (NormOB);
% transformedData = (S*COEFF);
