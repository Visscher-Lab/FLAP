%Orijit=0;
%jittering location of the target within the patch of distractors

% jitterxci=possibleoffset(randi(length(possibleoffset)));
% jitteryci=possibleoffset(randi(length(possibleoffset)));
%jitterxci=0;jitteryci=0;
% here I define the shapes
%% egg stimulus
ecccoeffCI_example=3;
eccentricity_XCI_example=xlocsCI*pix_deg/ecccoeffCI_example; %for the instruction slide
eccentricity_YCI_example=ylocsCI*pix_deg/ecccoeffCI_example;
coeffCI_example=ecccoeffCI_example/2;%for the instruction slide
xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
% xJitLoc2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
% yJitLoc2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;

%% 6/9 stimulus
% newTargynum=Targynum+jitteryci;
% newTargxnum=Targxnum+jitterxci;
% xJitLocnum=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
% yJitLocnum=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
% xJitLocnum2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
% yJitLocnum2=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
% %% both egg and 6/9 stimulus
% if stimulusdirection_rightstim==1 % nine is shown in right side or egg points left in the right side
%     targetcord =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
%     targetcordnum=newTargynum(1,:)+yTrans  + (newTargxnum(1,:)+xTrans - 1)*ymax;
% else %six is shown in the right side or egg points right in the right side
%     targetcord =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
%     targetcordnum =newTargynum(2,:)+yTrans  + (newTargxnum(2,:)+xTrans - 1)*ymax;
% end
% if stimulusdirection_leftstim==1 % nine is shown in left side or egg points left in the left side
%     targetcord2 =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
%     targetcordnum2 =newTargynum(1,:)+yTrans  + (newTargxnum(1,:)+xTrans - 1)*ymax;
% else %six is shown in the left side or egg points right in the left side
%     targetcord2 =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
%     targetcordnum2 =newTargynum(2,:)+yTrans  + (newTargxnum(2,:)+xTrans - 1)*ymax;
% end
% 
% xModLoc=zeros(1,length(eccentricity_XCI));
% yModLoc=zeros(1,length(eccentricity_XCI));
%% egg stimulus
% here I adjust the offset of distractors to avoid cluttering the CI shape
%Egg stimulus
% for i=1:length(xJitLoc)
%     if sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)= abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc(i);
%         newyJitLoc(i)=yJitLoc(i);
% 
%         replacementcounterx(i)=99;
%     end
% end

%yJitLoc=newyJitLoc;%Marcello commented out
%xJitLoc=newxJitLoc;
%clear newyJitLoc newxJitLoc;

