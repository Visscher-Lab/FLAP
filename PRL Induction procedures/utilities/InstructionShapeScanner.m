CIstimuliMod_Scanner
Screen('FillRect', w, gray);

DrawFormattedText(w, 'Before each trial, an auditory cue will indicate the location of the stimulus to attend (right or left) \n \n Please look at the center of the screen during the experiment\n \n Use your left index finger for the left oriented stimulus \n Right index finger for the right oriented stimulus \n \n','center', 600, white');
DrawFormattedText(w, 'Left',300, 450, white');
DrawFormattedText(w, 'Right',1280, 450, white');
ecccoeffCI_example=2%3;
eccentricity_XCI_example=xlocsCI*pix_deg/ecccoeffCI_example; %for the instruction slide
eccentricity_YCI_example=ylocsCI*pix_deg/ecccoeffCI_example;
coeffCI_example=ecccoeffCI_example/2;%for the instruction slide
xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
gaborcontrast=0.5;
possibleTRLlocations=[-7.5 7.5]; % possible TRL location with respect to the center of the screen in degrees of visual angle
PRLecc=[possibleTRLlocations(1) 0 ]; %eccentricity of PRL in deg
PRLx= PRLecc(1);
PRLy=-PRLecc(2);
theeccentricity_Y=0;
theeccentricity_X=-7.5*pix_deg;
%eggs--------------------
% imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
%     imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
% imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
%     imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
% imageRect_offsCI2instr=imageRect_offsCIinstr;
% imageRect_offsCI2instr2=imageRect_offsCIinstr2;
imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI_example'-800, imageRectSmall(2)+eccentricity_YCI_example'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI_example'-800, imageRectSmall(4)+eccentricity_YCI_example'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCIinstr2=[imageRectSmall(1)+eccentricity_XCI_example'+200, imageRectSmall(2)+eccentricity_YCI_example'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI_example'+200, imageRectSmall(4)+eccentricity_YCI_example'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCI2instr=imageRect_offsCIinstr;
imageRect_offsCI2instr2=imageRect_offsCIinstr2;
%6/9--------------------
% imageRect_offsCIinstrnum =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI',...
%     imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI']; % defining the rect of the shape or image for one of the two sub images
% imageRect_offsCIinstr2num=[imageRectSmall(1)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(2)+eccentricity_YCI',...
%     imageRectSmall(3)+eccentricity_XCI'-theeccentricity_X, imageRectSmall(4)+eccentricity_YCI']; % defining the rect of the shape or image for one of the two sub images
% imageRect_offsCI2instrnum=imageRect_offsCIinstrnum;
% imageRect_offsCI2instr2num=imageRect_offsCIinstr2num;
imageRect_offsCIinstrnum =[imageRectSmall(1)+eccentricity_XCI_example'-470, imageRectSmall(2)+eccentricity_YCI_example'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI_example'-470, imageRectSmall(4)+eccentricity_YCI_example'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCIinstr2num=[imageRectSmall(1)+eccentricity_XCI_example'+530, imageRectSmall(2)+eccentricity_YCI_example'+theeccentricity_X,...
    imageRectSmall(3)+eccentricity_XCI_example'+530, imageRectSmall(4)+eccentricity_YCI_example'+theeccentricity_X]; % defining the rect of the shape or image for one of the two sub images
imageRect_offsCI2instrnum=imageRect_offsCIinstrnum;
imageRect_offsCI2instr2num=imageRect_offsCIinstr2num;

% gabor-----------------------------
% imageRect_offsleft =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y+theeccentricity_X,...
%   imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y+theeccentricity_X];
% imageRect_offsright =[imageRect(1)-theeccentricity_X, imageRect(2)+theeccentricity_Y+theeccentricity_X,...
%   imageRect(3)-theeccentricity_X, imageRect(4)+theeccentricity_Y+theeccentricity_X];
 imageRect_offsleft =[imageRect(1)-220, imageRect(2)+theeccentricity_Y+theeccentricity_X,...
     imageRect(3)-220, imageRect(4)+theeccentricity_Y+theeccentricity_X];
 imageRect_offsright =[imageRect(1)+780, imageRect(2)+theeccentricity_Y+theeccentricity_X,...
     imageRect(3)+780, imageRect(4)+theeccentricity_Y+theeccentricity_X];
%eggs-------------------------------

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], Dcontr ); %Dcontr = contrast of the gabors
%here I draw the target contour (9) and other sub types (left egg, left
%diag, 2)
imageRect_offsCI2instr(setdiff(1:length(imageRect_offsCIinstr),exampletargetcord),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr' + [examplexJitLoc; exampleyJitLoc; examplexJitLoc; exampleyJitLoc], exampletheori,[], 0.88);


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2' + [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], Dcontr );
%here I draw the target contour (6) and other sub types (rught diag, right
%egg, 5...)
imageRect_offsCI2instr2(setdiff(1:length(imageRect_offsCIinstr2),exampletargetcord2),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2'+ [examplexJitLoc2; exampleyJitLoc2; examplexJitLoc2; exampleyJitLoc2], exampletheori2,[], 0.88);
% %6/9------------------------------------
Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstrnum' + [examplexJitLocnum; exampleyJitLocnum; examplexJitLocnum; exampleyJitLocnum], exampletheorinum,[], Dcontr ); %Dcontr = contrast of the gabors
%here I draw the target contour (9) and other sub types (left egg, left
%diag, 2)
imageRect_offsCI2instrnum(setdiff(1:length(imageRect_offsCIinstrnum),exampletargetcordnum),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instrnum' + [examplexJitLocnum; exampleyJitLocnum; examplexJitLocnum; exampleyJitLocnum], exampletheorinum,[], 0.88);


Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIinstr2num' + [examplexJitLocnum2; exampleyJitLocnum2; examplexJitLocnum2; exampleyJitLocnum2], exampletheorinum2,[], Dcontr );
%here I draw the target contour (6) and other sub types (rught diag, right
%egg, 5...)
imageRect_offsCI2instr2num(setdiff(1:length(imageRect_offsCIinstr2num),exampletargetcordnum2),:)=0;

Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2instr2num'+ [examplexJitLocnum2; exampleyJitLocnum2; examplexJitLocnum2; exampleyJitLocnum2], exampletheorinum2,[], 0.88);
% % gabor------------------------------------
Screen('DrawTexture', w, texture, [], imageRect_offsleft, theoris(1),[], gaborcontrast);
Screen('DrawTexture', w, texture, [], imageRect_offsright, theoris(2),[], gaborcontrast);
FirstInstructionOnsetTime=Screen('Flip', w);
% %WaitSecs(0.5);

%%
