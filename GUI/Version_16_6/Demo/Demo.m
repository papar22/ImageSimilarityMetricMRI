clc
clear all
close all
warning off

currpath = fileparts(mfilename('fullpath'));
addpath(genpath(['..',filesep,currpath,filesep,'imagine1_4_tue']));



%% _____________________________________
% SubFoldersName contains the folder name with TUE_BSPxxx
% CellName is a cell to have the address of folders like
% '/net/filse-sn/raidar2/d1132/0-DICOM_Reading_Files/TUE_BSP168/'
% CurrentFolder contains all subfolders containg IMA formats inside the Tue_BSPxxx folders like
% '/net/filse-sn/raidar2/d1132/0-DICOM_Reading_Files/TUE_BSP353/t2_tse_tra_fs_p2_Becken_0043'
% The content of CurrentFolder should be used for both undersampled and
% fullsampled data :)


% Window
Fig_h = figure('Visible','on', 'Menu','none',...
    'Name','Ranking', 'Resize','off',...
    'Position',[100 100 450 450]);
set(Fig_h, 'Color', [70/255 70/255 70/255]);


movegui(Fig_h,'northwest');
setappdata(Fig_h, 'loopIndex', 0);
setappdata(Fig_h, 'group',0);
setappdata(Fig_h, 'BackFlag',0);
setappdata(Fig_h, 'NextFlag',0);
setappdata(Fig_h, 'CountFlag',0);
setappdata(Fig_h, 'PopUpFlag',0);
setappdata(Fig_h, 'ImagineFlag',0);
setappdata(Fig_h, 'UserName','');
setappdata(Fig_h, 'Date','');
setappdata(Fig_h, 'alreadygroup',0);
setappdata(Fig_h, 'gr',0);
setappdata(Fig_h, 'EditFlag',0);



Edit1_h = uicontrol('Visible','on','style','edit','Position',[140 230 160 30],'Tag','Editname',...
    'FontSize',20,'FontName','times','BackgroundColor',[255/255 255/255 1]);

TxtBx4_h = uicontrol('Visible' , 'off','style','text','Position',[20 260 400 40]);

PopUp_h = uicontrol('Visible' , 'on','style','popupmenu','Position',[140 310 160 30],'Tag','popup',...)
    'BackgroundColor',[100/255 100/255 100/255],'ForegroundColor',[255/255 255/255 1],...
    'String','Open','FontSize',12,'FontName','times','Callback',{@PopUpFunc,Edit1_h,TxtBx4_h});


BtnGrp_h = uibuttongroup('Visible' , 'off','Position',[0 0 1 0.4], 'Units','Normalized', 'BackgroundColor', [70/255 70/255 70/255]);

R1_h = uicontrol('Style','Radio', 'Parent',BtnGrp_h,...
    'HandleVisibility','off', 'Position',[80 230 60 30],...
    'String',' 1', 'Tag','1','FontSize',14,'FontName','times');
R2_h = uicontrol('Style','Radio', 'Parent',BtnGrp_h,...
    'HandleVisibility','off', 'Position',[140 230 60 30],...
    'String',' 2', 'Tag','2' ,'FontSize',14,'FontName','times');
R3_h = uicontrol('Style','Radio', 'Parent',BtnGrp_h,...
    'HandleVisibility','off', 'Position',[200 230 60 30],...
    'String',' 3', 'Tag','3','FontSize',14,'FontName','times');
R4_h = uicontrol('Style','Radio', 'Parent',BtnGrp_h,...
    'HandleVisibility','off', 'Position',[260 230 60 30],...
    'String',' 4', 'Tag','4','FontSize',14,'FontName','times');
R5_h = uicontrol('Style','Radio', 'Parent',BtnGrp_h,...
    'HandleVisibility','off', 'Position',[320 230 60 30],...
    'String',' 5', 'Tag','5','FontSize',14,'FontName','times');

TxtBx5_h = uicontrol('Visible' , 'off','style','text','Position',[180 180 80 20],...
    'BackgroundColor',[70/255 70/255 70/255],'FontSize',12);

TxtBx6_h = uicontrol('Visible' , 'off','style','text','Position',[50 50 360 20],...
    'BackgroundColor',[70/255 70/255 70/255],'FontSize',12,...
    'ForegroundColor',[255/255 165/255 0]);


EnterBn_h = uicontrol('Style','pushbutton','Parent',BtnGrp_h,...
    'Visible' , 'on','String','OK', 'Position',[140 80 160 80],'FontSize',14,'FontName','times','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[100/255 100/255 100/255],...
    'Callback',{@EnterFunc, BtnGrp_h,TxtBx5_h});


TxtBx1_h = uicontrol('Visible' , 'off','style','text','Position',[30 330 390 65],...
    'BackgroundColor',[70/255 70/255 70/255], 'ForegroundColor',[255/255 165/255 0]);


TxtBx2_h = uicontrol('Visible' , 'off','style','text','Position',[30 300 390 20],...
    'BackgroundColor',[70/255 70/255 70/255], 'ForegroundColor',[255/255 165/255 0]);


