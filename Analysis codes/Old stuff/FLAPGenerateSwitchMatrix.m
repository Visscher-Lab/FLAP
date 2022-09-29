%Script to generate the trialmatrix forr the RSVP exo-endo attention task
%Marcello Maniglia July 2021
clear all
close all
io=0
diditclose=0;
while diditclose<1
try
    
    io=io+1;
clc
typeofcue=2; % endo, exo
stop_start=1;
PRLlocations=4;

for qq=1:typeofcue
position_to_switch=12; %permutations of 4 locations
number_of_hold_trials=4; %  number of hold trials, i.e. elements per RSVP stream
number_of_repetition_matrix=1;

a=fullfact([position_to_switch number_of_hold_trials]);
a(1:position_to_switch,2)=3;
a(position_to_switch+1:2*position_to_switch,2)=4;
a(2*position_to_switch+1:3*position_to_switch,2)=3;
a(3*position_to_switch+1:4*position_to_switch,2)=4;

% 4 types of trials for each combination of switch (4 locations to 3 other possible locations): 3 and 4 targets per stream
%4 types of trial pfor each combination for endo and exo separately


%%
d=fullfact([ PRLlocations PRLlocations]);
c=d(:,1)==d(:,2);
f=d(~c,:);
range_f=size(f)*number_of_hold_trials;
doh=[f(a(1:range_f(1)),:) a(:,2)];
randum=randi(length(doh));
newmatrix=doh(randum,:,:);

tot_trial=sum(doh(:,3));
lastblock=3;
g2=doh;
mixtr=[];
finder=10000;
counteromval=0;

%while exist('newmatrix(1,3)')==1
for q=1:number_of_repetition_matrix
    for fff=1:length(doh)
        for ww=1:newmatrix(1,3)
            pp=newmatrix(:,1:2);
            if numel(finder)>0 & finder==0 | isempty(finder)==1
                mixtr=[pp; mixtr];
            else
                mixtr=[mixtr; pp];
            end
        end
        if fff<length(doh)
            re=find(g2(:,1)==newmatrix(1,1) & g2(:,2)==newmatrix(1,2) & g2(:,3)==newmatrix(1,3));
            re=re(1);
            g2(re,:)=[];
            nextbin=newmatrix(1,2);

            a=find(g2(:,1)==nextbin);
            if isempty(a)
                finder=mixtr(1,1);
                newmatrix2=finder;
                a=find(g2(:,2)==finder);
                newmatrix=g2(a,:);
            else
                finder=g2(:,1)==nextbin;
                newmatrix2=randi(length(find(finder)));
                newmatrix=g2(a(newmatrix2),:);
            end
        end
    end
%end


end


% 'patch' to close the loop: 3 additional trial in the last 'position to switch to'
rrr=mixtr(end,2);
for dr=1:lastblock
    ppp=[rrr, 1];
    mixtr=[mixtr; ppp];
end

rep=length(find(doh(:,1)==3));
ori=[1 2 3 4];
orientarray=[];
for i=1:rep/length(ori)
    a=randperm(length(ori));
    orientarray=[orientarray a];
end
for ui=1:2
   cc= ori(randi(length(ori)));
orientarray = [orientarray cc];
end



trialmatrix=[mixtr zeros(length(mixtr),1)];
cntr1=0;
cntr2=0;
cntr3=0;
cntr4=0;

for do=2:length(mixtr)
    if    mixtr(do,1)==1 & mixtr(do-1,1)~=1
        cntr1=cntr1+1;
        trialmatrix(do,3)=orientarray(cntr1);
    end
    if    mixtr(do,1)==2 & mixtr(do-1,1)~=2
        cntr2=cntr2+1;
        trialmatrix(do,3)=orientarray(cntr2);
    end
    if    mixtr(do,1)==3 & mixtr(do-1,1)~=3
        cntr3=cntr3+1;
        trialmatrix(do,3)=orientarray(cntr3);
    end
    if    mixtr(do,1)==4 & mixtr(do-1,1)~=4
        cntr4=cntr4+1;
        trialmatrix(do,3)=orientarray(cntr4);
    end
