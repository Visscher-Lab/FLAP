Orijit=0;
%jittering location of the target within the patch of distractors

jitterxci=possibleoffset(randi(length(possibleoffset)));
jitteryci=possibleoffset(randi(length(possibleoffset)));
%jitterxci=0;jitteryci=0;
% here I define the shapes
newTargy=Targy+jitteryci;
newTargx=Targx+jitterxci;
xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
xJitLoc2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;

if stimulusdirection_rightstim==1 % nine is shown in right side
    targetcord =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
else %six is shown in the right side
    targetcord =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
end
if stimulusdirection_leftstim==1 % nine is shown in left side
    targetcord2 =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
else %six is shown in the left side
    targetcord2 =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
end
xModLoc=zeros(1,length(eccentricity_XCI));
yModLoc=zeros(1,length(eccentricity_XCI));

% here I adjust the offset of distractors to avoid cluttering the CI shape

for i=1:length(xJitLoc)
    if sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %1 down right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=abs(yJitLoc(i))*5;

        replacementcounterx(i)=1;
    elseif sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %2 up left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=2;
    elseif sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %3 up
        newyJitLoc(i)=abs(yJitLoc(i))*5;
        replacementcounterx(i)=3;

    elseif sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %4 down
        newyJitLoc(i)=- abs(yJitLoc(i))*5;
        replacementcounterx(i)=4;

    elseif sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %5 right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        replacementcounterx(i)=5;

    elseif sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %6 left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        replacementcounterx(i)=6;

    elseif sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %7 up right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=7;
    elseif sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %8 down left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        newyJitLoc(i)= abs(yJitLoc(i))*5;

        replacementcounterx(i)=8;

    else
        newxJitLoc(i)=xJitLoc(i);
        newyJitLoc(i)=yJitLoc(i);

        replacementcounterx(i)=99;
    end
end



%yJitLoc=newyJitLoc;
%xJitLoc=newxJitLoc;
clear newyJitLoc newxJitLoc;

