%% STAIRCASE
if taskType ==1
    max_contrast=.7;
    Contlist = log_unit_down(max_contrast+.122, 0.05, 76); %Updated contrast possible values
    Contlist(1)=1;
elseif taskType == 2
    max_noise=1;
    Noiselist=log_unit_down(max_noise+.122, 0.05, 76);
   Noiselist= Noiselist(Noiselist<1.01);
 %   Noiselist=fliplr(Noiselist);
elseif taskType==3 || taskType==4
    max_ori=30;
    Orilist=log_unit_down(max_ori+.122, 0.05, 76); %Updated contrast possible values
end
stepsizes=[4 4 3 3 2 1];
streakon=0; % if we activate the streak, we don't reset correct responses after sc.down
revcount=0;
reversalsToEnd=10; % how many reversals we need to reach to finish the block

trials=100; %100;
mixtr=[];
if taskType==1
    lok; %location: PRL vs no PRL
    fl=2; % flankers: Iso vs orto
    condlist=fullfact([lok fl]);
    numsc=length(condlist);
    n_blocks=1;    
    blocks=1; %10;
    n_blocks=round(trials/blocks);   %number of trials per miniblock   
    for j=1:blocks
        for i=1:numsc
            mixtr=[mixtr;repmat(condlist(i,:),n_blocks,1)];
        end
    end
end

b=mixtr(randperm(length(mixtr)),:);
if taskType>1
    condlist=[1 1];
    cndt=1;
ca=1;
    mixtr=[mixtr;repmat(condlist,trials,1)];
   % mixtr(:,1)= mixtr(:,1)+ (TRLlocation-1);
    %   mixtr(:,1)= mixtr(:,1)+ (TRLlocation-1);

else
    cndt=2;
ca=2;
end

trial=1;


thresh(1:cndt, 1:ca)=19;
reversals(1:cndt, 1:ca)=0;
isreversals(1:cndt, 1:ca)=0;
staircounter(1:cndt, 1:ca)=0;
corrcounter(1:cndt, 1:ca)=0;
if taskType==2
StartCont=12;  %zero noise, 100% signal
else
    StartCont=6;  %15
end
thresh(1:cndt, 1:ca)=StartCont;
step=5;
currentsf=1;
% Threshold -> 66%
sc.up = 1;                          % # of incorrect answers to go one step up
sc.down = 3;                        % # of correct answers to go one step down
sc.down = 2;                        % # of correct answers to go one step down