end

for do=2:length(mixtr)
    if    mixtr(do,1)==mixtr(do-1,1)
        trialmatrix(do,3)=randi(4);

    end
end

trialmatrix(1,3)=randi(4);
      
        mixtr2=mixtr;           
mixtr=[mixtr2(:,1), ones(length(mixtr2),1)];       
        response=zeros(length(mixtr),2)-1; %intialize response matrix with -1
        
        
        
        
        %%        
        for dd=2:length(trialmatrix)
            if trialmatrix(dd,1) ~= trialmatrix(dd-1,1)
                if trialmatrix(dd-1,2)==1
                    trialmatrix(dd-1,:)=[trialmatrix(dd-1,1:2) 6];
                elseif trialmatrix(dd-1,2)==2
                    trialmatrix(dd-1,:)=[trialmatrix(dd-1,1:2) 7];
                elseif trialmatrix(dd-1,2)==3
                    trialmatrix(dd-1,:)=[trialmatrix(dd-1,1:2) 8];
                    elseif trialmatrix(dd-1,2)==4
                    trialmatrix(dd-1,:)=[trialmatrix(dd-1,1:2) 9];
                end
            end
        end
        
        newtrialmatrix=[];
        
        
        
   %target locations:
%1=up
%2=right
%3=down
%4=left

%cue locations
%6=left 
%7=right
%8=down 
%9=up
     
contatore1=0;
contatore2=0;
contatore3=0;
contatore4=0;
contatore5=0;
contatore6=0;
contatore7=0;
contatore8=0;
contatore9=0;
contatore10=0;
contatore11=0;
contatore12=0;
 
        foils=repmat([2 3],1,11);
        foils1=[foils(randperm(length(foils))) 2 2 2];
        foils2=[foils(randperm(length(foils))) 2 2 2];
        foils3=[foils(randperm(length(foils))) 2 2 2];
        foils4=[foils(randperm(length(foils))) 2 2 2];
        foils5=[foils(randperm(length(foils))) 2 2 2];
        foils6=[foils(randperm(length(foils))) 2 2 2];
        foils7=[foils(randperm(length(foils))) 2 2 2];
        foils8=[foils(randperm(length(foils))) 2 2 2];
        foils9=[foils(randperm(length(foils))) 2 2 2];
        foils10=[foils(randperm(length(foils))) 2 2 2];
        foils11=[foils(randperm(length(foils))) 2 2 2];
        foils12=[foils(randperm(length(foils))) 2 2 2];
       
        
                     %add foil trials in the streams        
     for dd=1:length(trialmatrix)
         dummy=[];
         if trialmatrix(dd,3) <6
             if trialmatrix(dd,1)==1 && trialmatrix(dd,2)==2
                 contatore1=contatore1+1;
                 for yo=1:foils1(contatore1)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==1 && trialmatrix(dd,2)==3
                 contatore2=contatore2+1;
                 for yo=1:foils2(contatore2)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==1 && trialmatrix(dd,2)==4
                 contatore3=contatore3+1;
                 for yo=1:foils3(contatore3)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==2 && trialmatrix(dd,2)==1
                 contatore4=contatore4+1;
                 for yo=1:foils4(contatore4)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==2 && trialmatrix(dd,2)==3
                 contatore5=contatore5+1;
                 for yo=1:foils5(contatore5)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==2 && trialmatrix(dd,2)==4
                 contatore6=contatore6+1;
                 for yo=1:foils6(contatore6)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==3 && trialmatrix(dd,2)==1
                 contatore7=contatore7+1;
                 for yo=1:foils7(contatore7)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==3 && trialmatrix(dd,2)==2
                 contatore8=contatore8+1;
                 for yo=1:foils8(contatore8)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==3 && trialmatrix(dd,2)==4
                 contatore9=contatore9+1;
                 for yo=1:foils9(contatore9)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==4 && trialmatrix(dd,2)==1
                 contatore10=contatore10+1;
                 for yo=1:foils10(contatore10)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==4 && trialmatrix(dd,2)==2
                 contatore11=contatore11+1;
                 for yo=1:foils11(contatore11)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             elseif trialmatrix(dd,1)==4 && trialmatrix(dd,2)==3
                 contatore12=contatore12+1;
                 for yo=1:foils12(contatore12)
                     dummy=[dummy ;trialmatrix(dd,1:2) 5];
                 end
             end
         end
         newtrialmatrix=[newtrialmatrix ;trialmatrix(dd,:) ;dummy];
     end
        
     
