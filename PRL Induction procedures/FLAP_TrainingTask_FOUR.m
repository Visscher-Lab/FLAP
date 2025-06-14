% FLAP Training
% written by Marcello A. Maniglia july 2021 %2017/2021
% Training script for FLAP. This script runs 4 types of visual/oculomotor
% training in conditions of gaze-contingent, simulated central vision loss.
% participants are assigned a TRL (trained retinal location) to either left
% or right of the simulated scotoma.
% 1 = Contrast detection: Participant has to keep the simulated scotoma
% within the boundaries of the central visual aid (square) for some
% time defined by the variable AnnulusTime, then a Gabor appears for
% Stimulustime, participant has to report the Gabor's orientation.
% Participant has trialTimeout amount of time to respond, otherwise the
% trial is considered wrong and the script moves to the nextial.
% 2 = Contour Integration: Participant has to keep the simulated scotoma
% within the boundaries of the central visual aid (square) for some
% time defined by the variable A nnulusTime, then a CI target appears for
% Stimulustime, participant has to report the identity of the stimulus
%within the CI. Participant has trialTimeout amount of time to respond,
%otherwise the trial is considered wrong and the script moves to the next trial.
% 3 = Fixation stability: Participant has to find a white O on the screen and
%keep it within their TRL for some time defined by the variable AnnulusTime,
%then the O will start flickering for an amount of time defined by the
%variable flickertime. If the participant moves the TRL away from the O, it
% will stop flickering (and the flicker timer will stop as well).
%The trial ends when the overall flickering time is fulfilled, thus the more
%the participant keeps the O within their TRL, the shorter the trial duration
%Few consecutive trials are at the same location, then an endogenous (arrow) or an
%exogenous (briefly appearing O) indicates the location of the next series
%of trials.  
% 4 = perceptual/oculomotor training: same as 3, but with a target after
%the forced fixation period, either a Gabor (contrast detection) or a
%contour (contour integration).


close all; clear; clc;
commandwindow


