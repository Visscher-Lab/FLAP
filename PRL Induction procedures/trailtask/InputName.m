function name=InputName(Text)
%[name] = InputName
%
%This function opens a dialog box that asks the user to enter three
%initials.  It returns the initials in a string variable.  This is a better
%method than Matlab's default 'inputdlg' function.  This function allows
%either a button click or the ENTER key to accept new values, and has
%larger, more legible text.
%Wants Text to be a string such as "Subject" or "Session", etc

screendims=get(0,'ScreenSize'); %gets the screen width and height
ww=300; %window width
wh=150; %window height
wpos=[(screendims(3)-ww)/2 (screendims(4)-wh)/2 ww wh]; %centers window on screen
f=figure('Position',wpos,'Resize','off','WindowStyle','modal','Color',[.8 .8 .8],'Units','pixels','Menubar','none','Name','Name','NumberTitle','off'); %Open a new window to hold controls
    initText=uicontrol(f,'BackgroundColor',[.8 .8 .8],'Style','text','String',['Enter ' Text ' #:'],'FontSize',14,'Position',[(ww-150)/2 (wh-55)/2+40 150 15]); %instructions
    initials=uicontrol(f,'BackgroundColor',[.8 .8 .8],'Style','edit','String','1','FontSize',14,'Position',[(ww-150)/2 (wh-55)/2 150 40],'Callback',{@grabInits}); %text field
    goButton=uicontrol(f,'Style','pushbutton','String','OK','FontSize',14,'Position',[(ww-75)/2 (wh-55)/2-40 75 30],'Callback',{@grabInits}); %OK button
    
    uiwait; %pauses program until new initials are entered
    
    %The two lines below will not run until the OK button is clicked or the
    %ENTER key is pressed in the text box.
    name=get(initials,'String'); %Pulls the initials from the current 'String' of the 'initials' box.
    close(f); %closes the window

function grabInits(hObject, eventdata)
    uiresume; %resumes the program after new initials are entered
end

end    

    




