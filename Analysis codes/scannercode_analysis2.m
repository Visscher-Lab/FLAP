
%clear all;
%clc;
datadir='/Users/pinarde/Documents/Github/PRL Induction procedures/data'; %change it according to your directory
cd([datadir]);
%load("WC_FLAP_Scanner1_1_22_7_15_11_4.mat"); % change it

gaborblocks=find(activeblocktype(runnumber,:)==1);
numberblocks=find(activeblocktype(runnumber,:)==2);
tasks={'gabor','number'};
i=1 %there is 2 active blocks for each task in each run
%  if activeblocktype(runnumber,i)==1
k=num2str(i);
gabor_miss=strfind(ResponseType(gaborblocks(1,i),:), 'miss');
if sum(~cellfun('isempty',gabor_miss))>0
    eval(['gabor_misses_' k '(1,:)=find(not(cellfun(''isempty'', gabor_miss)));']);
    eval(['gabor_num_misses(1,' k ')=length(gabor_misses_' k '(1,:));']);
else gabor_num_misses(1,i)=0;
end
gabor_false=strfind(ResponseType(gaborblocks(1,i),:), 'false');
if sum(~cellfun('isempty',gabor_false))>0
    eval(['gabor_falses_' k '(1,:)=find(not(cellfun(''isempty'', gabor_false)));']);
    eval(['gabor_num_falses(1,' k ')=length(gabor_falses_' k '(1,:));']);
else gabor_num_falses(1,i)=0;
end
gabor_true=strfind(ResponseType(gaborblocks(1,i),:), 'correct');
if sum(~cellfun('isempty',gabor_true))>0
    eval(['gabor_trues_' k '(1,:)=find(not(cellfun(''isempty'', gabor_true)));']);
    eval(['gabor_num_trues(1,' k ')=length(gabor_trues_' k '(1,:));']);
else gabor_num_trues(1,i)=0;
end


for i=1:3 %there is 2 active blocks for each task in each run
    %  if activeblocktype(runnumber,i)==1
    k=num2str(i);

    number_miss=strfind(ResponseType(numberblocks(1,i),:), 'miss');
    if sum(~cellfun('isempty',number_miss))>0
        eval(['number_misses_' k '(1,:)=find(not(cellfun(''isempty'', number_miss)));']);
        eval(['number_num_misses(1,' k ')=length(number_misses_' k '(1,:));']);
    else number_num_misses(1,i)=0;
    end
    number_false=strfind(ResponseType(numberblocks(1,i),:), 'false');
    if sum(~cellfun('isempty',number_false))>0
        eval(['number_falses_' k '(1,:)=find(not(cellfun(''isempty'', number_false)));']);
        eval(['number_num_falses(1,' k ')=length(number_falses_' k '(1,:));']);
    else number_num_falses(1,i)=0;
    end
    number_true=strfind(ResponseType(numberblocks(1,i),:), 'correct');
    if sum(~cellfun('isempty',number_true))>0
        eval(['number_trues_' k '(1,:)=find(not(cellfun(''isempty'', number_true)));']);
        eval(['number_num_trues(1,' k ')=length(number_trues_' k '(1,:));']);
    else number_num_trues(1,i)=0;
    end

end
gabor_num_misses_total=sum(gabor_num_misses(1,:));
gabor_num_falses_total=sum(gabor_num_falses(1,:));
gabor_num_trues_total=sum(gabor_num_trues(1,:));
number_num_misses_total=sum(number_num_misses(1,:));
number_num_falses_total=sum(number_num_falses(1,:));
number_num_trues_total=sum(number_num_trues(1,:));
num_misses_total(1,1)=gabor_num_misses_total+number_num_misses_total;
num_falses_total(1,1)=gabor_num_falses_total+number_num_falses_total;
num_trues_total(1,1)=gabor_num_trues_total+number_num_trues_total;
percent_correct_gabor(1,1)=(gabor_num_trues_total*100)/10;percent_correct_gabor(1,2)=(gabor_num_misses_total*100)/10;percent_correct_gabor(1,3)=(gabor_num_falses_total*100)/10;
percent_correct_number(1,1)=(number_num_trues_total*100)/30;percent_correct_number(1,2)=(number_num_misses_total*100)/30;percent_correct_number(1,3)=(number_num_falses_total*100)/30;
percent_correct_total(1,1)=(num_trues_total*100)/40;percent_correct_total(1,2)=(num_misses_total*100)/40;percent_correct_total(1,3)=(num_falses_total*100)/40;

for i=1:2
    k=num2str(i);
    task=tasks{i};
    currtask=[task '_trues_' k];
    for x=1:length(eval([currtask]))
        eval(['RT_hits_' task '(1,x)=RT(' task 'blocks(1,i),' currtask '(1,x))']);
        eval(['RT_hits_' task 's=mean(RT_hits_' task ')']);
    end

end
RT_hits_average=(sum(RT_hits_gabor)+sum(RT_hits_number))/(length(RT_hits_gabor)+length(RT_hits_number));
Reaction_Time_for_hits(1,1)=RT_hits_average,Reaction_Time_for_hits(1,2)=RT_hits_gabors,Reaction_Time_for_hits(1,3)=RT_hits_numbers;
