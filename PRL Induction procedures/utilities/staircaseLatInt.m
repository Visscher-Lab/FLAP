    %% STAIRCASE
    cndt=2;
    ca=2;
    thresh(1:cndt, 1:ca)=19;
    reversals(1:cndt, 1:ca)=0;
    isreversals(1:cndt, 1:ca)=0;
    staircounter(1:cndt, 1:ca)=0;
    corrcounter(1:cndt, 1:ca)=0;
    StartCont=5;  %15
    thresh(1:cndt, 1:ca)=StartCont;
    step=5;
    currentsf=1;
    % Threshold -> 66%
    sc.up = 1;                          % # of incorrect answers to go one step up
    sc.down = 2;                        % # of correct answers to go one step down
    max_contrast=.7;
    max_ori=45;
    max_noise=1;
    Contlist = log_unit_down(max_contrast+.122, 0.05, 76); %Updated contrast possible values
    Contlist(1)=1;
    Noiselist=log_unit_down(max_noise+.122, 0.05, 76);
    Noiselist=fliplr(Noiselist);
    Orilist=log_unit_down(max_ori+.122, 0.05, 76); %Updated contrast possible values
    stepsizes=[4 4 3 2 1];
    
    
    lok=2; %location: PRL vs no PRL
    fl=2; % flankers: Iso vs orto
    condlist=fullfact([lok fl]);
    numsc=length(condlist);
    
    n_blocks=1;
    
    trials=10; %100;
    blocks=1; %10;
    n_blocks=round(trials/blocks);   %number of trials per miniblock
    mixtr=[];
    for j=1:blocks
        for i=1:numsc
            mixtr=[mixtr;repmat(condlist(i,:),n_blocks,1)];
        end
    end
    
    b=mixtr(randperm(length(mixtr)),:);