% when cue=2-> exogenous. it doesn't precede the target, i.e., it is not shown in the trial n-1, but rather in the
% trial n. I need a loop that looks for cue==2 and removes the cue from the
% previous trial.
%         
        
if qq==1
newnewmatrix=[ones(length(newtrialmatrix),1) newtrialmatrix];

elseif qq==2
    newnewmatrix2=[ones(length(newtrialmatrix),1)*2 newtrialmatrix];

end 


end
%%
                
        %mixtr for endogenous
        
        newnewtrialmatrix=[newnewmatrix(:,1:2) newnewmatrix(:,2) newnewmatrix(:,3:4) ];
        
                %mixtr for exogenous

                newnewtrialmatrix2=[newnewmatrix2(:,1:2) newnewmatrix2(:,2) newnewmatrix2(:,3:4) ];

                
                % now I need to tell the mixtr when to present the cue for
                % the exogenous condition, i.e., keep the '1' in first
                % column for the first switch (appearance of the cue),
                % replace with '0' for all the other conditions
                
                
                
                for dd=2:length(newnewtrialmatrix2)
                    if newnewtrialmatrix2(dd,2) ~= newnewtrialmatrix2(dd-1,2)
                    newnewtrialmatrix2(dd-1,:)=[ newnewtrialmatrix2(dd-1,1:end-1) 5];
                    newnewtrialmatrix2(dd,:)=[0 newnewtrialmatrix2(dd,2:end)];
%                 elseif trialmatrix(dd-1,2)==2
%                     trialmatrix(dd-1,:)=[trialmatrix(dd-1,1:2) 7];
%                     
                    end
                end
                
                                                                          
                %%  %breaks in the session 
                % endo
                possiblebreaks=[];
                for dd=20:length(newnewtrialmatrix)-5
                    if newnewtrialmatrix(dd+2,2) && newnewtrialmatrix(dd+1,2) && newnewtrialmatrix(dd,2) == newnewtrialmatrix(dd-1,2) && newnewtrialmatrix(dd+2,5) ==5 && newnewtrialmatrix(dd+1,5) ==5 && newnewtrialmatrix(dd,5) ==5 &&  newnewtrialmatrix(dd-1,5)==5
                 possiblebreaks=[possiblebreaks dd];
                    end
                end
                               
                                % exo
                possiblebreaks2=[];
                for dd=20:length(newnewtrialmatrix2)-5
                    if newnewtrialmatrix2(dd+2,2) && newnewtrialmatrix2(dd+1,2) && newnewtrialmatrix2(dd,2) == newnewtrialmatrix2(dd-1,2) && newnewtrialmatrix2(dd+2,5) ==5 && newnewtrialmatrix2(dd+1,5) ==5 && newnewtrialmatrix2(dd,5) ==5 &&  newnewtrialmatrix2(dd-1,5)==5
                 possiblebreaks2=[possiblebreaks2 dd];
                    end
                end
                               
                ntrialperblock=round(length(newnewtrialmatrix)/5);
                candidates=possiblebreaks(find(possiblebreaks>ntrialperblock));
                
                ntrialperblock2=round(length(newnewtrialmatrix2)/5);
                candidates2=possiblebreaks2(find(possiblebreaks2>ntrialperblock2));
                
                thebreaks=(length(candidates)+1)/5;
                thebreaks2=(length(candidates2)+1)/5;
                
                thebreaks=5;
                thebreaks2=thebreaks;
                
                trialbreak=[];
                trialbreak2=[];
                             
