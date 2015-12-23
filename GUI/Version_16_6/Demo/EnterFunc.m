function EnterFunc(hObject, evt, BtnGrp_h,TxtBx5_h)
    
  
    Fig_h = ancestor(hObject, 'figure');
    set(BtnGrp_h,'BackgroundColor',[70/255 70/255 70/255])
    Flag = getappdata(Fig_h, 'NextFlag');

     switch get(get(BtnGrp_h,'SelectedObject'),'Tag')
            case '1',  group = 1; Flag =1;
            case '2',  group = 2; Flag =1;
            case '3',  group = 3; Flag =1;
            case '4',  group = 4; Flag =1;
            case '5',  group = 5; Flag =1;
            otherwise, group = 0; Flag =0;
     end

    setappdata(Fig_h, 'group', group)
    setappdata(Fig_h, 'NextFlag', Flag)
    
    set(TxtBx5_h,'BackgroundColor',[0/255 255/255 0])
    set(TxtBx5_h,'String','Ranked')
    uiresume(Fig_h);


    
    
