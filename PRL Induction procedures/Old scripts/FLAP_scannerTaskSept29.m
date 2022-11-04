
% Gabor and contour task for scanner
% written by Pinar Demirayak April 2022
close all;
clear all;
clc;
commandwindow
addpath([cd '/utilities']); %add folder with utilities files

%% take information from the user
try
    prompt={'Subject Name', 'Pre or Post Scan','Run Number','site UAB lab(0), UCR(1), Mac Laptop(2)','demo (0) or session (1)', 'left (1) or right (2) TRL?'};

    name= 'Subject Name';
    numlines=1;
    defaultanswer={'test','1', '1', '0','1','1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end

    SUBJECT = answer{1,:}; %Gets Subject Name
    prepost=str2num(answer{2,:});
    runnumber= str2num(answer{3,:});
    site= str2num(answer{4,:});  % 0=UAB disp++;1=UCR;2=Anymac;3=Datapixx
    Isdemo=answer{5,:};
    TRLlocation= str2num(answer{6,:}); %1=left, 2=right

    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    %create a folder if it doesn't exist already
    if exist('data')==0
        mkdir('data');
    end


    baseName=['.\data\' SUBJECT '_FLAP_ScannerVPixx_PrePost' num2str(prepost) '_RunNum' num2str(runnumber) '_' TimeStart '.mat'];
    defineSite_Scanner %Screen parameters
    trainingType=0;
    CommonParametersFLAP_Scanner % define common parameters

    %     StartSize=2; %for VA
    %     sigma_degBig=2;
    %     sigma_degSmall=.1;
    %     sfs=3;
    %     PRL1x=-7.5;
    %     PRL1y=0; %0.5;
    %     PRL2x=7.5;
    %     PRL2y=0; %-0.5;%7.5; %eccentricity of PRLs
    %     jitterCI=1;
    %     possibleoffset=[-2:2];
    %     %ExerTime=0 ; % If this is a 1 then break time will be ignored.
    %     JitRat=4; % amount of jit ration the larger the value the less jitter
    %
    %     gaborcontrast=0.35;
    %     circularMasking=1; % if we want a circular masking around the contour
    %     %randomizeUnattended=1; % do we randomize the unattended stimulus or it will always be the other orientation?
    %     Screen('Preference', 'SkipSyncTests', 1);
    %     PC=getComputerName();
    %     %closescript=0;
    %     kk=1;
    %% task related variables
    startdatetime = datestr(now); %Current date and time as date vector. [year month day hour minute seconds]
    interTrialIntervals1=[1 4 1 2 7 2 2 8 2 1; 3 7 1 1 3 4 1 4 5 1; 1 5 3 1 7 1 3 1 6 2; 2 5 1 2 1 8 3 4 1 3];
    interTrialIntervals2=[4 1 1 2 8 2 3 1 6 2; 1 7 1 5 2 2 3 2 6 1; 2 1 5 2 8 1 3 4 2 2; 3 1 7 2 6 2 1 4 2 2];
    activeblockcue=[2 2 1 2 1 1 2 2 2 1; 1 1 2 1 2 2 1 2 2 1; 1 1 2 2 2 1 2 1 1 1; 1 2 2 1 1 2 1 2 1 2]; %attention location (cue direction) 1:left, 2:right
    activeblockstimulus1=[2 1;1 1;2 2;2 2;1 2;2 1;1 2;2 2;1 2;2 2];activeblockstimulus2=[2 1;1 2;2 1;2 1;1 1;1 2;1 1;1 1;1 1;2 1];activeblockstimulus3=[1 2;1 1;2 2;2 1;2 2;2 2;1 2;2 1;2 2;1 2];activeblockstimulus4=[1 1;1 2;1 2;2 1;1 2;2 1;1 2;2 2;1 1;2 1];%orientation of gabors/6 or 9 for left and right stimuli
    activeblocktype=[2 2 2 1;2 2 1 1;2 1 2 1;2 1 1 2;1 1 2 2]; %1 for gabors 2 for numbers
    %activeblocktype=[2 2 1 2;2 2 2 1;2 1 2 2;1 2 2 2;2 1 2 2;2 2 1 2]; %1 for gabors 2 for numbers
    totalactiveblock=4;
    TR=1.5;
    totaltrialtime=TR*2;

    %% Trigger Setup
    a                               = cd;
    if a(1)=='/' % mac or linux
        a                           = PsychHID('Devices');
        for i = 1:length(a)
            d(i)                    = strcmp(a(i).usageName, 'Keyboard');
        end
        keybs                       = find(d);
    else % windows
        keybs                       = [];
    end
    tChar = {'t'};
    rChar = {'r' 'g' 'b' 'y'};
    
    %% sound settings
    InitializePsychSound(1);
    pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    if site==0
        pahandle1 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    elseif site==1 || site ==2
        pahandle1 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 1, 44100, 2);
    elseif site==3

        pahandle1 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
        pahandle2 = PsychPortAudio('Open', [], 1, 0, 44100, 2);
    end

    try
        [errorS freq  ] = audioread('wrongtriangle.wav'); % load sound file (make sure that it is in the same folder as this script
        [corrS freq  ] = audioread('ding3up3.wav'); % load sound file (make sure that it is in the same folder as this script
    end
    PsychPortAudio('FillBuffer', pahandle1, corrS' ); % loads data into buffer
    PsychPortAudio('FillBuffer', pahandle2, errorS'); % loads data into buffer
    %% Stimuli creation

    PreparePRLpatch % here I characterize PRL features

    % Gabor stimuli
    createGabors_Scanner

    % CI stimuli
    CIShapes_Scanner
    %     %% defining circles
    %     imsize=StartSize*pix_deg;
    %     [x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);
    %     %circular mask
    %     xylim = imsize; %radius of circular mask
    %     circle = x.^2 + y.^2 <= xylim^2;
    %     [nrw, ncl]=size(x);
    %
    %     %theLetter=imread('letter_c2.tiff');
    %     theLetter=imread('newletterc22.tiff');
    %     theLetter=theLetter(:,:,1);
    %     [sizx sizy]= size(theLetter);
    %     theLetter=imresize(theLetter,[nrw nrw],'bicubic');
    %     theCircles=theLetter;
    %     theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
    %     theLetter=Screen('MakeTexture', w, theLetter);
    %     theCircles(1:nrw, round(nrw/2):nrw)=theCircles(nrw:-1:1, round(nrw/2):-1:1);
    %     theCircles = double(circle) .* double(theCircles)+bg_index * ~double(circle);
    %     theCircles=Screen('MakeTexture', w, theCircles);
    %     theDot=imread('thedot2.tiff');
    %     theDot=theDot(:,:,1);
    %     theDot=imresize(theDot,[nrw nrw],'bicubic');
    %     theDot = double(circle) .* double(theDot)+bg_index * ~double(circle);
    %     theDot=Screen('MakeTexture', w, theDot);
    %     rand('twister', sum(100*clock));

    %% response

    KbName('UnifyKeyNames');

    indexfingerresp = KbName('y');% left oriented gabor or six
    middlefingerresp = KbName('g');% right oriented gabor or nine
    %middlefingerresp = KbName('RightArrow');
    %indexfingerresp = KbName('LeftArrow');

    escapeKey = KbName('ESCAPE');	% quit key
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get keyboard for the key recording
    deviceIndex = -1; % reset to default keyboard
    [k_id, k_name] = GetKeyboardIndices();
    for i = 1:numel(k_id)
        if strcmp(k_name{i},'Dell Dell USB Keyboard') % unique for your deivce, check the [k_id, k_name]
            deviceIndex =  k_id(i);
        elseif  strcmp(k_name{i},'Apple Internal Keyboard / Trackpad')
            deviceIndex =  k_id(i);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% main loop
    HideCursor;
    %      ListenChar(2);
    %      ListenChar(0);



    %     colorfixation = white;
    %     [xc, yc] = RectCenter(wRect);
    %     eccentricity_X=[PRL1x PRL2x]*pix_deg;
    %     eccentricity_Y=[PRL1y PRL2y]*pix_deg;
    eccentricity_X=[PRLx -PRLx]*pix_deg;
    eccentricity_Y=[PRLy PRLy]*pix_deg;
    %
    %     eccentricity_Xdeg=[PRL1x PRL2x];
    %     eccentricity_Ydeg=[PRL1y PRL2y];

    %% settings for individual small gabors for contour integration stimulus
    %    %stimulusSize = 2.5;
    %     %sigma_deg = stimulusSize/2.5;
    %     sigma_pixSmall = sigma_degSmall*pix_deg;
    %     imsizeSmall=sigma_pixSmall*2.5;
    %     [x0Small,y0Small]=meshgrid(-imsizeSmall:imsizeSmall,-imsizeSmall:imsizeSmall); % contour integration task related
    %     G = exp(-((x0Small/sigma_pixSmall).^2)-((y0Small/sigma_pixSmall).^2));
    %     [r, c] = size(G);
    %     midgray=0.5;
    %
    %     rot=0*pi/180; %redundant but theoretically correct
    %     maxcontrast=1;
    %     for i=1:(length(sfs))  %creating individual small gabors
    %         f_gabor=(sfs(i)/pix_deg)*2*pi;
    %         aa=cos(rot)*f_gabor;
    %         b=sin(rot)*f_gabor;
    %         m=maxcontrast*sin(aa*x0Small+b*y0Small+pi).*G;
    %         TheGaborsSmall(i)=Screen('MakeTexture', w, midgray+inc*m,[],[],2);
    %     end
    %
    %     clear aa b m f_gabor
    %
    %     %% settings for orientation discrimination stimulus
    %     sigma_pixBig = sigma_degBig*pix_deg;
    %     imsizeBig=sigma_pixBig*2.5;
    %     [x0Big,y0Big]=meshgrid(-imsizeBig:imsizeBig,-imsizeBig:imsizeBig);
    %     G = exp(-((x0Big/sigma_pixBig).^2)-((y0Big/sigma_pixBig).^2));
    %     for i=1:(length(sfs))  %bpk: note that sfs has only one element
    %         f_gabor=(sfs(i)/pix_deg)*2*pi;
    %         a=cos(rot)*f_gabor;
    %         b=sin(rot)*f_gabor;
    %         m=maxcontrast*sin(a*x0Big+b*y0Big+pi).*G;
    %         TheGaborsBig(i)=Screen('MakeTexture', w, midgray+inc*m,[],[],2);
    %     end
    %
    %     %set the limit for stimuli position along x and y axis
    %     xLim=((wRect(3)-(2*imsize))/pix_deg)/2; %we don't use this
    %     yLim=((wRect(4)-(2*imsize))/pix_deg_vert)/2;
    %
    %     bg_index =round(gray*255); %background color
    %     %circular mask
    %     xylim = imsize; %radius of circular mask
    %     circle = x0Big.^2 + y0Big.^2 <= xylim^2;
    %     [nrw, ncl]=size(x0Big);
    %
    %     %% settings for contour integration stimuli
    %     xs=7;
    %     ys=7;
    %     %density 1 deg
    %     [x1,y1]=meshgrid(-xs:xs,-ys:ys); %possible positions of Gabors within grid; in degrees of visual angle
    %     %[x1,y1]=meshgrid(-8:8,-6:6); %contour integration related
    %     xlocsCI=x1(:)';
    %     ylocsCI=y1(:)';
    %     ecccoeffCI=3;
    %     %generate visual cue
    %     eccentricity_XCI=xlocsCI*pix_deg/ecccoeffCI;
    %     eccentricity_YCI=ylocsCI*pix_deg/ecccoeffCI;
    % coeffCI=ecccoeffCI/2;
    %     yfoo= [ -2   -2  -2 -1 -1  0 0  1  1  2   2  2  2 3 4  5   5  4];
    %     xfoo= [ -1    0  1  -2  2 -2 2 -2  2 -1   0  1  2 2 2  1   0  -1];
    %     orifoo=[ 60  90 120 30 150 0 0 150 30 120 90 60 0 0 30 60 90 150] ;
    %
    %
    %     Xoff= [0 0 0 1/4 -1/4 0 0 1/4 -1/4 0 0 0     0 0  -1/4 0 0 0];
    %     Yoff= [1/4 0 1/4 0 0  0 0   0 0  -1/4 0 -1/4 0 0 0 -1/4 0 1/4];
    %
    %     Targx= [xfoo; -xfoo];
    %     Targy= [yfoo; -yfoo];
    %
    %     Targori=[orifoo; orifoo];
    %
    %     offsetx= [Xoff; -Xoff];
    %     offsety=[Yoff; -Yoff];
    %     %% we need thses for eyefixation5 function
    %     scotomadeg=10;%needed for eyefixation5 function
    %     %
    %     %     if site<3
    %     scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg_vert]; %needed for eyefixation5 function
    %     %     elseif site==3
    %     %         scotomasize=[scotomadeg*pix_deg scotomadeg*pix_deg];
    %     %     end
    %     %
    %     scotomarect = CenterRect([0, 0, scotomasize(1), scotomasize(2)], wRect); %needed for eyefixation5 function
    %     FixDotSize=15;
    %     xeye=[];%needed for eyefixation5 function
    %     yeye=[];%needed for eyefixation5 function
%    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    %% first instructions
    %    eyefixation5
    %     Screen('TextFont',w, 'Arial');
    %     Screen('TextSize',w, 40);
    %     Screen('FillRect', w, gray);
    %     %create orientation discrimination task stimulus for instructions
    %     theeccentricity_X=eccentricity_X(1,2);
    %     theeccentricity_Y=eccentricity_Y(1,2);
    %     theeccentricity_X2=-theeccentricity_X;
    %     theeccentricity_Y2=-theeccentricity_Y;
    %     imageRect_Big = CenterRect([0, 0, size(x0Big)], wRect);
    %     theoris =[-45 45];
    %     imageRect_offs_Big =[imageRect_Big(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect_Big(2)+(newsampley-wRect(4)/2)+theeccentricity_Y+250,...
    %         imageRect_Big(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect_Big(4)+(newsampley-wRect(4)/2)+theeccentricity_Y+250];
    %     imageRect_offs2_Big =[imageRect_Big(1)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect_Big(2)+(newsampley-wRect(4)/2)+theeccentricity_Y2+250,...
    %         imageRect_Big(3)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect_Big(4)+(newsampley-wRect(4)/2)+theeccentricity_Y2+250];
    %
    %     %contour integration task stimulus for instructions
    %     theeccentricity_XCI=eccentricity_X(1,2);
    %     theeccentricity_YCI=eccentricity_Y(1,2);
    %     theeccentricity_XCI2=-theeccentricity_XCI;
    %     theeccentricity_YCI2=-theeccentricity_YCI;
    %     %Oscat= 0.5; %JitList(thresh(Ts,Tc));
    %
    %
    %     imageRect_Small = CenterRect([0, 0, size(x0Small)], wRect);
    %     % These are the individual rectangles for each Gabor within the array
    %     imageRect_offs_Small =[imageRect_Small(1)+eccentricity_XCI', imageRect_Small(2)+eccentricity_YCI',...
    %         imageRect_Small(3)+eccentricity_XCI', imageRect_Small(4)+eccentricity_YCI'];
    %
    %
    %     sf=1;
    %     Tscat=0;
    %     Tc=1;
    %     xmax=2*xs+1; %total number of squares in grid, along x direction (15)
    %     ymax=2*ys+1; %total number of squares in grid, along x direction (15)
    %     xTrans=round(xmax/2); %Translate target left/right or up/down within grid
    %     yTrans=round(ymax/2);
    %     targetcord=[95	110	125	81	141	82	142	83	143	99	114	129	144	145	146	132	117	101];
    %     targetcord2=[131	116	101	145	85	144	84	143	83	127	112	97	82	81	80	94	109	125];
    %     %assign numbers to target locations for instructions page because we
    %     %want to show them at the center
    %     xJitLoc=[7.59836824696209	-11.3200462199697	-13.4183442347327	1.79101327619290	-2.51925517186259	0.611644442333291	6.66846272433998	-9.35067536457468	3.07663095941268	2.24300244543055	-5.25085244093048	1.98837647997756	-4.39574017571957	5.25716069233406	-2.32753023310929	-11.0522892051531	4.90084380468939	13.4644511043468	-4.10919614326207	13.4543465244307	5.71141007727716	-4.33329616923411	-12.1799983156787	9.00768981754751	1.21834265693038	-4.42033269252799	-6.02566071702047	9.31090354329798	-11.8703082162475	5.81967404209366	-5.78215142526018	-2.25128556957029	-10.8226659769225	-7.96704968389486	9.61621348367695	-5.66190332834053	2.97320291193362	9.49410785860448	2.25028973818717	-3.15815551477385	8.32014758283206	7.80817630902245	8.78422661039823	0.642595777786157	11.3469461449359	-3.64110725710554	1.60161152853511	4.21941087394163	10.9692204348543	-10.4749126322254	4.38717205041047	-12.2420376707243	-7.49166452215026	1.71291909696316	-1.02037655522841	12.4861942464405	9.70496609551454	-1.42538761866044	2.57783870871365	-12.1046596539309	10.4921467725127	4.80685402867809	3.83827894585595	0.651217022097678	6.91776898988828	-10.2951064666568	-6.68950553793808	-4.47365206043266	-5.57128066042633	12.0222342862222	8.72083623812201	3.95203260738970	-7.11675333791318	7.75636499106951	2.72896041454748	10.1680856513216	-6.13843718928498	3.27328917810589	7.68758792102566	11.9325208574133	0	0	0	8.10153190033300	8.14876600494983	-0.425115749603326	-2.54745413848717	-3.43658708448999	8.43820398350311	-0.999552053170587	-12.5996090800250	-12.1723802161498	-9.55585780582992	-9.70895742065905	0	1.53317519639215	2.32058389594963	2.11114359913486	0	7.97542083234418	0	12.5083096064451	7.98685427095911	-13.6367093930453	-2.75237604939913	-7.56321317675248	3.02412754324745	-8.55471079164846	-2.58141818039576	0	9.37993246636682	7.97524853378358	1.30473722015331	0	13.0561847020954	1.68334681824891	0	10.4772508194715	-6.43529894602165	-1.15885220900349	7.12988530334030	-10.6921323313516	-7.43623150412601	-13.5148994776764	0	-0.439396007509333	11.6592345410849	-5.86093410694983	0	-2.01919273186402	2.82922819036823	0	11.3811361340511	11.9671210855914	-11.9792450871199	-11.8736053037385	-7.83263956766603	-11.5809066737306	11.1610191564988	6.76320994607695	0	0	0	0	0	0	-4.31518601932472	11.5407598007743	10.0993963551916	-11.0459430743312	9.13040364816976	8.94481045703324	2.48854047078072	5.33801424567074	-2.84145392906041	-11.6387185281718	7.09134292290656	4.04475437534720	12.3492622762475	-2.59987167701417	10.4022772380636	6.43139772247823	-9.63301587296279	7.91764829726538	5.07815726430994	6.90448044573629	-1.55717252528412	-2.73592244955270	2.78625033687525	-6.14829408513137	-12.0139147955048	-1.99333920554788	8.91243982493687	-6.92423868630339	-9.10334642003462	3.12745450867352	-6.45225008343137	-12.2742112663290	5.94180509694842	11.7440170743051	2.44107585493954	-6.81156646809540	6.89813552365708	12.4290604773616	-11.9159503317684	-8.14919452544716	-13.2620318426213	-0.941431122197169	6.03926214822195	2.79299343568610	12.2510420461969	4.12469815259470	5.56050162820869	8.71996194781042	11.2357015113181	0.225220463667538	8.57496287117076	6.10468631237904	8.68982204189611	5.51251922757739	-12.3625376683791	-5.90961864731565	7.35708227523421	9.96739133652019	-10.8060278150303	-5.79707155911552	-3.29230809260975	1.52708043370107	10.3694573893201	-4.87171509117527	12.7712160450063	13.0272870817718	-6.50012269053777	-2.26212426621152	-0.834776101539744	7.84964824161874	7.24021270543843	-4.20385070635999	-6.00288079094740	-0.0564629027871080	12.6970190928050	3.87213643957858	9.23193552073368	-0.381643606780090	-3.59182920481044];%sets right stimulus location to 0
    %     yJitLoc=[5.98186587356300	-4.46491973182510	4.96749547573815	-1.02762294630890	-9.42068432744692	1.31057118050267	-8.70845532886480	9.87634813833179	1.95871446988100	6.66656711622392	2.42002811806682	2.81619765756927	-13.0374869596690	5.82530951753160	11.1390699616165	-11.1845421809037	13.2982197758355	9.69842721270108	-1.11247298123833	-1.32613761322061	3.47532350291589	0.488293208021893	0.00745572368239133	1.64502114264846	11.6774362607354	12.6302190055448	-6.90899137330122	5.20558398591044	11.1714480972882	-8.33699245831715	-3.21965155799014	6.93034651092011	-10.2293953772663	6.90481399361032	12.2858491075098	2.41406179412820	8.85584090520273	4.24189463338110	3.49237494950575	-3.21459394802990	-1.25602276691265	-0.130502160632178	-1.29591495684748	-1.75848670468226	12.8816041560943	-10.1475855535527	-6.63781400183955	-10.2686263214525	-5.80045480861204	-1.05150903832923	2.87527778416955	9.28321357825701	-8.81201058969771	7.70020995119745	-2.24899300302303	-4.35958562597027	-13.4432755748080	11.8403061616331	4.63919681301821	-6.39766932703106	-9.68452937760833	-2.86234498485375	4.39187758436051	-7.85010995230520	3.27406918608117	-7.44286640864386	-10.6341807840625	-10.2449957461387	-2.31478635794221	-10.4357350466936	2.60478727152723	6.44762044040022	2.77511573121377	13.1083837230182	-6.36263005179962	-1.61981351496050	1.17090446810549	1.54325437351475	1.29829532506194	4.39260270546728	0	0	0	2.05025116665049	4.57267044320536	-4.50666716455927	2.05649537881134	-2.04311706652576	-10.6494355724749	12.3174149113042	7.19512613922807	6.84356954895197	-1.57794450010892	7.89229143501965	6.84129082425239	10.4465470035723	-8.75078779749468	-0.951170822848847	-6.84129082425239	2.75261876242624	6.84129082425239	-3.10472639890400	-1.54652468450424	-6.40456428876033	-0.781946788974285	-4.56328765580327	0.181428668064636	9.89305564591756	2.11723208380790	0	-9.31516419735847	-3.25340082049652	-7.80579927085551	0	9.71239269326669	3.41398597401163	0	8.00252740750151	-0.515360236274300	12.6380409417676	9.14287037948519	12.3801711852502	4.76273902268707	-8.04039821575127	6.84129082425239	10.7551652307098	9.51911122235071	10.3402453946917	-6.84129082425239	-4.80468531671402	1.88426973778007	-6.84129082425239	8.87498137081774	-13.2413734062252	-2.34762890386503	1.72927598320066	3.43617553865482	10.2124211128649	9.77761399104573	-6.79603848995985	0	0	0	0	0	0	9.46018364838605	-4.83491396053566	-2.82388258619930	3.09145521758510	-7.56729619868980	11.9541519298803	-2.26219506830445	4.34116812885591	12.6302099638577	-11.9713847250252	6.52943648851492	5.23190105836226	-10.0812041094965	1.96913247694332	0.695271217305642	3.60851833763154	3.83238066724303	5.56815137028648	8.40334083518185	-12.8638755083571	2.24352056881735	-12.1251179641491	-2.47654834699363	-10.7345900738117	7.95544409780224	-3.04894024028066	-7.92709071496503	13.4063830225781	1.13058624236307	4.59168665631610	6.64039724370908	-3.52428865928331	-2.73894747885158	-12.5238434924818	10.5529282496261	-7.57532131505856	7.02849427166184	-2.58427689802127	1.16701231378469	-7.04476331476144	10.3489796033739	10.7534097454923	-6.33109898768338	12.4136292187520	-5.26174824592695	3.49255057304326	7.96294428779929	-3.12607443725078	-12.5104873293563	-8.82479664944745	-3.21894239023960	8.83106461800382	6.55716207242558	2.13383481707043	1.25124651578916	-8.14605275532244	-3.02830725730683	4.26475033236314	4.45387672026887	13.6514295542053	7.16798421611439	-10.1047511046998	7.80677752132306	7.91186522904554	6.49462611377619	-0.704519496847318	9.89465347343978	2.78061616811789	6.47104706429809	10.7936502943901	8.02385182300500	-11.4119603908157	6.46701538670548	-2.32083692792229	13.6327505526893	10.2789304230658	-1.84985625120179	7.71286881794163	-9.58237857360079];%sets right stimulus location to 0
    %     xJitLoc2=[-5.84781886164790	-7.97008470466567	-11.8635237067526	0.918955276783671	-6.80037795036974	-10.9613271331590	-8.91268103847314	-8.81910351647134	3.90059689936487	-10.3626868014581	7.10162995832698	9.17374508294522	10.5300076246326	6.67060569970723	5.13794066546437	-11.5064593258617	-5.51288598227788	-7.33710385876513	-3.11433547792730	-2.86630853211674	11.9814911273537	-7.88528992070751	-11.5758251942156	-6.21076557571013	-1.16250798540925	-13.5676128667179	-11.2805200952235	10.9997856689183	8.25956990561168	5.73947319095302	3.84685921465461	4.00161577376394	-12.4061429966796	9.14574361977652	-6.36771218428573	-11.3602981341164	-10.3203533967951	-5.99414540481799	0.960079000073553	3.20600586314652	-11.1120875836770	2.29710213459810	-1.48578277890064	9.43896886131993	6.65429015460758	2.08051600912685	5.10506174884190	9.30248059428873	-2.35952633208867	-6.69135044189380	-6.23788907994192	-1.11204735128231	3.60253931704601	-7.44023931867566	9.61309084890923	0.0606935495036410	9.79160306903822	-1.14668587546727	-3.46154088113965	4.45826385252758	7.66790671441591	-1.27381526273489	-10.0733201391692	-12.9439369833319	-4.82340514464484	-11.1517854012488	1.21777286346100	3.09637192398669	12.8227302077013	5.21752619859519	12.2872668752182	10.7997308420332	0.591181798651166	-8.46097969499691	4.69023896416311	2.53366814735782	4.11652285870225	13.0862267630286	9.00427600095667	6.84129082425239	0	0	6.84129082425239	0	6.84129082425239	-7.08386163375847	2.38776983523603	2.68634113655879	-6.08477701670032	3.39262652010495	-0.674117670642743	-1.56997262102346	12.9207111416647	0	-4.89373875301716	-5.47524250865381	0	-11.1605536653717	10.2542680676750	8.32038599520449	0	9.37719548901369	-10.0845136799420	12.8299982560564	7.18708781736708	9.19522975856573	7.39096489869548	4.98125342986497	0	-3.90376569408692	13.2542432809322	0	11.7231252449856	-10.3387338972483	7.56493949651943	0	3.57051369979485	-7.93833430114794	13.1196764433603	-12.4686279167293	-0.780919953588007	12.5655853085226	-5.00674539708565	6.30987802586531	0	-9.44647774211355	0	-6.45741490497123	12.9960523556654	-0.836009392232822	0	9.03078827852195	-8.06580404480802	11.9536142361776	12.1893120038826	13.1485010514343	-2.02178941956789	11.4586874651175	4.03799450277890	2.19558199780779	-11.8592556457802	9.15782134200277	-6.84129082425239	0	-6.84129082425239	3.94341898810452	0.614164543604761	8.54578461377694	-4.88318713800632	-7.02414526704563	8.46676525004273	-4.64461299450673	5.48810813419112	-0.322278995455645	-3.69509377935645	-11.2245154777196	0.649254128572349	-0.771544696586054	-11.2123460895491	-11.0119262646140	8.58617660452676	12.5054776912209	10.6619500838676	0.238460531523880	-11.1152337813521	8.40628269646890	2.64871102635030	8.78437303727001	11.5346164807616	3.77376537549461	8.87545368246671	6.38555869567855	12.4404677233716	11.7898506306306	12.6036573150895	-0.763096447409978	-8.53928847620178	-1.85739246641214	8.78961946089739	11.1682776647082	-3.05193515841700	-12.4858073527736	9.63212502912504	1.11376895144842	-2.12729024052414	3.93683467730187	5.34920811590187	1.09543624582362	13.6480111495869	12.8128176548872	-8.29205780937773	4.03714151792992	11.1384339374336	-11.2383286124594	-11.5664290047013	9.18111810144462	6.20073806902888	12.9061264298697	13.6413845365839	7.65744531893954	-5.33790920059247	8.62237903266780	13.2152406826201	-0.639541517755826	8.21668276639681	0.718616696345617	1.52730124677653	10.4647849336466	-10.9327105045885	4.56560272987866	8.53772377667186	-12.3700560103621	-5.53626883125377	2.65794860481872	2.78575910124571	-7.98568582711404	-3.88585252060697	-8.21718251003670	12.0754405452454	11.9106102984630	-3.26806859260538	10.6247075308810	-3.03320986768195	4.90479197851080	-10.2368969776657];%sets left stimulus location to 0
    %     yJitLoc2=[11.2554018362752	-9.44227425623183	-9.78169617576851	-2.08458058004183	-2.98049602122670	-9.04985583759729	-11.3983272504975	-8.16602050165232	9.87218831176961	11.2709967249855	-7.09616069306021	7.98104335384412	-1.89649821947131	3.46854952438649	-3.89160817981408	-11.5075589806504	11.5452616878370	4.54780997530518	7.85745154325773	-7.24235394687083	6.73194527205187	7.79110869334304	2.45977136464021	-5.35791780876423	2.34497503566275	-11.3222668514196	-0.404882127589665	-9.34879934410697	1.46617476348068	0.140538249713875	13.5012560986276	-7.90171591174794	-1.71050929082564	-3.81098864401663	-12.0655620504818	2.32381625334284	-10.7103259601628	5.37705659459188	6.62591354644813	-10.0543677032758	-12.1808327519713	6.88819708422042	-7.88868082211090	-12.7407980787080	-7.52731886499718	10.2255881783975	-0.767091287726201	-8.01642565688598	-12.2399359920709	11.3173433034365	-1.75353597835832	-9.93912934756358	-6.14416080655543	-4.98837148645148	12.9173851395061	-12.2354731554423	3.03264862155866	6.40682966531506	11.8739995470656	3.77249371198587	8.27709834784339	-10.1041876420103	-0.224183624139298	-7.64265435545926	9.35391179608004	12.5274099447090	2.78829492250066	-12.7574269446295	2.51804278358019	-3.19910811240720	11.8615969200960	8.18469259363400	4.82255755027442	8.66103791561972	-0.254385717346347	-6.80019230057561	-12.3481544478590	5.31917661486080	-11.9188109826458	0	0	0	0	0	0	-10.3591240399166	-2.52686181219589	1.29248925059306	-1.07218039890575	13.4576598950823	12.9247697668345	7.62937788848859	13.2491467074725	6.84129082425239	1.02060952723069	10.1228514954858	6.84129082425239	2.63671394653500	-2.76826160541840	7.06939981170019	-6.84129082425239	-4.05481639778589	-8.72064113695009	4.46034046300759	-4.42799804131801	5.04068412640266	-10.2729227587542	-3.69043223658511	0	-9.69476138796111	5.81369404903981	0	8.79849777474797	-9.84680211129342	12.2116417495101	0	-10.4130998631599	7.12673573593458	-8.96812968645865	0.436736228671522	12.8499112023682	-13.1440832538650	8.19903360788369	-12.2284836516277	-6.84129082425239	5.05410956935408	6.84129082425239	-7.74734081069194	2.59838611830874	6.99107712579682	-6.84129082425239	-12.6689953344386	5.68981219398178	4.75753344223332	-0.922525337596079	-4.02189962375768	12.2791220839996	13.4759077547559	1.89053364265633	-8.35386447150338	-5.14171238782362	-4.41275261910943	0	0	0	-11.7354630092556	-12.4255216843676	9.70483668835497	-1.14862842652477	6.79972813345824	4.60897935467093	8.72505042191926	-5.69203972248833	-10.7386199714237	6.26204956331255	2.56943678730143	-4.97927142059861	0.539378519327436	3.24329279790793	-8.62669299586522	-4.63044047188498	-7.27930316756771	-10.1871502413384	-0.122836112770370	2.77038587962997	-12.8670184067884	6.09340828696595	2.89083975933590	-1.48959715994561	6.26048020414839	-9.91851507672948	3.42215900873253	-5.41402933256077	10.5970603397419	8.43889231459481	7.21566253874564	5.95810883260633	-10.9252133298671	-5.42766178434705	11.3485852468964	12.5926823661709	-9.76055313243887	-9.15248742890384	-8.93560151275769	-12.7693862140047	-8.55731585218022	13.5150103043356	2.36208122006672	-11.6911240091347	2.75417305987245	3.83251353124706	0.215787394839193	9.59566052715693	13.5460999779765	3.15712880700960	-2.14736253131488	10.0567359246327	8.83285244059977	0.408036633362992	-12.2734763118222	-3.69166457854191	12.1511315783005	-2.85297383036485	0.295568663380511	-1.50969516009400	6.23049043259359	2.97472980197100	-13.5839415789375	-13.6477661773109	13.0710013955007	-6.06432209800094	8.92565461653551	-2.23307932123244	8.15771989648498	-9.41545311398886	-9.49723930917920	-2.75836820563076	-3.00657683416067	-9.85284297686331	-4.88610387324793	12.9968058384471	2.87091958824216	-11.8815145817307	7.14009225666201	1.16517260694984];%sets left stimulus location to 0
    %     xModLoc=zeros(1,length(imageRect_offs_Small));% these are all zeros, I don't know why we have it
    %     yModLoc=zeros(1,length(imageRect_offs_Small));% these are all zeros, I don't know why we have it
    %     theori=180*rand(1,length(imageRect_offs_Small));% all small gabors are randomly oriented
    %     theori2=180*rand(1,length(imageRect_offs_Small));
    %     %theori(targetcord)=Targori(1,:) + (2*rand(1,length(targetcord))-1)*Oscat; %addrandom orientation to some gabors that make stimulus 9
    %     %theori(targetcord2)=Targori(2,:) + (2*rand(1,length(targetcord))-1)*Oscat;%addrandom orientation to some gabors that make stimulus 6
    %     theori(targetcord)=Targori(1,:);
    %     theori2(targetcord2)=Targori(2,:);
    %     Tcontr=0.7380; % stimulus contrats, we want stimulus to be visible for the instructions page
    %     Dcontr=0.38; % background contrast for the instructions page;
    %     imageRect_offsCI =[imageRect_Small(1)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI, imageRect_Small(2)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI,...
    %         imageRect_Small(3)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI, imageRect_Small(4)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI]; % right stimulus and background gabors
    %     imageRect_offsCII =[imageRect_Small(1)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI2, imageRect_Small(2)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI,...
    %         imageRect_Small(3)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI2, imageRect_Small(4)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI]; % left stimulus and background gabors
    %     imageRect_offsCI2=imageRect_offsCI; %location of the right stimulus only
    %     imageRect_offsCII2=imageRect_offsCII; %location of the left stimulus only
    %     imageRectMask = CenterRect([0, 0, [ xs*1.75*pix_deg xs*1.75*pix_deg]], wRect); %mask to make the stimulus circular
    %
    %     imageRect_offsCImask1=[imageRectMask(1)+theeccentricity_XCI, imageRectMask(2)+theeccentricity_YCI,...
    %         imageRectMask(3)+theeccentricity_XCI, imageRectMask(4)+theeccentricity_YCI]; % mask location to the right stimulus
    %     imageRect_offsCImask2=[imageRectMask(1)+theeccentricity_XCI2, imageRectMask(2)+theeccentricity_YCI2,...
    %         imageRectMask(3)+theeccentricity_XCI2, imageRectMask(4)+theeccentricity_YCI2]; % mask location to the left stimulus
    %% draw everything on the instruction page
    
    stimulusdirection_leftstim=1;stimulusdirection_rightstim=2; %what are shown in left and right is set
    CIstimuliMod_ScannerIns;
    theeccentricity_Y=0;
            theeccentricity_X=PRLx*pix_deg;
            eccentricity_X(1)= theeccentricity_X;
            eccentricity_Y(1) =theeccentricity_Y ;
            InstructionShape_Scanner
   %InstructionFLAPscanner(w,wRect,eccentricity_X,eccentricity_Y,TRLlocation,pix_deg,pix_deg_vert,gray,white)
    %     Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr ); % background of stimulus 9 for the instruction slide on the right side
    %     imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
    %     Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );% stimulus 9 for the instruction slide on the right side
    %     Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCII' + [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori,[], Dcontr );% background of stimulus 6 for the instruction slideon the left side
    %     imageRect_offsCII2(setdiff(1:length(imageRect_offsCI),targetcord2),:)=0;
    %     Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCII2' +[xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori2,[], Tcontr );% stimulus 6 for theinstruction slide on the left side
    %     Screen('FrameOval', w,gray, imageRect_offsCImask2, 22, 22); %mask
    %     Screen('FrameOval', w,gray, imageRect_offsCImask1, 22, 22); %mask
    %     Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs_Big, theoris(2),[], gaborcontrast);%orientation disc.task stimulus for the instruction slide on the right side
    %     Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs2_Big, theoris(1),[], gaborcontrast); %orientation disc. task stimulus for the instruction slide on the left side
    %     colorfixation = white;
    %     DrawFormattedText(w, 'Before each trial, a cue will indicate the location \n \n of the stimulus to attend (right: > or left: < ) \n \n Please look at the center of the screen during the experiment\n \n Index finger for 6 or left oriented stimulus \n Middle finger for 9 or right oriented stimulus \n \n','center', 100, white);
    %     DrawFormattedText(w, 'index finger',680, 930, white);
    %     DrawFormattedText(w, 'middle finger',1080, 930, white);
    %     DrawFormattedText(w, 'or',950, 700, white);
    %
    %     FirstInstructionOnsetTime=Screen('Flip',w);

    %% get trigger t
    ListenChar(2);
    soundsc(sin(1:.5:1000)); % play 'ready' tone
    disp('Ready, waiting for trigger...');
    commandwindow;
    startTime = wait4T(tChar);  %wait for 't' from scanner.
    disp(['Trigger received - ' startdatetime]);

    fixationlength=10;
    fixationscriptW;
    WaitSecs(TR);
    %% Start Trials
    if Isdemo==1
        totalactiveblock=2;
    end
    for totalblock=1:totalactiveblock
        if Isdemo==1
            runnumber=1;
        end
        active=num2str(totalblock);
        activeblock=activeblockcue(totalblock,:);
        activeblockstim=eval(['activeblockstimulus' active]);% direction of gabors or being 6 or9 in both location
        runnum=num2str(runnumber);
        blocktype=activeblocktype(runnumber,totalblock);
        for trial=1:10
            trialstarttime(totalblock,trial)=GetSecs;
            Screen('TextFont',w, 'Arial');
            Screen('TextSize',w, 42);
            fixationscriptW;
            cue=activeblock(trial); %if it's 1 attend to left, if it's 2 attend right
            if cue==1
                DrawFormattedText(w, '<', 'center', 560', white);
            else
                DrawFormattedText(w, '>', 'center',560, white);
            end
            CueOnsetTime=Screen('Flip',w);
            WaitSecs(0.250);
            stimulusdirection_leftstim=activeblockstim(trial,1);stimulusdirection_rightstim=activeblockstim(trial,2); %what are shown in left and right is set
            if blocktype==1 %gabors
                gaborcontrast=0.35;
theoris =[-45 45];
%                 imageRect_offs_Big =[imageRect_Big(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect_Big(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
%                     imageRect_Big(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect_Big(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
%                 imageRect_offs2_Big =[imageRect_Big(1)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect_Big(2)+(newsampley-wRect(4)/2)+theeccentricity_Y2,...
%                     imageRect_Big(3)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect_Big(4)+(newsampley-wRect(4)/2)+theeccentricity_Y2];
% imageRect_offs_Big =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y,...
%                     imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y];
           imageRect_offsleft =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y]; 
             imageRect_offsright =[imageRect(1)-theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)-theeccentricity_X, imageRect(4)+theeccentricity_Y];          
%            imageRect_offsCIinstr =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_X,...
%     imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_X];
% imageRect_offs2_Big =[imageRect(1)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect(2)+(newsampley-wRect(4)/2)+theeccentricity_Y2,...
%                     imageRect(3)+(newsamplex-wRect(3)/2)+theeccentricity_X2, imageRect(4)+(newsampley-wRect(4)/2)+theeccentricity_Y2];
                if stimulusdirection_leftstim==1 %1 means right
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(2),[], gaborcontrast);

                else
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsleft, theoris(1),[], gaborcontrast);
                end
                  if stimulusdirection_rightstim==1 %1 means right
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(2),[], gaborcontrast);

                else
                    Screen('DrawTexture', w, TheGabors, [], imageRect_offsright, theoris(1),[], gaborcontrast);
                end              
%                  if stimulusdirection_leftstim==1 %1 means right
%                     Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs2_Big, theoris(2),[], gaborcontrast);
% 
%                 else
%                     Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs2_Big, theoris(1),[], gaborcontrast);
%                 end
%                 if stimulusdirection_rightstim==1 %1 means left
%                     Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs_Big, theoris(2),[], gaborcontrast);
% 
%                 else
%                     Screen('DrawTexture', w, TheGaborsBig, [], imageRect_offs_Big, theoris(1),[], gaborcontrast);
%                 end
                fixationscriptW;
            else %numbers

