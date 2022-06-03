%RSVP endo-exo attention task analysis
%Marcello Maniglia July 2021
% modified by Kristina Visscher October, 2021
% This file requires first loading the outputs of the function FLAP_RSVP.m
% first clear all.  Then load your file.  Then run this script.

% Things to do potentially: make function, input filename.

sss;
thesix=size(sss)


if thesix(2)<8
    ohui=1
    if exist('respo')==1
        if length(respo)<trial
            s=trial-length(respo);
            ss=nan(1,s);

            respo=[respo ss];
        end
        if length(respRT)<trial
            s=trial-length(respRT);
            ss=nan(1,s);
            respRT=[respRT ss];
        end
        sss=[(1:length(respo))' newtrialmatrix(1:length(respo),:) respo' respRT'];
    end
end
% column headings are:
%1 trial
%3 type of trial: 0-exogenous cue trial, 1-endogenous , 2-exogenous in between
%cues, 3-first trial endogenous
%3 cue position (newmatrix,2)
%4 target position (newmatrix,3)
%5 target position next
%6 type of stimulus: 1-4: target, 5:foil, 6-8:cue
%7  accuracy
%8 RT
%cue X position:
% 6 x 1
% 7 x 2
% 8 x 3
%9 x 4

totalN=length(sss);
%positions:1=up, 2=right, 3=down, 4 = left

%% endogenous congruent
%%
% switch cost is congruent - incongruent



% 12 switch axes (1-2, 1-3, 1-4, 2-1, 2-3, 2-4, 3-1, 3-2, 3-4, 4-1, 4-2, 4-3)
% 6 switch trial type (3,3,4,4)
%endo: 80% congruent: meaning: 5 switches congruent, 1 incongruent


% [TRIAL_N TYPE_OF_TRIAL CUE TGT NEXT_TGT ORI CORR RT]  <-- ?? what is this? kmv
CorrPos1to2=0; % Corr means Congruent; Pos means position
CorrPos1to3=0;
CorrPos1to4=0;
CorrPos2to1=0;
CorrPos2to3=0;
CorrPos2to4=0;
CorrPos3to1=0;
CorrPos3to2=0;
CorrPos3to4=0;
CorrPos4to1=0;
CorrPos4to2=0;
CorrPos4to3=0;

CorrPos1to2RT=NaN;
CorrPos1to3RT=NaN;
CorrPos1to4RT=NaN;
CorrPos2to1RT=NaN;
CorrPos2to3RT=NaN;
CorrPos2to4RT=NaN;
CorrPos3to1RT=NaN;
CorrPos3to2RT=NaN;
CorrPos3to4RT=NaN;
CorrPos4to1RT=NaN;
CorrPos4to2RT=NaN;
CorrPos4to3RT=NaN;


counter=0;

pos1to2=0;
pos1to3=0;
pos1to4=0;
pos2to1=0;
pos2to3=0;
pos2to4=0;
pos3to1=0;
pos3to2=0;
pos3to4=0;
pos4to1=0;
pos4to2=0;
pos4to3=0;

CorrPos1to2Miss=0; % Corr stands for congruent.
CorrPos1to3Miss=0;
CorrPos1to4Miss=0;
CorrPos2to1Miss=0;
CorrPos2to3Miss=0;
CorrPos2to4Miss=0;
CorrPos3to1Miss=0;
CorrPos3to2Miss=0;
CorrPos3to4Miss=0;
CorrPos4to1Miss=0;
CorrPos4to2Miss=0;
CorrPos4to3Miss=0;


%cue X position:
% 6 x 1
% 7 x 2
% 8 x 3
%9 x 4


%sss structure:
%1
%2:type of trial (0-3) %0 = exo trial switch %1= endo trial, %2 = exo trial %3= wait for response
%3: cue location (1-4) only relevant for exogenous (if consistent
%with 3, valid cue, iif inconsistent, invalid cue
%4: target location (1-4)
%5: next target location (1-4)
%6: target type: 5=foil, 6=up cue, 7=right cue, 8=down cue, 9=left cue
%7: correct response =1, incorrect = 0
%8: RT

for ui=2:length(sss) % for each trial
    if sss(ui,2)==1 % endogenous trial
        if sss(ui-1,4)==2 && sss(ui-1,6)==6 && sss(ui,4)==1 % previous trial gave cue from position 2 to position 1
            pos2to1=pos2to1+1;
            if sss(ui,7)==1 % if it was correct
                CorrPos2to1=CorrPos2to1+1;
                CorrPos2to1RT(CorrPos2to1)=NaN;
                if sss(ui,8)>0
                    CorrPos2to1RT(CorrPos2to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos2to1Miss=CorrPos2to1Miss+1;
            end
        elseif sss(ui-1,4)==3 && sss(ui-1,6)==6 && sss(ui,4)==1 % previous trial gave cue from position 3 to position 1
            pos3to1=pos3to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos3to1=CorrPos3to1+1;
                CorrPos3to1RT(CorrPos3to1)=NaN;
                if sss(ui,8)>0
                    CorrPos3to1RT(CorrPos3to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos3to1Miss=CorrPos3to1Miss+1;
            end
        elseif sss(ui-1,4)==4 && sss(ui-1,6)==6 && sss(ui,4)==1
            pos4to1=pos4to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos4to1=CorrPos4to1+1;
                CorrPos4to1RT(CorrPos4to1)=NaN;
                if sss(ui,8)>0
                    CorrPos4to1RT(CorrPos4to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos4to1Miss=CorrPos4to1Miss+1;
            end
        elseif sss(ui-1,4)==1 && sss(ui-1,6)==7 && sss(ui,4)==2
            pos1to2=pos1to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos1to2=CorrPos1to2+1;
                CorrPos1to2RT(CorrPos1to2)=NaN;
                if sss(ui,8)>0
                    CorrPos1to2RT(CorrPos1to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos1to2Miss=CorrPos1to2Miss+1;
            end
        elseif sss(ui-1,4)==3 && sss(ui-1,6)==7 && sss(ui,4)==2
            pos3to2=pos3to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos3to2=CorrPos3to2+1;
                CorrPos3to2RT(CorrPos3to2)=NaN;
                if sss(ui,8)>0
                    CorrPos3to2RT(CorrPos3to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos3to2Miss=CorrPos3to2Miss+1;
            end
        elseif sss(ui-1,4)==4 && sss(ui-1,6)==7 && sss(ui,4)==2
            pos4to2=pos4to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos4to2=CorrPos4to2+1;
                CorrPos4to2RT(CorrPos4to2)=NaN;
                if sss(ui,8)>0
                    CorrPos4to2RT(CorrPos4to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos4to2Miss=CorrPos4to2Miss+1;
            end
        elseif sss(ui-1,4)==1 && sss(ui-1,6)==8 && sss(ui,4)==3
            pos1to3=pos1to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos1to3=CorrPos1to3+1;
                CorrPos1to3RT(CorrPos1to3)=NaN;
                if sss(ui,8)>0
                    CorrPos1to3RT(CorrPos1to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos1to3Miss=CorrPos1to3Miss+1;
            end
        elseif sss(ui-1,4)==2 && sss(ui-1,6)==8 && sss(ui,4)==3
            pos2to3=pos2to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos2to3=CorrPos2to3+1;
                CorrPos2to3RT(CorrPos2to3)=NaN;
                if sss(ui,8)>0
                    CorrPos2to3RT(CorrPos2to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos2to3Miss=CorrPos2to3Miss+1;
            end
        elseif sss(ui-1,4)==4 && sss(ui-1,6)==8 && sss(ui,4)==3
            pos4to3=pos4to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos4to3=CorrPos4to3+1;
                CorrPos4to3RT(CorrPos4to3)=NaN;
                if sss(ui,8)>0
                    CorrPos4to3RT(CorrPos4to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos4to3Miss=CorrPos4to3Miss+1;
            end
        elseif sss(ui-1,4)==1 && sss(ui-1,6)==9 && sss(ui,4)==4
            pos1to4=pos1to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos1to4=CorrPos1to4+1;
                CorrPos1to4RT(CorrPos1to4)=NaN;
                if sss(ui,8)>0
                    CorrPos1to4RT(CorrPos1to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos1to4Miss=CorrPos1to4Miss+1;
            end
        elseif sss(ui-1,4)==2 && sss(ui-1,6)==9 && sss(ui,4)==4
            pos2to4=pos2to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos2to4=CorrPos2to4+1;
                CorrPos2to4RT(CorrPos2to4)=NaN;
                if sss(ui,8)>0
                    CorrPos2to4RT(CorrPos2to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos2to4Miss=CorrPos2to4Miss+1;
            end
        elseif sss(ui-1,4)==3 && sss(ui-1,6)==9 && sss(ui,4)==4
            pos3to4=pos3to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos3to4=CorrPos3to4+1;
                CorrPos3to4RT(CorrPos3to4)=NaN;
                if sss(ui,8)>0
                    CorrPos3to4RT(CorrPos3to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                CorrPos3to4Miss=CorrPos3to4Miss+1;
            end
        else
            counter=counter+1;
        end
    end
end

%%incongruent: cue presented to the wrong place

inCorrPos1to2=0; % inCorr stands for incongruent
inCorrPos1to3=0;
inCorrPos1to4=0;
inCorrPos2to1=0;
inCorrPos2to3=0;
inCorrPos2to4=0;
inCorrPos3to1=0;
inCorrPos3to2=0;
inCorrPos3to4=0;
inCorrPos4to1=0;
inCorrPos4to2=0;
inCorrPos4to3=0;

inCorrPos1to2RT=[];
inCorrPos1to3RT=[];
inCorrPos1to4RT=[];
inCorrPos2to1RT=[];
inCorrPos2to3RT=[];
inCorrPos2to4RT=[];
inCorrPos3to1RT=[];
inCorrPos3to2RT=[];
inCorrPos3to4RT=[];
inCorrPos4to1RT=[];
inCorrPos4to2RT=[];
inCorrPos4to3RT=[];

incounter=0;

inPos1to2=0;
inPos1to3=0;
inPos1to4=0;
inPos2to1=0;
inPos2to3=0;
inPos2to4=0;
inPos3to1=0;
inPos3to2=0;
inPos3to4=0;
inPos4to1=0;
inPos4to2=0;
inPos4to3=0;


inCorrPos1to2Miss=0;
inCorrPos1to3Miss=0;
inCorrPos1to4Miss=0;
inCorrPos2to1Miss=0;
inCorrPos2to3Miss=0;
inCorrPos2to4Miss=0;
inCorrPos3to1Miss=0;
inCorrPos3to2Miss=0;
inCorrPos3to4Miss=0;
inCorrPos4to1Miss=0;
inCorrPos4to2Miss=0;
inCorrPos4to3Miss=0;

for ui=2:length(sss)
    if sss(ui,2)==1
        if sss(ui-1,4)==2 && sss(ui-1,6)~=6 && sss(ui,4)==1
            inPos2to1=inPos2to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos2to1=inCorrPos2to1+1;
                inCorrPos2to1RT(inCorrPos2to1)=NaN;
                if sss(ui,8)>0
                    inCorrPos2to1RT(inCorrPos2to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos2to1Miss=inCorrPos2to1Miss+1;
            end
        elseif sss(ui-1,4)==3 && sss(ui-1,6)~=6 && sss(ui,4)==1  % stream moves from 2 to 1 with cue pointing to 3 or 4
            inPos3to1=inPos3to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos3to1=inCorrPos3to1+1;
                inCorrPos3to1RT(inCorrPos3to1)=NaN;
                if sss(ui,8)>0
                    inCorrPos3to1RT(inCorrPos3to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos3to1Miss=inCorrPos3to1Miss+1;
            end
        elseif sss(ui-1,4)==4 && sss(ui-1,6)~=6 && sss(ui,4)==1  % stream moves from 2 to 1 with cue pointing to 3 or 4
            inPos4to1=inPos4to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos4to1=inCorrPos4to1+1;
                inCorrPos4to1RT(inCorrPos4to1)=NaN;
                if sss(ui,8)>0
                    inCorrPos4to1RT(inCorrPos4to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos4to1Miss=inCorrPos4to1Miss+1;
            end
        elseif sss(ui-1,4)==1 && sss(ui-1,6)~=7 && sss(ui,4)==2
            inPos1to2=inPos1to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos1to2=inCorrPos1to2+1;
                inCorrPos1to2RT(inCorrPos1to2)=NaN;
                if sss(ui,8)>0
                    inCorrPos1to2RT(inCorrPos1to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos1to2Miss=inCorrPos1to2Miss+1;
            end           
        elseif sss(ui-1,4)==3 && sss(ui-1,6)~=7 && sss(ui,4)==2
            inPos3to2=inPos3to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos3to2=inCorrPos3to2+1;
                inCorrPos3to2RT(inCorrPos3to2)=NaN;
                if sss(ui,8)>0
                    inCorrPos3to2RT(inCorrPos3to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos3to2Miss=inCorrPos3to2Miss+1;
            end
        elseif sss(ui-1,4)==4 && sss(ui-1,6)~=7 && sss(ui,4)==2
            inPos4to2=inPos4to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos4to2=inCorrPos4to2+1;
                inCorrPos4to2RT(inCorrPos4to2)=NaN;
                if sss(ui,8)>0
                    inCorrPos4to2RT(inCorrPos4to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos4to2Miss=inCorrPos4to2Miss+1;
            end
        elseif sss(ui-1,4)==1 && sss(ui-1,6)~=8 && sss(ui,4)==3
            inPos1to3=inPos1to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos1to3=inCorrPos1to3+1;
                inCorrPos1to3RT(inCorrPos1to3)=NaN;
                if sss(ui,8)>0
                    inCorrPos1to3RT(inCorrPos1to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos1to3Miss=inCorrPos1to3Miss+1;
            end
        elseif sss(ui-1,4)==2 && sss(ui-1,6)~=8 && sss(ui,4)==3
            inPos2to3=inPos2to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos2to3=inCorrPos2to3+1;
                inCorrPos2to3RT(inCorrPos2to3)=NaN;
                if sss(ui,8)>0
                    inCorrPos2to3RT(inCorrPos2to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos2to3Miss=inCorrPos2to3Miss+1;
            end
        elseif sss(ui-1,4)==4 && sss(ui-1,6)~=8 && sss(ui,4)==3
            inPos4to3=inPos4to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos4to3=inCorrPos4to3+1;
                inCorrPos4to3RT(inCorrPos4to3)=NaN;
                if sss(ui,8)>0
                    inCorrPos4to3RT(inCorrPos4to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos4to3Miss=inCorrPos4to3Miss+1;
            end
        elseif sss(ui-1,4)==1 && sss(ui-1,6)~=9 && sss(ui,4)==4
            inPos1to4=inPos1to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos1to4=inCorrPos1to4+1;
                inCorrPos1to4RT(inCorrPos1to4)=NaN;
                if sss(ui,8)>0
                    inCorrPos1to4RT(inCorrPos1to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos1to4Miss=inCorrPos1to4Miss+1;
            end
        elseif sss(ui-1,4)==2 && sss(ui-1,6)~=9 && sss(ui,4)==4
            inPos2to4=inPos2to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos2to4=inCorrPos2to4+1;
                inCorrPos2to4RT(inCorrPos2to4)=NaN;
                if sss(ui,8)>0
                    inCorrPos2to4RT(inCorrPos2to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos2to4Miss=inCorrPos2to4Miss+1;
            end
        elseif sss(ui-1,4)==3 && sss(ui-1,6)~=9 && sss(ui,4)==4
            inPos3to4=inPos3to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                inCorrPos3to4=inCorrPos3to4+1;
                inCorrPos3to4RT(inCorrPos3to4)=NaN;
                if sss(ui,8)>0
                    inCorrPos3to4RT(inCorrPos3to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                inCorrPos3to4Miss=inCorrPos3to4Miss+1;
            end
        else
            incounter=incounter+1;
        end
    end
end


%%incongruent: target presented to the wrong place <- what is the
%%difference between target presented to wrong place and cue presented to
%%wrong place?

twoinCorrPos1to2=0;
twoinCorrPos1to3=0;
twoinCorrPos1to4=0;
twoinCorrPos2to1=0;
twoinCorrPos2to3=0;
twoinCorrPos2to4=0;
twoinCorrPos3to1=0;
twoinCorrPos3to2=0;
twoinCorrPos3to4=0;
twoinCorrPos4to1=0;
twoinCorrPos4to2=0;
twoinCorrPos4to3=0;

twoinCorrPos1to2RT=[];
twoinCorrPos1to3RT=[];
twoinCorrPos1to4RT=[];
twoinCorrPos2to1RT=[];
twoinCorrPos2to3RT=[];
twoinCorrPos2to4RT=[];
twoinCorrPos3to1RT=[];
twoinCorrPos3to2RT=[];
twoinCorrPos3to4RT=[];
twoinCorrPos4to1RT=[];
twoinCorrPos4to2RT=[];
twoinCorrPos4to3RT=[];

twoincounter=0;

twoinCorrPos1to2Miss=0;
twoinCorrPos1to3Miss=0;
twoinCorrPos1to4Miss=0;
twoinCorrPos2to1Miss=0;
twoinCorrPos2to3Miss=0;
twoinCorrPos2to4Miss=0;
twoinCorrPos3to1Miss=0;
twoinCorrPos3to2Miss=0;
twoinCorrPos3to4Miss=0;
twoinCorrPos4to1Miss=0;
twoinCorrPos4to2Miss=0;
twoinCorrPos4to3Miss=0;


twoinPos1to2=0;
twoinPos1to3=0;
twoinPos1to4=0;
twoinPos2to1=0;
twoinPos2to3=0;
twoinPos2to4=0;
twoinPos3to1=0;
twoinPos3to2=0;
twoinPos3to4=0;
twoinPos4to1=0;
twoinPos4to2=0;
twoinPos4to3=0;

for ui=2:length(sss)
    if sss(ui,2)==1
        if sss(ui-1,3)==2 && sss(ui-1,6)==6 && sss(ui,4)~=1  % stream in 2 cues to 1 but goes to 3 or 4
            twoinPos2to1=twoinPos2to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos2to1=twoinCorrPos2to1+1;
                if sss(ui,8)>0
                    twoinCorrPos2to1RT(twoinCorrPos2to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos2to1Miss=twoinCorrPos2to1Miss+1;
            end
        elseif sss(ui-1,3)==3 && sss(ui-1,6)==6 && sss(ui,4)~=1  % stream in 3 cues to 1 but goes to 2 or 4
            twoinPos3to1=twoinPos3to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos3to1=twoinCorrPos3to1+1;
                if sss(ui,8)>0
                    twoinCorrPos3to1RT(twoinCorrPos3to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos3to1Miss=twoinCorrPos3to1Miss+1;
            end
        elseif sss(ui-1,3)==4 && sss(ui-1,6)==6 && sss(ui,4)~=1  % stream in 4 cues to 1 but goes to 2 or 4
            twoinPos4to1=twoinPos4to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos4to1=twoinCorrPos4to1+1;
                if sss(ui,8)>0
                    twoinCorrPos4to1RT(twoinCorrPos4to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPo4to1Miss=twoinCorrPos4to1Miss+1;
            end
        elseif sss(ui-1,3)==1 && sss(ui-1,6)==7 && sss(ui,4)~=2  % stream in 1 cues to 2 but goes to 3 or 4
            twoinPos1to2=twoinPos1to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos1to2=twoinCorrPos1to2+1;
                if sss(ui,8)>0
                    twoinCorrPos1to2RT(twoinCorrPos1to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos1to2Miss=twoinCorrPos1to2Miss+1;
            end
        elseif sss(ui-1,3)==3 && sss(ui-1,6)==7 && sss(ui,4)~=2  % stream in 3 cues to 2 but goes to 3 or 4
            twoinPos3to2=twoinPos3to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos3to2=twoinCorrPos3to2+1;
                if sss(ui,8)>0
                    twoinCorrPos3to2RT(twoinCorrPos3to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos3to2Miss=twoinCorrPos3to2Miss+1;
            end
        elseif sss(ui-1,3)==4 && sss(ui-1,6)==7 && sss(ui,4)~=2  % stream in 4 cues to 2 but goes to 3 or 1
            twoinPos4to2=twoinPos4to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos4to2=twoinCorrPos4to2+1;
                if sss(ui,8)>0
                    twoinCorrPos4to2RT(twoinCorrPos4to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos4to2Miss=twoinCorrPos4to2Miss+1;
            end
        elseif sss(ui-1,3)==1 && sss(ui-1,6)==8 && sss(ui,4)~=3  % stream in 1 cues to 3 but goes to 2 or 4
            twoinPos1to3=twoinPos1to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos1to3=twoinCorrPos1to3+1;
                if sss(ui,8)>0
                    twoinCorrPos1to3RT(twoinCorrPos1to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos1to3Miss=twoinCorrPos1to3Miss+1;
            end
        elseif sss(ui-1,3)==2 && sss(ui-1,6)==8 && sss(ui,4)~=3  % stream in 2 cues to 3 but goes to 2 or 4
            twoinPos2to3=twoinPos2to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos2to3=twoinCorrPos2to3+1;
                if sss(ui,8)>0
                    twoinCorrPos2to3RT(twoinCorrPos2to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos2to3Miss=twoinCorrPos2to3Miss+1;
            end
        elseif sss(ui-1,3)==4 && sss(ui-1,6)==8 && sss(ui,4)~=3  % stream in 4 cues to 3 but goes to 2 or 1
            twoinPos4to3=twoinPos4to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos4to3=twoinCorrPos4to3+1;
                if sss(ui,8)>0
                    twoinCorrPos4to3RT(twoinCorrPos4to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos4to3Miss=twoinCorrPos4to3Miss+1;
            end
        elseif sss(ui-1,3)==1 && sss(ui-1,6)==9 && sss(ui,4)~=4  % stream in 1 cues to 4 but goes to 2 or 1
            twoinPos1to4=twoinPos1to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos1to4=twoinCorrPos1to4+1;
                if sss(ui,8)>0
                    twoinCorrPos1to4RT(twoinCorrPos1to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos1to4Miss=twoinCorrPos1to4Miss+1;
            end
        elseif sss(ui-1,3)==2 && sss(ui-1,6)==9 && sss(ui,4)~=4  % stream in 2 cues to 4 but goes to 2 or 1
            twoinPos2to4=twoinPos2to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos2to4=twoinCorrPos2to4+1;
                if sss(ui,8)>0
                    twoinCorrPos2to4RT(twoinCorrPos2to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos2to4Miss=twoinCorrPos2to4Miss+1;
            end
        elseif sss(ui-1,3)==3 && sss(ui-1,6)==9 && sss(ui,4)~=4  % stream in 3 cues to 4 but goes to 2 or 1
            twoinPos3to4=twoinPos3to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                twoinCorrPos3to4=twoinCorrPos3to4+1;
                if sss(ui,8)>0
                    twoinCorrPos3to4RT(twoinCorrPos3to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                twoinCorrPos3to4Miss=twoinCorrPos3to4Miss+1;
            end
        else
            twoincounter=twoincounter+1;
        end
    end
end
%% exogenous
%%
exCorrPos1to2=0;
exCorrPos1to3=0;
exCorrPos1to4=0;
exCorrPos2to1=0;
exCorrPos2to3=0;
exCorrPos2to4=0;
exCorrPos3to1=0;
exCorrPos3to2=0;
exCorrPos3to4=0;
exCorrPos4to1=0;
exCorrPos4to2=0;
exCorrPos4to3=0;

exCorrPos1to2RT=[];
exCorrPos1to3RT=[];
exCorrPos1to4RT=[];
exCorrPos2to1RT=[];
exCorrPos2to3RT=[];
exCorrPos2to4RT=[];
exCorrPos3to1RT=[];
exCorrPos3to2RT=[];
exCorrPos3to4RT=[];
exCorrPos4to1RT=[];
exCorrPos4to2RT=[];
exCorrPos4to3RT=[];

excounter=0;

exPos1to2=0;
exPos1to3=0;
exPos1to4=0;
exPos2to1=0;
exPos2to3=0;
exPos2to4=0;
exPos3to1=0;
exPos3to2=0;
exPos3to4=0;
exPos4to1=0;
exPos4to2=0;
exPos4to3=0;

exCorrPos1to2Miss=0;
exCorrPos1to3Miss=0;
exCorrPos1to4Miss=0;
exCorrPos2to1Miss=0;
exCorrPos2to3Miss=0;
exCorrPos2to4Miss=0;
exCorrPos3to1Miss=0;
exCorrPos3to2Miss=0;
exCorrPos3to4Miss=0;
exCorrPos4to1Miss=0;
exCorrPos4to2Miss=0;
exCorrPos4to3Miss=0;


%(ui,3) = cue location
%(ui,4) = target location
for ui=2:length(sss)
    if sss(ui,2)==0
        if sss(ui,4)==1 && sss(ui-1,4)==2 && sss(ui,3)==sss(ui,4)
            exPos2to1=exPos2to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos2to1=exCorrPos2to1+1;
                exCorrPos2to1RT(exCorrPos2to1)=NaN;
                if sss(ui,8)>0
                    exCorrPos2to1RT(exCorrPos2to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos2to1Miss=exCorrPos2to1Miss+1;
            end
        elseif sss(ui,4)==1 && sss(ui-1,4)==3 && sss(ui,3)==sss(ui,4)
            exPos3to1=exPos3to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos3to1=exCorrPos3to1+1;
                exCorrPos3to1RT(exCorrPos3to1)=NaN;
                if sss(ui,8)>0
                    exCorrPos3to1RT(exCorrPos3to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos3to1Miss=exCorrPos3to1Miss+1;
            end
        elseif sss(ui,4)==1 && sss(ui-1,4)==4 && sss(ui,3)==sss(ui,4)
            exPos4to1=exPos4to1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos4to1=exCorrPos4to1+1;
                exCorrPos4to1RT(exCorrPos4to1)=NaN;
                if sss(ui,8)>0
                    exCorrPos4to1RT(exCorrPos4to1)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos4to1Miss=exCorrPos4to1Miss+1;
            end           
        elseif sss(ui,4)==2 && sss(ui-1,4)==1 && sss(ui,3)==sss(ui,4)
            exPos1to2=exPos1to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos1to2=exCorrPos1to2+1;
                exCorrPos1to2RT(exCorrPos1to2)=NaN;
                if sss(ui,8)>0
                    exCorrPos1to2RT(exCorrPos1to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos1to2Miss=exCorrPos1to2Miss+1;
            end            
        elseif sss(ui,4)==2 && sss(ui-1,4)==3 && sss(ui,3)==sss(ui,4)
            exPos3to2=exPos3to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos3to2=exCorrPos3to2+1;
                exCorrPos3to2RT(exCorrPos3to2)=NaN;
                if sss(ui,8)>0
                    exCorrPos3to2RT(exCorrPos3to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos3to2Miss=exCorrPos3to2Miss+1;
            end            
        elseif sss(ui,4)==2 && sss(ui-1,4)==4 && sss(ui,3)==sss(ui,4)
            exPos4to2=exPos4to2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos4to2=exCorrPos4to2+1;
                exCorrPos4to2RT(exCorrPos4to2)=NaN;
                if sss(ui,8)>0
                    exCorrPos4to2RT(exCorrPos4to2)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos4to2Miss=exCorrPos4to2Miss+1;
            end                        
        elseif sss(ui,4)==3 && sss(ui-1,4)==1 && sss(ui,3)==sss(ui,4)
            exPos1to3=exPos1to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos1to3=exCorrPos1to3+1;
                exCorrPos1to3RT(exCorrPos1to3)=NaN;
                if sss(ui,8)>0
                    exCorrPos1to3RT(exCorrPos1to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos1to3Miss=exCorrPos1to3Miss+1;
            end            
        elseif sss(ui,4)==3 && sss(ui-1,4)==2 && sss(ui,3)==sss(ui,4)
            exPos2to3=exPos2to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos2to3=exCorrPos2to3+1;
                exCorrPos2to3RT(exCorrPos2to3)=NaN;
                if sss(ui,8)>0
                    exCorrPos2to3RT(exCorrPos2to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos2to3Miss=exCorrPos2to3Miss+1;
            end            
        elseif sss(ui,4)==3 && sss(ui-1,4)==4 && sss(ui,3)==sss(ui,4)
            exPos4to3=exPos4to3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos4to3=exCorrPos4to3+1;
                exCorrPos4to3RT(exCorrPos4to3)=NaN;
                if sss(ui,8)>0
                    exCorrPos4to3RT(exCorrPos4to3)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos4to3Miss=exCorrPos4to3Miss+1;
            end
        elseif sss(ui,4)==4 && sss(ui-1,4)==1 && sss(ui,3)==sss(ui,4)
            exPos1to4=exPos1to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos1to4=exCorrPos1to4+1;
                exCorrPos1to4RT(exCorrPos1to4)=NaN;
                if sss(ui,8)>0
                    exCorrPos1to4RT(exCorrPos1to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos1to4Miss=exCorrPos1to4Miss+1;
            end            
        elseif sss(ui,4)==4 && sss(ui-1,4)==2 && sss(ui,3)==sss(ui,4)
            exPos2to4=exPos2to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos2to4=exCorrPos2to4+1;
                exCorrPos2to4RT(exCorrPos2to4)=NaN;
                if sss(ui,8)>0
                    exCorrPos2to4RT(exCorrPos2to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos2to4Miss=exCorrPos2to4Miss+1;
            end            
        elseif sss(ui,4)==4 && sss(ui-1,4)==3 && sss(ui,3)==sss(ui,4)
            exPos3to4=exPos3to4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos3to4=exCorrPos3to4+1;
                exCorrPos3to4RT(exCorrPos3to4)=NaN;
                if sss(ui,8)>0
                    exCorrPos3to4RT(exCorrPos3to4)=sss(ui,8);
                end
            elseif sss(ui,7)==0
                exCorrPos3to4Miss=exCorrPos3to4Miss+1;
            end           
        else
            excounter=excounter+1;
        end        
    end
end

%% switch cost incongruent: cue presented to the wrong place

exinCorrPos1to2=0;
exinCorrPos1to3=0;
exinCorrPos1to4=0;
exinCorrPos2to1=0;
exinCorrPos2to3=0;
exinCorrPos2to4=0;
exinCorrPos3to1=0;
exinCorrPos3to2=0;
exinCorrPos3to4=0;
exinCorrPos4to1=0;
exinCorrPos4to2=0;
exinCorrPos4to3=0;

exinCorrPos1to2RT=[];
exinCorrPos1to3RT=[];
exinCorrPos1to4RT=[];
exinCorrPos2to1RT=[];
exinCorrPos2to3RT=[];
exinCorrPos2to4RT=[];
exinCorrPos3to1RT=[];
exinCorrPos3to2RT=[];
exinCorrPos3to4RT=[];
exinCorrPos4to1RT=[];
exinCorrPos4to2RT=[];
exinCorrPos4to3RT=[];

exincounter=0;

exinPos1to2=0;
exinPos1to3=0;
exinPos1to4=0;
exinPos2to1=0;
exinPos2to3=0;
exinPos2to4=0;
exinPos3to1=0;
exinPos3to2=0;
exinPos3to4=0;
exinPos4to1=0;
exinPos4to2=0;
exinPos4to3=0;

exinCorrPos1to2Miss=0;
exinCorrPos1to3Miss=0;
exinCorrPos1to4Miss=0;
exinCorrPos2to1Miss=0;
exinCorrPos2to3Miss=0;
exinCorrPos2to4Miss=0;
exinCorrPos3to1Miss=0;
exinCorrPos3to2Miss=0;
exinCorrPos3to4Miss=0;
exinCorrPos4to1Miss=0;
exinCorrPos4to2Miss=0;
exinCorrPos4to3Miss=0;

% example: exinCorrPos2to1--> target n-1 in position 2, exo
% cue in position 3, target in position 1


% example: exinCorrPos3to1--> target n-1 in position 3, exo
% cue in position 2, target in position 1

for ui=2:length(sss)
    if sss(ui,2)==0
        if sss(ui,3)~=1  && sss(ui,4)==1  && sss(ui-1,4)==2
            exinPos2to1=exinPos2to1+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos2to1=exinCorrPos2to1+1;
                exinCorrPos2to1RT(exinCorrPos2to1)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos2to1Miss=exinCorrPos2to1Miss+1;
            end
        elseif sss(ui,3)~=1  && sss(ui,4)==1  && sss(ui-1,4)==3 %stream goes from 3 to  1, but cue flashes somewhere else
            exinPos3to1=exinPos3to1+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos3to1=exinCorrPos3to1+1;
                exinCorrPos3to1RT(exinCorrPos3to1)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos3to1Miss=exinCorrPos3to1Miss+1;
            end
        elseif sss(ui,3)~=1  && sss(ui,4)==1  && sss(ui-1,4)==4 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos4to1=exinPos4to1+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos4to1=exinCorrPos4to1+1;
                exinCorrPos4to1RT(exinCorrPos4to1)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos4to1Miss=exinCorrPos4to1Miss+1;
            end
        elseif sss(ui,3)~=2  && sss(ui,4)==2  && sss(ui-1,4)==1 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos1to2=exinPos1to2+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos1to2=exinCorrPos1to2+1;
                exinCorrPos1to2RT(exinCorrPos1to2)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos1to2Miss=exinCorrPos1to2Miss+1;
            end
        elseif sss(ui,3)~=2  && sss(ui,4)==2  && sss(ui-1,4)==3 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos3to2=exinPos3to2+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos3to2=exinCorrPos3to2+1;
                exinCorrPos3to2RT(exinCorrPos3to2)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos3to2Miss=exinCorrPos3to2Miss+1;
            end
        elseif sss(ui,3)~=2  && sss(ui,4)==2  && sss(ui-1,4)==4 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos4to2=exinPos4to2+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos4to2=exinCorrPos4to2+1;
                exinCorrPos4to2RT(exinCorrPos4to2)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos4to2Miss=exinCorrPos4to2Miss+1;
            end
        elseif sss(ui,3)~=3  && sss(ui,4)==3  && sss(ui-1,4)==1 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos1to3=exinPos1to3+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos1to3=exinCorrPos1to3+1;
                exinCorrPos1to3RT(exinCorrPos1to3)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos1to3Miss=exinCorrPos1to3Miss+1;
            end           
        elseif sss(ui,3)~=3  && sss(ui,4)==3  && sss(ui-1,4)==2 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos2to3=exinPos2to3+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos2to3=exinCorrPos2to3+1;
                exinCorrPos2to3RT(exinCorrPos2to3)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos2to3Miss=exinCorrPos2to3Miss+1;
            end           
        elseif sss(ui,3)~=3  && sss(ui,4)==3  && sss(ui-1,4)==4 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos4to3=exinPos4to3+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos4to3=exinCorrPos4to3+1;
                exinCorrPos4to3RT(exinCorrPos4to3)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos4to3Miss=exinCorrPos4to3Miss+1;
            end           
        elseif sss(ui,3)~=4  && sss(ui,4)==4  && sss(ui-1,4)==1 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos1to4=exinPos1to4+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos1to4=exinCorrPos1to4+1;
                exinCorrPos1to4RT(exinCorrPos1to4)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos1to4Miss=exinCorrPos1to4Miss+1;
            end           
        elseif sss(ui,3)~=4  && sss(ui,4)==4  && sss(ui-1,4)==2 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos2to4=exinPos2to4+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos2to4=exinCorrPos2to4+1;
                exinCorrPos2to4RT(exinCorrPos2to4)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos2to4Miss=exinCorrPos2to4Miss+1;
            end           
        elseif sss(ui,3)~=4  && sss(ui,4)==4  && sss(ui-1,4)==3 %stream goes from 4 to  1, but cue flashes somewhere else
            exinPos3to4=exinPos3to4+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                exinCorrPos3to4=exinCorrPos3to4+1;
                exinCorrPos3to4RT(exinCorrPos3to4)=sss(ui,8);
            elseif sss(ui,7)==0
                exinCorrPos3to4Miss=exinCorrPos3to4Miss+1;
            end
        else
            exincounter=exincounter+1;
        end
        
    end
end

%% switch cost incongruent: target presented to the wrong place

extwoinCorrPos1to2=0;
extwoinCorrPos1to3=0;
extwoinCorrPos1to4=0;
extwoinCorrPos2to1=0;
extwoinCorrPos2to3=0;
extwoinCorrPos2to4=0;
extwoinCorrPos3to1=0;
extwoinCorrPos3to2=0;
extwoinCorrPos3to4=0;
extwoinCorrPos4to1=0;
extwoinCorrPos4to2=0;
extwoinCorrPos4to3=0;

extwoinCorrPos1to2RT=[];
extwoinCorrPos1to3RT=[];
extwoinCorrPos1to4RT=[];
extwoinCorrPos2to1RT=[];
extwoinCorrPos2to3RT=[];
extwoinCorrPos2to4RT=[];
extwoinCorrPos3to1RT=[];
extwoinCorrPos3to2RT=[];
extwoinCorrPos3to4RT=[];
extwoinCorrPos4to1RT=[];
extwoinCorrPos4to2RT=[];
extwoinCorrPos4to3RT=[];

extwoincounter=0;

extwoinCorrPos1to2Miss=0;
extwoinCorrPos1to3Miss=0;
extwoinCorrPos1to4Miss=0;
extwoinCorrPos2to1Miss=0;
extwoinCorrPos2to3Miss=0;
extwoinCorrPos2to4Miss=0;
extwoinCorrPos3to1Miss=0;
extwoinCorrPos3to2Miss=0;
extwoinCorrPos3to4Miss=0;
extwoinCorrPos4to1Miss=0;
extwoinCorrPos4to2Miss=0;
extwoinCorrPos4to3Miss=0;

extwoinPos1to2=0;
extwoinPos1to3=0;
extwoinPos1to4=0;
extwoinPos2to1=0;
extwoinPos2to3=0;
extwoinPos2to4=0;
extwoinPos3to1=0;
extwoinPos3to2=0;
extwoinPos3to4=0;
extwoinPos4to1=0;
extwoinPos4to2=0;
extwoinPos4to3=0;

% example: extwoinCorrPos2to1--> target n-1 in position 2, exo
% cue in position 1, target in position 3

for ui=2:length(sss)
    if sss(ui,2)==0
        if sss(ui,4)~=1  && sss(ui,3)==1  && sss(ui-1,4)==2 %ss(ui,1)~=3
            extwoinPos2to1=extwoinPos2to1+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos2to1=extwoinCorrPos2to1+1;
                extwoinCorrPos2to1RT(extwoinCorrPos2to1)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos2to1Miss=extwoinCorrPos2to1Miss+1;
            end
        elseif sss(ui,4)~=1  && sss(ui,3)==1  && sss(ui-1,4)==3 %ss(ui,1)~=3
            extwoinPos3to1=extwoinPos3to1+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos3to1=extwoinCorrPos3to1+1;
                extwoinCorrPos3to1RT(extwoinCorrPos3to1)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos3to1Miss=extwoinCorrPos3to1Miss+1;
            end
        elseif sss(ui,4)~=1  && sss(ui,3)==1  && sss(ui-1,4)==4 %ss(ui,1)~=3
            extwoinPos4to1=extwoinPos4to1+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos4to1=extwoinCorrPos4to1+1;
                extwoinCorrPos4to1RT(extwoinCorrPos4to1)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos4to1Miss=extwoinCorrPos4to1Miss+1;
            end
        elseif sss(ui,4)~=2  && sss(ui,3)==2  && sss(ui-1,4)==1 %ss(ui,1)~=3
            extwoinPos1to2=extwoinPos1to2+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos1to2=extwoinCorrPos1to2+1;
                extwoinCorrPos1to2RT(extwoinCorrPos1to2)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos1to2Miss=extwoinCorrPos1to2Miss+1;
            end
        elseif sss(ui,4)~=2  && sss(ui,3)==2  && sss(ui-1,4)==3 %ss(ui,1)~=3
            extwoinPos3to2=extwoinPos3to2+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos3to2=extwoinCorrPos3to2+1;
                extwoinCorrPos3to2RT(extwoinCorrPos3to2)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos3to2Miss=extwoinCorrPos3to2Miss+1;
            end
        elseif sss(ui,4)~=2  && sss(ui,3)==2  && sss(ui-1,4)==4 %ss(ui,1)~=3
            extwoinPos4to2=extwoinPos4to2+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos4to2=extwoinCorrPos4to2+1;
                extwoinCorrPos4to2RT(extwoinCorrPos4to2)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos4to2Miss=extwoinCorrPos4to2Miss+1;
            end
        elseif sss(ui,4)~=3  && sss(ui,3)==3  && sss(ui-1,4)==1 %ss(ui,1)~=3
            extwoinPos1to3=extwoinPos1to3+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos1to3=extwoinCorrPos1to3+1;
                extwoinCorrPos1to3RT(extwoinCorrPos1to3)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos1to3Miss=extwoinCorrPos1to3Miss+1;
            end
        elseif sss(ui,4)~=3  && sss(ui,3)==3  && sss(ui-1,4)==2 %ss(ui,1)~=3
            extwoinPos2to3=extwoinPos2to3+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos2to3=extwoinCorrPos2to3+1;
                extwoinCorrPos2to3RT(extwoinCorrPos2to3)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos2to3Miss=extwoinCorrPos2to3Miss+1;
            end
        elseif sss(ui,4)~=3  && sss(ui,3)==3  && sss(ui-1,4)==4 %ss(ui,1)~=3
            extwoinPos4to3=extwoinPos4to3+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos4to3=extwoinCorrPos4to3+1;
                extwoinCorrPos4to3RT(extwoinCorrPos4to3)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos4to3Miss=extwoinCorrPos4to3Miss+1;
            end
        elseif sss(ui,4)~=4  && sss(ui,3)==4  && sss(ui-1,4)==1 %ss(ui,1)~=3
            extwoinPos1to4=extwoinPos1to4+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos1to4=extwoinCorrPos1to4+1;
                extwoinCorrPos1to4RT(extwoinCorrPos1to4)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos1to4Miss=extwoinCorrPos1to4Miss+1;
            end           
        elseif sss(ui,4)~=4  && sss(ui,3)==4  && sss(ui-1,4)==2 %ss(ui,1)~=3
            extwoinPos2to4=extwoinPos2to4+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos2to4=extwoinCorrPos2to4+1;
                extwoinCorrPos2to4RT(extwoinCorrPos2to4)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos2to4Miss=extwoinCorrPos2to4Miss+1;
            end
        elseif sss(ui,4)~=4  && sss(ui,3)==4  && sss(ui-1,4)==3 %ss(ui,1)~=3
            extwoinPos3to4=extwoinPos3to4+1;
            if sss(ui,7)==1 && sss(ui,8)>0
                extwoinCorrPos3to4=extwoinCorrPos3to4+1;
                extwoinCorrPos3to4RT(extwoinCorrPos3to4)=sss(ui,8);
            elseif sss(ui,7)==0
                extwoinCorrPos3to4Miss=extwoinCorrPos3to4Miss+1;
            end            
        else
            extwoincounter=extwoincounter+1;
        end
    end
end
%% 
% 
%% sustained trials
CorrPos1=0;
CorrPos2=0;
CorrPos3=0;
CorrPos4=0;
CorrPos1RT=[];
CorrPos2RT=[];
CorrPos3RT=[];
CorrPos4RT=[];
CorrPos1Miss=0;
CorrPos2Miss=0;
CorrPos3Miss=0;
CorrPos4Miss=0;

suscounter=0;

susPos1=0;
susPos2=0;
susPos3=0;
susPos4=0;

for ui=2:length(sss) % endogenous trials
    if sss(ui,2)==1
        if sss(ui,4)==1 && sss(ui,6)<5 && sss(ui-1,4)==1 %&& sss(ui-1,6)==6 && sss(ui,4)==1  %ss(ui,1)~=3
            susPos1=susPos1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos1=CorrPos1+1;
                CorrPos1RT(CorrPos1)=NaN;
                if sss(ui,8)>0
                    CorrPos1RT(CorrPos1)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                CorrPos1Miss=CorrPos1Miss+1;
            end
        elseif sss(ui,4)==2 && sss(ui,6)<5 && sss(ui-1,4)==2 % && sss(ui,6)==7 && sss(ui,4)==2
            susPos2=susPos2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos2=CorrPos2+1;
                CorrPos2RT(CorrPos2)=NaN;
                if sss(ui,8)>0
                    CorrPos2RT(CorrPos2)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                CorrPos2Miss=CorrPos2Miss+1;
            end
        elseif sss(ui,4)==3 && sss(ui,6)<5 && sss(ui-1,4)==3 %sss(ui,6)==8 && sss(ui,4)==3
            susPos3=susPos3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos3=CorrPos3+1;
                CorrPos3RT(CorrPos3)=NaN;
                if sss(ui,8)>0
                    CorrPos3RT(CorrPos3)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                CorrPos3Miss=CorrPos3Miss+1;
            end
        elseif sss(ui,4)==4 && sss(ui,6)<5 && sss(ui-1,4)==4 %sss(ui,6)==8 && sss(ui,4)==3
            susPos4=susPos4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                CorrPos4=CorrPos4+1;
                CorrPos4RT(CorrPos4)=NaN;
                if sss(ui,8)>0
                    CorrPos4RT(CorrPos4)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                CorrPos4Miss=CorrPos4Miss+1;
            end
        elseif sss(ui,6)==5
            suscounter=suscounter+1;
        end
    end
end


% sustained exo
exCorrPos1=0;
exCorrPos2=0;
exCorrPos3=0;
exCorrPos4=0;

exCorrPos1RT=[];
exCorrPos2RT=[];
exCorrPos3RT=[];
exCorrPos4RT=[];

exsuscounter=0;

exsusPos1=0;
exsusPos2=0;
exsusPos3=0;
exsusPos4=0;

exCorrPos1Miss=0;
exCorrPos2Miss=0;
exCorrPos3Miss=0;
exCorrPos4Miss=0;

for ui=2:length(sss)
    if sss(ui,2)==2
        if sss(ui,4)==1 && sss(ui,6)<5 %&& sss(ui-1,6)==6 && sss(ui,4)==1  %ss(ui,1)~=3
            exsusPos1=exsusPos1+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos1=exCorrPos1+1;
                exCorrPos1RT(exCorrPos1)=NaN;
                if sss(ui,8)>0
                    exCorrPos1RT(exCorrPos1)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                exCorrPos1Miss=exCorrPos1Miss+1;
            end
        elseif sss(ui,4)==2 && sss(ui,6)<5 % && sss(ui,6)==7 && sss(ui,4)==2
            exsusPos2=exsusPos2+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos2=exCorrPos2+1;
                exCorrPos2RT(exCorrPos2)=NaN;
                if sss(ui,8)>0
                    exCorrPos2RT(exCorrPos2)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                exCorrPos2Miss=exCorrPos2Miss+1;
            end
        elseif sss(ui,4)==3 && sss(ui,6)<5 % sss(ui,6)==8 && sss(ui,4)==3
            exsusPos3=exsusPos3+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos3=exCorrPos3+1;
                exCorrPos3RT(exCorrPos3)=NaN;
                if sss(ui,8)>0
                    exCorrPos3RT(exCorrPos3)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                exCorrPos3Miss=exCorrPos3Miss+1;
            end
        elseif sss(ui,4)==4 && sss(ui,6)<5 % sss(ui,6)==8 && sss(ui,4)==3
            exsusPos4=exsusPos4+1;
            if sss(ui,7)==1 %&& sss(ui,8)>0
                exCorrPos4=exCorrPos4+1;
                exCorrPos4RT(exCorrPos4)=NaN;
                if sss(ui,8)>0
                    exCorrPos4RT(exCorrPos4)=sss(ui,8);
                end
            elseif sss(ui,7)==0 && sss(ui,6)<5
                exCorrPos4Miss=exCorrPos4Miss+1;
            end
        elseif sss(ui,6)==5 %elseif sss(ui,6)==5
            exsuscounter=exsuscounter+1;
        end
    end
end
%% summary stats
%%
%switch cost endogenous congruent

CorrPos1to2;
CorrPos1to2RT;
CorrPos1to3;
CorrPos1to3RT;
CorrPos1to4;
CorrPos1to4RT;
CorrPos2to1;
CorrPos2to1RT;
CorrPos2to3;
CorrPos2to3RT;
CorrPos2to4;
CorrPos2to4RT;
CorrPos3to1;
CorrPos3to1RT;
CorrPos3to2;
CorrPos3to2RT;
CorrPos3to4;
CorrPos3to4RT;
CorrPos4to1;
CorrPos4to1RT;
CorrPos4to2;
CorrPos4to2RT;
CorrPos4to3;
CorrPos4to3RT;

counter;

pos1to2;
pos1to3;
pos1to4;
pos2to1;
pos2to3;
pos2to4;
pos3to1;
pos3to2;
pos3to4;
pos4to1;
pos4to2;
pos4to3;

%%%%%%%%
EndoSwitchCostTo1=[CorrPos2to1RT CorrPos3to1RT CorrPos4to1RT]
meanEndoTo1=nanmean(EndoSwitchCostTo1)
EndoSwitchCostAway1=[CorrPos1to3RT CorrPos1to2RT CorrPos1to4RT]
meanEndoAway1=nanmean(EndoSwitchCostAway1)
EndoSwitchCostTo2=[CorrPos1to2RT CorrPos3to2RT CorrPos4to2RT]
meanEndoTo2=nanmean(EndoSwitchCostTo2)
EndoSwitchCostAway2=[CorrPos2to3RT CorrPos2to1RT CorrPos2to4RT]
meanEndoAway2=nanmean(EndoSwitchCostAway2)
EndoSwitchCostTo3=[CorrPos2to3RT CorrPos1to3RT CorrPos4to3RT]
meanEndoTo3=nanmean(EndoSwitchCostTo3)
EndoSwitchCostAway3=[CorrPos3to1RT CorrPos3to2RT CorrPos3to4RT]
meanEndoAway3=nanmean(EndoSwitchCostAway3)

EndoSwitchCostTo4=[CorrPos2to4RT CorrPos1to4RT CorrPos3to4RT]
meanEndoTo4=nanmean(EndoSwitchCostTo4)
EndoSwitchCostAway4=[CorrPos4to1RT CorrPos4to2RT CorrPos4to3RT]
meanEndoAway4=nanmean(EndoSwitchCostAway4)



EndoSwitchCostTo1Acc=[CorrPos2to1/pos2to1 CorrPos3to1/pos3to1 CorrPos4to1/pos4to1];
meanEndoTo1Acc=nanmean(EndoSwitchCostTo1Acc)
EndoSwitchCostAway1Acc=[CorrPos1to3/pos1to3 CorrPos1to2/pos1to2 CorrPos1to4/pos1to4]
meanEndoAway1Acc=nanmean(EndoSwitchCostAway1Acc)
EndoSwitchCostTo2Acc=[CorrPos1to2/pos1to2 CorrPos3to2/pos3to2 CorrPos4to2/pos4to2]
meanEndoTo2Acc=nanmean(EndoSwitchCostTo2Acc)
EndoSwitchCostAway2Acc=[CorrPos2to3/pos2to3 CorrPos2to1/pos2to1 CorrPos2to4/pos2to4]
meanEndoAway2Acc=nanmean(EndoSwitchCostAway2Acc)
EndoSwitchCostTo3Acc=[CorrPos2to3/pos2to3 CorrPos1to3/pos1to3 CorrPos4to3/pos4to3]
meanEndoTo3Acc=nanmean(EndoSwitchCostTo3Acc)
EndoSwitchCostAway3Acc=[CorrPos3to1/pos3to1 CorrPos3to2/pos3to2 CorrPos3to4/pos3to4]
meanEndoAway3Acc=nanmean(EndoSwitchCostAway3Acc)

EndoSwitchCostTo4Acc=[CorrPos2to4/pos2to4 CorrPos1to4/pos1to4 CorrPos3to4/pos3to4]
meanEndoTo4Acc=nanmean(EndoSwitchCostTo4Acc)
EndoSwitchCostAway4Acc=[CorrPos4to1/pos4to1 CorrPos4to2/pos4to2 CorrPos4to3/pos4to3]
meanEndoAway4Acc=nanmean(EndoSwitchCostAway4Acc)


%switch cost endo incongruent: cue presented to the wrong place, target
%presented in the reported place (i.e., pos 1 to 2: target moved from 1 to
%2 independently from cue location

inCorrPos1to2;
inCorrPos1to2RT;
inCorrPos1to3;
inCorrPos1to3RT;
inCorrPos1to4;
inCorrPos1to4RT;
inCorrPos2to1;
inCorrPos2to1RT;
inCorrPos2to3;
inCorrPos2to3RT;
inCorrPos2to4;
inCorrPos2to4RT;
inCorrPos3to1;
inCorrPos3to1RT;
inCorrPos3to2;
inCorrPos3to2RT;
inCorrPos3to4;
inCorrPos3to4RT;
inCorrPos4to1;
inCorrPos4to1RT;
inCorrPos4to2;
inCorrPos4to2RT;
inCorrPos4to3;
inCorrPos4to3RT;

incounter;

inPos1to2
inPos1to3
inPos1to4
inPos2to1
inPos2to3
inPos2to4
inPos3to1
inPos3to2
inPos3to4
inPos4to1
inPos4to2
inPos4to3


EndoSwitchCostTo1inc=[inCorrPos2to1RT inCorrPos3to1RT inCorrPos4to1RT]
meanEndoTo1inc=nanmean(EndoSwitchCostTo1inc)
EndoSwitchCostAway1inc=[inCorrPos1to3RT inCorrPos1to2RT inCorrPos1to4RT]
meanEndoAway1inc=nanmean(EndoSwitchCostAway1inc)
EndoSwitchCostTo2inc=[inCorrPos1to2RT inCorrPos3to2RT inCorrPos4to2RT]
meanEndoTo2inc=nanmean(EndoSwitchCostTo2inc)
EndoSwitchCostAway2inc=[inCorrPos2to3RT inCorrPos2to1RT inCorrPos2to4RT]
meanEndoAway2inc=nanmean(EndoSwitchCostAway2inc)
EndoSwitchCostTo3inc=[inCorrPos2to3RT inCorrPos1to3RT inCorrPos4to3RT]
meanEndoTo3inc=nanmean(EndoSwitchCostTo3inc)
EndoSwitchCostAway3inc=[inCorrPos3to1RT inCorrPos3to2RT inCorrPos3to4RT]
meanEndoAway3inc=nanmean(EndoSwitchCostAway3inc)
EndoSwitchCostTo4inc=[inCorrPos2to4RT inCorrPos1to4RT inCorrPos3to4RT]
meanEndoTo4inc=nanmean(EndoSwitchCostTo4inc)
EndoSwitchCostAway4inc=[inCorrPos4to1RT inCorrPos4to2RT inCorrPos4to3RT]
meanEndoAway4inc=nanmean(EndoSwitchCostAway4inc)


EndoSwitchCostTo1Accinc=[inCorrPos2to1/inPos2to1 inCorrPos3to1/inPos3to1 inCorrPos4to1/inPos4to1]
meanEndoTo1incAcc=nanmean(EndoSwitchCostTo1Accinc)
EndoSwitchCostAway1Accinc=[inCorrPos1to3/inPos1to3 inCorrPos1to2/inPos1to2 inCorrPos1to4/inPos1to4]
meanEndoAway1incAcc=nanmean(EndoSwitchCostAway1Accinc)
EndoSwitchCostTo2Accinc=[inCorrPos1to2/inPos1to2 inCorrPos3to2/inPos3to2 inCorrPos4to2/inPos4to2]
meanEndoTo2incAcc=nanmean(EndoSwitchCostTo2Accinc)
EndoSwitchCostAway2Accinc=[inCorrPos2to3/inPos2to3 inCorrPos2to1/inPos2to1 inCorrPos2to4/inPos2to4]
meanEndoAway2incAcc=nanmean(EndoSwitchCostAway2Accinc)
EndoSwitchCostTo3Accinc=[inCorrPos2to3/inPos2to3 inCorrPos1to3/inPos1to3 inCorrPos4to3/inPos4to3]
meanEndoTo3incAcc=nanmean(EndoSwitchCostTo3Accinc)
EndoSwitchCostAway3Accinc=[inCorrPos3to1/inPos3to1 inCorrPos3to2/inPos3to2 inCorrPos3to4/inPos3to4]
meanEndoAway3incAcc=nanmean(EndoSwitchCostAway3Accinc)

EndoSwitchCostTo4Accinc=[inCorrPos2to4/inPos2to4 inCorrPos1to4/inPos1to4 inCorrPos3to4/inPos3to4];
meanEndoTo4incAcc=nanmean(EndoSwitchCostTo4Accinc)
EndoSwitchCostAway4Accinc=[inCorrPos4to1/inPos4to1 inCorrPos4to2/inPos4to2 inCorrPos4to3/inPos4to3]
meanEndoAway4incAcc=nanmean(EndoSwitchCostAway4Accinc)


%switch cost endo incongruent: target presented to the wrong place

twoinCorrPos1to2;
twoinCorrPos1to2RT;
twoinCorrPos1to3;
twoinCorrPos1to3RT;
twoinCorrPos1to4;
twoinCorrPos1to4RT;
twoinCorrPos2to1;
twoinCorrPos2to1RT;
twoinCorrPos2to3;
twoinCorrPos2to3RT;
twoinCorrPos2to4;
twoinCorrPos2to4RT;
twoinCorrPos3to1;
twoinCorrPos3to1RT;
twoinCorrPos3to2;
twoinCorrPos3to2RT;
twoinCorrPos3to4;
twoinCorrPos3to4RT;
twoinCorrPos4to1;
twoinCorrPos4to1RT;
twoinCorrPos4to2;
twoinCorrPos4to2RT;
twoinCorrPos4to3;
twoinCorrPos4to3RT;

twoincounter;

twoinPos1to2
twoinPos1to3
twoinPos1to4
twoinPos2to1
twoinPos2to3
twoinPos2to4
twoinPos3to1
twoinPos3to2
twoinPos3to4
twoinPos4to1
twoinPos4to2
twoinPos4to3
%
%
EndoSwitchCostTo1inc2=[twoinCorrPos2to1RT twoinCorrPos3to1RT twoinCorrPos4to1RT]
meanEndoTo1inc2=nanmean(EndoSwitchCostTo1inc2)

EndoSwitchCostAway1inc2=[twoinCorrPos1to3RT twoinCorrPos1to2RT twoinCorrPos1to4RT]
meanEndoAway1inc2=nanmean(EndoSwitchCostAway1inc2)

EndoSwitchCostTo2inc2=[twoinCorrPos1to2RT twoinCorrPos3to2RT twoinCorrPos4to2RT]
meanEndoTo2inc2=nanmean(EndoSwitchCostTo2inc2)

EndoSwitchCostAway2inc2=[twoinCorrPos2to3RT twoinCorrPos2to1RT twoinCorrPos2to4RT]
meanEndoAway2inc2=nanmean(EndoSwitchCostAway2inc2)

EndoSwitchCostTo3inc2=[twoinCorrPos2to3RT twoinCorrPos1to3RT twoinCorrPos4to3RT]
meanEndoTo3inc2=nanmean(EndoSwitchCostTo3inc2)

EndoSwitchCostAway3inc2=[twoinCorrPos3to1RT twoinCorrPos3to2RT twoinCorrPos3to4RT]
meanEndoAway3inc2=nanmean(EndoSwitchCostAway3inc2)

EndoSwitchCostTo4inc2=[twoinCorrPos2to4RT twoinCorrPos1to4RT twoinCorrPos3to4RT]
meanEndoTo4inc2=nanmean(EndoSwitchCostTo4inc2)

EndoSwitchCostAway4inc2=[twoinCorrPos4to1RT twoinCorrPos4to2RT twoinCorrPos4to3RT]
meanEndoAway4inc2=nanmean(EndoSwitchCostAway4inc2)



EndoSwitchCostTo1Accinc2=[twoinCorrPos2to1/twoinPos2to1 twoinCorrPos3to1/twoinPos3to1 twoinCorrPos4to1/twoinPos4to1]
meanEndoTo1incAcc2=nanmean(EndoSwitchCostTo1Accinc2)

EndoSwitchCostAway1Accinc2=[twoinCorrPos1to3/twoinPos1to3 twoinCorrPos1to2/twoinPos1to2 twoinCorrPos1to4/twoinPos1to4]
meanEndoAway1incAcc2=nanmean(EndoSwitchCostAway1Accinc2)

EndoSwitchCostTo2Accinc2=[twoinCorrPos1to2/twoinPos1to2 twoinCorrPos3to2/twoinPos3to2 twoinCorrPos4to2/twoinPos4to2]
meanEndoTo2incAcc2=nanmean(EndoSwitchCostTo2Accinc2)

EndoSwitchCostAway2Accinc2=[twoinCorrPos2to3/twoinPos2to3 twoinCorrPos2to1/twoinPos2to1 twoinCorrPos2to4/twoinPos2to4]
meanEndoAway2incAcc2=nanmean(EndoSwitchCostAway2Accinc2)

EndoSwitchCostTo3Accinc2=[twoinCorrPos2to3/twoinPos2to3 twoinCorrPos1to3/twoinPos1to3 twoinCorrPos4to3/twoinPos4to3]
meanEndoTo3incAcc2=nanmean(EndoSwitchCostTo3Accinc2)

EndoSwitchCostAway3Accinc2=[twoinCorrPos3to1/twoinPos3to1 twoinCorrPos3to2/twoinPos3to2 twoinCorrPos3to4/twoinPos3to4]
meanEndoAway3incAcc2=nanmean(EndoSwitchCostAway3Accinc2)

EndoSwitchCostTo4Accinc2=[twoinCorrPos2to4/twoinPos2to4 twoinCorrPos1to4/twoinPos1to4 twoinCorrPos3to4/twoinPos3to4]
meanEndoTo4incAcc2=nanmean(EndoSwitchCostTo4Accinc2)

EndoSwitchCostAway4Accinc2=[twoinCorrPos4to1/twoinPos4to1 twoinCorrPos4to2/twoinPos4to2 twoinCorrPos4to3/twoinPos4to3]
meanEndoAway4incAcc2=nanmean(EndoSwitchCostAway4Accinc2)


% exogenous
exCorrPos1to2;
exCorrPos1to2RT;
exCorrPos1to3;
exCorrPos1to3RT;
exCorrPos1to4;
exCorrPos1to4RT;
exCorrPos2to1;
exCorrPos2to1RT;
exCorrPos2to3;
exCorrPos2to3RT;
exCorrPos2to4;
exCorrPos2to4RT;
exCorrPos3to1;
exCorrPos3to1RT;
exCorrPos3to2;
exCorrPos3to2RT;
exCorrPos3to4;
exCorrPos3to4RT;
exCorrPos4to1;
exCorrPos4to1RT;
exCorrPos4to2;
exCorrPos4to2RT;
exCorrPos4to3;
exCorrPos4to3RT;

excounter;


exPos1to2
exPos1to3
exPos1to4
exPos2to1
exPos2to3
exPos2to4
exPos3to1
exPos3to2
exPos3to4
exPos4to1
exPos4to2
exPos4to3

ExSwitchCostTo1=[exCorrPos2to1RT exCorrPos3to1RT exCorrPos4to1RT]
meanExTo1=nanmean(ExSwitchCostTo1)
ExSwitchCostAway1=[exCorrPos1to3RT exCorrPos1to2RT exCorrPos1to4RT]
meanExAway1=nanmean(ExSwitchCostAway1)
ExSwitchCostTo2=[exCorrPos1to2RT exCorrPos3to2RT exCorrPos4to2RT]
meanExTo2=nanmean(ExSwitchCostTo2)
ExSwitchCostAway2=[exCorrPos2to3RT exCorrPos2to1RT exCorrPos2to4RT]
meanExAway2=nanmean(ExSwitchCostAway2)
ExSwitchCostTo3=[exCorrPos2to3RT exCorrPos1to3RT exCorrPos4to3RT]
meanExTo3=nanmean(ExSwitchCostTo3)
ExSwitchCostAway3=[exCorrPos3to1RT exCorrPos3to2RT exCorrPos3to4RT]
meanExAway3=nanmean(ExSwitchCostAway3)

ExSwitchCostTo4=[exCorrPos2to4RT exCorrPos1to4RT exCorrPos3to4RT]
meanExTo4=nanmean(ExSwitchCostTo4)
ExSwitchCostAway4=[exCorrPos4to1RT exCorrPos4to2RT exCorrPos4to3RT]
meanExAway4=nanmean(ExSwitchCostAway4)


ExSwitchCostTo1Acc=[exCorrPos2to1/exPos2to1 exCorrPos3to1/exPos3to1 exCorrPos3to1/exPos3to1]
meanExTo1Acc=nanmean(ExSwitchCostTo1Acc)
ExSwitchCostAway1Acc=[exCorrPos1to3/exPos1to3 exCorrPos1to2/exPos1to2 exCorrPos1to4/exPos1to4]
meanExAway1Acc=nanmean(ExSwitchCostAway1Acc)
ExSwitchCostTo2Acc=[exCorrPos1to2/exPos1to2 exCorrPos3to2/exPos3to2 exCorrPos4to2/exPos4to2]
meanExTo2Acc=nanmean(ExSwitchCostTo2Acc)
ExSwitchCostAway2Acc=[exCorrPos2to3/exPos2to3 exCorrPos2to1/exPos2to1 exCorrPos2to4/exPos2to4]
meanExAway2Acc=nanmean(ExSwitchCostAway2Acc)
ExSwitchCostTo3Acc=[exCorrPos2to3/exPos2to3 exCorrPos1to3/exPos1to3 exCorrPos4to3/exPos4to3]
meanExTo3Acc=nanmean(ExSwitchCostTo3Acc)
ExSwitchCostAway3Acc=[exCorrPos3to1/exPos3to1 exCorrPos3to2/exPos3to2 exCorrPos3to4/exPos3to4]
meanExAway3Acc=nanmean(ExSwitchCostAway3Acc)


ExSwitchCostTo4Acc=[exCorrPos2to4/exPos2to4 exCorrPos1to4/exPos1to4 exCorrPos3to4/exPos3to4]
meanExTo4Acc=nanmean(ExSwitchCostTo4Acc)
ExSwitchCostAway4Acc=[exCorrPos4to1/exPos4to1 exCorrPos4to2/exPos4to2 exCorrPos4to3/exPos4to3]
meanExAway4Acc=nanmean(ExSwitchCostAway4Acc)

%switch cost exo incongruent: cue presented to the wrong place

exinCorrPos1to2;
exinCorrPos1to2RT;
exinCorrPos1to3;
exinCorrPos1to3RT;
exinCorrPos1to4;
exinCorrPos1to4RT;
exinCorrPos2to1;
exinCorrPos2to1RT;
exinCorrPos2to3;
exinCorrPos2to3RT;
exinCorrPos2to4;
exinCorrPos2to4RT;
exinCorrPos3to1;
exinCorrPos3to1RT;
exinCorrPos3to2;
exinCorrPos3to2RT;
exinCorrPos3to4;
exinCorrPos3to4RT;
exinCorrPos4to1;
exinCorrPos4to1RT;
exinCorrPos4to2;
exinCorrPos4to2RT;
exinCorrPos4to3;
exinCorrPos4to3RT;

exincounter;


exinPos1to2
exinPos1to3
exinPos1to4
exinPos2to1
exinPos2to3
exinPos2to4
exinPos3to1
exinPos3to2
exinPos3to4
exinPos4to1
exinPos4to2
exinPos4to3



ExSwitchCostTo1in=[exinCorrPos2to1RT exinCorrPos3to1RT exinCorrPos4to1RT]
meanExTo1in=nanmean(ExSwitchCostTo1in)
ExSwitchCostAway1in=[exinCorrPos1to3RT exinCorrPos1to2RT exinCorrPos1to4RT]
meanExAway1in=nanmean(ExSwitchCostAway1in)
ExSwitchCostTo2in=[exinCorrPos1to2RT exinCorrPos3to2RT exinCorrPos4to2RT]
meanExTo2in=nanmean(ExSwitchCostTo2in)
ExSwitchCostAway2in=[exinCorrPos2to3RT exinCorrPos2to1RT exinCorrPos2to4RT]
meanExAway2in=nanmean(ExSwitchCostAway2in)
ExSwitchCostTo3in=[exinCorrPos2to3RT exinCorrPos1to3RT exinCorrPos4to3RT]
meanExTo3in=nanmean(ExSwitchCostTo3in)
ExSwitchCostAway3in=[exinCorrPos3to1RT exinCorrPos3to2RT exinCorrPos3to4RT]
meanExAway3in=nanmean(ExSwitchCostAway3in)


ExSwitchCostTo4in=[exinCorrPos2to4RT exinCorrPos1to4RT exinCorrPos3to4RT]
meanExTo4in=nanmean(ExSwitchCostTo4in)
ExSwitchCostAway4in=[exinCorrPos4to1RT exinCorrPos4to2RT exinCorrPos4to3RT]
meanExAway4in=nanmean(ExSwitchCostAway4in)

ExSwitchCostTo1Accin=[exinCorrPos2to1/exinPos2to1 exinCorrPos3to1/exinPos3to1 exinCorrPos4to1/exinPos4to1]
meanExTo1inAcc=nanmean(ExSwitchCostTo1Accin)
ExSwitchCostAway1Accin=[exinCorrPos1to3/exinPos1to3 exinCorrPos1to2/exinPos1to2 exinCorrPos1to4/exinPos1to4]
meanExAway1inAcc=nanmean(ExSwitchCostAway1Accin)
ExSwitchCostTo2Accin=[exinCorrPos1to2/exinPos1to2 exinCorrPos3to2/exinPos3to2 exinCorrPos4to2/exinPos4to2]
meanExTo2inAcc=nanmean(ExSwitchCostTo2Accin)
ExSwitchCostAway2Accin=[exinCorrPos2to3/exinPos2to3 exinCorrPos2to1/exinPos2to1 exinCorrPos2to4/exinPos2to4]
meanExAway2inAcc=nanmean(ExSwitchCostAway2Accin)
ExSwitchCostTo3Accin=[exinCorrPos2to3/exinPos2to3 exinCorrPos1to3/exinPos1to3 exinCorrPos4to3/exinPos4to3]
meanExTo3inAcc=nanmean(ExSwitchCostTo3Accin)
ExSwitchCostAway3Accin=[exinCorrPos3to1/exinPos3to1 exinCorrPos3to2/exinPos3to2 exinCorrPos3to4/exinPos3to4]
meanExAway3inAcc=nanmean(ExSwitchCostAway3Accin)


ExSwitchCostTo4Accin=[exinCorrPos2to4/exinPos2to4 exinCorrPos1to4/exinPos1to4 exinCorrPos3to4/exinPos3to4]
meanExTo4inAcc=nanmean(ExSwitchCostTo4Accin)
ExSwitchCostAway4Accin=[exinCorrPos4to1/exinPos4to1 exinCorrPos4to2/exinPos4to2 exinCorrPos4to3/exinPos4to3]
meanExAway4inAcc=nanmean(ExSwitchCostAway4Accin)


%switch cost exo incongruent: target presented to the wrong place
extwoinCorrPos1to2
extwoinCorrPos1to2RT
extwoinCorrPos1to3
extwoinCorrPos1to3RT
extwoinCorrPos1to4
extwoinCorrPos1to4RT
extwoinCorrPos2to1
extwoinCorrPos2to1RT
extwoinCorrPos2to3
extwoinCorrPos2to3RT
extwoinCorrPos2to4
extwoinCorrPos2to4RT
extwoinCorrPos3to1
extwoinCorrPos3to1RT
extwoinCorrPos3to2
extwoinCorrPos3to2RT
extwoinCorrPos3to4
extwoinCorrPos3to4RT
extwoinCorrPos4to1
extwoinCorrPos4to1RT
extwoinCorrPos4to2
extwoinCorrPos4to2RT
extwoinCorrPos4to3
extwoinCorrPos4to3RT


extwoincounter


extwoinPos1to2
extwoinPos1to3
extwoinPos1to4
extwoinPos2to1
extwoinPos2to3
extwoinPos2to4
extwoinPos3to1
extwoinPos3to2
extwoinPos3to4
extwoinPos4to1
extwoinPos4to2
extwoinPos4to3

%
%
ExSwitchCostTo1in2=[extwoinCorrPos2to1RT extwoinCorrPos3to1RT extwoinCorrPos4to1RT]
meanExTo1in2=nanmean(ExSwitchCostTo1in2)

ExSwitchCostAway1in2=[extwoinCorrPos1to3RT extwoinCorrPos1to2RT extwoinCorrPos1to4RT]
meanExAway1in2=nanmean(ExSwitchCostAway1in2)

ExSwitchCostTo2in2=[extwoinCorrPos1to2RT extwoinCorrPos3to2RT extwoinCorrPos4to2RT]
meanExTo2in2=nanmean(ExSwitchCostTo2in2)

ExSwitchCostAway2in2=[extwoinCorrPos2to3RT extwoinCorrPos2to1RT extwoinCorrPos2to4RT]
meanExAway2in2=nanmean(ExSwitchCostAway2in2)


ExSwitchCostTo3in2=[extwoinCorrPos2to3RT extwoinCorrPos1to3RT extwoinCorrPos4to3RT]
meanExTo3in2=nanmean(ExSwitchCostTo3in2)

ExSwitchCostAway3in2=[extwoinCorrPos3to1RT extwoinCorrPos3to2RT extwoinCorrPos3to4RT]
meanExAway3in2=nanmean(ExSwitchCostAway3in2)


ExSwitchCostTo4in2=[extwoinCorrPos2to4RT extwoinCorrPos1to4RT extwoinCorrPos3to4RT ]
meanExTo4in2=nanmean(ExSwitchCostTo4in2)

ExSwitchCostAway4in2=[extwoinCorrPos4to1RT extwoinCorrPos4to2RT extwoinCorrPos4to3RT]
meanExAway4in2=nanmean(ExSwitchCostAway4in2)


ExSwitchCostTo1Accin2=[extwoinCorrPos2to1/extwoinPos2to1 extwoinCorrPos3to1/extwoinPos3to1 extwoinCorrPos4to1/extwoinPos4to1]
meanExTo1inAcc2=nanmean(ExSwitchCostTo1Accin2)

ExSwitchCostAway1Accin2=[extwoinCorrPos1to3/extwoinPos1to3 extwoinCorrPos1to2/extwoinPos1to2 extwoinCorrPos1to4/extwoinPos1to4]
meanExAway1inAcc2=nanmean(ExSwitchCostAway1Accin2)

ExSwitchCostTo2Accin2=[extwoinCorrPos1to2/extwoinPos1to2 extwoinCorrPos3to2/extwoinPos3to2 extwoinCorrPos4to2/extwoinPos4to2]
meanExTo2inAcc2=nanmean(ExSwitchCostTo2Accin2)

ExSwitchCostAway2Accin2=[extwoinCorrPos2to3/extwoinPos2to3 extwoinCorrPos2to1/extwoinPos2to1 extwoinCorrPos2to4/extwoinPos2to4]
meanExAway2inAcc2=nanmean(ExSwitchCostAway2Accin2)

ExSwitchCostTo3Accin2=[extwoinCorrPos2to3/extwoinPos2to3 extwoinCorrPos1to3/extwoinPos1to3 extwoinCorrPos4to3/extwoinPos4to3]
meanExTo3inAcc2=nanmean(ExSwitchCostTo3Accin2)

ExSwitchCostAway3Accin2=[extwoinCorrPos3to1/extwoinPos3to1 extwoinCorrPos3to2/extwoinPos3to2 extwoinCorrPos3to4/extwoinPos3to4]
meanExAway3inAcc2=nanmean(ExSwitchCostAway3Accin2)
% kmv does not understand the line below
ExSwitchCostTo4Accin2=[extwoinCorrPos2to4/extwoinPos2to4 extwoinCorrPos1to4/extwoinPos1to4 extwoinCorrPos3to4/extwoinPos3to4]
meanExTo4inAcc2=nanmean(ExSwitchCostTo4Accin2)

ExSwitchCostAway4Accin2=[extwoinCorrPos4to1/extwoinPos4to1 extwoinCorrPos4to2/extwoinPos4to2 extwoinCorrPos4to3/extwoinPos4to3]
meanExAway4inAcc2=nanmean(ExSwitchCostAway4Accin2)


%
%sustained endo
CorrPos1;
CorrPos2;
CorrPos3;
CorrPos4;

susPos1
susPos2
susPos3
susPos4

EndosusPos1Acc=[CorrPos1/susPos1];
EndosusPos2Acc=[CorrPos2/susPos2];
EndosusPos3Acc=[CorrPos3/susPos3];
EndosusPos4Acc=[CorrPos4/susPos4];


endoPos1RT=nanmean(CorrPos1RT);
endoPos2RT=nanmean(CorrPos2RT);
endoPos3RT=nanmean(CorrPos3RT);
endoPos4RT=nanmean(CorrPos4RT);
% sustained exo
exCorrPos1;
exCorrPos2;
exCorrPos3;
exCorrPos4;

exsusPos1
exsusPos2
exsusPos3
exsusPos4

ExsusPos1Acc=[exCorrPos1/exsusPos1];
ExsusPos2Acc=[exCorrPos2/exsusPos2];
ExsusPos3Acc=[exCorrPos3/exsusPos3];
ExsusPos4Acc=[exCorrPos4/exsusPos4];

exPos1RT=nanmean(exCorrPos1RT);
exPos2RT=nanmean(exCorrPos2RT);
exPos3RT=nanmean(exCorrPos3RT);
exPos4RT=nanmean(exCorrPos4RT);


disp('RESULTS')


disp('results endo')


%RT in units of seconds (congruent)
meanEndoTo1
meanEndoAway1
meanEndoTo2
meanEndoAway2
meanEndoTo3
meanEndoAway3
meanEndoTo4
meanEndoAway4


%accuracy: aka accuracy.  in units of proportion correct.
meanEndoTo1Acc
meanEndoAway1Acc
meanEndoTo2Acc
meanEndoAway2Acc
meanEndoTo3Acc
meanEndoAway3Acc
meanEndoTo4Acc
meanEndoAway4Acc


%switch cost endo incongruent: cue presented to the wrong place
%RT incongruent
meanEndoTo1inc
meanEndoAway1inc
meanEndoTo2inc
meanEndoAway2inc
meanEndoTo3inc
meanEndoAway3inc
meanEndoTo4inc
meanEndoAway4inc

%Acc incongruent 1
meanEndoTo1incAcc
meanEndoAway1incAcc
meanEndoTo2incAcc
meanEndoAway2incAcc
meanEndoTo3incAcc
meanEndoAway3incAcc
meanEndoTo4incAcc
meanEndoAway4incAcc


%RT incongruent 2 
meanEndoTo1inc2
meanEndoAway1inc2
meanEndoTo2inc2
meanEndoAway2inc2
meanEndoTo3inc2
meanEndoAway3inc2
meanEndoTo4inc2
meanEndoAway4inc2

%Acc incongruent
meanEndoTo1incAcc2
meanEndoAway1incAcc2
meanEndoTo2incAcc2
meanEndoAway2incAcc2
meanEndoTo3incAcc2
meanEndoAway3incAcc2
meanEndoTo4incAcc2
meanEndoAway4incAcc2


disp('results exo');

%Exo RT
meanExTo1
meanExAway1
meanExTo2
meanExAway2
meanExTo3
meanExAway3
meanExTo4
meanExAway4

%Exo Acc
meanExTo1Acc
meanExAway1Acc
meanExTo2Acc
meanExAway2Acc
meanExTo3Acc
meanExAway3Acc
meanExTo4Acc
meanExAway4Acc

%Exo incongruent 1 ()
meanExTo1in
meanExAway1in
meanExTo2in
meanExAway2in
meanExTo3in
meanExAway3in
meanExTo4in
meanExAway4in
%exo Acc incongruent 1 
meanExTo1inAcc
meanExAway1inAcc
meanExTo2inAcc
meanExAway2inAcc
meanExTo3inAcc
meanExAway3inAcc
meanExTo4inAcc
meanExAway4inAcc


%Exo incongruent 2 ()
meanExTo1in2
meanExAway1in2
meanExTo2in2
meanExAway2in2
meanExTo3in2
meanExAway3in2
meanExTo4in2
meanExAway4in2
%exo Acc incongruent 2
meanExTo1inAcc2
meanExAway1inAcc2
meanExTo2inAcc2
meanExAway2inAcc2
meanExTo3inAcc2
meanExAway3inAcc2
meanExTo4inAcc2
meanExAway4inAcc2



%sustained
disp('results endo sus');

endosusRT=[endoPos1RT
endoPos2RT
endoPos3RT
endoPos4RT]

endosusAcc=[EndosusPos1Acc
EndosusPos2Acc
EndosusPos3Acc
EndosusPos4Acc]

disp('results exo sus');

exosusRT=[exPos1RT
exPos2RT
exPos3RT
exPos4RT]

exosusAcc=[ExsusPos1Acc
ExsusPos2Acc
ExsusPos3Acc
ExsusPos4Acc]


%% non-location specific analysis
sustained_endoRT=nanmean(endosusRT);
sustained_endoAcc=nanmean(endosusAcc);
sustained_exoRT=nanmean(exosusRT);
sustained_exoAcc=nanmean(exosusAcc);



figure
subplot(2,2,1)
boxplot(endosusAcc)
title ([baseName(8:11) 'sustained endo Acc'])
ylabel('Acc')
set(gca,'FontSize',12)
ylim([0 1.09])

subplot(2,2,3)
boxplot(exosusAcc)
title ([baseName(8:11) 'sustained exo Acc'])
xlabel('Locations')
ylabel('Acc')
ylim([0 1.09])
set(gca,'FontSize',12)

subplot(2,2,4)
boxplot(exosusRT)
title ([baseName(8:11) 'sustained exo RT'])
xlabel('Locations')
ylabel('RT')
set(gca,'FontSize',12)

subplot(2,2,2)
boxplot(endosusRT)
title ([baseName(8:11) 'sustained endo RT'])
xlabel('Locations')
ylabel('RT')

set(gca,'FontSize',12)

print([baseName(8:11) 'sustained'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI





% congruent vs incongruent analysis


%RT
Overall_endo_congruent=[EndoSwitchCostTo1 EndoSwitchCostTo2 EndoSwitchCostTo3 EndoSwitchCostTo4];
Overall_endo_incongruent=[EndoSwitchCostTo1inc EndoSwitchCostTo2inc EndoSwitchCostTo3inc EndoSwitchCostTo4inc];

themeancongruentEndo=nanmean(Overall_endo_congruent);
themeanIncongruentEndo=nanmean(Overall_endo_incongruent);
themeanEndo=[themeancongruentEndo themeanIncongruentEndo];


Overall_exo_congruent=[ExSwitchCostTo1 ExSwitchCostTo2 ExSwitchCostTo3 ExSwitchCostTo4];
Overall_exo_incongruent=[ExSwitchCostTo1in ExSwitchCostTo2in ExSwitchCostTo3in ExSwitchCostTo4in];

themeancongruentExo=nanmean(Overall_exo_congruent);
themeanIncongruentExo=nanmean(Overall_exo_incongruent);
themeanExo=[themeancongruentExo themeanIncongruentExo];

figure
subplot(1,2,1)
c = bar(themeanEndo);
set(gca, 'XTickLabel',{'Cong','Incong'})
%xlabel('Wt% of cenospheres')
ylabel('RT (sec)')
ylim([0 0.99])
c.FaceColor = 'flat';
c.CData(1,:) = [0.2 1 0.2 ];
c.CData(2,:) = [1 0.2 0.2];
%c.CData(3,:) = [0.54 0.54 1];
%c.CData(4,:) = [0.76 0.76 1];
%c.CData(5,:) = [0 0 1];
set(gca, 'FontSize', 14)
title([baseName(8:11) 'Endogenous attention'])
hold on

errlow=[(std(Overall_endo_congruent)/sqrt(length(Overall_endo_congruent))) (std(Overall_endo_incongruent)/sqrt(length(Overall_endo_incongruent)))];
errhigh=errlow;
er = errorbar(c.XData,themeanEndo,errlow,errhigh);  
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 

subplot(1,2,2)
c = bar(themeanExo);
set(gca, 'XTickLabel',{'Cong','Incong'})
%xlabel('Wt% of cenospheres')
ylabel('RT (sec)')
ylim([0 0.99])
c.FaceColor = 'flat';
c.CData(1,:) = [0.2 1 0.2 ];
c.CData(2,:) = [1 0.2 0.2];
%c.CData(3,:) = [0.54 0.54 1];
%c.CData(4,:) = [0.76 0.76 1];
%c.CData(5,:) = [0 0 1];
set(gca, 'FontSize', 14)
title([baseName(8:11) 'Exogenous attention'])
hold on

errlow=[(std(Overall_exo_congruent)/sqrt(length(Overall_exo_congruent))) (std(Overall_exo_incongruent)/sqrt(length(Overall_exo_incongruent)))];
errhigh=errlow;
er = errorbar(c.XData,themeanExo,errlow,errhigh);  
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 

print([baseName(8:11) 'Endo_congruent_incongruent_RT'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI




%Acc
Overall_endo_congruentAcc=[EndoSwitchCostTo1Acc EndoSwitchCostTo2Acc EndoSwitchCostTo3Acc EndoSwitchCostTo4Acc];
Overall_endo_incongruentAcc=[EndoSwitchCostTo1Accinc EndoSwitchCostTo2Accinc EndoSwitchCostTo3Accinc EndoSwitchCostTo4Accinc];

themeancongruentEndoAcc=nanmean(Overall_endo_congruentAcc);
themeanIncongruentEndoAcc=nanmean(Overall_endo_incongruentAcc);
themeanEndoAcc=[themeancongruentEndoAcc themeanIncongruentEndoAcc];


Overall_exo_congruentAcc=[ExSwitchCostTo1Acc ExSwitchCostTo2Acc ExSwitchCostTo3Acc ExSwitchCostTo4Acc];
Overall_exo_incongruentAcc=[ExSwitchCostTo1Accin ExSwitchCostTo2Accin ExSwitchCostTo3Accin ExSwitchCostTo4Accin];

themeancongruentExoAcc=nanmean(Overall_exo_congruentAcc);
themeanIncongruentExoAcc=nanmean(Overall_exo_incongruentAcc);
themeanExoAcc=[themeancongruentExoAcc themeanIncongruentExoAcc];

figure
subplot(1,2,1)
c = bar(themeanEndoAcc);
set(gca, 'XTickLabel',{'Cong','Incong'})
%xlabel('Wt% of cenospheres')
ylabel('Accuracy')
ylim([0 1.09])
c.FaceColor = 'flat';
c.CData(1,:) = [0.2 1 0.2 ];
c.CData(2,:) = [1 0.2 0.2];
%c.CData(3,:) = [0.54 0.54 1];
%c.CData(4,:) = [0.76 0.76 1];
%c.CData(5,:) = [0 0 1];
set(gca, 'FontSize', 14)
title([baseName(8:11) 'Endogenous attention'])
hold on

errlow=[(std(Overall_endo_congruentAcc)/sqrt(length(Overall_endo_congruentAcc))) (std(Overall_endo_incongruentAcc)/sqrt(length(Overall_endo_incongruentAcc)))];
errhigh=errlow;
er = errorbar(c.XData,themeanEndoAcc,errlow,errhigh);  
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 

subplot(1,2,2)
c = bar(themeanExoAcc);
set(gca, 'XTickLabel',{'Cong','Incong'})
%xlabel('Wt% of cenospheres')
ylabel('Accuracy')
ylim([0 1.09])
c.FaceColor = 'flat';
c.CData(1,:) = [0.2 1 0.2 ];
c.CData(2,:) = [1 0.2 0.2];
%c.CData(3,:) = [0.54 0.54 1];
%c.CData(4,:) = [0.76 0.76 1];
%c.CData(5,:) = [0 0 1];
set(gca, 'FontSize', 14)
title([baseName(8:11) 'Exogenous attention'])
hold on

errlow=[(std(Overall_exo_congruentAcc)/sqrt(length(Overall_exo_congruentAcc))) (std(Overall_exo_incongruentAcc)/sqrt(length(Overall_exo_incongruentAcc)))];
errhigh=errlow;
er = errorbar(c.XData,themeanExoAcc,errlow,errhigh);  
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 




print([baseName(8:11) 'Endo_congruent_incongruent_Acc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%[1 1 1 1]
% cue: 1 2 (endo exo)
%cue position:1 2 3
% target position:1 2 3
% target position next: 1 2 3
% target: 1 2 3 4 5 6 7 8
        % 1 2 3 4 Foil, L, R, D

 
%%
        
%%Test Numbers
% column headings are:
%1 trial
%2 exo (0) or endo (1).  
%3 type of trial: 0-exogenous cue trial, 1-endogenous , 2-exogenous in between
%cues, 3-first trial endogenous
%3 cue position (newmatrix,2)
%4 target position (newmatrix,3)
%5 target position next
%6 type of stimulus: 1-4: target, 5:foil, 6-8:cue
%7  accuracy
%8 RT


%Exo Trials (congruent vs. incongruent)
%%kmv
Corr_RT_ExoCon = []; %this variable will be first column RT, second column 0 for incorrect
Corr_RT_ExoIncon = [];
for ui=2:length(sss)
    if sss(ui,2)==0 %it's exogenous trial
        if sss(ui,3)==sss(ui,4)  % congruent trial; cue == target
            Corr_RT_ExoCon(end+1,:) = sss(ui,7:8);
        else % incongruent trial
            Corr_RT_ExoIncon(end+1,:) = sss(ui,7:8);
        end
    end
end

%Endo Trials
%cso
Corr_RT_EndoCon = [];
Corr_RT_EndoIncon = [];
for ui=2:length(sss)
    if sss(ui,2)==1 %endogenous trial
        if sss(ui-1,3)==sss(ui,4) %congruent trial
            Corr_RT_EndoCon(end+1,:) = sss(ui,7:8);
            %ec = nonzeros(Corr_RT_EndoCon);
            %Corr_RT_EndoCon = reshape(ec,39,2);
        else % incongruent trial
            Corr_RT_EndoIncon(end+1,:) = sss(ui,7:8);
            %ei = nonzeros(Corr_RT_EndoIncon);
            %Corr_RT_EndoIncon = reshape(ei,39,2);
        end
    end
end
     

%%
%% below was written by kmv
%

%%Compare endogenous Congruent vs. incongruent trials
varnames = who('CorrPos*to*RT');
values = cellfun(@eval, varnames, 'UniformOutput', false);

TableOfValues = cell2table([varnames, values], 'VariableNames', {'Variable', 'Value'})
%%Compare endogenous Congruent vs. incongruent trials
RT_congruent = [CorrPos1to2RT  CorrPos1to4RT  CorrPos2to3RT  CorrPos3to1RT  CorrPos3to4RT  CorrPos4to2RT  ...
CorrPos1to3RT  CorrPos2to1RT  CorrPos2to4RT  CorrPos3to2RT  CorrPos4to1RT  CorrPos4to3RT ];

RT_incongruent = [inCorrPos1to2RT  inCorrPos1to4RT  inCorrPos2to3RT  inCorrPos3to1RT  inCorrPos3to4RT  inCorrPos4to2RT  ...
inCorrPos1to3RT  inCorrPos2to1RT  inCorrPos2to4RT  inCorrPos3to2RT  inCorrPos4to1RT  inCorrPos4to3RT ];

mean(RT_congruent, 'omitnan')
mean(RT_incongruent, 'omitnan')

[h p]= ttest2(RT_congruent, RT_incongruent)


 

%%Compare exogenous congruent vs. incongruent trials


RT_exo_incongruent = [exinCorrPos1to2RT  exinCorrPos1to4RT  exinCorrPos2to3RT  exinCorrPos3to1RT  exinCorrPos3to4RT  exinCorrPos4to2RT ... 
exinCorrPos1to3RT  exinCorrPos2to1RT  exinCorrPos2to4RT  exinCorrPos3to2RT  exinCorrPos4to1RT  exinCorrPos4to3RT];

RT_exo_congruent = [exCorrPos1to2RT  exCorrPos1to4RT  exCorrPos2to3RT  exCorrPos3to1RT  exCorrPos3to4RT  exCorrPos4to2RT  ...
exCorrPos1to3RT  exCorrPos2to1RT  exCorrPos2to4RT  exCorrPos3to2RT  exCorrPos4to1RT  exCorrPos4to3RT  ];

nanmean(RT_exo_congruent)

nanmean(RT_exo_incongruent)

[h p]= ttest2(RT_exo_congruent, RT_exo_incongruent)
% so they were faster/slower on congruent trials