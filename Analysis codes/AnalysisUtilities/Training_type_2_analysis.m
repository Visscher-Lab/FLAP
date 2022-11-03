close all
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


shapes_type={ '9 vs 6','2 vs 5', 'q vs p', 'b vs d', 'eggs', 'diagonal line', 'horizontal vs vertical line'};
shapesoftheDay
sz=size(thresho);

for ui=1:sz(2)
subplot(2,3,ui)
scatter(1:sz(1),thresho(:,ui), 'filled')
 xlabel('n trials', 'fontsize', 10);

 ylabel('jitter', 'fontsize', 10);
 title(shapes_type{shapesoftheDay(ui)})

end

      print([name session 'training2' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



%Reaction Time    
ReactionT = mixtr;
ReactionT(1:numel(totale_trials'),3) = totale_trials';
ReactionT(1:numel(feat'),4) = feat';
%ReactionT(1:numel(contrcir'),5) = contrcir;
% ReactionT(1:numel(coordinatex'),6) = coordinatex';
% ReactionT(1:numel(coordinatey'),7) = coordinatey';
ReactionT(1:numel(time_stim'),8) = time_stim';
ReactionT(1:numel(rispo'),9) = rispo';





%RT divided by cue visibility (correct trials only)
 RT_correct= find(ReactionT(:,9) == 1);
 stair_correct=ReactionT(RT_correct,:); 
 RT_value_stair= mean(stair_correct(:,8))
 STD_value_stair= std(stair_correct(:,8)); 
 

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
 
 
 Labels = {'Training type 2'};
 set(gca, 'XTick', 1, 'XTickLabel', Labels);
 %xlabel(' cpd', 'fontsize', 10);
 ylabel('RT (seconds)', 'fontsize', 10);
 title([name ' ' session 'Trial reaction time'], 'fontsize', 10);

subplot(2,1,2)
bar(trialTimeout)
ylim([0 20])
 ylabel('n trials', 'fontsize', 10);
 Labels = {'Training type 2'};
 set(gca, 'XTick', 1, 'XTickLabel', Labels);
title([name ' ' session 'Trials timed out T2'])

      print([name session 'graphsT2' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% close all
 %%
  
 %spatf2array1=find(spatf2==min(spatf2)+0.02) %gives me empty matrix
 %min(spatf2)+0.02 %gives me 0.12
 %find(spatf2==0.12) %gives me correct values
 
 
 
 


 