% new generate trial matrix for RSVP FLAP 2023
clear all

PRLlocations=3; % trained, untrained, additional location
trycounter=0; %counting attempts at generating the mixtr

d=fullfact([ PRLlocations PRLlocations]);
c=d(:,1)==d(:,2);
f=d(~c,:);
position_to_switch=length(f); %permutations of 3 locations (we need to remove 'switches' from same to same

repetitions=24;  %48 trials per location equals 24 trials per switch (3 PRLs, 6 switches, see 'position_to_switch')
%repetitions=32;  %48 trials per location equals 24 trials per switch (3 PRLs, 6 switches, see 'position_to_switch')

trial_type=[1 2 3]; % we want three types of trials, defined below
trial_type_frequency=[0.25 0.25 0.50]*repetitions; % how often do these trial types occur?

nextmat=[]; % generate trial matrix (still not concatenated/doesn't care about cue consistency)
for ui=1:position_to_switch
    for ii=1:length(trial_type)
        bins=repmat([f(ui,:), trial_type(ii)],trial_type_frequency(ii),1);
        nextmat=[nextmat; bins];
        clear bins
    end
end

%1: location now
%2: location to go (where the cue will be pointing at)
%3: trial type (one of the three types)

randum=randi(length(nextmat));
newmatrix=nextmat(randum,:,:);
mixtr=[];
%finder=10000;
g2=nextmat;

satisfied=0;
while satisfied<1
    try
        trycounter=trycounter+1;
        for fff=1:length(nextmat)
            if fff==1
                nextbin=newmatrix;
            end
            finder=(g2(:,1)==nextbin(:,1) & g2(:,2)==nextbin(:,2) & g2(:,3)==nextbin(:,3));
            remover=find(finder);
            remover=remover(1);
            ttt{fff}=g2;
            g2(remover,:)=[];
            a=find(g2(:,1)==nextbin(2));
            clear nextbin
            nextbin=g2(a(randi(length(a))),:);
            mixtr(fff,:)=nextbin;
            if fff>=length(nextmat)-1
                satisfied=1;
            end
        end
    end
end

%mixtr=[ttt{end}; mixtr]
%mixtr
%1: where stream is
%2: where stream will go
%3: trial type

%50% T ? Target + Rand 3D ? Rand 5T ? Rand 5T ? Rand 3C?
%50% T ? Target + 1,2 or 3  distractors ? 1-4 distractors + 1 target ? 1-4 distractors + 1 target ? 1-2 distractors + 1 cue?
%25% T ? Target + Rand 3D ? Rand 8T ? Rand 5C?
%25% T ? Target + 1,2 or 3 distractors ? 1-7 distractors + 1 target ? 1-4 distractors + 1 cue?
%25% T ? Target + Rand 3D ? Rand 2T ? Rand 4T ? Rand 4T ? Rand 3C?
%25% T ? Target + 1,2 or 3 distractors ? 1 distractor + 1 target ? 1-3 distractors + 1 target - 1-3 distractors + 1 target ? 1-2 distractors + 1 cue?
%events type

%1= C stays on screen until response
%2= foil
%3= target
%4=cue
%5= blank


% add incongruent trials

trialype{1}=[ 3 ones(randi(3),1)'*2 3 ones(randi(4),1)'*2 3 ones(randi(4),1)'*2 4 ];
trialype{2}=[ 3 ones(randi(3),1)'*2 3 ones(randi(8),1)'*2 3 4 ];
trialype{3}=[ 3 ones(randi(3),1)'*2 3 ones(randi(2),1)'*2 3 ones(randi(3),1)'*2 3  ones(randi(3),1)'*2 3  ones(randi(2),1)'*2 4 ];

trialArray=[];

for ui=1:length(mixtr)
    ttemp=[];
    
    if mixtr(ui,3)==1
        tempo=[ 3 ones(randi(3),1)'*2 3 ones(randi(4),1)'*2 3 ones(randi(4),1)'*2 4 ];
    elseif mixtr(ui,3)==2
        tempo=[ 3 ones(randi(3),1)'*2 3 ones(randi(8),1)'*2 3 4 ];
    elseif mixtr(ui,3)==3
        tempo=[ 3 ones(randi(3),1)'*2 3 ones(randi(2),1)'*2 3 ones(randi(3),1)'*2 3  ones(randi(3),1)'*2 3  ones(randi(2),1)'*2 4 ];
    end
    
    for ii=1:length(tempo) % here we add the blank intervals
        
        temp=[tempo(ii) 5];
        if tempo(ii)==4
            temp=[tempo(ii)];
        end
        ttemp=[ttemp temp];
    end
    
    trialArray{ui}=ttemp;
    clear temp
end


save RSVP3mx.mat

for ui=1:length(trialArray)
    trialArray{ui}(length(trialArray{ui})+1)=6;
end

save RSVP3mxII.mat


oldmixtr=mixtr;
%find switch groups
one=mixtr(:,1)==1 & mixtr(:,2)==2;
two=mixtr(:,1)==1 & mixtr(:,2)==3;
three=mixtr(:,1)==2 & mixtr(:,2)==1;
four=mixtr(:,1)==2 & mixtr(:,2)==3;
five=mixtr(:,1)==3 & mixtr(:,2)==1;
six=mixtr(:,1)==3 & mixtr(:,2)==2;

%identify specific switch types in the mixtr


% add 5 incongruent trials out of 24 (20%) (the stream is on 1, the target goes to 2 but the cue is on 3)
onef=find(one==1);
idx=onef(randperm(length(onef),5));
mixtr(idx,2)=3;
ddd(1,:)= idx;

clear idx
% add 5 incongruent trials out of 24 (20%) (the stream is on 1, the target goes to 3 but the cue is on 2)

twof=find(two==1);
idx=twof(randperm(length(twof),5));
mixtr(idx,2)=2;
ddd(2,:)= idx;
clear idx
% add 5 incongruent trials out of 24 (20%) (the stream is on 2, the target goes to 1 but the cue is on 3)

threef=find(three==1);
idx=threef(randperm(length(threef),5));
mixtr(idx,2)=3;
ddd(3,:)= idx;
clear idx
% add 5 incongruent trials out of 24 (20%) (the stream is on 2, the target goes to 3 but the cue is on 1)

fourf=find(four==1);
idx=fourf(randperm(length(fourf),5));
mixtr(idx,2)=1;
ddd(4,:)= idx;
clear idx
% add 5 incongruent trials out of 24 (20%) (the stream is on 3, the target goes to 1 but the cue is on 2)

fivef=find(five==1);
idx=fivef(randperm(length(fivef),5));
mixtr(idx,2)=2;
ddd(5,:)= idx;
clear idx
% add 5 incongruent trials out of 24 (20%) (the stream is on 3, the target goes to 2 but the cue is on 1)

sixf=find(six==1);
idx=sixf(randperm(length(sixf),5));
mixtr(idx,2)=1;
ddd(6,:)= idx;
clear idx
save RSVP3mxIII.mat

%randx means a rand sequence 1-x long that ends in a target (T) distractor (D) or cue (C) 

congone=setdiff(onef,ddd(1,:))
congtwo=setdiff(twof,ddd(2,:))
congthree=setdiff(threef,ddd(3,:))
congfour=setdiff(fourf,ddd(4,:))
congfive=setdiff(fivef,ddd(5,:))
congsix=setdiff(sixf,ddd(6,:))
incongone=ddd(1,:)
incongtwo=ddd(2,:)
incongthree=ddd(3,:)
incongfour=ddd(4,:)
incongfive=ddd(5,:)
incongsix=ddd(6,:)
% ddd = incongruent trials. each row is a switch type. each row contains
% the trials with the incongruent switch. these trials end with a 'wrong'
% cue, thus the incongruent trial is the one after this
%