% for i=1:length(xJitLoc2)
%     if sum((xlocsCI(i)-xlocsCI(targetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc2(i))*5;
%         newyJitLoc(i)=abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc2(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc2(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc2(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc2(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc2(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc2(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc2(i))*5;
%         newyJitLoc(i)= abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc2(i);
%         newyJitLoc(i)=yJitLoc2(i);
% 
%         replacementcounterx(i)=99;
%     end
% end

%yJitLoc2=newyJitLoc; %Marcello commented out
%xJitLoc2=newxJitLoc;

%clear newyJitLoc newxJitLoc
xJitLoc(xJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
xJitLoc(xJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
yJitLoc(yJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
%sum(replacementcounterx~=99)
% xJitLoc2(xJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
% xJitLoc2(xJitLoc2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
% yJitLoc2(yJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
% yJitLoc2(yJitLoc2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;

% if stimulusdirection_rightstim==1 % egg points left on the right side
%     xJitLoc(targetcord)=pix_deg*(offsetx(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI xJitLoc(targetcord)=pix_deg*(offsetx(1,:))/ecccoeffCI;
%     yJitLoc(targetcord)=pix_deg*(offsety(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI yJitLoc(targetcord)=pix_deg*(offsety(1,:))/ecccoeffCI;
%     theori=180*rand(1,length(eccentricity_XCI));
%     theori(targetcord)=Targori(1,:)+Orijit;
% else %egg points right on the right side
%     xJitLoc(targetcord)=pix_deg*(offsetx(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI xJitLoc(targetcord)=pix_deg*(offsetx(2,:))/ecccoeffCI;
%     yJitLoc(targetcord)=pix_deg*(offsety(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI  yJitLoc(targetcord)=pix_deg*(offsety(2,:))/ecccoeffCI;
%     theori=180*rand(1,length(eccentricity_XCI));
%     theori(targetcord)=Targori(2,:)+Orijit;
% end
% if stimulusdirection_leftstim==1 % eggs points left on the left side
%     xJitLoc2(targetcord2)=pix_deg*(offsetx(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI xJitLoc2(targetcord2)=pix_deg*(offsetx(1,:))/ecccoeffCI;
%     yJitLoc2(targetcord2)=pix_deg*(offsety(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI yJitLoc2(targetcord2)=pix_deg*(offsety(1,:))/ecccoeffCI;
%     theori2=180*rand(1,length(eccentricity_XCI));
%     theori2(targetcord2)=Targori(1,:)+Orijit;
% else %eggs points right on the left side
%     xJitLoc2(targetcord2)=pix_deg*(offsetx(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI  xJitLoc2(targetcord2)=pix_deg*(offsetx(2,:))/ecccoeffCI;
%     yJitLoc2(targetcord2)=pix_deg*(offsety(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI yJitLoc2(targetcord2)=pix_deg*(offsety(2,:))/ecccoeffCI;
%     theori2=180*rand(1,length(eccentricity_XCI));
%     theori2(targetcord2)=Targori(2,:)+Orijit;
% end

%% 6/9 stimulus
% for i=1:length(xJitLoc)
%     if sum((xlocsCI(i)-xlocsCI(targetcordnum))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcordnum))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcordnum))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)= abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc(i);
%         newyJitLoc(i)=yJitLoc(i);
% 
%         replacementcounterx(i)=99;
%     end
% end

%yJitLocnum=newyJitLoc; %before marcello changed it
%xJitLocnum=newxJitLoc;
%xJitLocnum=xJitLoc; %marcello prefers
%yJitLocnum=yJitLoc;
%clear newyJitLoc newxJitLoc;

% for i=1:length(xJitLoc2)
%     if sum((xlocsCI(i)-xlocsCI(targetcordnum2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc2(i))*5;
%         newyJitLoc(i)=abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc2(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc2(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc2(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcordnum2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc2(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(targetcordnum2))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcordnum2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc2(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc2(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(targetcordnum2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc2(i))*5;
%         newyJitLoc(i)= abs(yJitLoc2(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc2(i);
%         newyJitLoc(i)=yJitLoc2(i);
% 
%         replacementcounterx(i)=99;
%     end
% end

%yJitLocnum2=newyJitLoc; %before marcello changed it
%xJitLocnum2=newxJitLoc;
%yJitLocnum2=yJitLoc2; %marcello prefers
%xJitLocnum2=xJitLoc2;

%clear newyJitLoc newxJitLoc
% xJitLocnum(xJitLocnum>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
% xJitLocnum(xJitLocnum< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
% yJitLocnum(yJitLocnum>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
% yJitLocnum(yJitLocnum< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
% 
% xJitLocnum2(xJitLocnum2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
% xJitLocnum2(xJitLocnum2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
% yJitLocnum2(yJitLocnum2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
% yJitLocnum2(yJitLocnum2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;

% if stimulusdirection_rightstim_num==1 % 9 is shown on the right side
%     xJitLocnum(targetcordnum)=pix_deg*(offsetxnum(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI xJitLocnum(targetcordnum)=pix_deg*(offsetxnum(1,:))/ecccoeffCI;
%     yJitLocnum(targetcordnum)=pix_deg*(offsetynum(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI yJitLocnum(targetcordnum)=pix_deg*(offsetynum(1,:))/ecccoeffCI;
%     theorinum=180*rand(1,length(eccentricity_XCI));
%     theorinum(targetcordnum)=Targorinum(1,:)+Orijit;
% else %6 is shown on the right side
%     xJitLocnum(targetcordnum)=pix_deg*(offsetxnum(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI
%     yJitLocnum(targetcordnum)=pix_deg*(offsetynum(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI
%     theorinum=180*rand(1,length(eccentricity_XCI));
%     theorinum(targetcordnum)=Targorinum(2,:)+Orijit;
% end
% if stimulusdirection_leftstim_num==1 % 9 is shown on the left side
%     xJitLocnum2(targetcordnum2)=pix_deg*(offsetxnum(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI
%     yJitLocnum2(targetcordnum2)=pix_deg*(offsetynum(1,:))/coeffCI;%I changed coeffCI with ecccoeffCI
%     theorinum2=180*rand(1,length(eccentricity_XCI));
%     theorinum2(targetcordnum2)=Targorinum(1,:)+Orijit;
% else %6 is shown on the left side
%     xJitLocnum2(targetcordnum2)=pix_deg*(offsetxnum(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI
%     yJitLocnum2(targetcordnum2)=pix_deg*(offsetynum(2,:))/coeffCI;%I changed coeffCI with ecccoeffCI
%     theorinum2=180*rand(1,length(eccentricity_XCI));
%     theorinum2(targetcordnum2)=Targorinum(2,:)+Orijit;
% end

%this is for the instructions
% here I adjust the offset of distractors to avoid
% cluttering the CI shape (left stimulus example)
%% instruction page egg stimulus
examplenewTargy=Targy{5};
examplenewTargx=Targx{5};
exampletargetcord =examplenewTargy(1,:)+yTrans  + (examplenewTargx(1,:)+xTrans - 1)*ymax;
exampletargetcord2 =examplenewTargy(2,:)+yTrans  + (examplenewTargx(2,:)+xTrans - 1)*ymax;
% for i=1:length(xJitLoc)
%     if sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)= abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc(i);
%         newyJitLoc(i)=yJitLoc(i);
% 
%         replacementcounterx(i)=99;
%     end
% end

%exampleyJitLoc=newyJitLoc; %before marcello changed it
%examplexJitLoc=newxJitLoc;
exampleyJitLoc=yJitLoc; %marcello prefers
examplexJitLoc=xJitLoc;
%clear newyJitLoc newxJitLoc


% for i=1:length(xJitLoc)
%     if sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)= abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc(i);
%         newyJitLoc(i)=yJitLoc(i);
% 
%         replacementcounterx(i)=99;
%     end
% end

%exampleyJitLoc2=newyJitLoc;% before marcello changed it
%examplexJitLoc2=newxJitLoc;
exampleyJitLoc2=yJitLoc; %marcello prefers
examplexJitLoc2=xJitLoc;
%clear newyJitLoc newxJitLoc

examplexJitLoc(examplexJitLoc>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
examplexJitLoc(examplexJitLoc< - pix_deg/ecccoeffCI_example/3)=-pix_deg/ecccoeffCI_example/3;
exampleyJitLoc(exampleyJitLoc>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
exampleyJitLoc(exampleyJitLoc< - pix_deg/ecccoeffCI_example/3)=- pix_deg/ecccoeffCI_example/3;

examplexJitLoc2(examplexJitLoc2>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
examplexJitLoc2(examplexJitLoc2< - pix_deg/ecccoeffCI_example/3)=-pix_deg/ecccoeffCI_example/3;
exampleyJitLoc2(exampleyJitLoc2>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
exampleyJitLoc2(exampleyJitLoc2< - pix_deg/ecccoeffCI_example/3)=- pix_deg/ecccoeffCI_example/3;

examplexJitLoc(exampletargetcord)=pix_deg*(offsetx{5}(1,:))/coeffCI_example;%+xJitLoc(targetcord);
exampleyJitLoc(exampletargetcord)=pix_deg*(offsety{5}(1,:))/coeffCI_example;%+xJitLoc(targetcord);
examplexJitLoc2(exampletargetcord2)=pix_deg*(offsetx{5}(2,:))/coeffCI_example;%+xJitLoc(targetcord);
exampleyJitLoc2(exampletargetcord2)=pix_deg*(offsety{5}(2,:))/coeffCI_example;%+xJitLoc(targetcord);

exampletheori=180*rand(1,length(eccentricity_XCI_example));
exampletheori2=exampletheori;

exampletheori(exampletargetcord)=Targori{5}(1,:);
exampletheori2(exampletargetcord2)=Targori{5}(2,:);

%% instruction page 6/9
examplenewTargynum=Targy{1};
examplenewTargxnum=Targx{1};


exampletargetcordnum =examplenewTargynum(1,:)+yTrans  + (examplenewTargxnum(1,:)+xTrans - 1)*ymax;
exampletargetcordnum2 =examplenewTargynum(2,:)+yTrans  + (examplenewTargxnum(2,:)+xTrans - 1)*ymax;


% for i=1:length(xJitLoc)
%     if sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)= abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc(i);
%         newyJitLoc(i)=yJitLoc(i);
% 
%         replacementcounterx(i)=99;
%     end
% end

%exampleyJitLocnum=newyJitLoc;%before marcello changed it
%examplexJitLocnum=newxJitLoc;
exampleyJitLocnum=yJitLoc; %marcello prefers
examplexJitLocnum=xJitLoc;
%clear newyJitLoc newxJitLoc


% for i=1:length(xJitLoc)
%     if sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %1 down right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=1;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %2 up left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=2;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %3 up
%         newyJitLoc(i)=abs(yJitLoc(i))*5;
%         replacementcounterx(i)=3;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
%         %4 down
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
%         replacementcounterx(i)=4;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %5 right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         replacementcounterx(i)=5;
% 
%     elseif sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
%         %6 left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         replacementcounterx(i)=6;
% 
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
%         %7 up right
%         newxJitLoc(i)=abs(xJitLoc(i))*5;
%         newyJitLoc(i)=- abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=7;
%     elseif sum((xlocsCI(i)-xlocsCI(exampletargetcordnum2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcordnum2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
%         %8 down left
%         newxJitLoc(i)=- abs(xJitLoc(i))*5;
%         newyJitLoc(i)= abs(yJitLoc(i))*5;
% 
%         replacementcounterx(i)=8;
% 
%     else
%         newxJitLoc(i)=xJitLoc(i);
%         newyJitLoc(i)=yJitLoc(i);
% 
%         replacementcounterx(i)=99;
%     end
% end
%exampleyJitLocnum2=newyJitLoc; %before Marcello changed it
%examplexJitLocnum2=newxJitLoc;

exampleyJitLocnum2=yJitLoc; %marcello prefers
examplexJitLocnum2=xJitLoc;
%clear newyJitLoc newxJitLoc

examplexJitLocnum(examplexJitLocnum>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
examplexJitLocnum(examplexJitLocnum< - pix_deg/ecccoeffCI_example/3)=-pix_deg/ecccoeffCI_example/3;
exampleyJitLocnum(exampleyJitLocnum>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
exampleyJitLocnum(exampleyJitLocnum< - pix_deg/ecccoeffCI_example/3)=- pix_deg/ecccoeffCI_example/3;

examplexJitLocnum2(examplexJitLocnum2>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
examplexJitLocnum2(examplexJitLocnum2< - pix_deg/ecccoeffCI_example/3)=-pix_deg/ecccoeffCI_example/3;
exampleyJitLocnum2(exampleyJitLocnum2>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
exampleyJitLocnum2(exampleyJitLocnum2< - pix_deg/ecccoeffCI_example/3)=- pix_deg/ecccoeffCI_example/3;

examplexJitLocnum(exampletargetcordnum)=pix_deg*(offsetx{1}(1,:))/coeffCI_example;%I changed coeffCI with ecccoeffCI
exampleyJitLocnum(exampletargetcordnum)=pix_deg*(offsety{1}(1,:))/coeffCI_example;%I changed coeffCI with ecccoeffCI
examplexJitLocnum2(exampletargetcordnum2)=pix_deg*(offsetx{1}(2,:))/coeffCI_example;%I changed coeffCI with ecccoeffCI
exampleyJitLocnum2(exampletargetcordnum2)=pix_deg*(offsety{1}(2,:))/coeffCI_example;%I changed coeffCI with ecccoeffCI

exampletheorinum=180*rand(1,length(eccentricity_XCI_example));
exampletheorinum2=exampletheorinum;

exampletheorinum(exampletargetcordnum)=Targori{1}(1,:);
exampletheorinum2(exampletargetcordnum2)=Targori{1}(2,:);