addpath([cd '/utilities']); %add folder with utilities files
try
%     participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUCR_corr.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
    %participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUAB_corr.csv']); % uncomment this if running task at UAB
    
    % format of participantAssignment table is:
    %       first row has column labels; second row is comments about what the
    %       columns mean; Third row is a test participant; subsequent rows are
    %       subjects.
    %       Columns are: participant    TRL     WhichEye    Afirst      TrainingTask    Acuitycondition     ContrastCondition   crowdingCondition   ContourCondition    ScotomaPresent
    %       Comments are: %(participant name),	[TRL ("R" or "L", defined prior to first training, starts as NA) left(1) right(2) for tracking],  [A first = 1 (Assessment A will be run first)],
    %                        [Training Task: 1=contrast, 2=contour integration, 3= oculomotor, 4=everything bagel], acuity (1:2),	contrast (1:2),     Crowding condition (1:4), 	contour (1:4),	Is there a scotoma present for this participant (1), or no (0, MD participant)
    
    % output from the gui is 'SUBJECT' < a string with the participant
    % name in it in the format fr1001, for the first participant.
    % f stands for FLAP, r stands for UCR, 1 stands for first cycle of
    % participants, 001 stands for the first participant run at UCR.
    % SUBJECT must match a participant number in the table
    % ParticipantAssignmentsUCR.csv, which lives in the current directory.
    
    prompt={'Participant Name', 'Session', 'Calibration(1), Validation (2), or nothing(0)'}; %suggest changing to 'session' in case there are 2 sessions in one day  %PA table!
    name= 'Parameters';
    numlines=1;
    defaultanswer={'test','1','1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    % temp= readtable(participantAssignmentTable);
    SUBJECT = answer{1,:}; %Gets Subject Name

    [tt,site] = getParticipantAssignmentTable(SUBJECT);
    if strcmp(tt.TRL{1,1},'R') == 1
        TRLlocation = 2;
    else
        TRLlocation = 1;
    end
    trainingType= str2num(tt.TrainingTask{1,1}); % training type: 1=contrast, 2=contour integration, 3= oculomotor, 4=everything bagel
    penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    expDay=str2num(answer{2,:}); % training session
    if strcmp(tt.WhichEye{1,1},'R') == 1 % are we tracking left (1) or right (2) eye? Only for Vpixx
        whicheye = 2;
    else
        whicheye = 1;
    end
    calibration=str2num(answer{3,:}); % do we want to calibrate or do we skip it? only for Vpixx
    ScotomaPresent = str2num(tt.ScotomaPresent{1,1});
    EyeTracker = 1; %0=mouse, 1=eyetracker
    orijitconct=[];
    orijitconctprog=[];
    progtrackend=15; % new variable for prog track setup 7/17 MGR
%     threshconc1=[]; %debugging variables 8-2-2024
%     threshconc2=[];
%     threshconc3=[];
%     threshconc1prog=[];
%     threshconc2prog=[];
%     threshconc3prog=[];
    resptotal=[];
 

    
    % If not using CSV table, uncomment following
    % --------------------------------------------------------------------------------------------------------------------------------
    %     prompt={'Participant Name', 'Session','Training Type? Contrast(1),CI (2), Oculomotor(3), Everything bagel(4)','TRL Location? left(1), right(2)', 'Calibration? yes (1), no(0)', 'Eyetracker(1) or mouse(0)?'}; %suggest changing to 'session' in case there are 2 sessions in one day  %PA table!
    %     name= 'Parameters';
    %     numlines=1;
    %     defaultanswer={'test','1','1','1','0', '0'};
    %     answer=inputdlg(prompt,name,numlines,defaultanswer);
    %     if isempty(answer)
    %         return;
    %     end
    %     SUBJECT = answer{1,:}; %Gets Subject Name
    %     TRLlocation=str2num(answer{4,:});%1=left, 2=right
    %     penalizeLookaway=0;   %mostly for debugging, we can remove the masking on the target when assigned PRL ring is out of range
    %     expDay=str2num(answer{2,:}); % training session
    %     calibration=str2num(answer{5,:}); % do we want to calibrate or do we skip it? only for Vpixx
    %     EyeTracker = str2num(answer{6,:}); %0=mouse, 1=eyetracker
    %     trainingType= str2num(answer{3,:}); % training type: 1=contrast, 2=contour integration, 3= oculomotor, 4=everything bagel
    %     whicheye=2; % are we tracking left (1) or right (2) eye? Only for Vpixx
    % ScotomaPresent = 1; %0 = no scotoma, 1 = scotoma
    % ------------------------------------------------------------------------------------------------------------------------------------
   % site = 3; % training site (UAB vs UCR vs Vpixx)
    %  demo=str2num(answer{4,:}); % are we testing in debug mode?
    demo=2;
    test=demo;
    datapixxtime=1;
    responsebox=1;
    if EyeTracker==0
        calibration=0;
    end
    
    c = clock; %Current date and time as date vector. [year month day hour minute seconds]
    filename='_FLAPtraining_type';
    DAY = ['\Training\Day' answer{2,:} '\'];
    folderchk=cd;
    folder=fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY]);
    if exist(fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAY])) == 0
        mkdir(folder);
    end
    
    TimeStart=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    baseName=[folder SUBJECT  filename '_' num2str(trainingType) '_Day_' answer{2,:} '_' TimeStart]; %makes unique filename
    
    %
    %
    %     ..\datafolder\FLAP_XXX\training
    % ..\datafolder\FLAP_XXX\training\sess1
    % ..\datafolder\FLAP_XXX\training\sess2
    % ..\datafolder\FLAP_XXX\training\sess3
    
    
    defineSite % initialize Screen function and features depending on OS/Monitor
    
    CommonParametersFLAP % define common parameters
    
    %% eyetracker initialization (eyelink)
    
    if EyeTracker==1
        if site==3
            EyetrackerType=2; %1 = Eyelink, 2 = Vpixx
        else
            EyetrackerType=1; %1 = Eyelink, 2 = Vpixx
        end
        eyetrackerparameters % set up Eyelink eyetracker
    else
        EyetrackerType=0;
    end
    %% Stimuli creation
    
    PreparePRLpatch % here I characterize PRL features
    %       stimulusduration=2.2; % stimulus duration during actual sessions
    
    % Gabor stimuli
    if trainingType==1 || trainingType==4
        createGabors
    end
    
    if trainingType==2 || trainingType==4
        CIShapesIV
    end
    
    % create flickering Os
    if trainingType>1
        createO
    end
    
    %% calibrate eyetracker, if Eyelink
    if EyetrackerType==1
        eyelinkCalib
    end
    %% Trial matrix definition
    
    % initialize jitter matrix
    if trainingType==2 || trainingType==4
        shapes=3; % how many shapes per day?
        JitList = 0:1:90;
        StartJitter=1;
        JitListprog=0:2:28
        
    end
    %define number of trials per condition
    if trainingType==1
        conditionOne=1; %only Gabors
        conditionTwo=1; %currently not needed for this training type
        if demo==1
            trials=5; %total number of trials per staircase
        else
            trials=500;  %total number of trials per staircase
        end
    elseif trainingType==2
        conditionOne=shapes; % shapes (training type 2)
        conditionTwo=1; %currently not needed for this training type
        if demo==1
            trials=5; %total number of trials per staircase (per shape)
        else
            trials= 166;  %total number of trials per staircase (per shape, we have 3 per day)
        end
    elseif trainingType==3
        conditionOne=1; %only landolt C
        conditionTwo=2; % endogenous or exogenous cue
        if demo==1
            trials=5;
        else
            trials= 62; %total number of trials per stimulus (250 trials
            %per cue condition divided by 4 because of the 'hold trial
            %location' later)
        end
    elseif trainingType==4
        
        % 420 total trials, divided as: 6 blocks of 14 switch trials per
        % cue type (14 endo + 14 exo). 14 switch trials are 35 total trials
        % per cue type. 2 cue types = 70 trials per block 
        % conditionOne=2; %gabors or contours
        conditionTwo=2; % high or low visibility cue
   %     if demo==1
    %        trialsContrast=5;
     %       trialsShape=4;
     %   else
            trialsContrast=3;
            trialsShape=1;
    %    end
    end

    %create trial matrix
    if trainingType<3 % trial matrix for training type 1 and 2 are structurally similar,
        %with Training type 2 having multiple stimulus types (shapes) per
        %session
        mixcond=fullfact([conditionOne conditionTwo]); %full factorial design
        % restructuring to assign 2 to the last column
        mixtr=[];
        for ui=1:conditionOne
            mixtr=[mixtr; repmat(mixcond(ui,:),trials,1) ];
        end
        mixtr=[mixtr ones(length(mixtr(:,1)),1)];
       
    elseif trainingType==3
        mixcond=fullfact([conditionOne conditionTwo]);
        mixtr=[];
        for ui=1:conditionTwo
            mixtr=[mixtr; repmat(mixcond(ui,:),trials,1) ];
        end
        mixtr=[mixtr ones(length(mixtr(:,1)),1) ];
        mixtr =mixtr(randperm(length(mixtr)),:);

    elseif trainingType==4 % more complex structure, we have type of shapes
        %(for Gabor it's always the same, for shapes it will have 6 types per
        %session; type of stimuli (shapes/Gabors), type of cue (exo vs
        %endo)

        % type of stimulus, shapes, type of cue
        mixcondShapes=fullfact([shapes conditionTwo 1]);
        mixcondShapes=[mixcondShapes(:,1:2) mixcondShapes(:,3)+1 ];
        mixcondGabor=fullfact([1 conditionTwo 1]);
        coin= randi(2); % shall we start with exo or endo cue trials?
        if coin ==1
            mixcondGabor= [mixcondGabor(2,:) ; mixcondGabor(1,:) ];
            mixcondShapes = [mixcondShapes(length(mixcondShapes)/2+1: end, :); mixcondShapes(1:length(mixcondShapes)/2,:)];
        end
        mixtr=[];
        % divide the number of trials by 4 because we have the 'hold
        % location' later that will increase the number of trials
        %         mixtr_gabor=[repmat(mixcond2,round(trialsContrast/4),1) ];
        mixtr_gabor=[repmat(mixcondGabor,round(trialsContrast),1) ];
        mixtr_shapes=[repmat(mixcondShapes,round(trialsShape),1) ];
        mixtr_shapes = sortrows(mixtr_shapes,1);
        %   [B,~,gi] = unique(mixtr_shapes(:,1),'rows','stable');
        %    B(:,3) = accumarray(gi(:), mixtr_shapes(:,3)); %, [], @max);
%        block_n=length(mixtr_shapes)/3;
 %       block_n=10;
        %         block_n=length(mixtr_gabor)/3;
        if demo==1
            mixtr=[mixtr_gabor;mixtr_shapes];
        else
            mixtr=[mixtr_gabor(1:2,:);mixtr_shapes(1:2,:); mixtr_gabor(3:4,:); mixtr_shapes(3:4,:);mixtr_gabor(5:6,:);mixtr_shapes(5:6,:)];
        end
      
        %mixtr(:,1) = shape type (for gabor always 1, for shapes 1-3)
        %mixtr(:,2) = cue type (1: endo, 2: exo)
        %mixtr(:,3) = task type (1: Gabor, 2: CI)
        trials_per_block=35; %overall trials per block
        trials_per_block_before_hold=trials_per_block/2.5; % because we  have equal number of 2 and 3 consecutive trials per location in the hold trials
        % create an array of hold trials equally split into 2 and 3 trials hold
        hold_mat= [ones(trials_per_block_before_hold/2,1)*2; ones(trials_per_block_before_hold/2,1)*3];
        % randomize occurence of 2 and 3 hold trials
        hold_mat=hold_mat(randperm(length(hold_mat)),:);
    end

    %% STAIRCASE
    nsteps=70; % elements in the stimulus intensity list (contrast or jitter or TRL size in training type 3)
    if trainingType~=3
        stepsizes=2; % step sizes for staircases
        % Threshold -> 79%
        sc.up = 1;   % # of incorrect answers to go one step up
        sc.down = 3;  % # of correct answers to go one step down
        SFthreshmin=0.01;     % contrast value below which we increase SF
        SFthreshmax=0.2; % contrast value above which we decrease SF
        SFadjust=10; % steps to go up in the contrast list (easier) once we increase SF
        
        if trainingType==2 || trainingType==4
            load NewShapeMat.mat;         % shape parameters for each session of training
            shapeMat=[shapeMat(1,:); shapeMat(2,:); shapeMat(3,:) ] ;
            shapesoftheDay=shapeMat(:,expDay);
            if demo==1
                shapeMat = shapeMat(:,expDay);
            end
        end
        if expDay==1      % trainingType~=4) || (expDay > 0 && trainingType==4)
            if trainingType==1 || trainingType==4
                if expDay==1 %setting up contrast list and spatial freq for exp 1
                    StartCont=15;  %starting value for Gabor contrast
                    currentsf=4;
                    logUnitStep=0.05;
                    theoris =[-45 45]; % possible orientation of the Gabor
                    Contlist = log_unit_down(max_contrast+.122, logUnitStep, nsteps); % contrast list for trainig type 1 and 4
                    Contlist(1)=1;
                    Contrthresh=StartCont;
                    AllShapes=size((Targy));
                    trackthresh=ones(AllShapes(2),1)*StartJitter;
                end
                if trainingType==1
                    thresh(1:conditionOne, 1:conditionTwo)=StartCont; %Changed from 10 to have same starting contrast as the smaller Contlist
                end
                step=5;
            end
        else
            DAYN = ['\Training\Day' num2str(str2num(answer{2})-1) '\'];
            foldern=fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAYN]);
            if trainingType==2 %trainingType==4 % load thresholds from previous days %uncommented on 7/2
                %OLD DIRECTORY
                %d = dir(['../../datafolder/' SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
                %      NEW DIRECTORY
                d = dir([foldern SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
                
                %                 d=[folder SUBJECT  filename '_' num2sthr(trainingType) '_Day_' num2str(expDay-1) '*.mat']; %makes unique filename
                %[dx,dx] = sort([d.datenum]); %EC changed to .bytes instead of datenum for %running fb1005 day 2 training %PD commented out 11/8/2023
                %newest = d(dx(end)).name;%PD commented out 11/8/2023
                for z=1:length(d)%PD added this for loop to pick up the correct file 11/8/2023
                    und=strfind(d(z).name,'_');
                    zz(z)=logical(strfind(d(z).name,'.')-und(end)<4);
                end
                if sum(zz) > 1
                    [dx,dx] = sort([d.datenum]); % added by EC 11/29/2023: sorts outputs of zz by datenum if there are more than one instances of a certain training day
                    dt = dx(end);
                else
                    dt=find(zz==1);
                end %PD addedd  this to pick up the correct file 11/8/2023
                newest=d(dt).name;%PD addedd  this to pick up the correct file 11/8/2023
                last_staircounter=load([foldern newest],'staircounter');
                lasttrackthresh=load([foldern newest],'trackthresh');
                trackthresh=lasttrackthresh.trackthresh;
                Contrthresh=lastContrthresh.Contrthresh;
                Contlist2=load([foldern newest],'Contlist');  %% em, please check if we need this
                Contlist = Contlist2.Contlist;
                lasttracksf=load([foldern newest],'currentsf');
                currentsf=lasttracksf.currentsf;
                theoris =[-45 45]; % possible orientation of the Gabor
                thresh=trackthresh(shapesoftheDay);
            elseif trainingType==1 || trainingType==4
                d = dir([foldern SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
                %                 [dx,dx] = sort([d.datenum]);%PD commented out 11/8/2023
                %                 newest = d(dx(end)).name;%PD commented out 11/8/2023
                for z=1:length(d)%PD added this for loop to pick up the correct file 11/8/2023
                    und=strfind(d(z).name,'_');
                    zz(z)=logical(strfind(d(z).name,'.')-und(end)<4);
                end
                if sum(zz) > 1
                    [dx,dx] = sort([d.datenum]); % added by EC 11/29/2023: sorts outputs of zz by datenum if there are more than one instances of a certain training day
                    dt = dx(end);
                else
                    dt=find(zz==1);%PD addedd  this to pick up the correct file 11/8/2023
                end
                newest=d(dt).name;%PD addedd  this to pick up the correct file 11/8/2023
                lasttrackthresh=load([foldern newest],'thresh');
                thresh=lasttrackthresh.thresh;
                Contlist2=load([foldern newest],'Contlist');
                Contlist = Contlist2.Contlist;
                lasttracksf=load([foldern newest],'currentsf');
                currentsf=lasttracksf.currentsf;
                theoris =[-45 45]; % possible orientation of the Gabor
                AllShapes=size((Targy));
                Contrthresh=thresh(1,1)
                trackthresh=ones(AllShapes(2),1)*StartJitter
            end
        end
        if trainingType<4
            reversals(1:conditionOne, 1:conditionTwo)=0;
            isreversals(1:conditionOne, 1:conditionTwo)=0;
            staircounter(1:conditionOne, 1:conditionTwo)=0;
            corrcounter(1:conditionOne, 1:conditionTwo)=0;
        elseif trainingType==4
            reversals=zeros(shapes,2);
            isreversals=zeros(shapes,2);
            staircounter=zeros(shapes,2);
            corrcounter=zeros(shapes,2);
            thresh(:,2)=trackthresh(shapesoftheDay);
            thresh(:,1)=Contrthresh;
        end
    end
        
        % training type 3 has its own structure, no behavioral performance
        % recorded except for eye movements, no keys to press
        if trainingType==3 || trainingType==4
            if expDay==1 && trainingType==3 || trainingType==4 && expDay >0
                sizeArray=log_unit_down(1.99, 0.008, nsteps); % array of TRL size: the larger, the easier the task (keeping the target within the PRL)
                persistentflickerArray=log_unit_up(0.08, 0.026, nsteps); % array of flickering persistence: the lower, the easier the task (keeping the target within the PRL for tot time)
                %higher pointer=more difficult
                % TRL size parameter
                if trainingType==3
                    sizepointer=15;
                else
                    sizeArray=log_unit_down(3, 0.008, nsteps);
                    sizepointer = 15;
                    
                end
                coeffAdj=sizeArray(sizepointer); % possible list of TRL size (proportion of TRL size) that allows frames to be counted as 'within the TRL'
                % flcikering time parameter
                flickerpointerPre=15;
                flickerpointerPost=15;
                timeflickerallowed=persistentflickerArray(flickerpointerPre); % time before flicker starts
                flickerpersistallowed=persistentflickerArray(flickerpointerPost); % time away from flicker in which flicker persists
            end
            
            if expDay>1 && trainingType==3 % if we are not on day one, we load thresholds from previous days
                DAYN = ['\Training\Day' (answer{2,:}-1) '\'];
                foldern=fullfile(folderchk, ['..\..\datafolder\' SUBJECT DAYN]);
                sizeArray=log_unit_down(1.99, 0.008, nsteps);
                persistentflickerArray=log_unit_up(0.08, 0.026, nsteps);
                
                d = dir([foldern SUBJECT '_FLAPtraining_type_' num2str(trainingType) '_Day_' num2str(expDay-1) '*.mat']);
                
                [dx,dx] = sort([d.datenum]);
                newest = d(dx(end)).name;
                %  oldthresh=load(['./data/' newest],'thresh');
                previousFixTime2=load([foldern newest],'movieDuration');
                %previousresp=load(['./data/' newest],'rispo');
                previoustrials2=load([foldern newest],'trials');
                coeffAdj2=load([foldern newest],'coeffAdj');
                sizepointer2=load([foldern newest],'sizepointer');
                flickerpointerPre2 = load([foldern newest],'flickerpointerPre');
                flickerpointerPost2 = load([foldern newest],'flickerpointerPost');
                coeffAdj = coeffAdj2.coeffAdj;
                previousFixTime = previousFixTime2.movieDuration;
                previoustrials = previoustrials2.trials;
                sizepointer = sizepointer2.sizepointer;
                flickerpointerPre = flickerpointerPre2.flickerpointerPre;
                flickerpointerPost = flickerpointerPost2.flickerpointerPost;
                %             if sum(previousresp)/previoustrials< 0.8
                %                 coeffAdj=1.3;
                %             elseif  sum(previousresp)/previoustrials> 0.8
                %                 coeffAdj=1;
                %             end
            end
        end

    %% Trial structure

    if trainingType==3
        % 1: shape type (1-6 for shapes, 1 for Gabors), 2: cue type (exo or endo), 3: stimulus type (gabor of shapes)
        if holdtrial==1 % if we want to hold target position for few consecutive trials
            
            newmat = [];
            theoriginalmat=mixtr;
            mixtr=[mixtr (1:length(theoriginalmat))'];
            for i=1:length(mixtr) % clone trials from original trial matrix
                %to have a series of stimuli presented in the same location
                newfirstone=mixtr(i,:);
                repnum=randi(2)+1;
                tempmat=repmat([newfirstone],repnum,1);
                newmat=[newmat;tempmat];
            end
            mixtr=newmat;
        end
    end
    if trainingType==4
        if holdtrial==1 % if we want to hold target position for few consecutive trials
            newmat = [];
            theoriginalmat=mixtr;
            for i=1:length(mixtr) % clone trials from original trial matrix
                %to have a series of stimuli presented in the same location
                hold_mat=hold_mat(randperm(length(hold_mat)),:);
                newmixtr{i}= repmat([mixtr(i,:)], length(hold_mat),1);
                newfirstone=newmixtr{i}(i,:);
                for ui=1:length(hold_mat)
                    repnum=hold_mat(ui);
                    %    tempmat=repmat([newfirstone ui],repnum,1);
                    tempmat=repmat([newfirstone ui i],repnum,1);
                    
                    newmat=[newmat;tempmat];
                end
            end
            newmixtr=newmat;
        end
        
        if demo == 1
            mixtr=[newmixtr(1:5,:) ; newmixtr(end-5:end,:)];
        else
            mixtr = newmixtr;
        end
    end
    if annulusOrPRL==1 % annulus for pre-target fixation (default is NOT this)
        % here I define the annulus around the scotoma which allows for a
        % fixation to count as 'valid', i.e., the flickering is on when a
        % fixation is within this region
        [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
        smallradiusannulus=(scotomadeg/2)*pix_deg; % inner circle: scotoma eccentricity
        largeradiusannulus=smallradiusannulus+3*pix_deg; %outer circle (3 degrees from the border of the scotoma
        circlePixels=sx.^2 + sy.^2 <= largeradiusannulus.^2;
        circlePixels2=sx.^2 + sy.^2 <= smallradiusannulus.^2;
        d=(circlePixels2==1);
        newfig=circlePixels;
        newfig(d==1)=0;
        circlePixelsPRL=newfig;
    end
    
    %% Initialize trial loop
    HideCursor;
    if demo==2
        ListenChar(2);
    end
    ListenChar(0);
    
    % check EyeTracker status, if Eyelink
    if EyetrackerType == 1
        status = Eyelink('startrecording');
        if status~=0
            error(['startrecording error, status: ', status])
        end
        Eyelink('message' , 'SYNCTIME');
        location =  zeros(length(mixtr), 6);
    end
    
    checkcounter = 0;
    shapecounter = 0;
    skiptrial = 0;
    skipflag = 0;
    tracktrialnumber = [];
    % currentsf = currentsf.currentsf;
    %% HERE starts trial loop
    for trial=1:length(mixtr)
%         if trainingType==4 && skipflag==1 && mixtr(trial-1,3)~=
%         mixtr(trial,3) %skipflag resets when block is over (rep start of
%         a new block) %decided NOT to carryover shape to shape  
%             if mixtr(trial,3)==2 && shapesoftheDay(1)==shapesoftheDay(2)
%                 staircounter(2,2)=staircounter(1,2) 
%             end
%         end
        if trial > 1 && trainingType == 4 && skipflag == 1
            temptrial = skiptrial - 1;
            randomlocationflag = 1;
            skipflag = 2;
        end
        if trial > 1 && trainingType == 4 && skipflag == 2
            temptrial = temptrial + 1;
            trial = temptrial;
        end
        if trainingType == 4
            tracktrialnumber = [tracktrialnumber; trial];
        end
        checkcounter = checkcounter + 1     
        
        if trainingType == 4 && (mixtr(trial,3) == 2)
            
            coeffAdj = 1;
            possibleTRLlocations=[-8.25 8.25]; %
            PRLecc=[possibleTRLlocations(TRLlocation) 0 ];
            PRLx= PRLecc(1);
            PRLy=-PRLecc(2);
            PRLxpix=PRLx*pix_deg*coeffAdj;
            PRLypix=PRLy*pix_deg*coeffAdj;
            PRLsize=6.5; % for contour make this 6.5 in training type 4
            [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
            
            radiusPRL=(PRLsize/2)*pix_deg;
            circlePixelsPRL=sx.^2 + sy.^2 <= radiusPRL.^2;
            
            imageRectcue = CenterRect([0, 0, [radiusPRL*2 ((radiusPRL/pix_deg)*pix_deg_vert)*2]], wRect);
            
            % mask to cover the target when outside the TRL (if needed)
            [img, sss, alpha] =imread('neutral21.png');
            img(:, :, 4) = alpha;
            Neutralface=Screen('MakeTexture', w, img);
            
            mask_color= [170 170 170];
        elseif trainingType == 4 && (mixtr(trial,3) == 1)
            
            
            coeffAdj = 1;
            possibleTRLlocations=[-7.5 7.5]; %
            PRLecc=[possibleTRLlocations(TRLlocation) 0 ];
            PRLx= PRLecc(1);
            PRLy=-PRLecc(2);
            PRLxpix=PRLx*pix_deg*coeffAdj;
            PRLypix=PRLy*pix_deg*coeffAdj;
            PRLsize=5; % for contour make this 6.5 in training type 4
            [sx,sy]=meshgrid(-wRect(3)/2:wRect(3)/2,-wRect(4)/2:wRect(4)/2);
            
            radiusPRL=(PRLsize/2)*pix_deg;
            circlePixelsPRL=sx.^2 + sy.^2 <= radiusPRL.^2;
            
            imageRectcue = CenterRect([0, 0, [radiusPRL*2 ((radiusPRL/pix_deg)*pix_deg_vert)*2]], wRect);
            
            % mask to cover the target when outside the TRL (if needed)
            [img, sss, alpha] =imread('neutral21.png');
            img(:, :, 4) = alpha;
            Neutralface=Screen('MakeTexture', w, img);
            
            mask_color= [170 170 170];
        end
        
        if trainingType==4 && trial==1
            Welcometype4
        end
        
        
        if trainingType==1 && trial==1 || trial>2 && mixtr(trial,1)~= mixtr(trial-1,1)
            practicePassed=0;
            %         practicePassed=1;
        end
        
        %         if test==2
        %             practicePassed=1;
        %         end
        
        
        if trainingType == 1 || trainingType == 4 && trial==1
            practicePassed=0; % MGR added 5-13
            while practicePassed==0
                FLAP_Training1_Practice_4
            end
        end
        
        if trainingType==2 && trial==1 || trial>2 && mixtr(trial,1)~= mixtr(trial-1,1)
            practicePassed=0;
            %         practicePassed=1;
        end
        
        %         if test==2
        %             practicePassed=1;
        %         end
        
        if trainingType == 2
            while practicePassed==0
                FLAP_Training2_Practice
            end
        end
        
        if trainingType==4 && (mixtr(trial,3)==2 && mixtr(trial-1,3) ==1) || (mixtr(trial,1) ~= mixtr(trial,1))
            practicePassed=2;
            while practicePassed==2
                FLAP_Training2_Practice_4
            end
        end
        
        if trainingType==3 && trial==1 || trial>2 && mixtr(trial,1)~= mixtr(trial-1,1)
            practicePassed=0;
            %         practicePassed=1;
        end
        
        %         if test==2
        %             practicePassed=1;
        %         end
        if trainingType == 3
            while practicePassed==0
                Flap_Training3Practice
            end
        end
        
        
        %         if trainingType==4 && practicePassed==1
        %               InstructionFLAP(w,trainingType,gray,white)        % general instruction TO BE REWRITTEN
        %         end
        
        %% training type-specific staircases
        
        if trainingType==1 || (trainingType==4 && mixtr(trial,3)==1)  %if it's a Gabor trial (training type 1 or 4)
            ssf=sflist(currentsf);
            fase=randi(4);
            texture(trial)=TheGabors(currentsf, fase);
            contr = Contlist(thresh(mixtr(trial,1),mixtr(trial,3)));
        end
        
        if trainingType==2 || (trainingType==4 && mixtr(trial,3)==2) %if it's a CI trial (training type 2 or 4)
            if staircounter(mixtr(trial,1), mixtr(trial,3))>= progtrackend %defined new variable
                Orijit=JitList(thresh(mixtr(trial,1),mixtr(trial,3)));
%                 if mixtr(trial,1)==1 && mixtr(trial,3)==2 %debugging MGR
%                 8-2
%                     threshconc1= horzcat(threshconc1, thresh(mixtr(trial,1),mixtr(trial,3)))
%                 elseif mixtr(trial,1)==2
%                     threshconc2= horzcat(threshconc2, thresh(mixtr(trial,1),mixtr(trial,3)))
%                 elseif mixtr(trial,1)==3
%                     threshconc3= horzcat(threshconc3, thresh(mixtr(trial,1),mixtr(trial,3)))
%                 end
%                 orijitconctprog=horzcat(orijitconctprog, Orijit)
            else
                Orijit=JitListprog(staircounter(mixtr(trial,1),mixtr(trial,3))+1);
%                 if mixtr(trial,1)==1 && mixtr(trial,3)==2 %debugging MGR
%                 8-2
%                     threshconc1prog= horzcat(threshconc1prog, thresh(mixtr(trial,1),mixtr(trial,3)))
%                 elseif mixtr(trial,1)==2
%                     threshconc2prog= horzcat(threshconc2prog, thresh(mixtr(trial,1),mixtr(trial,3)))
%                 elseif mixtr(trial,1)==3
%                     threshconc3prog= horzcat(threshconc3prog, thresh(mixtr(trial,1),mixtr(trial,3)))
%                 end
%                 orijitconct=horzcat(orijitconct, Orijit
            end 
            Tscat=0;
        end
        
        if trainingType==4 %if it's a training type 4 trial, which cue type? high or low visibility cue
            ContCirc= CircConts(mixtr(trial,2));
        end
        if trainingType==3 || trainingType==4 %if it's a training type 3 or 4 trial, how long is the flickering?
            FlickerTime=Jitter(randi(length(Jitter)));
            actualtrialtimeout=realtrialTimeout;
            %   trialTimeout=400000;
            trialTimeout=realtrialTimeout+5;
            
        elseif trainingType==1 || trainingType==2 || demo==1 %if it's a training type 1 or 2 trial, no flicker
            FlickerTime=0;
        end
        %% generate answer for this trial (training type 3 has no button response)
        
        if trainingType==1 ||  (trainingType==4 && mixtr(trial,3)==1)
            theans(trial)=randi(2);
            ori=theoris(theans(trial));
        elseif trainingType==2 || (trainingType==4 && mixtr(trial,3)==2)
            theans(trial)=randi(2);
            CIstimuliModIItest % add the offset/polarity repulsion
        end
        %% target location calculation
        if trainingType==1 || trainingType==2 % if training type 1 or 2, stimulus always presented in the center
            theeccentricity_Y=0;
            theeccentricity_X=PRLx*pix_deg;
            eccentricity_X(trial)= theeccentricity_X;
            eccentricity_Y(trial) =theeccentricity_Y ;
        elseif trainingType==3 % if training type 3 or 4 and not a hold trial, stimulus position spatially randomized
            if trial==1 || sum(mixtr(trial,:)~=mixtr(trial-1,:))>0
                
                % ellipse area within which the stimulus can appear (in
                % dva)
                maj_a = 18; % major axis (horizontal)
                min_b = 10; % minor axis (vrtical)
                % Generate random angles between 0 and 2*pi
                ecc_t = 2 * pi * rand;
                % Generate random radius
                ecc_r = sqrt(rand);
                % Convert polar coordinates to Cartesian coordinates
                xx = ecc_r * maj_a * cos(ecc_t);
                yy = ecc_r * min_b * sin(ecc_t);
                xxyy=[xx*pix_deg yy*pix_deg_vert ];
                
                %                 ecc_r=(r_lim*pix_deg).*rand(1,1);
                %                 ecc_t=2*pi*rand(1,1);
                %                 cs= [cos(ecc_t), sin(ecc_t)];
                %                 xxyy=[ecc_r ecc_r].*cs;
                ecc_x=xxyy(1);
                ecc_y=xxyy(2);
                eccentricity_X(trial)=ecc_x;
                eccentricity_Y(trial)=ecc_y;
                theeccentricity_X=ecc_x;
                theeccentricity_Y=ecc_y;
                %   xlimit=[-8:0.5:8]*pix_deg;
                %  ylimit=xlimit;
                %   theeccentricity_X=xlimit(randi(length(xlimit)));
                %  theeccentricity_Y=ylimit(randi(length(xlimit)));
            else
                eccentricity_X(trial) = eccentricity_X(trial-1);
                eccentricity_Y(trial) = eccentricity_Y(trial-1);
            end
        end
        if trainingType == 4 
            if trial==1 || sum(mixtr(trial,:)~=mixtr(trial-1,:))>0 %|| randomlocationflag == 1
                ecc_r=(r_lim*pix_deg).*rand(1,1);
                ecc_t=2*pi*rand(1,1);
                cs= [cos(ecc_t), sin(ecc_t)];
                xxyy=[ecc_r ecc_r].*cs;
                ecc_x=xxyy(1);
                ecc_y=xxyy(2);
                eccentricity_X(trial)=ecc_x;
                eccentricity_Y(trial)=ecc_y;
                theeccentricity_X=ecc_x;
                theeccentricity_Y=ecc_y;
                %   xlimit=[-8:0.5:8]*pix_deg;
                %  ylimit=xlimit;
                %   theeccentricity_X=xlimit(randi(length(xlimit)));
                %  theeccentricity_Y=ylimit(randi(length(xlimit)));
            elseif randomlocationflag == 0
                eccentricity_X(trial) = eccentricity_X(tracktrialnumber(end - 1));
                eccentricity_Y(trial) = eccentricity_Y(tracktrialnumber(end - 1));
            end
        end

        if trial==length(mixtr)
            endExp=GetSecs; %time at the end of the session
        end

        if demo==2 && trainingType ~= 4
            if mod(trial,round(length(mixtr)/8))==0 %|| trial== length(mixtr)/4 || trial== length(mixtr)/4
                interblock_instruction
            end

        end
        if trainingType==2
            if trial==1
                InstructionShape
            elseif trial>1
                if mixtr(trial,1)~=mixtr(trial-1,1)
                    InstructionShape
                end
            end
        end
        
     if trainingType == 4 && trial == 1 || randomlocationflag == 1
            InstructionTrainingTask4
            randomlocationflag = 0;
     end
    
        %  destination rectangle for the target stimulus
        imageRect_offs =[imageRect(1)+theeccentricity_X, imageRect(2)+theeccentricity_Y,...
            imageRect(3)+theeccentricity_X, imageRect(4)+theeccentricity_Y];

        %  destination rectangle for the fixation dot
        imageRect_offs_dot=[imageRectDot(1)+theeccentricity_X, imageRectDot(2)+theeccentricity_Y,...
            imageRectDot(3)+theeccentricity_X, imageRectDot(4)+theeccentricity_Y];


        %% initializing response box (if needed)

        if responsebox==1
            Bpress=0;
            timestamp=-1;
            TheButtons=-1;
            inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error
            % saying that inter_buttonpress was not assigned.
            % 26 June 2018
            RespTime=[];
            binaryvals=[];
            bin_buttonpress{1}=[]; % Jerry:use array instead of cell
            inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
            %
            % Datapixx('RegWrRd');
            % buttonLogStatus = Datapixx('GetDinStatus');

            % if buttonLogStatus.logRunning~=1 % initialize digital input log if not up already.
            %     Datapixx('SetDinLog'); %added by Jerry
            %     Datapixx('StartDinLog');
            %     Datapixx('RegWrRd');
            %     buttonLogStatus = Datapixx('GetDinStatus');
            %     Datapixx('RegWrRd');
            % end
            % if ~exist('starttime','var') % var added by Jason
            %     Datapixx('RegWrRd');
            %     starttime=Datapixx('GetTime');
            % elseif  isempty(starttime)  % modified by Jerry from else to elseif
            %     Datapixx('RegWrRd');
            %     starttime=Datapixx('GetTime');
            % end

            % Configure digital input system for monitoring button box
            Datapixx('SetDinDataDirection', hex2dec('1F0000'));     % Drive 5 button lights
            Datapixx('EnableDinDebounce');                          % Debounce button presses
            Datapixx('SetDinLog');                                  % Log button presses to default address
            Datapixx('StartDinLog');                                % Turn on logging
            Datapixx('RegWrRd');
            % Wait until all buttons are up
            while (bitand(Datapixx('GetDinValues'), hex2dec('FFFF')) ~= hex2dec('FFFF'))
                Datapixx('RegWrRd');
            end
            % Flush any past button presses
            Datapixx('SetDinLog');
            Datapixx('RegWrRd');
        end
        %% Initialization/reset of several trial-based variables
        FLAPVariablesReset % reset some variables used in each trial
        if trial==1
            startExp=GetSecs; %time at the beginning of the session
            Datapixx('RegWrRd');
            blocktime=Datapixx('GetTime');
        end
        
        if trial>1
            if mixtr(trial, end) ~= mixtr(trial-1, end) %|| mixtr(trial, end) ~= mixtr(end,end)+1 %mixtr(trial, end) == mixtr(end, end)-1
                Datapixx('RegWrRd');
                blocktime=Datapixx('GetTime');
            end
        end
        while eyechecked<1
            if datapixxtime==1
                Datapixx('RegWrRd');
                eyetime2=Datapixx('GetTime');
            end
            if EyetrackerType ==2
                Datapixx('RegWrRd');
            end
            if trainingType<3
                fixationscriptW % visual aids on screen
            end
            fixating=1500;

            if trainingType>2 && trial>1 %if it's training 3 or 4 trial, we evaluate whether it's a cue trial
                %    if mixtr(trial,2)~=mixtr(trial-1,2) || mixtr(trial,2)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1

                if mixtr(trial,4)~=mixtr(trial-1,4)
                    if mixtr(trial,2)==1 %if it's endogenous cue
                        %calculations for arrow pointing to the next location (endo cue)
                        nexcoordx=(imageRect_offs(1)+imageRect_offs(3))/2;
                        nexcoordy=(imageRect_offs(2)+imageRect_offs(4))/2;
                        previouscoordx=(rectimage{kk-1}(1)+rectimage{kk-1}(3))/2;
                        previouscoordy=(rectimage{kk-1}(2)+rectimage{kk-1}(4))/2;
                        delta=[previouscoordx-nexcoordx previouscoordy-nexcoordy];
                        oriArrow(trial)=atan2d(delta(2), delta(1));
                        oriArrow(trial)=oriArrow(trial)-90;
                    elseif mixtr(trial,2)==2 %if it's exogenous cue (circle flashing to the next location)
                    end
                end
                currentExoEndoCueDuration=ExoEndoCueDuration(mixtr(trial,2));
            else
                currentExoEndoCueDuration=ExoEndoCueDuration(1);
            end
            %% here is where the first time-based trial loop starts (until first forced fixation is satisfied)
            if (eyetime2-trial_time)>=ifi*2 && (eyetime2-trial_time)<ifi*2+preCueISI && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                % pre-event empty space, allows for some cleaning
                if trainingType==1 || trainingType==2 % no flicker type of training trial
                    counterflicker=-10000;
                end

            elseif (eyetime2-trial_time)>=ifi*2+preCueISI && (eyetime2-trial_time)<+ifi*2+preCueISI+currentExoEndoCueDuration && fixating>400 && stopchecking>1 && (eyetime2-pretrial_time)<=trialTimeout
                if exist('startrial') == 0
                    if datapixxtime==1
                        trialstart(trial)=Datapixx('GetTime');
                        trialstart_frame(trial)=eyetime2;
                    else
                        trialstart(trial)=GetSecs;
                        trialstart_frame(trial)=eyetime2;
                        %   startfix(trial)=eyetime2;
                    end
                    startrial=1;
                end
                % HERE I present the cue for training types 3 and 4 or skip
                % this interval for training types 1 and 2

                if trainingType>2 && trial>1
                    %   if mixtr(trial,2)~=mixtr(trial-1,2) || mixtr(trial,3)==2 && mixtr(trial,1)~=mixtr(trial-1,1) % ||  trial==1
                    if mixtr(trial,4)~=mixtr(trial-1,4)
                        if mixtr(trial,2)==1 %endogenous cue
                            newrectimage{kk}=[rectimage{kk-1}(1)-2*pix_deg rectimage{kk-1}(2)-2*pix_deg rectimage{kk-1}(3)+2*pix_deg rectimage{kk-1}(4)+2*pix_deg ];
                            Screen('DrawTexture', w, theArrow, [], rectimage{kk-1}, oriArrow(trial),[], 1);
                            realcuecontrast=cuecontrast*0.1;
                            isendo=1;
                            contrastcounter=0;
                        elseif mixtr(trial,2)==2 %exogenous cue
                            Screen('FrameOval', w,scotoma_color, imageRect_offs, 22, 22);
                            isendo=0;
                        end
                    else
                        isendo=0;
                    end
                elseif trainingType>2 && trial==1
                    isendo=0;
                end
            elseif (eyetime2-trial_time)>=ifi*2+preCueISI+currentExoEndoCueDuration+postCueISI && fixating>400 && stopchecking>1 && flickerdone<1 && counterannulus<=AnnulusTime/ifi && counterflicker<FlickerTime/ifi  && (eyetime2-pretrial_time)<=trialTimeout
                % here I need to reset the trial time in order to preserve
                % timing for the next events (first fixed fixation event)
                % HERE interval between cue disappearance and beginning of
                % next stream of flickering stimuli

                %keyCode(escapeKey) ==0
                if trainingType~=3 % no more dots!
                    Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                end
                if skipforcedfixation==1 % skip the forced fixation
                    counterannulus=(AnnulusTime/ifi)+1;
                    skipcounterannulus=1000;
                else %force fixation for training types 1 and 2
                    if trainingType<3
                        [counterannulus framecounter ]=  IsFixatingSquareNew2(wRect,newsamplex,newsampley,framecounter,counterannulus,fixwindowPix);
                    elseif trainingType>2
                        [counterannulus framecounter ]=  IsFixatingPRL3(newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,EyetrackerType,theeccentricity_X,theeccentricity_Y,framecounter,counterannulus);
                    end
                    if trainingType~=3 % no more dots!
                        %                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    elseif trainingType==3 %force fixation for training types 3
                        if exist('isendo') == 0
                            isendo=0;
                        end
                        if isendo==1 % if is endo trial we slowly increase the visibility of the cue
                            if mod(round(eyetime2-trial_time),100)
                                contrastcounter=contrastcounter+1;
                                realcuecontrast=(cuecontrast*0.45)+(contrastcounter/2000);
                            end
                            Screen('FillOval', w, realcuecontrast, imageRect_offs_dot);
                        elseif isendo==0
                            realcuecontrast=cuecontrast;
                            Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], realcuecontrast);
                        end
                    end
                    if counterannulus==round(AnnulusTime/ifi) % when I have enough frame to satisfy the fixation requirements
                        if datapixxtime==1
                            Datapixx('RegWrRd');
                            newtrialtime=Datapixx('GetTime');
                        else
                            newtrialtime=GetSecs;
                        end
                        skipcounterannulus=1000;
                    end
                end
                if responsebox==0
                    if  keyCode(escapeKey) ~=0   % HERE I exit the script if I press ESC
                        thekeys = find(keyCode);
                        closescript=1;
                        break;
                    end
                end
            end
            %% here is where the second time-based trial loop starts
            if (eyetime2-newtrialtime)>=forcedfixationISI && fixating>400 && stopchecking>1 && skipcounterannulus>10 && counterflicker<=FlickerTime/ifi && flickerdone<1 && (eyetime2-pretrial_time)<=trialTimeout
                % HERE starts the flicker for training types 3 and 4, if
                % training type is 1 or 2, this is skipped

                if exist('flickerstar') == 0 % start flicker timer
                    flicker_time_start(trial)=eyetime2; % beginning of the overall flickering period
                    flickerstar=1;
                    flickswitch=0;
                    flick=1;
                end
                if datapixxtime==1
                    Datapixx('RegWrRd');
                    tempFlickTime=Datapixx('GetTime');
                    flicker_time=tempFlickTime-flicker_time_start(trial);     % timer for the flicker decision
                else
                    flicker_time=GetSecs-flicker_time_start(trial);     % timer for the flicker decision
                end
                if flicker_time>flickswitch % time to flicker?
                    flickswitch= flickswitch+flickeringrate;
                    flick=3-flick; % flicker/non flicker
                end
                if trainingType>2 && demo==2  % Force flicker here (training type 3 and 4)
                    if EyeTracker==1
                        [countgt framecont countblank blankcounter counterflicker turnFlickerOn]=  ForcedFixationFlicker3(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, EyeData, counterflicker,eyetime2,EyeCode,turnFlickerOn);
                    else
                        %  [countgt framecont countblank blankcounter counterflicker turnFlickerOn eyerunner]=  ForcedFixationFlicker3mouse(w,countgt,countblank, framecont, newsamplex,newsampley,wRect,PRLxpix,PRLypix,circlePixelsPRL,theeccentricity_X,theeccentricity_Y,blankcounter,framesbeforeflicker,blankframeallowed, counterflicker,eyetime2,turnFlickerOn);
                        ForcedFixationFlicker3mouse
                    end
                end

                % from ForcedFixationFlicker3, should I show the flicker or not?
                if turnFlickerOn(end)==1 %flickering cue
                    if flick==2
                        if trainingType==3
                            Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                        elseif trainingType==4
                            Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                        end
                    end
                elseif turnFlickerOn(end)==0 %non-flickering cue
                    if trainingType==3
                        Screen('DrawTexture', w, theCircles, [], imageRect_offs, [],[], 1);
                    elseif trainingType==4
                        Screen('FillOval', w, fixdotcolor, imageRect_offs_dot);
                    end
                end
                if exist('circlestar')==0
                    if datapixxtime==1
                        Datapixx('RegWrRd');
                        circle_start=Datapixx('GetTime');
                    else
                        circle_start = GetSecs;
                    end
                    circlestar=1;
                end

                if datapixxtime==1
                    Datapixx('RegWrRd');
                    cue_last=Datapixx('GetTime');
                else
                    cue_last=GetSecs;
                end

                if trainingType>2 && counterflicker>=round(FlickerTime/ifi) || trainingType<3 || demo==1
                    if datapixxtime==0
                        newtrialtime=GetSecs; % when fixation constrains are satisfied, I reset the timer to move to the next series of events
                    else
                        Datapixx('RegWrRd');
                        newtrialtime=Datapixx('GetTime');% when fixation constrains are satisfied, I reset the timer to move to the next series of events
                    end
                    flickerdone=10;
                    flicker_time_stop(trial)=eyetime2; % end of the overall flickering period
                end
            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
                % HERE I PRESENT THE TARGET

                if trainingType==3
                    eyechecked=10^4; % if it's training type 3, we exit the trial, good job
                    if skipmasking==0
                        if trainingType~=3
                            assignedPRLpatch
                        end
                    end
                elseif trainingType==1 || (trainingType==4 && mixtr(trial,3)==1)
                    Screen('DrawTexture', w, texture(trial), [], imageRect_offs, ori,[], contr );
                    if skipmasking==0
                        assignedPRLpatch
                    end
                elseif trainingType==2 || (trainingType==4 && mixtr(trial,3)==2)
                    if exist('imageRect_offsCI')==0    % destination rectangle for CI stimuli
%                         if trainingType == 2
                   %         imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(2)+eccentricity_YCI'+eccentricity_Y(trial),...
                   %             imageRectSmall(3)+eccentricity_XCI'+eccentricity_X(trial), imageRectSmall(4)+eccentricity_YCI'+eccentricity_Y(trial)];
                            
                            imageRect_offsCI =[imageRectSmall(1)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(2)+eccentricity_YCI'+theeccentricity_Y,...
                                imageRectSmall(3)+eccentricity_XCI'+theeccentricity_X, imageRectSmall(4)+eccentricity_YCI'+theeccentricity_Y];  
%                         elseif trainingType == 4
%                             imageRect_offsCI =[imageRect_offs(1)+eccentricity_XCI'+eccentricity_X(trial), imageRect_offs(2)+eccentricity_YCI'+eccentricity_Y(trial),...
%                                 imageRect_offs(3)+eccentricity_XCI'+eccentricity_X(trial), imageRect_offs(4)+eccentricity_YCI'+eccentricity_Y(trial)];
%                         end
                        imageRect_offsCI2=imageRect_offsCI;
                        %   imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)*1.56 (xs/coeffCI*pix_deg)*1.56]], wRect);
                        %          imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)+pix_deg*2 (xs/coeffCI*pix_deg)]+pix_deg*2 ], wRect);
                        %          imageRectMask = CenterRect([0, 0, [ (xs/coeffCI*pix_deg)+pix_deg*2 (xs/coeffCI*pix_deg_vert)]+pix_deg_vert*2 ], wRect);
                        imageRectMask = CenterRect([0, 0,  CIstimulussize+maskthickness CIstimulussize+maskthickness ], wRect);
                        %    imageRectMask = CenterRect([0, 0, [ (stimulusSize*2*pix_deg) (stimulusSize*2*pix_deg_vert)] ], wRect);
                   %     imageRect_offsCImask=[imageRectMask(1)+eccentricity_X(trial), imageRectMask(2)+eccentricity_Y(trial),...
                  %          imageRectMask(3)+eccentricity_X(trial), imageRectMask(4)+eccentricity_Y(trial)];
                        
                         imageRect_offsCImask=[imageRectMask(1)+theeccentricity_X, imageRectMask(2)+theeccentricity_Y,...
                            imageRectMask(3)+theeccentricity_X, imageRectMask(4)+theeccentricity_Y];
                        
                    end
                    %here I draw the target contour
                    Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], Dcontr );
                    imageRect_offsCI2(setdiff(1:length(imageRect_offsCI),targetcord),:)=0;
                    if demo==1
                        Screen('DrawTextures', w, TheGaborsSmall, [], imageRect_offsCI2' + [xJitLoc+xModLoc; yJitLoc+yModLoc; xJitLoc+xModLoc; yJitLoc+yModLoc], theori,[], 0.7 );
                    end
                    % here I draw the circle within which I show the contour target
                    Screen('FrameOval', w,[gray], imageRect_offsCImask, maskthickness/2, maskthickness/2);
                    %                    Screen('FrameOval', w,[gray*1.5], imageRect_offsCImask, 1, 1);
                    if trainingType==2
                        fixationscriptW
                    end
                    if skipmasking==0
                        assignedPRLpatch
                    end
                    imagearray{trial}=Screen('GetImage', w);

                end

                if exist('stimstar') == 0
                    stim_startT(trial)=eyetime2;
                    stim_start=eyetime2;
                    stim_startPTB = GetSecs;
                    if EyetrackerType ==2
                        %set a marker to get the exact time the screen flips
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        Pixxstruct(trial).TargetOnset = Datapixx('GetMarker');
                        Pixxstruct(trial).TargetOnset2 = Datapixx('GetTime');
                    end

                    if responsebox==1
                        Datapixx('SetMarker');
                        Datapixx('RegWrVideoSync');
                        %collect marker data
                        Datapixx('RegWrRd');
                        stim_startBox2(trial)= Datapixx('GetMarker');
                        stim_startBox(trial)=Datapixx('GetTime');
                    end
                    stimstar=1;
                end

                % start counting timeout for the non-fixed time training
                % types 3 and 4
                if trainingType>2
                    if exist('checktrialstart')==0
                        trialTimeout=actualtrialtimeout+(stim_start-pretrial_time);
                        checktrialstart=1;
                    end
                end

            elseif (eyetime2-newtrialtime)>=forcedfixationISI && (eyetime2-newtrialtime)<=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout  && stopchecking>1 %present pre-stimulus and stimulus

                if responsebox==0
                    if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);

                        if datapixxtime==0
                            [secs  indfirst]=min(thetimes);
                            respTimeT(trial)=secs;
                            respTime=GetSecs;
                        else
                            respTimeT(trial)=eyetime2;
                            respTime=eyetime2;
                        end
                    end
                    eyechecked=10^4; % exit loop for this trial
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        actualsecs{trial}= secs;
                        if length(secs)>1
                            if sum(thekeys(1)==RespType)>0
                                thekeys=thekeys(1);
                                secs=secs(1);
                            elseif sum(thekeys(2)==RespType)>0
                                thekeys=thekeys(2);
                                secs=secs(2);
                            end
                        end
                        respTime(trial)=secs;
                        eyechecked=10^4;
                    end
                end
            elseif (eyetime2-newtrialtime)>=forcedfixationISI+stimulusduration && fixating>400 && skipcounterannulus>10  && flickerdone>1  && (eyetime2-pretrial_time)<=trialTimeout && stopchecking>1 %present pre-stimulus and stimulus
                if responsebox==0
                    if keyCode(RespType(1)) + keyCode(RespType(2)) + keyCode(RespType(3)) + keyCode(RespType(4)) + keyCode(escapeKey) ~=0
                        thekeys = find(keyCode);
                        if length(thekeys)>1
                            thekeys=thekeys(1);
                        end
                        thetimes=keyCode(thekeys);
                        [secs  indfirst]=min(thetimes);

                        if datapixxtime==0
                            [secs  indfirst]=min(thetimes);
                            respTimeT(trial)=secs;
                            respTime=GetSecs;
                        else
                            respTimeT(trial)=eyetime2;
                            respTime=eyetime2;
                        end
                    end
                    eyechecked=10^4; % exit loop for this trial
                elseif responsebox==1
                    if (buttonLogStatus.newLogFrames > 0)
                        %em modified on 12/4/2023, added lines 976-982, if length(sec)>1 through eyechecked 10^4; makes sure that the correct value is taken for button press more than one input is received
                        if length(secs)>1
                            if sum(thekeys(1)==RespType)>0
                                thekeys=thekeys(1);
                                secs=secs(1);
                            elseif sum(thekeys(2)==RespType)>0
                                thekeys=thekeys(2);
                                secs=secs(2);
                            end
                        end
                        eyechecked=10^4;
                        respTime(trial)=secs; %em moved to after if statement 12/4/2023
                    end
                end
            elseif (eyetime2-pretrial_time)>=trialTimeout
                stim_stop=eyetime2;
                trialTimedout(trial)=1;
                %    [secs  indfirst]=min(thetimes);
                if responsebox==1
                    Datapixx('StopDinLog');
                end
                eyechecked=10^4; % exit loop for this trial
            end

            %% here I draw the scotoma, elements below are called every frame
            eyefixation5
            if ScotomaPresent == 1 % do we want the scotoma? (default is yes)
                Screen('FillOval', w, scotoma_color, scotoma);
                if trainingType == 3
                    visiblePRLring
                end
                if trainingType == 4
                    visiblePRLring %T4
                end
            else % else we get a fixation cross and no scotoma
                Screen('DrawLine', w, colorfixation, wRect(3)/2, wRect(4)/2-fixationlength, wRect(3)/2, wRect(4)/2+fixationlength, 4);
                Screen('DrawLine', w, colorfixation, wRect(3)/2-fixationlength, wRect(4)/2, wRect(3)/2+fixationlength, wRect(4)/2, 4);
            end
            if demo==2
                if penalizeLookaway>0
                    if newsamplex>wRect(3) || newsampley>wRect(3) || newsamplex<0 || newsampley<0
                        Screen('FillRect', w, gray);
                    end
                end
            end


            if datapixxtime==1
                [eyetime3, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime3];
            else
                [eyetime2, StimulusOnsetTime, FlipTimestamp, Missed]=Screen('Flip',w);
                VBL_Timestamp=[VBL_Timestamp eyetime2];
            end

            %% process eyedata in real time (fixation/saccades)
            dd=49;
            if EyeTracker==1
                GetEyeTrackerDataNew
                GetFixationDecision
                if EyeData(end,1)<8000 && stopchecking<0
                    if datapixxtime==1
                        Datapixx('RegWrRd');
                        trial_time = Datapixx('GetTime');
                    else
                        trial_time = GetSecs; %start timer if we have eye info
                    end
                    stopchecking=10;
                end
                if EyeData(end,1)>8000 && stopchecking<0 && (eyetime2-pretrial_time)>calibrationtolerance
                    trialTimeout=100000;
                    caliblock=1;
                    if responsebox==0
                        DrawFormattedText(w, 'Need calibration: press "c" to continue the study, press "m" to recalibrate, press "esc" to exit ', 'center', 'center', white);
                    else
                        DrawFormattedText(w, 'Need calibration: press "red" to continue the study, press "yellow" to recalibrate, press "green" to exit ', 'center', 'center', white);
                    end
                    Screen('Flip', w);
                    %   KbQueueWait;
                    if responsebox==0
                        if  sum(keyCode)~=0
                            thekeys = find(keyCode);
                            if  thekeys==escapeKey
                                DrawFormattedText(w, 'Bye', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                closescript = 1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(5)
                                DrawFormattedText(w, 'continue', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                % trial=trial-1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(6)
                                DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                TPxReCalibrationTestingMM(1,screenNumber, baseName)
                                %    KbQueueWait;
                                eyechecked=10^4;
                            end
                        end
                    elseif responsebox==1
                        if (buttonLogStatus.newLogFrames > 0)
                            if  thekeys==RespType(3)
                                DrawFormattedText(w, 'Bye', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                closescript = 1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(1)
                                DrawFormattedText(w, 'continue', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                %  KbQueueWait;
                                % trial=trial-1;
                                eyechecked=10^4;
                            elseif thekeys==RespType(2)
                                DrawFormattedText(w, 'Calibration!', 'center', 'center', white);
                                Screen('Flip', w);
                                WaitSecs(1);
                                TPxReCalibrationTestingMM(1,screenNumber, baseName)
                                %    KbQueueWait;
                                eyechecked=10^4;
                            end
                        end
                    end
                end
                if CheckCount > 1
                    if (EyeCode(CheckCount) == 0) && (EyeCode(CheckCount-1) > 0)
                        TimerIndex = FixOnsetIndex;
                        FixCount = FixCount + 1;
                        FixIndex(FixCount,1) = FixOnsetIndex;
                        FixatingNow = 1;
                    end
                    if (EyeCode(CheckCount) ~= 0) && (FixatingNow == 1)
                        if FixCount == 0
                            FixCount = 1;
                            FixIndex(FixCount,1) = EndIndex+1;
                        end
                        FixIndex(FixCount,2) = CheckCount-1;
                        FixatingNow = 0;
                    end
                end
            else
                if stopchecking<0
                    trial_time = eyetime2; %start timer if we have eye info
                    stopchecking=10;
                end
            end
            if responsebox==1 % DATApixx AYS 5/4/23 I added some documentation for WaitForEvent_Jerry - let me know if you have questions.
                %  [Bpress, RespTime, TheButtons] = WaitForEvent_Jerry(0, TargList);
                Datapixx('RegWrRd');
                buttonLogStatus = Datapixx('GetDinStatus');
                if (buttonLogStatus.newLogFrames > 0)
                    [thekeys secs] = Datapixx('ReadDinLog');
                end
                %         [keyIsDown, keyCode] = KbQueueCheck;
            else % AYS: UCR and UAB?
                [keyIsDown, keyCode] = KbQueueCheck;
            end
            
        end
        %% response processing
        if trialTimedout(trial)== 0 && trainingType~=3
            foo=(RespType==thekeys(1)); %em added (1) 11/15/2023
            % staircase update
            if trainingType~=3
                staircounter(mixtr(trial,1),mixtr(trial,3))=staircounter(mixtr(trial,1),mixtr(trial,3))+1;
            end
            if trainingType==1 || (trainingType == 4 && mixtr(trial,3)==1)
                Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3)))=contr
            end
            if trainingType==2 || (trainingType == 4 && mixtr(trial,3)==2)
                Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3)))=Orijit;
            end
            %Progressive Track
            if mixtr(trial,3)==2 && staircounter(mixtr(trial,1),mixtr(trial,3)) < progtrackend
                if foo(theans(trial)) % if correct response
                    resp = 1;
                    resptotal=horzcat(resptotal, resp)
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    iscorr{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,3))) = 1;
                    thresh(mixtr(trial,1),mixtr(trial,3))= staircounter(mixtr(trial,1),mixtr(trial,3))+1
                elseif (thekeys==escapeKey) % esc pressed
                    %                     closescript = 1;
                    ListenChar(0);
                    break;
                else
                    resp = 0; % if wrong response
                    resptotal=horzcat(resptotal, resp)
                    nswr(trial) = 0;
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    iscorr{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,3))) = 0;
                    thresh(mixtr(trial,1),mixtr(trial,3))= staircounter(mixtr(trial,1),mixtr(trial,3))
                end
            elseif mixtr(trial,3)==2 && staircounter(mixtr(trial,1),mixtr(trial,3)) == progtrackend
                if foo(theans(trial)) % if correct response
                    resp = 1;
                    resptotal=horzcat(resptotal, resp)
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    iscorr{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,3))) = 1;
                    thresh(mixtr(trial,1),mixtr(trial,3))= find(JitList==Orijit)
                elseif (thekeys==escapeKey) % esc pressed
                    %                     closescript = 1;
                    ListenChar(0);
                    break;
                else
                    resp = 0; % if wrong response
                    resptotal=horzcat(resptotal, resp)
                    nswr(trial) = 0;
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    iscorr{mixtr(trial,1),mixtr(trial,2)}(staircounter(mixtr(trial,1),mixtr(trial,3))) = 0;
                    %thresh(mixtr(trial,1),mixtr(trial,3))==staircounter(mixtr(trial,1),mixtr(trial,3));
                    thresh(mixtr(trial,1),mixtr(trial,3))= find(JitList == Orijit)-2;
                  
                end
            elseif mixtr(trial,3)==1 || (mixtr(trial,3)==2 && staircounter(mixtr(trial,1),mixtr(trial,3)) > progtrackend)
                if foo(theans(trial)) % if correct response
                    resp = 1;
                    resptotal=horzcat(resptotal, resp)
                    PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    if trainingType~=3
                        corrcounter(mixtr(trial,1),mixtr(trial,3))=corrcounter(mixtr(trial,1),mixtr(trial,3))+1;
                        if  corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down
                            isreversals(mixtr(trial,1),mixtr(trial,3))= 1; %isreversals(mixtr(trial,1),mixtr(trial,3)) + 1;
                        end
                        if corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down  % && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                            if isreversals(mixtr(trial,1),mixtr(trial,3))==1
                                reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                                isreversals(mixtr(trial,1),mixtr(trial,3))=0;
                            end
                            thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
                    else
                        if trainingType == 2
                            thresh(mixtr(trial,1),mixtr(trial,3))=min(thresh(mixtr(trial,1),mixtr(trial,3)),length(JitList));
                        elseif trainingType == 1
                            thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(Contlist));
                        end
                        % the staircase begins as a 1 up 1 down until 3 reversals
                        %                         % have passed
                        %                                                 if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                        %                                                     if isreversals(mixtr(trial,1),mixtr(trial,3))==1
                        %                                                         reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                        %                                                         isreversals(mixtr(trial,1),mixtr(trial,3))=0;
                        %                                                     end
                        %                                                     thestep=min(reversals(mixtr(trial,1),mixtr(trial,3)),length(stepsizes));
                        %                                                 end
                        end
                    end
                    if trainingType==1 || (trainingType == 4 && mixtr(trial,3)==1)
                        if corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down % if we have enough consecutive correct responses to
                            %update stimulus intensity
                            if contr<SFthreshmin && currentsf<length(sflist)
                                currentsf=min(currentsf+1,length(sflist));
                                foo=find(Contlist>=SFthreshmin);
                                thresh(:,:)=foo(end)-SFadjust;
                                corrcounter(:,:)=0;
                                thestep=3;
                            else
                                thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) +stepsizes(thestep);
                                thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(Contlist));
                            end
                            corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                        else
                            if corrcounter(mixtr(trial,1),mixtr(trial,3)) < sc.down %maintain stimulus intensity
                                if contr<SFthreshmin && currentsf<length(sflist)
                                    currentsf=min(currentsf+1,length(sflist));
                                    foo=find(Contlist>=SFthreshmin);
                                    thresh(:,:)=foo(end)-SFadjust;
                                    corrcounter(:,:)=0;
                                    thestep=3;
                                else
                                    thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)); %setting value equal to itself??
                                    thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(Contlist));
                                end
                            end
                        end
                    end
                    if trainingType==2 || (trainingType == 4 && mixtr(trial,3)==2)
                        if corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down
                            thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) +stepsizes(thestep);
                            thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(JitList));
                            corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                        else
                            if corrcounter(mixtr(trial,1),mixtr(trial,3)) < sc.down
                                thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3));
                                thresh(mixtr(trial,1),mixtr(trial,3))=min( thresh(mixtr(trial,1),mixtr(trial,3)),length(JitList));
                            end
                        end
                    end
                elseif (thekeys==escapeKey) % esc pressed
                    closescript = 1;
                    ListenChar(0);
                    break;
                else
                    resp = 0; % if wrong response
                    resptotal=horzcat(resptotal, resp)
                    PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                    PsychPortAudio('Start', pahandle);
                    if trainingType~=3
                        if  corrcounter(mixtr(trial,1),mixtr(trial,3))>=sc.down && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                            isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                            reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                            %                     else
                            %                         if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                            %                             isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                            %                             reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                            %                         end
                        end
                        corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                        thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
                    end
                    if trainingType==1 || trainingType == 4 && mixtr(trial,3)==1
                        if contr>SFthreshmax && currentsf>1
                            currentsf=max(currentsf-1,1);
                            thresh(:,:)=StartCont;
                            corrcounter(:,:)=0;
                            thestep=3;
                        else
                            thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) -stepsizes(thestep);
                            thresh(mixtr(trial,1),mixtr(trial,3))=max(thresh(mixtr(trial,1),mixtr(trial,3)),1);
                        end
                    end
                        if trainingType==2 || trainingType == 4 && mixtr(trial,3)==2
                            thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) -stepsizes(thestep);
                            thresh(mixtr(trial,1),mixtr(trial,3))=max(thresh(mixtr(trial,1),mixtr(trial,3)),1);
                        end
                end
            end
                    elseif trainingType==3 % no response to be recorded here
                        if closescript==1
                            %         PsychPortAudio('Start', pahandle2);
                        elseif trialTimedout(trial)==1
                            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
                            PsychPortAudio('Start', pahandle);
                        else
                            PsychPortAudio('FillBuffer', pahandle, corrS' ); % loads data into buffer
                            PsychPortAudio('Start', pahandle);
                        end
        else
            % staircase update
            if trainingType~=3
                staircounter(mixtr(trial,1),mixtr(trial,3))=staircounter(mixtr(trial,1),mixtr(trial,3))+1;
            end
            if trainingType==1 || (trainingType == 4 && mixtr(trial,3)==1)
                Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3)))=contr;
            end
            if trainingType==2 || (trainingType == 4 && mixtr(trial,3)==2)
                Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3)))=Orijit;
            end
            resp = 0;
            respTime(trial)=0;
            PsychPortAudio('FillBuffer', pahandle, errorS'); % loads data into buffer
            PsychPortAudio('Start', pahandle);
            if trainingType~=3
                if  corrcounter(mixtr(trial,1),mixtr(trial,3))==sc.down && reversals(mixtr(trial,1),mixtr(trial,3)) >= 3
                    isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                    reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                else
                    if reversals(mixtr(trial,1),mixtr(trial,3)) < 3
                        isreversals(mixtr(trial,1),mixtr(trial,3))=1;
                        reversals(mixtr(trial,1),mixtr(trial,3))=reversals(mixtr(trial,1),mixtr(trial,3))+1;
                    end
                end
                corrcounter(mixtr(trial,1),mixtr(trial,3))=0;
                thestep=min(reversals(mixtr(trial,1),mixtr(trial,3))+1,length(stepsizes));
            end
            if trainingType==1 || trainingType == 4 && mixtr(trial,3)==1
                if contr>SFthreshmax && currentsf>1
                    currentsf=max(currentsf-1,1);
                    thresh(:,:)=StartCont+SFadjust;
                    corrcounter(:,:)=0;
                    thestep=3;
                else
                    thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) -stepsizes(thestep);
                    thresh(mixtr(trial,1),mixtr(trial,3))=max(thresh(mixtr(trial,1),mixtr(trial,3)),1);
                end
            end
            if trainingType==2 || trainingType == 4 && mixtr(trial,3)==2
                thresh(mixtr(trial,1),mixtr(trial,3))=thresh(mixtr(trial,1),mixtr(trial,3)) -stepsizes(thestep);
                thresh(mixtr(trial,1),mixtr(trial,3))=max(thresh(mixtr(trial,1),mixtr(trial,3)),1);
            end
        end
    if trainingType~=3 % if the trial didn't time out, save some variables
        if trialTimedout(trial)==0
            stim_stop=secs;
            if length(thekeys)>1
                cheis(kk)=thekeys(1);  % this is giving an error Dec 4- kmv
            else
                cheis(kk)=thekeys;  % this is giving an error Dec 4- kmv
            end
        end
        if  exist('stim_start')
            time_stim(kk) = stim_stop - stim_start;
        end
        rispo(kk)=resp;
        %   respTimes(trial)=respTime;
        if  exist('stim_start')
            cueendToResp(kk)=stim_stop-cue_last;
            cuebeginningToResp(kk)=stim_stop-circle_start;
        end
    end
    if trainingType > 2 % if it's a
        %   training type with flicker
        %   fixDuration(trial)=flicker_time_start-trial_time;
        if flickerdone>1
            flickertimetrial(trial)=FlickerTime; %  nominal duration of flicker
            movieDuration(trial)=flicker_time_stop(trial)-flicker_time_start(trial); % actual duration of flicker
            Timeperformance(trial)=movieDuration(trial)-(flickertimetrial(trial)*3); % estimated difference between actual and expected flicker duration
            unadjustedTimeperformance(trial)=movieDuration(trial)-flickertimetrial(trial);
        end
    end
    if trainingType==2
        trackthresh(shapesoftheDay(mixtr,1))=thresh(mixtr,1);
        threshperday(expDay,:)=trackthresh;
    end
    %         if trainingType == 4 && mixtr(trial,3)==2 %EC changed 4/9 for jitter continuity after Day 1
    %              threshShapes = thresh(:,2);
    %             trackthresh(shapesoftheDay(mixtr(trial,1)))= threshShapes(mixtr(trial,1));
    %             threshperday(expDay,:)=trackthresh;
    
    %         end
    if (mod(trial,150))==1 && trial>1
        save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    end
    if (mod(trial,10))==1 && trial>1 && trainingType==3
        updatecounter=updatecounter+1;
        %some adaptive measures for the TRL size that counts as 'fixation within the TRL'
        if mean(unadjustedTimeperformance(end-9:end))>8
            if mod(updatecounter,2)==0 && flickerpointerPre ~= 0 && flickerpointerPre ~= 1
                %here we implement staircase on flicker time
                flickerpointerPre=flickerpointerPre-1;
                flickerpointerPost=flickerpointerPost+1;
            end
            sizepointer=sizepointer-1; % increase the size of the TRL region within which the target will be deemed as 'seen through the TRL'
        elseif mean(unadjustedTimeperformance(end-9:end))<5
            if mod(updatecounter,2)==0 && flickerpointerPost ~= 0 && flickerpointerPost ~= 1
                %here we implement staircase on flicker time
                flickerpointerPre=flickerpointerPre+1;
                flickerpointerPost=flickerpointerPost-1;
            end
            if sizepointer~=length(sizeArray)
                sizepointer=sizepointer+1; % decrease the size of the TRL region within which the target will be deemed as 'seen through the TRL'
            end
        end
        timeflickerallowed=persistentflickerArray(flickerpointerPre); % time before flicker starts
        flickerpersistallowed=persistentflickerArray(flickerpointerPost); % time away from flicker in which flicker persists
        coeffAdj=sizeArray(sizepointer);
    end
    
    
    if responsebox==1 && trialTimedout(trial)==0 && trainingType ~= 3
        time_stim3(kk) = respTime(trial) - stim_startBox2(trial);
        time_stim2(kk) = respTime(trial) - stim_startBox(trial);
    else
        if trainingType ~= 3 && exist('stim_start')
            time_stim3(kk) = respTime(trial) - stim_start;
        end
    end
    TRLsize(trial)=coeffAdj;
    flickOne(trial)=timeflickerallowed;
    flickTwo(trial)=flickerpersistallowed;
    totale_trials(kk)=trial;
    coordinate(trial).x=theeccentricity_X/pix_deg;
    coordinate(trial).y=theeccentricity_Y/pix_deg;
    xxeye(trial).ics=[xeye];
    yyeye(trial).ipsi=[yeye];
    vbltimestamp(trial).ix=[VBL_Timestamp];
    if exist('ssf')
        feat(kk)=ssf;
    end
    SizeAttSti(kk) =imageRect_offs(3)-imageRect_offs(1);
    rectimage{kk}=imageRect_offs;
    if exist('endExp')
        totalduration=(endExp-startExp)/60;
    end
    %% record eyelink-related variables
    if EyeTracker==1
        EyeSummary.(TrialNum).EyeData = EyeData;
        clear EyeData
        EyeSummary.(TrialNum).EyeData(:,6) = EyeCode';
        clear EyeCode
        if exist('FixIndex')==0
            FixIndex=0;
        end
        EyeSummary.(TrialNum).FixationIndices = FixIndex;
        clear FixIndex
        EyeSummary.(TrialNum).TotalEvents = CheckCount;
        clear CheckCount
        EyeSummary.(TrialNum).TotalFixations = FixCount;
        clear FixCount
        EyeSummary.(TrialNum).TargetX = theeccentricity_X/pix_deg;
        EyeSummary.(TrialNum).TargetY = theeccentricity_Y/pix_deg;
        EyeSummary.(TrialNum).EventData = EvtInfo;
        clear EvtInfo
        EyeSummary.(TrialNum).ErrorData = ErrorData;
        clear ErrorData
        if exist('EndIndex')==0
            EndIndex=0;
        end
        EyeSummary.(TrialNum).GetFixationInfo.EndIndex = EndIndex;
        clear EndIndex
        EyeSummary.(TrialNum).DriftCorrectionX = driftoffsetx;
        EyeSummary.(TrialNum).DriftCorrectionY = driftoffsety;
        if exist('stim_start')
            EyeSummary.(TrialNum).TimeStamps.Fixation = stim_start;
        end
        if trainingType~=3
            EyeSummary.(TrialNum).TimeStamps.Response = stim_stop;
        end
        clear ErrorInfo
    end
    if EyetrackerType==2
            %read in eye data
            Datapixx('RegWrRd');
            status = Datapixx('GetTPxStatus');
            toRead = status.newBufferFrames;
            if toRead>0
                [bufferData, ~, ~] = Datapixx('ReadTPxData', toRead);
                
                %bufferData is formatted as follows:
                %1      --- Timetag (in seconds)
                %2      --- Left Eye X (in pixels)
                %3      --- Left Eye Y (in pixels)
                %4      --- Left Pupil Diameter (in pixels)
                %5      --- Right Eye X (in pixels)
                %6      --- Right Eye Y (in pixels)
                %7      --- Right Pupil Diameter (in pixels)
                %8      --- Digital Input Values (24 bits)
                %9      --- Left Blink Detection (0=no, 1=yes)
                %10     --- Right Blink Detection (0=no, 1=yes)
                %11     --- Digital Output Values (24 bits)
                %12     --- Left Eye Fixation Flag (0=no, 1=yes)
                %13     --- Right Eye Fixation Flag (0=no, 1=yes)
                %14     --- Left Eye Saccade Flag (0=no, 1=yes)
                %15     --- Right Eye Saccade Flag (0=no, 1=yes)
                %16     --- Message code (integer)
                %17     --- Left Eye Raw X (in pixels)
                %18     --- Left Eye Raw Y (in pixels)
                %19     --- Right Eye Raw X (in pixels)
                %20     --- Right Eye Raw Y (in pixels)
                
                %IMPORTANT: "RIGHT" and "LEFT" refer to the right and left eyes shown
                %in the console overlay. In tabletop and MEG setups, this view is
                %inverted. This means "RIGHT" in our labelling convention corresponds
                %to the participant's left eye. Similarly "LEFT" in our convention
                %refers to left on the screen, which corresponds to the participant's
                %right eye.
                
                %If you are using an MRI setup with an inverting mirror, "RIGHT" will
                %correspond to the participant's right eye.
                
                %save eye data from trial as a table in the trial structure
                Pixxstruct(trial).EyeData = array2table(bufferData, 'VariableNames', {'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter', 'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
                    'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut', 'LeftEyeFixationFlag', 'RightEyeFixationFlag', 'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',...
                    'MessageCode', 'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});
                %interim save
                % save(baseName, 'Pixxstruct');
                % Pixxstruct(trial).EyeData.TimeTag-Pixxstruct(trial).TargetOnset2
            end
        end
    if closescript==1
        break;
    end
    kk=kk+1;
    if shapecounter>11 && trainingType < 3
        if mod(checkcounter,10) == 0 && sum(Threshlist(mixtr(trial,1),mixtr(trial,3),staircounter(mixtr(trial,1),mixtr(trial,3))-10:staircounter(mixtr(trial,1),mixtr(trial,3))))==0
            DrawFormattedText(w, 'Wake up and call the experimenter', 'center', 'center', white);
            Screen('Flip', w);
            KbQueueWait;
        end
    end
    if trainingType==4
        if eyetime2-blocktime>blockdurationtolerance || trial==(mixtr(trial,5)*trials_per_block)
            moveon=mixtr(trial,end);
            nextrials=find(mixtr(:,end) == moveon+1);
            if isempty(nextrials)
                break
            else
                skiptrial=nextrials(1);
                countertrialskipped=countertrialskipped+1;
                oldtrial(countertrialskipped)=trial;
                skipflag = 1;
            end
        end
    end
end

    DrawFormattedText(w, 'Task completed - Press a key to close', 'center', 'center', white);

    ListenChar(0);
    Screen('Flip', w);

    %% shut down EyeTracker and screen functions
    if EyetrackerType==1    
        Eyelink('closefile');
        status = Eyelink('ReceiveFile',eyeTrackerFileName,save_dir,1); % this is the eyetracker file that needs to be put in the correct folder with the other files!!!
        if status < 0, fprintf('Error in receiveing file!\n');
        end
        Eyelink('Shutdown');
    end
    
    c=clock;
    TimeStop=[num2str(c(1)-2000) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))];
    save(baseName,'-regexp', '^(?!(wavedata|sig|tone|G|m|x|y|xxx|yyyy)$).');
    KbQueueWait;
    
    ShowCursor;
    Screen('CloseAll');
    PsychPortAudio('Close', pahandle);

catch ME
    psychlasterror()
end
