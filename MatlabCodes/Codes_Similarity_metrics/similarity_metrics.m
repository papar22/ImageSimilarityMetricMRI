%% Function to measures dis/similarity metrics between two images
% written by Thomas Küstner
% (with small changes)

% Input Parameters:     - I_a: The first image (like the reference image)
%                       - I_b: The second image (like the sensed image)

% Output Parameter:     - Out: a 30x1 vector containing 30 single values
%                       corresponding to 30 different similarity metrics
%                       listed as below:

% Out = [smi; snmi; efinfo; rmi; rnmi; tmi; tnmi; ejp; finfo.Ia;...
%    finfo.Ma; finfo.Xa; cc; zcc; spr; ket; mse; rmse; psnr; tam; zca_zz;...
%    zcr_zz; mr; ssd; msd; nssd; sad; zsad; lsad; mad; shd] ;

% smi               Shannon mutual information
% snmi              Shannon normalized mutual information
% efinfo            exclusive F-information
% rmi               Renyi mutual information (additional input ..., 'r', rvalue)
% rnmi              Renyi normalized mutual information (additional input ..., 'r', rvalue)
% tmi               Tsallis mutual information (additional input ..., 'q', qvalue)
% tnmi              Tsallis normalized mutual information (additional input ..., 'q', qvalue)
% ejp               energy of joint probability
% finfo             F-information measures (additional input ..., 'alpha', alphavalue)
% cc                (Pearson) cross correlation
% zcc               zero-mean normalized (Pearson) cross correlation coefficient
% spr               Spearman rank correlation
% ket               Kendall's tau
% mse               mean squared error
% rmse              root mean squared error
% psnr              peak signal to noise ratio
% tam               Tanimoto measure
% zca_zz            zero crossings (absolute)
% zcr_zz            zero crossings (relative)
% mr                minimum ratio
% ssd               sum of squared differences
% msd               median of squared differences
% nssd              normalized sum of squared differences
% sad               sum of absolute differences
% zsad              zero-mean sum of absolute differences
% lsad              locally scaled sum of absolute differences
% mad               median of absolute differences
% shd               sum of hamming distance




function Out = similarity_metrics(I_a, I_b)

% Check whether two images have the same size or not
% add zero padding for an equal size

sz_a = size(I_a);
sz_b = size(I_b);

pic_a = zeros(max(sz_a(1,1) , sz_b(1,1)) , max(sz_a(1,2) , sz_b(1,2)));
pic_a(1:size(I_a,1) , 1: size(I_a,2)) = I_a;

pic_b = zeros(max(sz_a(1,1) , sz_b(1,1)) , max(sz_a(1,2) , sz_b(1,2)));
pic_b(1:size(I_b,1) , 1: size(I_b,2)) = I_b;


% Dynamic range of pixel intensities can be specified here as grayscale


grayscale = 256;
x = 0:grayscale-1;

% First scale dynamic ranges of images to fit in {0,...,grayscale-1}
% otherwise there will be an inconsistency of the results

pic_a=round((pic_a-min(pic_a(:)))*(grayscale-1)/(max(pic_a(:))-min(pic_a(:))+eps));
pic_b=round((pic_b-min(pic_b(:)))*(grayscale-1)/(max(pic_b(:))-min(pic_b(:))+eps));


% marginal histograms
n_a = histc(pic_a(:),x);
n_b = histc(pic_b(:),x);

% probabilities
p_a = n_a ./ sum(n_a);
p_b = n_b ./ sum(n_b);

%% joint histogram
n_ab = jointHistogram(pic_a, pic_b, grayscale, 1);

%% joint probability
p_ab = n_ab ./ sum(sum(n_ab));

%% Shannon mutual informations (SMI/SNMI)
% marginal entropies
H_a = -sum(p_a(p_a ~= 0) .* log2(p_a(p_a ~= 0)));
H_b = -sum(p_b(p_b ~= 0) .* log2(p_b(p_b ~= 0)));
% joint entropy
H_ab = -sum(p_ab(p_ab ~= 0) .* log2(p_ab(p_ab ~= 0)));
%% Shannon mutual information (SMI)
smi = H_a + H_b - H_ab;

%% Shannon normalized mutual information (SNMI)
snmi = (H_a + H_b)/(H_ab);

