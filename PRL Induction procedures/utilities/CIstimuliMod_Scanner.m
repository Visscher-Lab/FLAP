
% here I define the shapes
 orifooexample=    [35+180 0+180 -35+180 50+180 -45+180 55+180 -55+180 65+180 -70+180 90+180 90 -55 55 -30 0 35];
 twoorifooexample= [-35 0 35 -50 45 -55 55 -65 70 90+180 90 55+180 -55+180 30+180 0+180 -35+180];
 Xoffexample=[-0.2 -0.01 -0.2 -0.1 -0.05 -0.01 0.02 0 0.03 0 0 -0.06 0 0.1 0.01 0.15];
 Yoffexample= [-0.2 -0.03 0.02 0.15 -0.25 -0.2 0.15 -0.05 -0.01 0 0 -0.1 0.09 0.02 0.01 -0.07];
Targorinew{7}=[orifooexample;twoorifooexample];

offsetxnew{7}= [-Xoffexample; Xoffexample];
offsetynew{7}=[-Yoffexample; -Yoffexample];
clear Xoffexample Yoffexample orifooexample
%% egg stimulus
ecccoeffCI_example=3;
eccentricity_XCI_example=xlocsCI*pix_deg/ecccoeffCI_example; %for the instruction slide
eccentricity_YCI_example=ylocsCI*pix_deg/ecccoeffCI_example;
coeffCI_example=ecccoeffCI_example/2;%for the instruction slide
xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;


%% instruction page egg stimulus
examplenewTargy=Targy{7};
examplenewTargx=Targx{7};
exampletargetcord =examplenewTargy(1,:)+yTrans  + (examplenewTargx(1,:)+xTrans - 1)*ymax;
exampletargetcord2 =examplenewTargy(2,:)+yTrans  + (examplenewTargx(2,:)+xTrans - 1)*ymax;
exampleyJitLoc=yJitLoc; %marcello prefers
examplexJitLoc=xJitLoc;
exampleyJitLoc2=yJitLoc; %marcello prefers
examplexJitLoc2=xJitLoc;

examplexJitLoc(examplexJitLoc>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
examplexJitLoc(examplexJitLoc< - pix_deg/ecccoeffCI_example/3)=-pix_deg/ecccoeffCI_example/3;
exampleyJitLoc(exampleyJitLoc>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
exampleyJitLoc(exampleyJitLoc< - pix_deg/ecccoeffCI_example/3)=- pix_deg/ecccoeffCI_example/3;

examplexJitLoc2(examplexJitLoc2>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
examplexJitLoc2(examplexJitLoc2< - pix_deg/ecccoeffCI_example/3)=-pix_deg/ecccoeffCI_example/3;
exampleyJitLoc2(exampleyJitLoc2>pix_deg/ecccoeffCI_example/3)=pix_deg/ecccoeffCI_example/3;
exampleyJitLoc2(exampleyJitLoc2< - pix_deg/ecccoeffCI_example/3)=- pix_deg/ecccoeffCI_example/3;

examplexJitLoc(exampletargetcord)=pix_deg*(offsetxnew{7}(1,:))/coeffCI_example;%+xJitLoc(targetcord);
exampleyJitLoc(exampletargetcord)=pix_deg*(offsetynew{7}(1,:))/coeffCI_example;%+xJitLoc(targetcord);
examplexJitLoc2(exampletargetcord2)=pix_deg*(offsetxnew{7}(2,:))/coeffCI_example;%+xJitLoc(targetcord);
exampleyJitLoc2(exampletargetcord2)=pix_deg*(offsetynew{7}(2,:))/coeffCI_example;%+xJitLoc(targetcord);

exampletheori=180*rand(1,length(eccentricity_XCI_example));
exampletheori2=180*rand(1,length(eccentricity_YCI_example));

exampletheori(exampletargetcord)=Targorinew{7}(1,:);
exampletheori2(exampletargetcord2)=Targorinew{7}(2,:);

%% instruction page p/d
examplenewTargynum=Targy{1};
examplenewTargxnum=Targx{1};
exampletargetcordnum =examplenewTargynum(1,:)+yTrans  + (examplenewTargxnum(1,:)+xTrans - 1)*ymax;
exampletargetcordnum2 =examplenewTargynum(2,:)+yTrans  + (examplenewTargxnum(2,:)+xTrans - 1)*ymax;
exampleyJitLocnum=yJitLoc; %marcello prefers
examplexJitLocnum=xJitLoc;
exampleyJitLocnum2=yJitLoc; %marcello prefers
examplexJitLocnum2=xJitLoc;
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
