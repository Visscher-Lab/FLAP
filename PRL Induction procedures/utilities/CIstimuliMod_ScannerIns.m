Orijit=0;
%jittering location of the target within the patch of distractors

jitterxci=possibleoffset(randi(length(possibleoffset)));
jitteryci=possibleoffset(randi(length(possibleoffset)));
%jitterxci=0;jitteryci=0;
% here I define the shapes
newTargy=Targy+jitteryci;newTargynum=Targynum+jitteryci
newTargx=Targx+jitterxci;newTargxnum=Targxnum+jitterxci;
xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
xJitLoc2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;

if stimulusdirection_rightstim==1 % nine is shown in right side or egg points left in the right side
    targetcord =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
    targetcordnum==newTargynum(1,:)+yTrans  + (newTargxnum(1,:)+xTrans - 1)*ymax;
else %six is shown in the right side or egg points right in the right side
    targetcord =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
    targetcordnum =newTargynum(2,:)+yTrans  + (newTargxnum(2,:)+xTrans - 1)*ymax;
end
if stimulusdirection_leftstim==1 % nine is shown in left side or egg points left in the left side
    targetcord2 =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
    targetcordnum2 =newTargynum(1,:)+yTrans  + (newTargxnum(1,:)+xTrans - 1)*ymax;
else %six is shown in the left side or egg points right in the left side
    targetcord2 =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
    targetcordnum2 =newTargynum(2,:)+yTrans  + (newTargxnum(2,:)+xTrans - 1)*ymax;
end
xModLoc=zeros(1,length(eccentricity_XCI));
yModLoc=zeros(1,length(eccentricity_XCI));

% here I adjust the offset of distractors to avoid cluttering the CI shape
%Egg stimulus
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



yJitLoc=newyJitLoc;
xJitLoc=newxJitLoc;
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