%% exclusive F-information (EFINFO)
efinfo = 2 * H_ab - H_a - H_b;

%% Renyi mutual informations (RMI/RNMI)
% needs variable r
r = 0.5;

formula = '1/(1-r) .* log2(sum((p_X(p_X ~= 0)).^r)/sum(p_X(p_X ~= 0)));';
for idx = {'a','b','ab'}
    eval(sprintf('H_%s = %s',idx{1},strrep(formula,'X',idx{1})));
end
rmi = H_a + H_b - H_ab;
rnmi = (H_a + H_b)/(H_ab);


%% Tsallis mutual informations (TMI/TNMI)

% needs variable q
q = 0.5;

formula = '1/(q-1) .* (1 - sum((p_X(p_X ~= 0)).^r));';
for idx = {'a','b','ab'}
    eval(sprintf('H_%s = %s',idx{1},strrep(formula,'X',idx{1})));
end
tmi = H_a + H_b + (1-q)*H_a*H_b - H_ab;
tnmi = (H_a + H_b + (1-q)*H_a*H_b)/(H_ab);


%% energy of joint probability (EJP)

%jpd = n_ab./(numel(pic_a(:))); % joint probability distribution, same as p_ab
jpd = p_ab;
ejp = sum(sum(sum((jpd).^2)));


%% F-information measures

% needs variable alpha
alpha = 0.5;

