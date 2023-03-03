%jittering location of the target within the patch of distractors

if jitterCI==1
    jitterxci(trial)=possibleoffset(randi(length(possibleoffset))); % -1,0 and 1 are the possible offsets
    jitteryci(trial)=possibleoffset(randi(length(possibleoffset)));
    
elseif jitterCI==0
    jitterxci(trial)=0;
    jitteryci(trial)=0;
end

% here I define the shapes

newTargy=Targy{shapesoftheDay(mixtr(trial,1))}+jitteryci(trial);
newTargx=Targx{shapesoftheDay(mixtr(trial,1))}+jitterxci(trial);

targetcord =newTargy(theans(trial),:)+yTrans  + (newTargx(theans(trial),:)+xTrans - 1)*ymax;

xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;

xModLoc=zeros(1,length(eccentricity_XCI));
yModLoc=zeros(1,length(eccentricity_XCI));
% 


xJitLoc(xJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLoc(xJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
%sum(replacementcounterx~=99)

%xJitLoc(targetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/coeffCI;%+xJitLoc(targetcord);
%yJitLoc(targetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/coeffCI;%+xJitLoc(targetcord);
xJitLoc(targetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);
yJitLoc(targetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/ecccoeffCI;%+xJitLoc(targetcord);
theori=180*rand(1,length(eccentricity_XCI));

theori(targetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(theans(trial),:) +Orijit;

if demo==1
    theori(targetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(theans(trial),:);
end


%this is for the instructions

examplenewTargy=Targy{shapesoftheDay(mixtr(trial,1))};
examplenewTargx=Targx{shapesoftheDay(mixtr(trial,1))};

exampletargetcord =examplenewTargy(1,:)+yTrans  + (examplenewTargx(1,:)+xTrans - 1)*ymax;
exampletargetcord2 =examplenewTargy(2,:)+yTrans  + (examplenewTargx(2,:)+xTrans - 1)*ymax;



exampleyJitLoc=yJitLoc;
examplexJitLoc=xJitLoc;

clear newyJitLoc newxJitLoc


exampleyJitLoc2=yJitLoc;
examplexJitLoc2=xJitLoc;


examplexJitLoc(examplexJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
examplexJitLoc(examplexJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
exampleyJitLoc(exampleyJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
exampleyJitLoc(exampleyJitLoc< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;

examplexJitLoc2(examplexJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
examplexJitLoc2(examplexJitLoc2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
exampleyJitLoc2(exampleyJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
exampleyJitLoc2(exampleyJitLoc2< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;

examplexJitLoc(exampletargetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(1,:))/coeffCI;%+xJitLoc(targetcord);
exampleyJitLoc(exampletargetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(1,:))/coeffCI;%+xJitLoc(targetcord);
examplexJitLoc2(exampletargetcord2)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(2,:))/coeffCI;%+xJitLoc(targetcord);
exampleyJitLoc2(exampletargetcord2)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(2,:))/coeffCI;%+xJitLoc(targetcord);

exampletheori=180*rand(1,length(eccentricity_XCI));
exampletheori2=exampletheori;

exampletheori(exampletargetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(1,:);
exampletheori2(exampletargetcord2)=Targori{shapesoftheDay(mixtr(trial,1))}(2,:);