%                 jitterxci(1)=possibleoffset(randi(length(possibleoffset)));
%                 jitteryci(1)=possibleoffset(randi(length(possibleoffset)));
%                 newTargy= Targy+jitteryci(1);
%                 newTargx= Targx+jitterxci(1);
%                 Tcontr=0.7;
%                 Dcontr=0.7;
% imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
%                             imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
%                         imageRect_offsCI2=imageRect_offsCI;
%                         
CIstimuliMod_Scanner
           imageRect_offsCIleft =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
            imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(1), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)]; 
           imageRect_offsCIleft2=imageRect_offsCIleft;  
           imageRect_offsCIright =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(1),...
            imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(2), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(1)]; 
imageRect_offsCIright2=imageRect_offsCIright;
imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                        imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                            imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
           % imageRect_offsCI =[imageRect_Small(1)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI, imageRect_Small(2)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI,...
%                     imageRect_Small(3)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI, imageRect_Small(4)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI];
%                 imageRect_offsCII =[imageRect_Small(1)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI2, imageRect_Small(2)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI,...
%                     imageRect_Small(3)+(newsamplex-wRect(3)/2)+eccentricity_XCI'+theeccentricity_XCI2, imageRect_Small(4)+(newsampley-wRect(4)/2)+eccentricity_YCI'+theeccentricity_YCI];
                %imageRect_offsCI2=imageRect_offsCI;
                %imageRect_offsCII2=imageRect_offsCII;
                %imageRectMask = CenterRect([0, 0, [ xs*1.75*pix_deg xs*1.75*pix_deg]], wRect);
