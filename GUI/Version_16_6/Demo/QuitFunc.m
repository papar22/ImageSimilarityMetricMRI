function QuitFunc(hObject, evt)

Fig_imagine = findobj('type','figure','-regexp','name','IMAGINE 1.4 \w* Edition');
if(length(Fig_imagine) > 1)
    Fig_imagine = max(Fig_imagine);
end
close(Fig_imagine);

Fig_h = ancestor(hObject, 'figure');
close(Fig_h);

close all;
    
