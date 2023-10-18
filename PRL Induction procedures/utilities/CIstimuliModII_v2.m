%jittering location of the target within the patch of distractors

if jitterCI==1
    jitterxci(trial)= possibleoffset(randi(length(possibleoffset))); % -1,0 and 1 are the possible offsets
    jitteryci(trial)= possibleoffset(randi(length(possibleoffset)));
    
elseif jitterCI==0
    jitterxci(trial)=0;
    jitteryci(trial)=0;
end

% here I define the shapes
if site == 5 || site==6  || site==7 %PD added site 6 and 7 here 8/17/23
    newTargy=Targy{shapesoftheDay(mixtr(trial,3))}+jitteryci(trial);
    newTargx=Targx{shapesoftheDay(mixtr(trial,3))}+jitterxci(trial);
else
    newTargy=Targy{shapesoftheDay(mixtr(trial,1))}+jitteryci(trial);
    newTargx=Targx{shapesoftheDay(mixtr(trial,1))}+jitterxci(trial);
end

targetcord =newTargy(theans(trial),:)+yTrans  + (newTargx(theans(trial),:)+xTrans - 1)*ymax;
% 'other shape' needed for the scanner task
if exist('theothershape')==1
 targetcord2 =newTargy(theothershape(trial),:)+yTrans  + (newTargx(theothershape(trial),:)+xTrans - 1)*ymax;
end
xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
% for the other shape in scanner task -------------------------------------
xJitLocothershape=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLocothershape=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
% -------------------------------------------------------------------------
xModLoc=zeros(1,length(eccentricity_XCI));
yModLoc=zeros(1,length(eccentricity_XCI));


xJitLoc(xJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLoc(xJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;

% for the other shape in scanner task -------------------------------------
xJitLocothershape(xJitLocothershape>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLocothershape(xJitLocothershape< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLocothershape(yJitLocothershape>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLocothershape(yJitLocothershape< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
% -------------------------------------------------------------------------
%sum(replacementcounterx~=99)

%xJitLoc(targetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/coeffCI;%+xJitLoc(targetcord);
%yJitLoc(targetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/coeffCI;%+xJitLoc(targetcord);
if site == 5 || site==6 || site==7%PD added site ==6 here 8/18/23
    xJitLoc(targetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,3))}(theans(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);
    yJitLoc(targetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,3))}(theans(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);
    xJitLocothershape(targetcord2)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,3))}(theothershape(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);
    yJitLocothershape(targetcord2)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,3))}(theothershape(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);    
else
    xJitLoc(targetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);
    yJitLoc(targetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);
end
theori=180*rand(1,length(eccentricity_XCI));
theori2= 180*rand(1,length(eccentricity_YCI)); %180*rand(1,length(eccentricity_XCI));
if site == 5 || site==6 || site==7%PD added site 6 here 8/17/23
    theori(targetcord)=Targori{shapesoftheDay(mixtr(trial,3))}(theans(trial),:) +Orijit;
else
    theori(targetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(theans(trial),:) +Orijit;
end
if exist('theothershape')==1
    if site == 5 || site==6 || site==7%PD added site 6 here 8/17/23
        theori2(targetcord2)=Targori{shapesoftheDay(mixtr(trial,3))}(theothershape(trial),:) +Orijit;
    else
        theori2(targetcord2)=Targori{shapesoftheDay(mixtr(trial,1))}(theothershape(trial),:) +Orijit;
    end
end
% if demo==1
%     theori(targetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(theans(trial),:);
% end


%this is for the instructions

examplenewTargy=Targy{shapesoftheDay(mixtr(trial,1))};
examplenewTargx=Targx{shapesoftheDay(mixtr(trial,1))};

exampletargetcord =examplenewTargy(1,:)+yTrans  + (examplenewTargx(1,:)+xTrans - 1)*ymax;
exampletargetcord2 =examplenewTargy(2,:)+yTrans  + (examplenewTargx(2,:)+xTrans - 1)*ymax;

clear newyJitLoc newxJitLoc

exampleyJitLoc=yJitLoc;
examplexJitLoc=xJitLoc;

examplexJitLoc(examplexJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
examplexJitLoc(examplexJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
exampleyJitLoc(exampleyJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
exampleyJitLoc(exampleyJitLoc< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;

exampleyJitLoc2=yJitLoc;
examplexJitLoc2=xJitLoc;

examplexJitLoc2(examplexJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
examplexJitLoc2(examplexJitLoc2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
exampleyJitLoc2(exampleyJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
exampleyJitLoc2(exampleyJitLoc2< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;

examplexJitLoc(exampletargetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(1,:))/ecccoeffCI;%+xJitLoc(targetcord);
exampleyJitLoc(exampletargetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(1,:))/ecccoeffCI;%+xJitLoc(targetcord);
examplexJitLoc2(exampletargetcord2)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(2,:))/ecccoeffCI;%+xJitLoc(targetcord);
exampleyJitLoc2(exampletargetcord2)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(2,:))/ecccoeffCI;%+xJitLoc(targetcord);

exampletheori=180*rand(1,length(eccentricity_XCI));
exampletheori2=180*rand(1,length(eccentricity_YCI));

exampletheori(exampletargetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(1,:);
exampletheori2(exampletargetcord2)=Targori{shapesoftheDay(mixtr(trial,1))}(2,:);
