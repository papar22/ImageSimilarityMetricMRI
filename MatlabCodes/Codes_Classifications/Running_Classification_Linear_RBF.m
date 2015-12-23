%% This scripts serves to perform the classification task

% By means of LIBSVM standard library.
% reference: C.-C. Chang and C.-J. Lin, “LIBSVM: A library for support
% vector machines,” ACM Transactions on Intelligent Systems and Technology,
% vol. 2, pp. 27:1–27:27, 2011, software
% available at http://www.csie.ntu.edu.tw/~cjlin/libsvm.


%     - load the labeled data (Both Training and Test sets), totally 2911
%     as TrainDataPCA.mat and TestDataPCA.mat. These two .mat files
%     include the feature vector (1x2871) and the corresponding class
%     label for each sample, hence (1x2872). The last column represents the
%     class label.

%     - Create the model, train the classifier with different C and gamma
%     values and choose the best ones through cross-validations and
%     calculate the training erorr rate

%     - Again train the classifier by the best parameters which have been
%     found

%     - Test the test dataset to calculate the generalization error rate



%     - use "svmtrain" to train and "svmpredict" for test. For more
%     information see (http://www.csie.ntu.edu.tw/~cjlin/libsvm)

% options:
% -s svm_type : set type of SVM (default 0)
% 	0 -- C-SVC
% 	1 -- nu-SVC
% 	2 -- one-class SVM
% 	3 -- epsilon-SVR
% 	4 -- nu-SVR
% -t kernel_type : set type of kernel function (default 2)
% 	0 -- linear: u'*v
% 	1 -- polynomial: (gamma*u'*v + coef0)^degree
% 	2 -- radial basis function: exp(-gamma*|u-v|^2)
% 	3 -- sigmoid: tanh(gamma*u'*v + coef0)
% -d degree : set degree in kernel function (default 3)
% -g gamma : set gamma in kernel function (default 1/num_features)
% -r coef0 : set coef0 in kernel function (default 0)
% -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
% -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
% -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
% -m cachesize : set cache memory size in MB (default 100)
% -e epsilon : set tolerance of termination criterion (default 0.001)
% -h shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
% -b probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
% -wi weight: set the parameter C of class i to weight*C, for C-SVC (default 1)
%
% The k in the -g option means the number of attributes in the input data.


clc
clear all
close all

% Add the LIBSVM path
addpath(genpath([pwd filesep 'LIBSVM']));


% Parameter settings

% Number of desired principle components (PCs)
NUM_PC = 36;
% Number of folds to impelement the k-folds cross validation
Folds = 10;
% The range of C and gamma values for a grid search and to find the
% best parameters
[C,gamma] = meshgrid(-5:1:15, -15:2:3);
% Type of kernel function in SVM
Kernel_Type = 'RBF'; % or Kernel_Type = 'LINEAR';

% Loading the training and the test sets with the corresponding labels.
% The last column shows the corresponding class labels.

a = load('TrainDataPCA.mat');
TrainData = a.TrainData;
data = TrainData(:,1:NUM_PC);
labels = TrainData(:,end);


a1 = load('TestDataPCA.mat');
TestData = a1.TestData;
dataTest = TestData(:,1:NUM_PC);
labelsTest = TestData(:,end);


if Kernel_Type == 'RBF'
    
    %____________________ Training ____________________
    
    % Grid search and Cross-validation
    CvAccurracy = zeros(numel(C),1);
    for i=1:numel(C)
        
        %         In svmtrain:
        %         - data: training samples
        %         - labels: training class labels
        %         - '-c': set the parameter C
        %         - '-g': set gamma in RBF kernel function
        %         - '-v': number of folds to carry out cross-validation
        %         - '-s': svm_type, here as default 0 --> C-SVC
        %         - '-t': kernel_type, here as default 2 --> RBF
        
        CvAccurracy(i) = svmtrain(labels, data, ...
            sprintf('-c %f -g %f -v %d', 2^C(i), 2^gamma(i), Folds));
    end
    
    % Choose the best pair of (C,gamma) with the best accuracy
    [~,idx] = max(CvAccurracy);
    BestC = 2^C(idx);
    Bestgamma = 2^gamma(idx);
    BestAccurracy = max(CvAccurracy);
    
    Result = [BestC Bestgamma  BestAccurracy Folds];
    
    nameTrain = strcat('Result_Training_RBF_',num2str(NUM_PC), '_' , num2str(Folds));
    save([fullfile(nameTrain),'.mat'], 'Result', '-mat');
    
    %_______________ Create the Model _____________
    
    Model = svmtrain(labels,data, sprintf('-t 2 -c %f -g %f', Result(1,1), Result(1,2)));
    
    %____________________ Test ____________________
    
    [EstimatedLabel, TestAccuracy, DecValues] = svmpredict(labelsTest,dataTest, Model);
    
    ConfusionMatrix = confusionmat(labelsTest, EstimatedLabel);
    
    TestResult = struct('EstimatedLabel', EstimatedLabel, 'TestAccuracy', TestAccuracy(1,1),...
        'DecValues', DecValues, 'ConfusionMatrix',ConfusionMatrix);
    
    
    nameTest = strcat('Result_Test_RBF_',num2str(NUM_PC), '_' , num2str(Folds));
    save([fullfile(nameTest),'.mat'], 'TestResult', '-mat');
    
end

if Kernel_Type == 'LINEAR'
    
    %____________________ Training ____________________
    
    % Grid search and Cross-validation
    CvAccurracy = zeros(numel(C),1);
    for i=1:numel(C)
        
        %         In svmtrain:
        %         - data: training samples
        %         - labels: training class labels
        %         - '-t': kernel_type, set to 0 --> linear
        %         - '-c': set the parameter C
        %         - '-v': number of folds to carry out cross-validation
        %         - '-s': svm_type, here as default 0 --> C-SVC
        
        CvAccurracy(i) = svmtrain(labels, data, ...
            sprintf('-t 0 -c %f -v %d', 2^C(i), folds));
        
    end
    
    % Choose the best parameter C with the best accuracy
    [~,idx] = max(CvAccurracy);
    BestC = 2^C(idx);
    BestAccurracy = max(CvAccurracy);
    
    Result = [BestC BestAccurracy Folds];
    
    nameTrain = strcat('Result_Training_Linear_',num2str(NUM_PC), '_' , num2str(Folds));
    save([fullfile(nameTrain),'.mat'], 'Result', '-mat');
    
    
    %_______________ Create the Model _____________
    
    Model = svmtrain(labels,data, sprintf('-t 0 -c %f ', Result(1,1)));
    
    %____________________ Test ____________________
    
    [EstimatedLabel, TestAccuracy, DecValues] = svmpredict(labelsTest,dataTest, Model);
    
    ConfusionMatrix = confusionmat(labelsTest, EstimatedLabel);
    
    TestResult = struct('EstimatedLabel', EstimatedLabel, 'TestAccuracy', TestAccuracy(1,1),...
        'DecValues', DecValues, 'ConfusionMatrix',ConfusionMatrix);
    nameTest = strcat('Result_Test_Linear_',num2str(NUM_PC), '_' , num2str(Folds));
    save([fullfile(nameTest),'.mat'], 'TestResult', '-mat');
    
end



