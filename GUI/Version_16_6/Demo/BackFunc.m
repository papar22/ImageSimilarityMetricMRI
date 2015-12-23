function BackFunc(hObject, evt,BtnGrp_h,EnterBn_h,TxtBx5_h,TxtBx6_h)

Fig_h = ancestor(hObject, 'figure');
countflag = getappdata(Fig_h, 'CountFlag');
countflag = 1;
setappdata(Fig_h, 'CountFlag',countflag);
FlagNext = getappdata(Fig_h, 'NextFlag');

loopBack = getappdata(Fig_h, 'loopIndex')-1;
grBack = getappdata(Fig_h, 'gr');
indexBack = getappdata(Fig_h, 'index');
FlagIterationBack = getappdata(Fig_h, 'FlagIteration');

if FlagIterationBack
    if  loopBack > 0
    if (grBack(indexBack(loopBack)))==0 
        set(TxtBx5_h,'BackgroundColor',[255/255 0/255 0])
        set (TxtBx5_h,'String','UnRanked')
        set(TxtBx6_h,'Visible','on');
    else if (grBack(indexBack(loopBack)))~=0 
            set(TxtBx5_h,'BackgroundColor',[0/255 255/255 0])
            set(TxtBx5_h,'String','Ranked')
            set(TxtBx6_h,'Visible','off');
        else
            set(TxtBx5_h,'BackgroundColor',[70/255 70/255 70/255])
            set(TxtBx5_h,'String','')
            set(TxtBx6_h,'Visible','off');
        end
    end
    end
else
    if  loopBack > 0    
    if (grBack(loopBack))==0 
        set(TxtBx5_h,'BackgroundColor',[255/255 0/255 0])
        set (TxtBx5_h,'String','UnRanked')
        set(TxtBx6_h,'Visible','on');
    else if (grBack(loopBack))~=0 
            set(TxtBx5_h,'BackgroundColor',[0/255 255/255 0])
            set(TxtBx5_h,'String','Ranked')
            set(TxtBx6_h,'Visible','off');
        else
            set(TxtBx5_h,'BackgroundColor',[70/255 70/255 70/255])
            set(TxtBx5_h,'String','')
            set(TxtBx6_h,'Visible','off');
        end
    end
    end
end

% increment the loop index:
FlagImagine = getappdata(Fig_h, 'ImagineFlag');
if FlagImagine(1,1) ~=0
    delete(get(get(get(FlagImagine(1,1), 'Parent'),'Parent'),'Parent'))
end
setappdata(Fig_h, 'loopIndex', getappdata(Fig_h, 'loopIndex')-1);
setappdata(Fig_h, 'ImagineFlag', 0)

if ~FlagNext
uiresume(Fig_h);
end
