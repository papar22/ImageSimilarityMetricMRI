function PopUpFunc(hObject, evt,Edit1_h, TxtBx4_h)

Fig_h = ancestor(hObject, 'figure');
LR = getappdata(Fig_h, 'L');
PopFlag = getappdata(Fig_h, 'PopUpFlag');
PopFlag =1;

setappdata(Fig_h, 'PopUpFlag',PopFlag);
sz = getappdata(Fig_h, 'size');
countflag = getappdata(Fig_h, 'CountFlag');


UserHistoryName = dir((fullfile(pwd, '*.mat')));
UserHistoryName = {UserHistoryName.name}';
% UserHistoryNameChar{1,:} = '...';

if ~isempty(UserHistoryName)
    for n=1:1:size(UserHistoryName,1)
        as = UserHistoryName{n,:};
        UserHistoryNameChar{n,:} = as(8:end-4);
    end
else
    UserHistoryNameChar = '';
end

set(hObject,'String',UserHistoryNameChar);
contents = cellstr(get(hObject,'String'));
Selectedname = contents{get(hObject,'Value')};
setappdata(Fig_h, 'UserName',Selectedname);

if ~isempty(Selectedname)
    if ispc
        HistoryFile{1,:} = (strcat(pwd , '\','Result_',Selectedname,'.mat'));
    elseif isunix
        HistoryFile{1,:} = (strcat(pwd , '/','Result_',Selectedname,'.mat'));
    end
    set(Edit1_h,'String',Selectedname);
    OriginalStruct = load (HistoryFile{1,:});
    Info = OriginalStruct.LabeledResult;
    
    for n=1:1:size(Info,2)
        alreadygroup(n,1) =  Info(n).group;
    end
    LR = Info;
    ff = find(alreadygroup ~=0);
    loopIndex = ff(end,1);
    dd = Info(loopIndex).date;
    ss = size(find(alreadygroup ~=0),1);
    setappdata(Fig_h, 'alreadygroup', alreadygroup);
%     setappdata(Fig_h, 'loopIndex', loopIndex);
    set(TxtBx4_h,'String',sprintf('%s Ranked %s Out of 100 Images on %s. To Continue Press Start!',Selectedname, num2str(ss),dd));
    set(TxtBx4_h,'Visible','on','FontSize',10,...
        'FontName','times','BackgroundColor',[70/255 70/255 70/255],'ForegroundColor',[255/255 165/255 0] );
    setappdata(Fig_h, 'L',LR);
else
%     setappdata(Fig_h, 'loopIndex', 1);
    setappdata(Fig_h, 'alreadygroup', 0);
    LabeledResult = repmat(struct('username', '','imagename','','date','','group',0),1,sz);
    setappdata(Fig_h, 'L',LabeledResult);
end