%                 imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
%                 imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
%                             imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                

%                 if stimulusdirection_rightstim==1 % nine is shown in right side
%                     targetcord =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
%                     xJitLoc=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat; %plus or minus .25 deg
%                     yJitLoc=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat;
%                     xModLoc=zeros(1,length(imageRect_offs_Small));
%                     yModLoc=zeros(1,length(imageRect_offs_Small));
%                     xJitLoc(targetcord)=Tscat*xJitLoc(targetcord);
%                     yJitLoc(targetcord)=Tscat*yJitLoc(targetcord);
%                     theori=180*rand(1,length(imageRect_offs_Small));
%                     theori(targetcord)=Targori(1,:);
%                     xJitLoc(targetcord)=(pix_deg*offsetx(1,:))+xJitLoc(targetcord);
%                     yJitLoc(targetcord)=(pix_deg*offsety(1,:))+yJitLoc(targetcord);
%                 else %six is shown in the right side
%                     targetcord =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
%                     xJitLoc=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat; %plus or minus .25 deg
%                     yJitLoc=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat;
%                     xModLoc=zeros(1,length(imageRect_offs_Small));
%                     yModLoc=zeros(1,length(imageRect_offs_Small));
%                     xJitLoc(targetcord)=Tscat*xJitLoc(targetcord);
%                     yJitLoc(targetcord)=Tscat*yJitLoc(targetcord);
%                     theori=180*rand(1,length(imageRect_offs_Small));
%                     theori(targetcord)=Targori(2,:);
%                     xJitLoc(targetcord)=(pix_deg*offsetx(2,:))+xJitLoc(targetcord);
%                     yJitLoc(targetcord)=(pix_deg*offsety(2,:))+yJitLoc(targetcord);
%                 end
%                 if stimulusdirection_leftstim==1 % nine is shown in left side
%                     targetcord2 =newTargy(1,:)+yTrans  + (newTargx(1,:)+xTrans - 1)*ymax;
%                     xJitLoc2=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat; %plus or minus .25 deg
%                     yJitLoc2=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat;
%                     xModLoc=zeros(1,length(imageRect_offs_Small));
%                     yModLoc=zeros(1,length(imageRect_offs_Small));
%                     xJitLoc2(targetcord2)=Tscat*xJitLoc2(targetcord2);
%                     yJitLoc2(targetcord2)=Tscat*yJitLoc2(targetcord2);
%                     theori2=180*rand(1,length(imageRect_offs_Small));
%                     theori2(targetcord2)=Targori(1,:);
%                     xJitLoc2(targetcord2)=(pix_deg*offsetx(1,:))+xJitLoc2(targetcord2);
%                     yJitLoc2(targetcord2)=(pix_deg*offsety(1,:))+yJitLoc2(targetcord2);
%                 else %six is shown in the left side
%                     targetcord2 =newTargy(2,:)+yTrans  + (newTargx(2,:)+xTrans - 1)*ymax;
%                     xJitLoc2=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat; %plus or minus .25 deg
%                     yJitLoc2=pix_deg*(rand(1,length(imageRect_offs_Small))-.5)/JitRat;
%                     xModLoc=zeros(1,length(imageRect_offs_Small));
%                     yModLoc=zeros(1,length(imageRect_offs_Small));
%                     xJitLoc2(targetcord2)=Tscat*xJitLoc2(targetcord2);
%                     yJitLoc2(targetcord2)=Tscat*yJitLoc2(targetcord2);
%                     theori2=180*rand(1,length(imageRect_offs_Small));
%                     theori2(targetcord2)=Targori(2,:);
%                     xJitLoc2(targetcord2)=(pix_deg*offsetx(2,:))+xJitLoc2(targetcord2);
%                     yJitLoc2(targetcord2)=(pix_deg*offsety(2,:))+yJitLoc2(targetcord2);
%                 end
                
