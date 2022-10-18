
thresho=permute(Threshlist,[3 1 2]);
%to get the final value for each staircase
%final_threshold=thresho(numel(thresho(:,:,1)),1:length(thresho(1,:,1)),1:length(thresho(1,1,:)))
 

%%long method
%a=[thresho(:,:,1); thresho(:,:,2)];
%total=[mixtr, a];


 name = baseName(8:10);
  theadd= baseName(37:end);
 session = baseName(34:38);
%feat=ones(1,length(totale_trials))*4;
%% graph stats
lowt=thresho(:,:,1);

low_th=mean(lowt(end-20:end));
low_thresh = num2str(low_th);


for i=1:length(totale_trials)
    TrialNum = strcat('Trial',num2str(i));

timing(i)=EyeSummary.(TrialNum).TimeStamps.Fixation

end


reconstruct_thresho=zeros(1,length(totale_trials));


key=0;
for ui=1:length(totale_trials)
    if ui==length(totale_trials)
        reconstruct_thresho(ui)=thresho(end)
    end
    if trialTimedout(ui)==0
        key=key+1;
        if key>length(thresho)
           key=length(thresho); 
        end
        reconstruct_thresho(ui)=thresho(key)       
    elseif trialTimedout(ui)==1
        if ui==1
            key=1;
        end            
        reconstruct_thresho(ui)=thresho(key);
    end
    
end

%graphs

% subplot(2,1,1)
% semilogy(lowt,'-ro', 'MarkerSize', 2, 'MarkerFaceColor', 'k');
% xlabel('Trial n', 'fontsize', 10);
% ylabel('Contrast', 'fontsize', 10);
% title('Low Vis target first block')
% 
% 
% txt1 = low_thresh;
% text(50,0.1, ['Thresh = ', txt1])
% 
% 
% subplot(2,1,2)
% semilogy(hight, '-ro', 'MarkerSize', 2, 'MarkerFaceColor', 'k');
% xlabel('Trial n', 'fontsize', 10);
% ylabel('Contrast', 'fontsize', 10);
% title('High Vis target first block')
% txt1 = high_thresh;
% text(50,0.1, ['Thresh = ', txt1])



low_thresh

