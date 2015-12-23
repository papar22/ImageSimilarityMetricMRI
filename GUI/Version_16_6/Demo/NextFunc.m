function NextFunc(hObject, evt, BtnGrp_h,TxtBx3_h,BckBn_h,TxtBx1_h,TxtBx2_h,Edit1_h,PopUp_h, TxtBx4_h,QuitBn_h,EnterBn_h,TxtBx5_h,TxtBx6_h)

Fig_h = ancestor(hObject, 'figure');

loopNext = getappdata(Fig_h, 'loopIndex')+1;
grNext = getappdata(Fig_h, 'gr');

set(TxtBx5_h,'Visible','on')
set(EnterBn_h,'String','OK');
set(EnterBn_h,'BackgroundColor',[100/255 100/255 100/255]);
set(TxtBx4_h,'Visible','off');
set(EnterBn_h,'Visible','on');
set(QuitBn_h,'Visible','on')
set(QuitBn_h,'Position',[20 20 60 25])
set(TxtBx3_h,'Visible','off');
set(Edit1_h,'Visible','off');
set(PopUp_h,'Visible','off');
set(hObject,'String','Next');
set(hObject, 'Position',[360 410 60 25])
set(BckBn_h,'Visible','on');
set(BtnGrp_h,'Visible','on');
set(TxtBx1_h,'Visible','on','String','Please Choose your Ranking and Press OK! For Next Image, Please Press Next and For Previous Image, Press Back','FontSize',14,...
    'FontName','times');
set(TxtBx2_h,'Visible','on','String','1: Highly Visible, 5: Poorly Visible','FontSize',12,...
    'FontName','times');
% UserName = get(Edit1_h, 'String');
% setappdata(Fig_h, 'UserName', UserName)


FlagNext = getappdata(Fig_h, 'NextFlag');
countflag = getappdata(Fig_h, 'CountFlag');
countflag = 1;
setappdata(Fig_h, 'CountFlag',countflag);

indexNext = getappdata(Fig_h, 'index');
FlagIterationNext = getappdata(Fig_h, 'FlagIteration');

if FlagIterationNext
    if  numel(indexNext) >= loopNext 
        if (grNext(indexNext(loopNext)))==0
            set(TxtBx5_h,'BackgroundColor',[255/255 0/255 0]);
            set (TxtBx5_h,'String','UnRanked');
            set(TxtBx6_h,'Visible','on'); 
            set(TxtBx6_h,'String','Please Rank The Image or Press Next to Skip')
            
        else if (grNext(indexNext(loopNext)))~=0
                set(TxtBx5_h,'BackgroundColor',[0/255 255/255 0]);
                set(TxtBx5_h,'String','Ranked');
                set(TxtBx6_h,'String','');
            else
                set(TxtBx5_h,'BackgroundColor',[70/255 70/255 70/255]);
                set(TxtBx5_h,'String','');
                set(TxtBx6_h,'String','');
            end
        end
    end
else
    if  numel(grNext) >= loopNext 
        if (grNext(loopNext))==0
            set(TxtBx5_h,'BackgroundColor',[255/255 0/255 0]);
            set (TxtBx5_h,'String','UnRanked') ;  
            set(TxtBx6_h,'Visible','on');
            set(TxtBx6_h,'String','Please Rank The Image or Press Next to Skip')
            
        else if (grNext(loopNext))~=0
                set(TxtBx5_h,'BackgroundColor',[0/255 255/255 0]);
                set(TxtBx5_h,'String','Ranked');
                set(TxtBx6_h,'String','');
            else
                set(TxtBx5_h,'BackgroundColor',[70/255 70/255 70/255]);
                set(TxtBx5_h,'String','');
                set(TxtBx6_h,'String','');
            end
        end
    end
end

% increment the loop index:
FlagImagine = getappdata(Fig_h, 'ImagineFlag');
if FlagImagine(1,1) ~=0
    delete(get(get(get(FlagImagine(1,1), 'Parent'),'Parent'),'Parent'))
end
setappdata(Fig_h, 'loopIndex', 1+getappdata(Fig_h, 'loopIndex'));
setappdata(Fig_h, 'ImagineFlag', 0)

if ~FlagNext
uiresume(Fig_h);
end

