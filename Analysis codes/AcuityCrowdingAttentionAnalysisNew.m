close all
dir= ['./PilotFigures/' ];
subj=baseName(8:9);
subj=baseName(51:58);

testmatVA=[mixtrVA rispo(1:length(mixtrVA))' time_stim(1:length(mixtrVA))'];

testmatCW=[mixtrCW rispo(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))' time_stim(length(mixtrVA)+1:(length(mixtrVA)+length(mixtrCW)))'];


testmatAtt= [mixtrAtt rispo(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))' time_stim(length(mixtrVA)+length(mixtrCW)+1:(length(mixtrVA)+length(mixtrCW)+length(mixtrAtt)))'];

AttCorr=testmatAtt(testmatAtt(:,3)==1,:);
AttCuedTotal=length(testmatAtt(testmatAtt(:,2)==1));
AttUncuedTotal=length(testmatAtt(testmatAtt(:,2)==2));
AttCorrCued=AttCorr(AttCorr(:,2)==1,:);
AttCorrUncued=AttCorr(AttCorr(:,2)==2,:);

AttCorrCuedRT=mean(AttCorrCued(:,4));
AttCorrUncuedRT=mean(AttCorrUncued(:,4));

AttCorrCuedPerc=length(AttCorrCued)/AttCuedTotal*100;
AttCorrUncuedPerc=length(AttCorrUncued)/AttUncuedTotal*100;
CWradial=testmatCW(testmatCW(:,1)==2,:);
CWtangential=testmatCW(testmatCW(:,2)==2,:);



ThreshlistCW_radial=ThreshlistCW(1,:)';
ThreshlistCW_tan=ThreshlistCW(2,:)';

figure
scatter(1:length(ThreshlistVA), ThreshlistVA,50, 'filled')

%title([  subj titles{ui} ' acuity'])
title([  subj ' acuity'])
xlabel('trials')
ylabel('dva')
%ylim([0 2])
set(gca,'FontSize',17)

             print([dir subj 'acitynew'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

             figure
scatter(1:length(ThreshlistVA), ThreshlistCW_radial+0.1,50, 'r','filled')
hold on
scatter(1:length(ThreshlistVA), ThreshlistCW_tan-0.1,50, 'k','filled')

legend ('radial', 'tangential')
%title([  subj titles{ui} ' acuity'])
title([  subj ' crowding'])
xlabel('trials')
ylabel('dva')
%ylim([0 2])
set(gca,'FontSize',17)

             print([dir subj 'crowdingnew'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
             
             
  figure
subplot(2,1,1)
bar(1, AttCorrCuedPerc, 'g')
hold on
bar(2, AttCorrUncuedPerc, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Percentage correct')
title([  subj ' Attention %'])
limits2=max([AttCorrCuedPerc AttCorrUncuedPerc])
limithigh=limits2*1.2;

if limithigh>100 
    limithigh=100;
end
ylim([limits2*0.8 limithigh])

 %            print([dir subj 'att_new_corr'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



%figure
subplot(2,1,2)

bar(1, AttCorrCuedRT, 'g')
hold on
bar(2, AttCorrUncuedRT, 'r')
hold on
legend ('cued', 'uncued')
ylabel('Reaction time (s)')
title([  subj ' Attention RT'])
limits=max([AttCorrCuedRT AttCorrUncuedRT])

ylim([limits*0.8 limits*1.2])
             print([dir subj 'att_new_Results'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