totaltrialbreak=[trialbreak trialbreak2+length(newnewtrialmatrix)];
totalnewnewtrial=[newnewtrialmatrix; newnewtrialmatrix2];
totalnewnewtrial_incongruent=totalnewnewtrial;
        
% how many incongruent trials? here we decide
trialincongruent_endo=round(number_of_hold_trials*.2); % 20% incongruent
trialincongruent_exo=round(number_of_hold_trials*.5); % 50% incongruent

n=[zeros(1,number_of_hold_trials-trialincongruent_endo) ones(1,trialincongruent_endo)];

arrayori1=n(randperm(length(n)));
arrayori2=n(randperm(length(n)));
arrayori3=n(randperm(length(n)));
arrayori4=n(randperm(length(n)));
arrayori5=n(randperm(length(n)));
arrayori6=n(randperm(length(n)));
arrayori7=n(randperm(length(n)));
arrayori8=n(randperm(length(n)));
arrayori9=n(randperm(length(n)));
arrayori10=n(randperm(length(n)));
arrayori11=n(randperm(length(n)));
arrayori12=n(randperm(length(n)));

counter1=0;
counter2=0;
counter3=0;
counter4=0;
counter5=0;
counter6=0;
counter7=0;
counter8=0;
counter9=0;
counter10=0;
counter11=0;
counter12=0;

n_exo=[zeros(1,number_of_hold_trials-trialincongruent_exo) ones(1,trialincongruent_exo)];

arrayori1_exo=n_exo(randperm(length(n_exo)));
arrayori2_exo=n_exo(randperm(length(n_exo)));
arrayori3_exo=n_exo(randperm(length(n_exo)));
arrayori4_exo=n_exo(randperm(length(n_exo)));
arrayori5_exo=n_exo(randperm(length(n_exo)));
arrayori6_exo=n_exo(randperm(length(n_exo)));
arrayori7_exo=n_exo(randperm(length(n_exo)));
arrayori8_exo=n_exo(randperm(length(n_exo)));
arrayori9_exo=n_exo(randperm(length(n_exo)));
arrayori10_exo=n_exo(randperm(length(n_exo)));
arrayori11_exo=n_exo(randperm(length(n_exo)));
arrayori12_exo=n_exo(randperm(length(n_exo)));

counter1_exo=0;
counter2_exo=0;
counter3_exo=0;
counter4_exo=0;
counter5_exo=0;
counter6_exo=0;
counter7_exo=0;
counter8_exo=0;
counter9_exo=0;
counter10_exo=0;
counter11_exo=0;
counter12_exo=0;

        kk1=0;
        kk2=0;
        kk3=0;
        kk4=0;
               
        %% add incongruent trials
totalnewnewtrial_incongruent=totalnewnewtrial;