TxtBx3_h = uicontrol('Visible' , 'on','style','text','Position',[30 340 400 100],'FontSize',12);
set(TxtBx3_h,'String','To Begin The Ranking of Images Please at First, Check Whether You Have Already Done The Labeling Or Not From "Open" PopUp Menu. If Not, Enter Your Name In The White Box And Press Start!','FontSize',13,...
    'FontName','times','BackgroundColor',[70/255 70/255 70/255],'ForegroundColor',[255/255 165/255 0] );

QuitBn_h = uicontrol('Style','pushbutton',...
    'Visible' , 'off','String','Quit', 'Position',[20 20 60 25],'FontSize',14,'FontName','times','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[100/255 100/255 100/255],...
    'Callback',{@QuitFunc});



BckBn_h = uicontrol('Parent', Fig_h,'Style','pushbutton',...
    'Visible' , 'off','String','Back', 'Position',[30 410 60 25],...
    'FontSize',14,'FontName','times','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[100/255 100/255 100/255],...
    'Callback',{@BackFunc,BtnGrp_h,EnterBn_h,TxtBx5_h,TxtBx6_h});

NxtBn_h = uicontrol('Parent', Fig_h,'Style','pushbutton',...
    'Visible' , 'on','String','Start', 'Position',[140 130 160 80],...
    'FontSize',14,'FontName','times','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[100/255 100/255 100/255],...
    'Callback',{@NextFunc, BtnGrp_h,TxtBx3_h,BckBn_h,TxtBx1_h,TxtBx2_h, Edit1_h, PopUp_h , TxtBx4_h,QuitBn_h,EnterBn_h,TxtBx5_h,TxtBx6_h});


