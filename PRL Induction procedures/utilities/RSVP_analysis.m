

% column 1: RT
% column 2: resp
TT_total_target(trial)=sum(array_of_events==3);
TT_total_corr_resp(trial)=sum(resp(trial,:)==1);
TT_total_wrong_resp(trial)=sum(resp(trial,:)==99);
TT_miss(trial)=sum(isnan(resp(trial,:)));


% sustained
sus_one=mixtr(:,1)==1;
sus_two=mixtr(:,1)==2;
sus_three=mixtr(:,1)==3;
sus_four=mixtr(:,1)==4;
sus_five=mixtr(:,1)==5;
sus_six=mixtr(:,1)==6;


%find all switch trials
all_trials_one=onef+1; % all trials for 1->2
all_trials_two=twof+1; % all trials for 1->3
all_trials_three=threef+1; % all trials for 2->1
all_trials_four=fourf+1; % all trials for 2->3
all_trials_five=fivef+1; % all trials for 3->1
all_trials_six=sixf+1; % all trials for 3->2



%find incongruent trials
incongruent_one=ddd(1,:)+1; % incongruent trials for 1->2
incongruent_two=ddd(2,:)+1; % incongruent trials for 1->3
incongruent_three=ddd(3,:)+1; % incongruent trials for 2->1
incongruent_four=ddd(4,:)+1; % incongruent trials for 2->3
incongruent_five=ddd(5,:)+1; % incongruent trials for 3->1
incongruent_six=ddd(6,:)+1; % incongruent trials for 3->2

%congruent_trials: all trials per switch minus the incongruent ones
congruent_one=setdiff(all_trials_one,incongruent_one);
congruent_two=setdiff(all_trials_two,incongruent_two);
congruent_three=setdiff(all_trials_three,incongruent_three);
congruent_four=setdiff(all_trials_four,incongruent_four);
congruent_five=setdiff(all_trials_five,incongruent_five);
congruent_six=setdiff(all_trials_six,incongruent_six);




TT{trial}=[RespMatrix(trial,:)' [resp(trial,:)'; nan(length(RespMatrix(trial,:))-(length(resp(trial,:))),1)]];