for dd=2:length(totalnewnewtrial_incongruent)
    if totalnewnewtrial_incongruent(dd,1)==1 && totalnewnewtrial_incongruent(dd,5)>5
        kk1=kk1+1;
        if totalnewnewtrial_incongruent(dd,3)==1 && totalnewnewtrial_incongruent(dd,4)==2
            counter1=counter1+1;
            if arrayori1(counter1)==1
                cueori=[ 7 8 9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
        elseif totalnewnewtrial_incongruent(dd,3)==1 && totalnewnewtrial_incongruent(dd,4)==3
            counter2=counter2+1;
            if arrayori2(counter2)==1
                 cueori=[ 7 8 9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
        elseif totalnewnewtrial_incongruent(dd,3)==2 && totalnewnewtrial_incongruent(dd,4)==1
            counter3=counter3+1;          
            if arrayori3(counter3)==1
                 cueori=[6  8 9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
        elseif totalnewnewtrial_incongruent(dd,3)==2 && totalnewnewtrial_incongruent(dd,4)==3
            counter4=counter4+1;
            if arrayori4(counter4)==1
                 cueori=[6  8 9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
        elseif totalnewnewtrial_incongruent(dd,3)==3 && totalnewnewtrial_incongruent(dd,4)==1
            counter5=counter5+1;
            if arrayori5(counter5)==1
                 cueori=[6 7  9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
        elseif totalnewnewtrial_incongruent(dd,3)==3 && totalnewnewtrial_incongruent(dd,4)==2
            counter6=counter6+1;
            if arrayori6(counter6)==1
                 cueori=[6 7  9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end          
             elseif totalnewnewtrial_incongruent(dd,3)==1 && totalnewnewtrial_incongruent(dd,4)==4
            counter7=counter7+1;
            if arrayori7(counter7)==1
                 cueori=[ 7 8 9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
                         elseif totalnewnewtrial_incongruent(dd,3)==2 && totalnewnewtrial_incongruent(dd,4)==4
            counter8=counter8+1;
            if arrayori8(counter8)==1
                 cueori=[6  8 9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
                       
                         elseif totalnewnewtrial_incongruent(dd,3)==3 && totalnewnewtrial_incongruent(dd,4)==4
            counter9=counter9+1;
            if arrayori9(counter9)==1
                 cueori=[6 7  9];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end           
                         elseif totalnewnewtrial_incongruent(dd,3)==4 && totalnewnewtrial_incongruent(dd,4)==1
            counter10=counter10+1;
            if arrayori10(counter10)==1
                 cueori=[6 7 8 ];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
                         elseif totalnewnewtrial_incongruent(dd,3)==4 && totalnewnewtrial_incongruent(dd,4)==2
            counter11=counter11+1;
            if arrayori11(counter11)==1
                 cueori=[6 7 8 ];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
                         elseif totalnewnewtrial_incongruent(dd,3)==4 && totalnewnewtrial_incongruent(dd,4)==3
            counter12=counter12+1;
            if arrayori12(counter12)==1
                 cueori=[6 7 8 ];
                thecue=totalnewnewtrial_incongruent(dd,5);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[totalnewnewtrial_incongruent(dd,1:4) thenewcue];
            end
        end       
    elseif totalnewnewtrial_incongruent(dd,1)==0 
        kk3=kk3+1;
        wh=randi(10);                      
        if totalnewnewtrial_incongruent(dd-1,3)==1 && totalnewnewtrial_incongruent(dd-1,4)==2
            counter1_exo=counter1_exo+1;
            if arrayori1_exo(counter1_exo)==1
                             cueori=[ 2 3 4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end            
        elseif totalnewnewtrial_incongruent(dd-1,3)==1 && totalnewnewtrial_incongruent(dd-1,4)==3
            counter2_exo=counter2_exo+1;
            if arrayori2_exo(counter2_exo)==1
                             cueori=[ 2 3 4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end            
        elseif totalnewnewtrial_incongruent(dd-1,3)==2 && totalnewnewtrial_incongruent(dd-1,4)==1
            counter3_exo=counter3_exo+1;
            if arrayori3_exo(counter3_exo)==1
                             cueori=[1  3 4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end
        elseif totalnewnewtrial_incongruent(dd-1,3)==2 && totalnewnewtrial_incongruent(dd-1,4)==3
            counter4_exo=counter4_exo+1;
            if arrayori4_exo(counter4_exo)==1
                             cueori=[1  3 4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end
        elseif totalnewnewtrial_incongruent(dd-1,3)==3 && totalnewnewtrial_incongruent(dd-1,4)==1
            counter5_exo=counter5_exo+1;
            if arrayori5_exo(counter5_exo)==1
                             cueori=[1 2  4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end
        elseif totalnewnewtrial_incongruent(dd-1,3)==3 && totalnewnewtrial_incongruent(dd-1,4)==2
            counter6_exo=counter6_exo+1;
            if arrayori6_exo(counter6_exo)==1
                             cueori=[1 2  4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end          
            elseif totalnewnewtrial_incongruent(dd-1,3)==1 && totalnewnewtrial_incongruent(dd-1,4)==4
            counter7_exo=counter7_exo+1;
            if arrayori7_exo(counter7_exo)==1
                             cueori=[ 2 3 4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end           
            elseif totalnewnewtrial_incongruent(dd-1,3)==2 && totalnewnewtrial_incongruent(dd-1,4)==4
            counter8_exo=counter8_exo+1;
            if arrayori8_exo(counter8_exo)==1
                             cueori=[1  3 4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end            
            elseif totalnewnewtrial_incongruent(dd-1,3)==3 && totalnewnewtrial_incongruent(dd-1,4)==4
            counter9_exo=counter9_exo+1;
            if arrayori9_exo(counter9_exo)==1
                             cueori=[1 2 3 4];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end           
            elseif totalnewnewtrial_incongruent(dd-1,3)==4 && totalnewnewtrial_incongruent(dd-1,4)==1
            counter10_exo=counter10_exo+1;
            if arrayori10_exo(counter10_exo)==1
                             cueori=[1 2 3 ];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end            
            elseif totalnewnewtrial_incongruent(dd-1,3)==4 && totalnewnewtrial_incongruent(dd-1,4)==2
            counter11_exo=counter11_exo+1;
            if arrayori11_exo(counter11_exo)==1
                             cueori=[1 2 3 ];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end            
            elseif totalnewnewtrial_incongruent(dd-1,3)==4 && totalnewnewtrial_incongruent(dd-1,4)==3
            counter12_exo=counter12_exo+1;
            if arrayori12_exo(counter12_exo)==1
                             cueori=[1 2 3 ];
                thecue=totalnewnewtrial_incongruent(dd,2);
                otherc=cueori(cueori~=thecue);
                thenewcue=otherc(randi(2));
                totalnewnewtrial_incongruent(dd,:)=[ totalnewnewtrial_incongruent(dd,1) thenewcue totalnewnewtrial_incongruent(dd,3:5)];
            end
        end
    end
end

        totalnewnewtrial_incongruent_exo=totalnewnewtrial_incongruent(totalnewnewtrial_incongruent(:,1)~=1,:);       
        
        if stop_start==1
 totalnewnewtrial_incongruent2=totalnewnewtrial_incongruent;
                 contati=0;
                 contati2=0;
                 contati3=0;
        totalnewnewtrial_incongruent2=[];
        for riu=2:length(totalnewnewtrial_incongruent)
            if totalnewnewtrial_incongruent(riu-1,5)>5
                contati=contati+1;
                dumm=[3 totalnewnewtrial_incongruent(riu,2:end)];
            totalnewnewtrial_incongruent2=[totalnewnewtrial_incongruent2; totalnewnewtrial_incongruent(riu,:); dumm];
            dumm=[];
            elseif totalnewnewtrial_incongruent(riu,1)==0
                 contati2=contati2+1;
                dumm=[3 totalnewnewtrial_incongruent(riu,2:end)];
            totalnewnewtrial_incongruent2=[totalnewnewtrial_incongruent2; totalnewnewtrial_incongruent(riu,:); dumm];
            dumm=[];               
            elseif totalnewnewtrial_incongruent(riu-1,1)==1 && totalnewnewtrial_incongruent(riu,1)==2
                
                 contati3=contati3+1;
                 
                 totalnewnewtrial_incongruent2(riu,:)=[3 totalnewnewtrial_incongruent(riu,2:end-1) 3];
                
            else
           totalnewnewtrial_incongruent2=[totalnewnewtrial_incongruent2; totalnewnewtrial_incongruent(riu,:)];
            end
           
        end       
                        dumm=[3 totalnewnewtrial_incongruent(1,2:end)];
        totalnewnewtrial_incongruent2=[dumm; totalnewnewtrial_incongruent2];                           
     totalnewnewtrial_incongruent2(round(length(totalnewnewtrial_incongruent2)/2+1),1)=3;       
        end
        
        for seu=2:length(totalnewnewtrial_incongruent2)           
            if totalnewnewtrial_incongruent2(seu-1,1)==1 && totalnewnewtrial_incongruent2(seu,1)==2                              
            %    newone= [3 totalnewnewtrial_incongruent2(seu,2:end)];
            newone= [3 totalnewnewtrial_incongruent2(seu,2:end-1) randi(4)];
                totalnewnewtrial_incongruent3=[totalnewnewtrial_incongruent2(1:seu-1,:); newone; totalnewnewtrial_incongruent2(seu:end,:)];
            end
        end
              
        for da=2:length(totalnewnewtrial_incongruent2)
            if totalnewnewtrial_incongruent2(da,1)==3               
            end           
        end
                
                    abc=find(totalnewnewtrial_incongruent2(:,1)==3);
        totaltrialbreak=(abc(1:10:end));
        totaltrialbreak=totaltrialbreak(2:end);


     sss=[ (1:length(totalnewnewtrial_incongruent2(:,1)))' totalnewnewtrial_incongruent2];         

sss2=[(1:length(totalnewnewtrial_incongruent3(:,1)))' totalnewnewtrial_incongruent3];
dummysss=[sss nan(length(sss(:,1)),1) nan(length(sss(:,1)),1)];

% find endo-exo divider
ce=find(totalnewnewtrial_incongruent3(:,1)==2);
%create endo only matrix
nexendo=totalnewnewtrial_incongruent3(1:ce(1)-2,:);
% %clean up final part of endo so that it ends on a 3 
threeindex=find(nexendo(:,1)==3);
nexendox=nexendo(1:threeindex(end),:);


nexexo=totalnewnewtrial_incongruent3(ce(1)-1:end,:);
threeindex=find(nexexo(:,1)==3);
nexexox=nexexo(1:threeindex(end),:);


totalnewnewtrial_incongruent4=[nexendox; nexexox];

du= find(totalnewnewtrial_incongruent4(:,1)==3 & totalnewnewtrial_incongruent4(:,5)==5)

if du>0    
    for ud=1:length(du)
        totalnewnewtrial_incongruent4(du(ud),:)=[totalnewnewtrial_incongruent4(du(ud),1:end-1) randi(4)];
    end   
end
%~=
%sss 1: trial n
%sss 2: trial type: 0: exogenous cue, 1: endogenous trial, 2: exogenous stream,3: beginning of trial/wait until response, 
%sss 3:where the cue is
%sss 4: where the stream is
%sss 5: where the stream will go
%sss 6: target type: 1-4: ori, 5: foil, 6-9: cue ori


%FLAP
%structure: totalnewnewtrial_incongruent2
%1:type of trial (0-3) %0 = exo trial switch %1= endo trial, %2 = exo trial %3= wait for response
%2: cue location (1-4)
%3: target location (1-4)
%4: next target location (1-4)
%5: target type: 5=foil, 6=up cue, 7=right cue, 8=down cue, 9=left cue

%target locations:
%1=up
%2=right
%3=down
%4=left
%cue locations
%6=up
%7=right
%8=down 
%9=left

%% THIS IS NOT NECESSARY ANYMORE
%Adjust for 'impossible cues' (e.g., when the stimulus is down and the cue
% %is dow, when the stimulus is up and the cue is up, etc)
% for sud=1:length(totalnewnewtrial_incongruent2)
% if totalnewnewtrial_incongruent2(sud,5)>5
%   if totalnewnewtrial_incongruent2(sud,3)==1 && totalnewnewtrial_incongruent2(sud,5)~=6 % target will appear up
%       possibleOri=[];
%       totalnewnewtrial_incongruent2(sud,5)=possibleOri(randi(2));
%   elseif totalnewnewtrial_incongruent2(sud,4)==2 && totalnewnewtrial_incongruent2(sud,5)~=7 % target will appear right
%   elseif totalnewnewtrial_incongruent2(sud,4)==3 && totalnewnewtrial_incongruent2(sud,5)~=8 % target will appear down
%         elseif totalnewnewtrial_incongruent2(sud,4)==4 && totalnewnewtrial_incongruent2(sud,5)~=9 % target will appear left
%   end
% end
% end
diditclose=10;
end
save RSVPTrialMat2022-D.mat
end
io