if stimulusdirection_leftstim==1 %1 means right
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
imageRect_offsCIleft2(setdiff(1:length(imageRect_offsCIleft),targetcord),:)=0;
                else
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIleft'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
                imageRect_offsCIleft2(setdiff(1:length(imageRect_offsCIleft),targetcord),:)=0;
                end
                  if stimulusdirection_rightstim==1 %1 means right
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
imageRect_offsCIright2(setdiff(1:length(imageRect_offsCIright),targetcord),:)=0;
                else
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCIright'+ [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr);
                imageRect_offsCIright2(setdiff(1:length(imageRect_offsCIright),targetcord),:)=0;
                  end  


%                 Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
%                     imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                %Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr ); % background of left stimulus
                %imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                %Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Tcontr );% stimulus right
                %Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCII' + [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori2,[], Dcontr );% background of right stimulus
                %imageRect_offsCII2(setdiff(1:length(imageRect_offsCI),targetcord2),:)=0;
                %Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCII2' + [xJitLoc2+xModLoc; yJitLoc2+yModLoc; xJitLoc2+xModLoc; yJitLoc2+yModLoc], theori2,[], Tcontr );% stimulus left
                %Screen('FrameOval', w,gray, imageRect_offsCImask, 22, 22);
                %Screen('FrameOval', w,gray, imageRect_offsCImask1, 22, 22);
                fixationscriptW; %fixation aids
                if cue==1 % we are showing cue during the stimulus presentation
                    DrawFormattedText(w, '<', 'center', 560', white);
                else
                    DrawFormattedText(w, '>', 'center',560, white);
                end

            end

            StimulusOnsetTime=Screen('Flip',w); %show stimulus
            WaitSecs(0.200);
            fixationscriptW; %fixation aids
            ResponseFixationOnsetTime=Screen('Flip',w); %start of response time
            MaximumResponseTime=totaltrialtime-(ResponseFixationOnsetTime-trialstarttime); % maximum time to response
            ListenChar(2);
            timedout=false;
            RT(totalblock,trial)=0;ResponseType{totalblock,trial}='miss';
            if site==2
                while ~timedout
                    keyTime=GetSecs;
                    if CharAvail
                        [ch, keyTime] = GetChar;
                        responsekey=KbName(ch);
                        RT(totalblock,trial)=keyTime.secs-ResponseFixationOnsetTime; %reaction time
                        conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==middlefingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==indexfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==middlefingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==indexfingerresp); %conditions that are true
                        if any(conditions)==1
                            PsychPortAudio('Start', pahandle1); % feedback for true response
                            ResponseType{totalblock,trial}='correct';
                        else
                            PsychPortAudio('Start', pahandle2); %feedback for false response
                            ResponseType{totalblock,trial}='false';
                        end
                        clear conditions;
                        FlushEvents;
                        break;
                    end

                    if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime),timedout=true;
                    end

                end
            elseif site==0
                while ~timedout
                    [ keyIsDown, keyTime, keyCode ] = KbCheck;
                    responsekey = find(keyCode, 1);
                    if keyIsDown
                        RT(totalblock,trial)=keyTime-ResponseFixationOnsetTime;
                        conditions(1)=logical(cue==1 && stimulusdirection_leftstim==1 && responsekey==middlefingerresp);conditions(2)=logical(cue==1 && stimulusdirection_leftstim==2 && responsekey==indexfingerresp);conditions(3)=logical(cue==2 && stimulusdirection_rightstim==1 && responsekey==middlefingerresp);conditions(4)=logical(cue==2 && stimulusdirection_rightstim==2 && responsekey==indexfingerresp); %conditions that are true
                        if any(conditions)==1
                            PsychPortAudio('Start', pahandle1); % feedback for true response
                            ResponseType{totalblock,trial}='correct';
                        else
                            PsychPortAudio('Start', pahandle2); %feedback for false response
                            ResponseType{totalblock,trial}='false';
                        end
                        clear conditions;
                        FlushEvents;
                        break;
                    end;
                    if((keyTime-ResponseFixationOnsetTime)>MaximumResponseTime),timedout=true;
                    end
                end
            end
            % Begin the rest block jittered times between trials

            itiforrun=eval(['interTrialIntervals' runnum]);
            iti=itiforrun(totalblock,trial)*TR;
            WaitSecs(iti);
        end
        if responsekey == escapeKey
            break;
        end
        clear responsekey;
                Screen('TextFont',w, 'Arial');
                Screen('TextSize',w, 42);
                Screen('FillRect', w, gray);
                fixationscriptW;
                DrawFormattedText(w, 'x', 'center', 558, white);
                RestTime=Screen('Flip',w);
             %   save(baseName,'RT','ResponseType','trialstarttime','-append') %save our variables
        
                while GetSecs < RestTime + 15; %  rest for 15 sec
        
                end
    end


    %% Clean up
    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);
    Screen('Flip', w);
    Screen('TextFont', w, 'Arial');
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    ListenChar(0);
    ShowCursor;

    if site==1
        Screen('CloseAll');
        Screen('Preference', 'SkipSyncTests', 0);
        PsychPortAudio('Close', pahandle);
    else
        Screen('Preference', 'SkipSyncTests', 0);
        Screen('LoadNormalizedGammaTable', w , (linspace(0,1,256)'*ones(1,3)));
        Screen('Flip', w);
        Screen('CloseAll');
        if site<3
            PsychPortAudio('Close', pahandle);
        elseif site ==3
            PsychPortAudio('Close', pahandle1);
        end
    end


catch ME
    'There was an error caught in the main program.'
    psychlasterror()
end