%Reaction Time    
ReactionT = mixtr;
ReactionT(1:numel(totale_trials'),3) = totale_trials';
ReactionT(1:numel(feat'),4) = feat';
%ReactionT(1:numel(contrcir'),5) = contrcir;
% ReactionT(1:numel(coordinatex'),6) = coordinatex';
% ReactionT(1:numel(coordinatey'),7) = coordinatey';
ReactionT(1:numel(time_stim'),8) = time_stim';
ReactionT(1:numel(rispo'),9) = rispo';
ReactionT(1:numel(totale_trials'),10) =reconstruct_thresho;


%3-4-6-8-10-12-14-16-18
%sf
spatf1=ReactionT(:,4)/100;


%spatf1array=find(spatf1==min(spatf1));
spatf1array=find(spatf1==0.03);
if spatf1array~=0 
firstsf=spatf1array(1)
sf1=spatf1(firstsf)
dddd=spatf1(firstsf)
end

%spatf1array1=find(spatf1==min(spatf1)+0.02);
spatf1array1=find(spatf1==0.04);
if spatf1array1~=0
secondsf=spatf1array1(1)
sf2=spatf1(secondsf)
end

%spatf1array2=find(spatf1==min(spatf1)+0.04);
spatf1array2=find(spatf1==0.06);
if spatf1array2~=0
thirdsf=spatf1array2(1)
sf3=spatf1(thirdsf)
end

%spatf1array3=find(spatf1==min(spatf1)+0.06);
spatf1array3=find(spatf1==0.08);
if spatf1array3~=0
fourthsf=spatf1array3(1)
sf4=spatf1(fourthsf)
end

%spatf1array4=find(spatf1==min(spatf1)+0.08);
spatf1array4=find(spatf1==0.10);
if spatf1array4~=0
fifthsf=spatf1array4(1)
sf5=spatf1(fifthsf)
end
spatf1array5=find(spatf1==0.12);
%spatf1array5=find(spatf1==min(spatf1)+0.10);
if spatf1array5~=0
sixthsf=spatf1array5(1)
sf6=spatf1(sixthsf)
end

spatf1array6=find(spatf1==0.14);
if spatf1array6~=0
sevensf=spatf1array6(1)
sf7=spatf1(sevensf)
end

spatf1array7=find(spatf1==0.16);
if spatf1array7~=0
eightsf=spatf1array7(1)
sf8=spatf1(eightsf)
end

spatf1array8=find(spatf1==0.18);
if spatf1array8~=0
ninesf=spatf1array8(1);
sf9=spatf1(ninesf);
end




asse=max(lowt)*1.4
semilogy(lowt,'-ro', 'MarkerSize', 2, 'MarkerFaceColor', 'k');
hold on
plot(spatf1, '-go', 'MarkerSize', 2, 'MarkerFaceColor', 'k');
xlabel('Trial n', 'fontsize', 10);
ylabel('Contrast', 'fontsize', 10);
%title('Low Vis target')

title([name session])

txt1 = low_thresh;
text(450,0.2, ['Thresh = ', txt1])


if exist ('sf1')
txt2=sf1*100;
txt2=num2str(txt2);
text(firstsf+1,asse, [txt2, 'cpd'])
end

if exist ('sf2')
txt3=sf2*100;
txt3=num2str(txt3);
text(secondsf+2,asse, [txt3, 'cpd'])
end

if exist ('sf3')
txt4=sf3*100;
txt4=num2str(txt4);
text(thirdsf+3,asse, [txt4, 'cpd'])
end

if exist ('sf4')
txt5=sf4*100;
txt5=num2str(txt5);
text(fourthsf+4,asse, [txt5, 'cpd'])
end

if exist ('sf5')
txt6=sf5*100;
txt6=num2str(txt6);
text(fifthsf+10,asse, [txt6, 'cpd'])
end


if exist ('sf6')
txt7=sf6*100;
txt7=num2str(txt7);
text(sixthsf+15,asse, [txt7, 'cpd'])
end

if exist ('sf7')
txt8=sf7*100;
txt8=num2str(txt8);
text(sevensf+20,asse, [txt8, 'cpd'])
end

if exist ('sf8')
txt9=sf8*100;
txt9=num2str(txt9);
text(eightsf+50,asse, [txt9, 'cpd'])
end

if exist ('sf9')
txt10=sf9*100;
txt10=num2str(txt10);
text(ninesf+55,asse, [txt10, 'cpd'])
end





%RT divided by cue visibility (correct trials only)
 RT_correct= find(ReactionT(:,9) == 1);
 stair_correct=ReactionT(RT_correct,:); 
 RT_value_stair= mean(stair_correct(:,8))
 STD_value_stair= std(stair_correct(:,8)); 
 
 ylim([min(lowt)*.8 max(lowt)*1.6])

      print([name session 'thresh' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%Reaction time graph
 figure
 subplot(2,1,1)
 % labels and title
 grafici= [RT_value_stair ];
   errore= [STD_value_stair];
 scala= [1,5,10];
 bar(grafici);
 hold on
 errorbar(1,grafici(:,1), errore(:,1), 'k', 'linestyle', 'none');
 
 
 Labels = {'Training type 1'};
 set(gca, 'XTick', 1, 'XTickLabel', Labels);
 %xlabel(' cpd', 'fontsize', 10);
 ylabel('RT (seconds)', 'fontsize', 10);
 title([name ' ' session 'Trial reaction time'], 'fontsize', 10);
 
low_thresh
RT_value_stair
subplot(2,1,2)
bar(trialTimeout)
ylim([0 20])
 ylabel('n trials', 'fontsize', 10);
 Labels = {'Training type 1'};
 set(gca, 'XTick', 1, 'XTickLabel', Labels);
title([name ' ' session 'Trials timed out'])

      print([name session 'graphs' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%close all
 %%
  
 %spatf2array1=find(spatf2==min(spatf2)+0.02) %gives me empty matrix
 %min(spatf2)+0.02 %gives me 0.12
 %find(spatf2==0.12) %gives me correct values
 