for i=1:length(xJitLoc2)
    if sum((xlocsCI(i)-xlocsCI(targetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %1 down right
        newxJitLoc(i)=abs(xJitLoc2(i))*5;
        newyJitLoc(i)=abs(yJitLoc2(i))*5;

        replacementcounterx(i)=1;
    elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %2 up left
        newxJitLoc(i)=- abs(xJitLoc2(i))*5;
        newyJitLoc(i)=- abs(yJitLoc2(i))*5;

        replacementcounterx(i)=2;
    elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %3 up
        newyJitLoc(i)=abs(yJitLoc2(i))*5;
        replacementcounterx(i)=3;

    elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %4 down
        newyJitLoc(i)=- abs(yJitLoc2(i))*5;
        replacementcounterx(i)=4;

    elseif sum((ylocsCI(i)-ylocsCI(targetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %5 right
        newxJitLoc(i)=abs(xJitLoc2(i))*5;
        replacementcounterx(i)=5;

    elseif sum((ylocsCI(i)-ylocsCI(targetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %6 left
        newxJitLoc(i)=- abs(xJitLoc2(i))*5;
        replacementcounterx(i)=6;

    elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %7 up right
        newxJitLoc(i)=abs(xJitLoc2(i))*5;
        newyJitLoc(i)=- abs(yJitLoc2(i))*5;

        replacementcounterx(i)=7;
    elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %8 down left
        newxJitLoc(i)=- abs(xJitLoc2(i))*5;
        newyJitLoc(i)= abs(yJitLoc2(i))*5;

        replacementcounterx(i)=8;

    else
        newxJitLoc(i)=xJitLoc2(i);
        newyJitLoc(i)=yJitLoc2(i);

        replacementcounterx(i)=99;
    end
end

%yJitLoc2=newyJitLoc;
%xJitLoc2=newxJitLoc;

xJitLoc(xJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLoc(xJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
%sum(replacementcounterx~=99)
xJitLoc2(xJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLoc2(xJitLoc2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLoc2(yJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLoc2(yJitLoc2< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
theori=180*rand(1,length(eccentricity_XCI));
theori2=theori;
if stimulusdirection_rightstim==1 % nine is shown in right side
    theori(targetcord)=Targori(1,:)+Orijit;
    xJitLoc(targetcord)=pix_deg*(offsetx(1,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc(targetcord)=pix_deg*(offsety(1,:))/coeffCI;%+xJitLoc(targetcord);
else %six is shown in the right side
    theori(targetcord)=Targori(2,:)+Orijit;
    xJitLoc(targetcord)=pix_deg*(offsetx(2,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc(targetcord)=pix_deg*(offsety(2,:))/coeffCI;%+xJitLoc(targetcord);
end
if stimulusdirection_leftstim==1 % nine is shown in left side
    theori2(targetcord2)=Targori(1,:)+Orijit;
    xJitLoc2(targetcord2)=pix_deg*(offsetx(1,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc2(targetcord2)=pix_deg*(offsety(1,:))/coeffCI;%+xJitLoc(targetcord);
else %six is shown in the left side
    theori2(targetcord2)=Targori(2,:)+Orijit;
    xJitLoc2(targetcord2)=pix_deg*(offsetx(2,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc2(targetcord2)=pix_deg*(offsety(2,:))/coeffCI;%+xJitLoc(targetcord);
end



%this is for the instructions

examplenewTargy=Targy;
examplenewTargx=Targx;

exampletargetcord =examplenewTargy(1,:)+yTrans  + (examplenewTargx(1,:)+xTrans - 1)*ymax;
exampletargetcord2 =examplenewTargy(2,:)+yTrans  + (examplenewTargx(2,:)+xTrans - 1)*ymax;



% here I adjust the offset of distractors to avoid
% cluttering the CI shape (left stimulus example)

for i=1:length(xJitLoc)
    if sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %1 down right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=abs(yJitLoc(i))*5;

        replacementcounterx(i)=1;
    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %2 up left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=2;
    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %3 up
        newyJitLoc(i)=abs(yJitLoc(i))*5;
        replacementcounterx(i)=3;

    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %4 down
        newyJitLoc(i)=- abs(yJitLoc(i))*5;
        replacementcounterx(i)=4;

    elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %5 right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        replacementcounterx(i)=5;

    elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %6 left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        replacementcounterx(i)=6;

    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %7 up right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=7;
    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %8 down left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        newyJitLoc(i)= abs(yJitLoc(i))*5;

        replacementcounterx(i)=8;

    else
        newxJitLoc(i)=xJitLoc(i);
        newyJitLoc(i)=yJitLoc(i);

        replacementcounterx(i)=99;
    end
end

exampleyJitLoc=yJitLoc;
examplexJitLoc=xJitLoc;

clear newyJitLoc newxJitLoc


for i=1:length(xJitLoc)
    if sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %1 down right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=abs(yJitLoc(i))*5;

        replacementcounterx(i)=1;
    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %2 up left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=2;
    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %3 up
        newyJitLoc(i)=abs(yJitLoc(i))*5;
        replacementcounterx(i)=3;

    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %4 down
        newyJitLoc(i)=- abs(yJitLoc(i))*5;
        replacementcounterx(i)=4;

    elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %5 right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        replacementcounterx(i)=5;

    elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %6 left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        replacementcounterx(i)=6;

    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %7 up right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=7;
    elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %8 down left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        newyJitLoc(i)= abs(yJitLoc(i))*5;

        replacementcounterx(i)=8;

    else
        newxJitLoc(i)=xJitLoc(i);
        newyJitLoc(i)=yJitLoc(i);

        replacementcounterx(i)=99;
    end
end


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

examplexJitLoc(exampletargetcord)=pix_deg*(offsetx(1,:))/coeffCI;%+xJitLoc(targetcord);
exampleyJitLoc(exampletargetcord)=pix_deg*(offsety(1,:))/coeffCI;%+xJitLoc(targetcord);
examplexJitLoc2(exampletargetcord2)=pix_deg*(offsetx(2,:))/coeffCI;%+xJitLoc(targetcord);
exampleyJitLoc2(exampletargetcord2)=pix_deg*(offsety(2,:))/coeffCI;%+xJitLoc(targetcord);

exampletheori=180*rand(1,length(eccentricity_XCI));
exampletheori2=exampletheori;

exampletheori(exampletargetcord)=Targori(1,:);
exampletheori2(exampletargetcord2)=Targori(2,:);

