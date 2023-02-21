

% column 1: RT
% column 2: resp
TT_total_target(trial)=sum(array_of_events==3);
TT_total_corr_resp(trial)=sum(resp(trial,:)==1);
TT_total_wrong_resp(trial)=sum(resp(trial,:)==99);
TT_miss(trial)=sum(resp(trial,:)==NaN;


TT{trial}=[RespMatrix(trial,:)' [resp(trial,:)'; nan(length(RespMatrix(trial,:))-(length(resp(trial,:))),1)]];