%% This scripts serves to calculate dis/similarity metrics 


%     - read all labeled data (Both Training and Test sets), totally 2911
%     samples from a folder named "TrainingSet"
%     - use "similarity_metrics" function to calculate the similarity metrics 


clc
clear all
close all


if ispc
    FolderAdrs{1,:} = (strcat(pwd , '\','TrainingSet','\'));
elseif isunix
    FolderAdrs{1,:} = (strcat(pwd , '/','TrainingSet','/'));
end

SubFolders = dir((fullfile(FolderAdrs{1,:}, '*.mat')));
SubFoldersName = {SubFolders.name}';

counter =1;
for k=1:1:size(SubFoldersName,1)
    
    OriginalStruct = load (strcat(FolderAdrs{1,:},SubFoldersName{k,:}));
    UnderSampledImage = getfield(OriginalStruct,  'Struct_Final');
    
    TestImage = UnderSampledImage.TestSample;
    TestImage = double(TestImage);
    RefImage = UnderSampledImage.FullSample;
    RefImage = double(RefImage);
    
    for n=1:1:size(TestImage,3)
        Out(counter,:) = similarity_metrics(RefImage(:,:,n), TestImage(:,:,n));
        counter= counter+1
    end
end