if ispc
    FolderAdrs{1,:} = (strcat(pwd , '\','TrainingSet','\'));
elseif isunix
    FolderAdrs{1,:} = (strcat(pwd , '/','TrainingSet','/'));
end

SubFolders = dir((fullfile(FolderAdrs{1,:}, '*.mat')));
SubFoldersName = {SubFolders.name}';

setappdata(Fig_h, 'size',size(SubFoldersName,1));
LabeledResult = repmat(struct('username', '','imagename','','date','','group',0),1,size(SubFoldersName,1));
setappdata(Fig_h, 'L',LabeledResult);

group = getappdata(Fig_h, 'group');
alreadygroup = getappdata(Fig_h, 'alreadygroup');
flag = getappdata(Fig_h, 'NextFlag');
gr = zeros(size(SubFoldersName,1),1);
setappdata(Fig_h, 'gr',gr);

while (1)
    
    uiwait(Fig_h); % this will wait for anyone to call uiresume(hFig)
    loopIndex = getappdata(Fig_h, 'loopIndex');
    

    PPFlag = getappdata(Fig_h, 'PopUpFlag');
    if PPFlag
        currentString = get(Edit1_h, 'String');
        Name = getappdata(Fig_h, 'UserName');
        if strcmp(Name,currentString)
            alreadygroup = getappdata(Fig_h, 'alreadygroup');
            gr(1:size(alreadygroup,1)) = alreadygroup;
            LabeledResult = getappdata(Fig_h, 'L');
            ff = find(alreadygroup ~=0);
            loopIndex = ff(end,1)+1;
            setappdata(Fig_h, 'UserName', Name);
            setappdata(Fig_h, 'loopIndex', loopIndex);
        elseif  ~strcmp(Name,currentString)
            alreadygroup =0;
            gr = zeros(size(SubFoldersName,1),1);
            LabeledResult = repmat(struct('username', '','imagename','','date','','group',0),1,size(SubFoldersName,1));
            loopIndex = 1;
            setappdata(Fig_h, 'UserName', currentString);
            setappdata(Fig_h, 'loopIndex', loopIndex);
        end
            setappdata(Fig_h, 'PopUpFlag',0);
            setappdata(Fig_h, 'gr',gr);
    else
        setappdata(Fig_h, 'UserName', get(Edit1_h, 'String'));
    end
    
    
    CoFlag = getappdata(Fig_h, 'CountFlag');
    if CoFlag==1
        
        if (0 < loopIndex) && (loopIndex <= size(SubFoldersName,1))
            
            OriginalStruct = load (strcat(FolderAdrs{1,:},SubFoldersName{loopIndex,:}));
            UnderSampledImage = getfield(OriginalStruct,  'Struct_Final');
            
            TestImage = UnderSampledImage.TestSample;
            TestImageName = UnderSampledImage.TestSampleName;
            
            RefImage = UnderSampledImage.FullSample;
            RefImageName = UnderSampledImage.FullSampleName;
            
            ImagineHandler = imagine(RefImage,'The Reference Image', TestImage ,sprintf('The Test Image. No = %d',loopIndex));
            setappdata(Fig_h, 'ImagineFlag', ImagineHandler(1,:));
        end
        setappdata(Fig_h, 'CountFlag',0)
    end
    
    flag = getappdata(Fig_h, 'NextFlag');
    if flag
        gr(loopIndex,1) = getappdata(Fig_h, 'group');
        setappdata(Fig_h, 'gr',gr);
        UserName = getappdata(Fig_h, 'UserName');
        
        if (loopIndex >= 1) && (loopIndex <=  size(SubFoldersName,1))
            LabeledResult(loopIndex).group = gr(loopIndex);
            LabeledResult(loopIndex).imagename = SubFoldersName{loopIndex};
            LabeledResult(loopIndex).username = UserName;
            LabeledResult(loopIndex).date = date;
        end
        save([fullfile(strcat('Result_',UserName)),'.mat'], 'LabeledResult', '-mat');
        
        flag = 0;
        setappdata(Fig_h, 'NextFlag', flag)
        setappdata(Fig_h, 'gr',gr);
    end
    
    % stop loop at some point:
    if (loopIndex > size(SubFoldersName,1) || loopIndex <= 0)
        break
    end
    
end

if(isempty(Fig_h) || ~exist('Fig_h','var') || ~ishandle(Fig_h))
    % NOP
else
    
    FlagIteration = 1;
    [index] = find(gr==0);
    
    setappdata(Fig_h, 'index', index);
    setappdata(Fig_h, 'FlagIteration',1);
    
    
    if size(index,1)~=0
        
        set(EnterBn_h,'Visible','off')
        set(BckBn_h,'Visible','off')
        set(NxtBn_h,'Position',[280 30 110 50])
        set(NxtBn_h,'String','Continue')
        set(NxtBn_h,'Visible','on')
        set(TxtBx1_h,'String',sprintf('You Did Not Rank %s Out of %s Images. Do You Want to Continue Or Quit?',num2str(size(index,1)),num2str(size(SubFoldersName,1))))
        set(TxtBx2_h,'Visible','off')
        set(TxtBx5_h,'Visible','off')
        set(TxtBx6_h,'Visible','off')
        set(BtnGrp_h,'Visible','off')
        set(QuitBn_h,'Position',[30 30 110 50])
        
        loopIndex = 0;
        setappdata(Fig_h, 'loopIndex', 0);
        setappdata(Fig_h, 'NextFlag',0);
        
        
        while (1)
            uiwait(Fig_h); % this will wait for anyone to call uiresume(hFig)
            loopIndex = getappdata(Fig_h, 'loopIndex');
            
            CoFlag = getappdata(Fig_h, 'CountFlag');
            if CoFlag==1
                
                if (0 < loopIndex) && (loopIndex <= size(index,1))
                    
                    OriginalStruct = load (strcat(FolderAdrs{1,:},SubFoldersName{index(loopIndex),:}));
                    UnderSampledImage = getfield(OriginalStruct,  'Struct_Final');
                    
                    TestImage = UnderSampledImage.TestSample;
                    TestImageName = UnderSampledImage.TestSampleName;
                    
                    RefImage = UnderSampledImage.FullSample;
                    RefImageName = UnderSampledImage.FullSampleName;
                    
                    ImagineHandler(loopIndex,:) = imagine(RefImage,'The Reference Image', TestImage ,sprintf('The Test Image. No = %d',index(loopIndex)));
                    setappdata(Fig_h, 'ImagineFlag', ImagineHandler(loopIndex));
                end
                setappdata(Fig_h, 'CountFlag',0)
            end
            
            flag = getappdata(Fig_h, 'NextFlag');
            if flag && loopIndex > 0
                gr(index(loopIndex),1) = getappdata(Fig_h, 'group');
                setappdata(Fig_h, 'gr',gr);
            end
            flag = 0;
            setappdata(Fig_h, 'NextFlag', flag)
            
            UserName = getappdata(Fig_h, 'UserName');
            
            if (loopIndex >= 1) && (loopIndex <=  size(index,1))
                LabeledResult(index(loopIndex)).group =  gr(index(loopIndex));
                LabeledResult(index(loopIndex)).imagename = SubFoldersName{index(loopIndex)};
                LabeledResult(index(loopIndex)).username = UserName;
                LabeledResult(index(loopIndex)).date = date;
            end
            
            save([fullfile(strcat('Result_',UserName)),'.mat'], 'LabeledResult', '-mat');
            
            % stop loop at some point:
            if (loopIndex > size(index,1))
                sa = size(find(gr~= 0),1);
                if sa == size(SubFoldersName,1)
                    hFinishMsg = msgbox('Congratulation. You Successfully Completed The Ranking Task. Thank You');
                    movegui(hFinishMsg,'center')
                    pause(5);
                    break
                else
                    hCondMsg = msgbox(sprintf('You Have Ranked %s Images Out of %s. Thank You For Cooperation!',num2str(sa),num2str(size(SubFoldersName,1))));
                    movegui(hCondMsg,'center')
                    pause(3)
                    break
                end
            end
        end
        
        
    else
        hFinishMsg = msgbox('Congratulation. You Successfully Completed The Ranking Task.');
        movegui(hFinishMsg,'center')
        pause(5);
        close all;
    end
    
end