if(alpha ~= 0 && alpha ~= 1)
    finfo.Ia = 1/(alpha * (alpha -1)) .* sum(sum((p_ab).^alpha ./(p_a * p_b').^(alpha-1) - 1));
else
    finfo.Ia = NaN;
end
if((0 < alpha) && (alpha <= 1))
    finfo.Ma = sum(sum((abs((p_ab).^alpha - (p_a * p_b').^alpha)).^(1/alpha)));
else
    finfo.Ma = NaN;
end
if(alpha > 1)
    finfo.Xa = sum(sum(((abs(p_ab - p_a * p_b')).^alpha)./((p_a * p_b').^(alpha-1))));
else
    finfo.Xa = NaN;
end


%% (Pearson) normalized cross correlation coefficient (NCC/CC)
% Hint: Matlab uses default 1/(n-1) for expectation value instead of 1/n,
% but in correlation coefficient this cancels out

% for 1/(n-1) and 1/n
cc = corrcoef(pic_a,pic_b);
cc = cc(1,2);


% for 1/n
% C = cov(pic_a,pic_b,1);
% cc = C(1,2)/(sqrt(C(1,1) * C(2,2)));

% test:
% 2D
% cc_2D = sum(sum((pic_a - mean(mean(pic_a))).*(pic_b - mean(mean(pic_b)))))/sqrt(sum(sum((pic_a - mean(mean(pic_a))).^2)) .* sum(sum((pic_b - mean(mean(pic_b))).^2)));
% % 3D
% cc_3D = sum(sum(sum((pic_a - mean(mean(mean(pic_a)))).*(pic_b - mean(mean(mean(pic_b)))))))/sqrt(sum(sum(sum((pic_a - mean(mean(mean(pic_a)))).^2))) .* sum(sum(sum((pic_b - mean(mean(mean(pic_b)))).^2))));


%% zero-mean normalized cross correlation coefficient (ZCC)
zcc = sum(sum(sum(pic_a.*pic_b)))/sqrt(sum(sum(sum((pic_a).^2))) .* sum(sum(sum((pic_b).^2))));

%% Spearman rank correlation (SPR)
spr = corr(pic_a(:), pic_b(:), 'type', 'Spearman');
%     spr = 1 - ((6*sum((pic_a(:) - pic_b(:)).^2))/(numel(pic_a(:)) * (numel(pic_a(:)).^2 - 1)));

%% Kendall's tau (KET)
ket = corr(pic_a(:), pic_b(:), 'type', 'Kendall');

%% mean squared error (MSE)
mse = sum((pic_a(:) - pic_b(:)).^2)/numel(pic_a(:));

%% root mean squared error (RMSE)
rmse = sqrt(sum(abs(pic_a(:) - pic_b(:)).^2)/numel(pic_a(:)));

%% peak to signal noise ratio (PSNR)
psnr = 10*log10(grayscale^2 / abs(sum(pic_a(:) - pic_b(:))/numel(pic_a(:))));

%% Tanimoto measure (TAM)
tam = (pic_a(:)' * pic_b(:))/(sum(abs(pic_a(:) - pic_b(:)).^2) + pic_a(:)' * pic_b(:));

%% zero crossings (absolute and relative) (ZCA/ZCR)
pic_diff = pic_a - pic_b;
pic_diff = pic_diff(:);
zca_zz = length(find(pic_diff(1:end-1).*pic_diff(2:end) < 0));
zcr_zz = zca_zz/(numel(pic_diff(:)));

%% minimum ratio (MR)
mr = sum(sum(sum(min(pic_a,pic_b))))/numel(pic_a(:)) ;

%% sum of squared differences (SSD)
ssd = sqrt(sum(sum(sum((pic_a-pic_b).^2))))/(numel(pic_a));

%% median of squared differences (MSD)
msd = median(median(median((pic_a - pic_b).^2)))/(numel(pic_a));

%% normalized sum of squared differences (nssd)
nssd = sqrt(sum(sum(sum(((pic_a - mean(mean(mean(pic_a))))/std(std(std(pic_a,1),1),1) - (pic_b - mean(mean(mean(pic_b))))/std(std(std(pic_b,1),1),1)).^2))));

%% sum of absolute differences (SAD)
sad = sum(sum(sum(abs(pic_a - mean(pic_a(:)) - pic_b + mean(pic_b(:))))))/(numel(pic_a));

%% zero-mean sum of absolute differences (ZSAD)
zsad = sum(sum(sum(abs(pic_a - pic_b))))/(numel(pic_a));

%% locally scaled sum of absolute differences (LSAD)
lsad = sum(sum(sum(abs(pic_a - (mean(pic_a(:))/mean(pic_b(:)) * pic_b)))))/(numel(pic_a));

%% median of absolute differences (MAD)
mad = median(median(median(pic_a - pic_b)))/(numel(pic_a));

%% sum of hamming distance (SHD)
shd = sum(pic_a(:) == pic_b(:))/(numel(pic_a));

%% Output Together
%[smi, snmi, efinfo, rmi, rnmi, tmi, tnmi, ejp, finfo, ssim, mssim, cc, zcc, spr, ket, mse, rmse, psnr, tam, zca, zcr, mr, ssd, msd, nssd, sad, zsad, lsad, mad, shd, besov]
OutputVectorValue = [smi; snmi; efinfo; rmi; rnmi; tmi; tnmi; ejp; finfo.Ia;...
    finfo.Ma; finfo.Xa; cc; zcc; spr; ket; mse; rmse; psnr; tam; zca_zz;...
    zcr_zz; mr; ssd; msd; nssd; sad; zsad; lsad; mad; shd] ;
% OutputVectorString = {'smi'; 'snmi'; 'efinfo'; 'rmi'; 'rnmi'; 'tmi'; 'tnmi';...
%     'ejp'; 'finfo.Ia'; 'finfo.Ma'; 'finfo.Xa'; 'cc'; 'zcc'; 'spr'; 'ket'; ...
%     'mse'; 'rmse'; 'psnr'; 'tam'; 'zca_zz'; 'zcr_zz'; 'mr'; 'ssd'; 'msd';...
%     'nssd'; 'sad'; 'zsad'; 'lsad'; 'mad'; 'shd'}

% OutputVectorString = [...
%     'smi     '; 'snmi    '; 'efinfo  '; 'rmi     '; 'rnmi    '; 'tmi     '; 'tnmi    ';...
%     'ejp     '; 'finfo.Ia'; 'finfo.Ma'; 'finfo.Xa'; 'cc      '; 'zcc     '; 'spr     '; 'ket     '; ...
%     'mse     '; 'rmse    '; 'psnr    '; 'tam     '; 'zca_zz  '; 'zcr_zz  '; 'mr      '; 'ssd     '; 'msd     ';...
%     'nssd    '; 'sad     '; 'zsad    '; 'lsad    '; 'mad     '; 'shd     '] ;
%
% OutputString = [OutputVectorString num2str(OutputVectorValue)]

Out = [OutputVectorValue'];