yJitLoc2=newyJitLoc;
xJitLoc2=newxJitLoc;

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
if stimulusdirection_rightstim==1 % egg points left on the right side
    theori(targetcord)=Targori(1,:)+Orijit;
    xJitLoc(targetcord)=pix_deg*(offsetx(1,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc(targetcord)=pix_deg*(offsety(1,:))/coeffCI;%+xJitLoc(targetcord);
else %egg points right on the right side
    theori(targetcord)=Targori(2,:)+Orijit;
    xJitLoc(targetcord)=pix_deg*(offsetx(2,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc(targetcord)=pix_deg*(offsety(2,:))/coeffCI;%+xJitLoc(targetcord);
end
if stimulusdirection_leftstim==1 % eggs points left on the left side
    theori2(targetcord2)=Targori(1,:)+Orijit;
    xJitLoc2(targetcord2)=pix_deg*(offsetx(1,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc2(targetcord2)=pix_deg*(offsety(1,:))/coeffCI;%+xJitLoc(targetcord);
else %eggs points right on the left side
    theori2(targetcord2)=Targori(2,:)+Orijit;
    xJitLoc2(targetcord2)=pix_deg*(offsetx(2,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLoc2(targetcord2)=pix_deg*(offsety(2,:))/coeffCI;%+xJitLoc(targetcord);
end

%6/9 stimulus
for i=1:length(xJitLoc)
    if sum((xlocsCI(i)-xlocsCI(targetcordnum))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %1 down right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=abs(yJitLoc(i))*5;

        replacementcounterx(i)=1;
    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %2 up left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=2;
    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %3 up
        newyJitLoc(i)=abs(yJitLoc(i))*5;
        replacementcounterx(i)=3;

    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %4 down
        newyJitLoc(i)=- abs(yJitLoc(i))*5;
        replacementcounterx(i)=4;

    elseif sum((ylocsCI(i)-ylocsCI(targetcordnum))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %5 right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        replacementcounterx(i)=5;

    elseif sum((ylocsCI(i)-ylocsCI(targetcordnum))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %6 left
        newxJitLoc(i)=- abs(xJitLoc(i))*5;
        replacementcounterx(i)=6;

    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %7 up right
        newxJitLoc(i)=abs(xJitLoc(i))*5;
        newyJitLoc(i)=- abs(yJitLoc(i))*5;

        replacementcounterx(i)=7;
    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
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



yJitLocnum=newyJitLoc;
xJitLocnum=newxJitLoc;
clear newyJitLoc newxJitLoc;

for i=1:length(xJitLoc2)
    if sum((xlocsCI(i)-xlocsCI(targetcordnum2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
        %1 down right
        newxJitLoc(i)=abs(xJitLoc2(i))*5;
        newyJitLoc(i)=abs(yJitLoc2(i))*5;

        replacementcounterx(i)=1;
    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %2 up left
        newxJitLoc(i)=- abs(xJitLoc2(i))*5;
        newyJitLoc(i)=- abs(yJitLoc2(i))*5;

        replacementcounterx(i)=2;
    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %3 up
        newyJitLoc(i)=abs(yJitLoc2(i))*5;
        replacementcounterx(i)=3;

    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
        %4 down
        newyJitLoc(i)=- abs(yJitLoc2(i))*5;
        replacementcounterx(i)=4;

    elseif sum((ylocsCI(i)-ylocsCI(targetcordnum2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %5 right
        newxJitLoc(i)=abs(xJitLoc2(i))*5;
        replacementcounterx(i)=5;

    elseif sum((ylocsCI(i)-ylocsCI(targetcordnum2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
        %6 left
        newxJitLoc(i)=- abs(xJitLoc2(i))*5;
        replacementcounterx(i)=6;

    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
        %7 up right
        newxJitLoc(i)=abs(xJitLoc2(i))*5;
        newyJitLoc(i)=- abs(yJitLoc2(i))*5;

        replacementcounterx(i)=7;
    elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
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

yJitLocnum2=newyJitLoc;
xJitLocnum2=newxJitLoc;

xJitLocnum(xJitLocnum>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLocnum(xJitLocnum< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLocnum(yJitLocnum>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLocnum(yJitLocnum< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
%sum(replacementcounterx~=99)
xJitLocnum2(xJitLocnum2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLocnum2(xJitLocnum2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLocnum2(yJitLocnum2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLocnum2(yJitLocnum2< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
theorinum=180*rand(1,length(eccentricity_XCI));
theorinum2=theorinum;
if stimulusdirection_rightstim_num==1 % 9 is shown on the right side
    theorinum(targetcordnum)=Targorinum(1,:)+Orijit;
    xJitLocnum(targetcordnum)=pix_deg*(offsetxnum(1,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLocnum(targetcordnum)=pix_deg*(offsetynum(1,:))/coeffCI;%+xJitLoc(targetcord);
else %6 is shown on the right side
    theorinum(targetcord)=Targorinum(2,:)+Orijit;
    xJitLocnum(targetcordnum)=pix_deg*(offsetxnum(2,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLocnum(targetcordnum)=pix_deg*(offsetynum(2,:))/coeffCI;%+xJitLoc(targetcord);
end
if stimulusdirection_leftstim_num==1 % 9 is shown on the left side
    theorinum2(targetcordnum2)=Targorinum(1,:)+Orijit;
    xJitLocnum2(targetcordnum2)=pix_deg*(offsetxnum(1,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLocnum2(targetcordnum2)=pix_deg*(offsetynum(1,:))/coeffCI;%+xJitLoc(targetcord);
else %6 is shown on the left side
    theorinum2(targetcordnum2)=Targorinum(2,:)+Orijit;
    xJitLocnum2(targetcordnum2)=pix_deg*(offsetxnum(2,:))/coeffCI;%+xJitLoc(targetcord);
    yJitLocnum2(targetcordnum2)=pix_deg*(offsetynum(2,:))/coeffCI;%+xJitLoc(targetcord);
end

%this is for the instructions

examplenewTargy=Targy;examplenewTargynum=Targynum;
examplenewTargx=Targx;examplenewTargxnum=Targxnum;

exampletargetcord =examplenewTargy(1,:)+yTrans  + (examplenewTargx(1,:)+xTrans - 1)*ymax;
exampletargetcord2 =examplenewTargy(2,:)+yTrans  + (examplenewTargx(2,:)+xTrans - 1)*ymax;
exampletargetcordnum =examplenewTargynum(1,:)+yTrans  + (examplenewTargxnum(1,:)+xTrans - 1)*ymax;
exampletargetcordnum2 =examplenewTargynum(2,:)+yTrans  + (examplenewTargxnum(2,:)+xTrans - 1)*ymax;


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

exampleyJitLoc=newyJitLoc;
examplexJitLoc=newxJitLoc;

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


exampleyJitLoc2=newyJitLoc;
examplexJitLoc2=newxJitLoc;


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

