% Acuity/crowding/attention analysis
%Marcello A. Maniglia July 2021

%% Acuity
subj= baseName(8:9);
r= (scotomadeg*pix_deg)/2;
th=0:pi/50:2*pi;
xunit= r*cos(th) + wRect(3)/2;
yunit= r*sin(th) + wRect(4)/2;
pgon = fill([wRect(1) wRect(2) wRect(3) wRect(3)], [wRect(4) wRect(2) wRect(1) wRect(4)], [0.5 0.5 0.5]);
   
for ui=1:length(eccentricity_X)
    hold on
    PRL_sc{ui} = ThreshlistVA(ui,:);
    PRL_thresh{ui} = mean(ThreshlistVA(ui,end-10:end));
    PRL_coord{ui}= [eccentricity_X(ui) eccentricity_Y(ui)];
    PRLLoc{ui}=[(wRect(3)/2)+eccentricity_X(ui) (wRect(4)/2)+eccentricity_Y(ui)];

Scores{ui} = text(PRLLoc{ui}(1)*0.9,PRLLoc{ui}(2),num2str(PRL_thresh{ui}));
end

 hold on

fill(xunit,yunit, [200/255 200/255 200/255]);
set (gca,'YDir','reverse')
axis off
title([subj ' acuity']);
     print([subj '_acuity'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


colors= ['r', 'g', 'b' , 'k'];
titles= {'PRL 0',  'PRL 90', 'PRL180', 'PRL270' };



figure

for ui=1:length(eccentricity_X)
    subplot(2,2,ui)
scatter(1:length(ThreshlistVA(ui,:)), ThreshlistVA(ui,:), colors(ui), 'filled')
title([  subj titles{ui} ' acuity'])
xlabel('trials')
ylabel('dva')
end

     print([subj '_acuity_sc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


%% Crowding


    threshoCW=permute(ThreshlistCW,[3 1 2]);
    
    radialCW=threshoCW(:,:,1);
    tangentialCW=threshoCW(:,:,2);
    
 % ThreshlistCW   
%    4     2    40

for ui=1:2
    figure
    pgon = fill([wRect(1) wRect(2) wRect(3) wRect(3)], [wRect(4) wRect(2) wRect(1) wRect(4)], [0.5 0.5 0.5]);

   for si=1:length(eccentricity_X)
 %   PRL_sc{si,ui} = threshoCW(si,ui,:);
    PRL_threshCW{si,ui} = mean(ThreshlistCW(si,ui,end-10:end));
Scores{si,ui} = text(PRLLoc{si}(1)*0.9,PRLLoc{si}(2),num2str(PRL_threshCW{si,ui}));
       hold on
   end

fill(xunit,yunit, [200/255 200/255 200/255]);
hold on
set (gca,'YDir','reverse')
axis off

if ui ==1
title( [subj titles{ui} 'radial crowding']);
     print([subj 'radial crowding'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
elseif ui ==2
    title( [subj titles{ui} 'tangential crowding']);
         print([subj 'tangential crowding'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
end
end



for ui=1:2 
  figure        
    for si=1:length(eccentricity_X)
    subplot(2,2,si)
scatter(1:length(ThreshlistCW(si,ui,:)), ThreshlistCW(si,ui,:), colors(si), 'filled')
%title([  subj titles{ui} ' acuity'])
xlabel('trials')
ylabel('dva')
  if ui ==1
title([subj titles{si}  'radial crowding']);
     print([subj 'radial crowding_sc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
elseif ui ==2
    title([subj titles{si} 'tangential crowding']);
             print([subj 'tangential crowding_sc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

  end  
hold on

    end
 
end

%% Attention

correxadj=correx(end-length(mixtrAtt)+1:end);
time_stimadj=time_stim(end-length(mixtrAtt)+1:end);
Attmax= [mixtrAtt correxadj' time_stimadj'];
figure
pgon = fill([wRect(1) wRect(2) wRect(3) wRect(3)], [wRect(4) wRect(2) wRect(1) wRect(4)], [0.5 0.5 0.5]);

for ui=1:length(eccentricity_X)
    PRL_cued_acc{ui} =       Attmax(Attmax(:,1)==ui & Attmax(:,2)==1,3);
        PRL_uncued_acc{ui} = Attmax(Attmax(:,1)==ui & Attmax(:,2)==2,3);

    PRL_cued_RT{ui} = Attmax(Attmax(:,1)==ui & Attmax(:,2)==1,4);
        PRL_uncued_RT{ui} = Attmax(Attmax(:,1)==ui & Attmax(:,2)==2,4);
      
        PRL_cued_acc_perc(ui)=sum(PRL_cued_acc{ui})/length(PRL_cued_acc{ui});
        PRL_uncued_acc_perc(ui)=sum(PRL_uncued_acc{ui})/length(PRL_uncued_acc{ui});
        PRL_cued_RT_mean(ui)=mean(PRL_cued_RT{ui});
        PRL_uncued_RT_mean(ui)=mean(PRL_uncued_RT{ui});

      hold on
      
  %    Scores{ui} = text(PRLLoc{ui}(1)*0.9,PRLLoc{ui}(2),num2str(PRL_cued_RT_mean(ui)/PRL_uncued_RT_mean(ui)));
      Scores{ui} = text(PRLLoc{ui}(1)*0.9,PRLLoc{ui}(2),num2str(PRL_cued_RT_mean(ui)));

%Scores{ui} = text(PRL_cued_RT_mean{ui}(1)*0.9,PRL_cued_RT_mean{ui}(2),num2str(PRL_thresh{ui}));
end


hold on

fill(xunit,yunit, [200/255 200/255 200/255]);
axis off
title([subj ' Attention cue/uncued RT']);
             print([subj 'attention cued/uncued RT'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI


figure

pgon = fill([wRect(1) wRect(2) wRect(3) wRect(3)], [wRect(4) wRect(2) wRect(1) wRect(4)], [0.5 0.5 0.5]);


      Scores{ui} = text(PRLLoc{ui}(1)*0.9,PRLLoc{ui}(2),num2str(PRL_cued_RT_mean(ui)/PRL_uncued_RT_mean(ui)));
hold on

fill(xunit,yunit, [200/255 200/255 200/255]);
axis off
title([subj ' Attention cue/uncued Accuracy']);
             print([subj 'attention cued/uncued Acc'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI





