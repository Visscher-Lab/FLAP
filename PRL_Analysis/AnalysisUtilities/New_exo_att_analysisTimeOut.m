% script for analyzing results from Exo Attention
% Written by Marcello Maniglia, 2023

close all
addpath([cd '/AnalysisUtilities']); %add folder with utilities files

%uab=0;
newdir= [cd '\PilotFigures\'];
if length(baseName)>55
    subj=baseName(51:53);
    subj=baseName(70:71);
else
    subj=baseName(8:9);
    
end

subj=baseName(71:72);
subj=[baseName(71:72) 'scotoma'];

%subj=baseName(51:58);

time_stim(time_stim<0)=nan;

testmat=[mixtr rispo(1:length(mixtr))' time_stim(1:length(mixtr))'];

% this variable has all the information for the Attention task
% mixtrAtt = something to do with stimulus type; 2 columns
%       apparently if the second column is ==1, it is a cued trial; if 2 it
%       is uncued.
% rispo = response is correct (1) or incorrect (2)
% time_stim seems to be a reaction time measurement in s


AttCorr=testmat(testmat(:,3)==1,:);
Attleft=testmat(testmat(:,1)==1,:);
Attright=testmat(testmat(:,1)==2,:);

Attleft_congr=Attleft(Attleft(:,2)==1,:);
Attleft_incongr=Attleft(Attleft(:,2)==2,:);
Attright_congr=Attright(Attright(:,2)==2,:);
Attright_incongr=Attright(Attright(:,2)==1,:);


Attleft_congr_corr=sum(Attleft_congr(:,3))/length(Attleft_congr);
Attleft_incongr_corr=sum(Attleft_incongr(:,3))/length(Attleft_incongr);
Attright_congr_corr=sum(Attright_congr(:,3))/length(Attright_congr);
Attright_incongr_corr=sum(Attright_incongr(:,3))/length(Attright_incongr);


Attleft_congr_corr_only=Attleft_congr(Attleft_congr(:,3)==1,:);
Attleft_incongr_corr_only=Attleft_congr(Attleft_incongr(:,3)==1,:);
Attright_congr_corr_only=Attright_congr(Attright_congr(:,3)==1,:);
Attright_incongr_corr_only=Attright_incongr(Attright_incongr(:,3)==1,:);

Attleft_congr_corrRT=nanmean(Attleft_congr_corr_only(:,4));
Attleft_incongr_corrRT=nanmean(Attleft_incongr_corr_only(:,4));

Attright_congr_corrRT=nanmean(Attright_congr_corr_only(:,4));
Attright_incongr_corrRT=nanmean(Attright_incongr_corr_only(:,4));

Attleft_congr_corrSTD=nanstd(Attleft_congr_corr_only(:,4));
Attleft_incongr_corrSTD=nanstd(Attleft_incongr_corr_only(:,4));

Attright_congr_corrSTD=nanstd(Attright_congr_corr_only(:,4));
Attright_incongr_corrSTD=nanstd(Attright_incongr_corr_only(:,4));

Attleft_congr_corrERR=nanstd(Attleft_congr_corr_only(:,4))/sqrt(length(Attleft_congr_corr_only(:,4)));
Attleft_incongr_corrERR=nanstd(Attleft_incongr_corr_only(:,4)/sqrt(length(Attleft_incongr_corr_only(:,4))));

Attright_congr_corrERR=nanstd(Attright_congr_corr_only(:,4))/sqrt(length(Attright_congr_corr_only(:,4)));
Attright_incongr_corrERR=nanstd(Attright_incongr_corr_only(:,4))/sqrt(length(Attright_incongr_corr_only(:,4)));

%outlier removal

%left congr
upperborder=Attleft_congr_corrRT+2*Attleft_congr_corrSTD;
lowerborder=Attleft_congr_corrRT-2*Attleft_congr_corrSTD;
for ui=1:length(Attleft_congr_corr_only(:,4))
    if Attleft_congr_corr_only(ui,4)> upperborder | Attleft_congr_corr_only(ui,4)< lowerborder
        cleanedAttleft_congr_corr_only(ui,4)=NaN;
        Attleft_congr_corr_only_outlier=1;
    else
        cleanedAttleft_congr_corr_only(ui,4)=Attleft_congr_corr_only(ui,4);
    end
end

%left incongr
upperborder=Attleft_incongr_corrRT+2*Attleft_incongr_corrSTD;
lowerborder=Attleft_incongr_corrRT-2*Attleft_incongr_corrSTD;
for ui=1:length(Attleft_incongr_corr_only(:,4))
    if Attleft_incongr_corr_only(ui,4)> upperborder | Attleft_incongr_corr_only(ui,4)< lowerborder
        cleanedAttleft_incongr_corr_only(ui,4)=NaN;
        Attleft_incongr_corr_only_outlier=1;
    else
        cleanedAttleft_incongr_corr_only(ui,4)=Attleft_incongr_corr_only(ui,4);
    end
end

%right congr
upperborder=Attright_congr_corrRT+2*Attright_congr_corrSTD;
lowerborder=Attright_congr_corrRT-2*Attright_congr_corrSTD;
for ui=1:length(Attright_congr_corr_only(:,4))
    if Attright_congr_corr_only(ui,4)> upperborder | Attright_congr_corr_only(ui,4)< lowerborder
        cleanedAttright_congr_corr_only(ui,4)=NaN;
        Attright_congr_corr_only_outlier=1;
    else
        cleanedAttright_congr_corr_only(ui,4)=Attright_congr_corr_only(ui,4);
    end
end

%right incongr
upperborder=Attright_incongr_corrRT+2*Attright_incongr_corrSTD;
lowerborder=Attright_incongr_corrRT-2*Attright_incongr_corrSTD;
for ui=1:length(Attright_incongr_corr_only(:,4))
    if Attright_incongr_corr_only(ui,4)> upperborder | Attright_incongr_corr_only(ui,4)< lowerborder
        cleanedAttright_incongr_corr_only(ui,4)=NaN;
        Attright_incongr_corr_only_outlier=1;
    else
        cleanedAttright_incongr_corr_only(ui,4)=Attright_incongr_corr_only(ui,4);
    end
end


Attleft_congr_corrRTclean=nanmean(cleanedAttleft_congr_corr_only(:,4));
Attleft_incongr_corrRTclean=nanmean(cleanedAttleft_incongr_corr_only(:,4));

Attright_congr_corrRTclean=nanmean(cleanedAttright_congr_corr_only(:,4));
Attright_incongr_corrRTclean=nanmean(cleanedAttright_incongr_corr_only(:,4));

Attleft_congr_corrSTDclean=nanstd(cleanedAttleft_congr_corr_only(:,4));
Attleft_incongr_corrSTDclean=nanstd(cleanedAttleft_incongr_corr_only(:,4));

Attright_congr_corrSTDclean=nanstd(cleanedAttright_congr_corr_only(:,4));
Attright_incongr_corrSTDclean=nanstd(cleanedAttright_incongr_corr_only(:,4));

Attleft_congr_corrERRclean=nanstd(cleanedAttleft_congr_corr_only(:,4))/sqrt(length(cleanedAttleft_congr_corr_only(:,4)));
Attleft_incongr_corrERRclean=nanstd(cleanedAttleft_incongr_corr_only(:,4)/sqrt(length(cleanedAttleft_incongr_corr_only(:,4))));

Attright_congr_corrERR=nanstd(cleanedAttright_congr_corr_only(:,4))/sqrt(length(cleanedAttright_congr_corr_only(:,4)));
Attright_incongr_corrERR=nanstd(cleanedAttright_incongr_corr_only(:,4))/sqrt(length(cleanedAttright_incongr_corr_only(:,4)));




[h p] = ttest2(Attright_congr_corr_only(:,4), Attright_incongr_corr_only(:,4),'tail','left'); % 1 tailed because we expect cued to be smaller than uncued



[h2 p2] = ttest2(Attleft_congr_corr_only(:,4), Attleft_incongr_corr_only(:,4),'tail','left'); % 1 tailed because we expect cued to be smaller than uncued



[h3 p3] = ttest2(cleanedAttright_congr_corr_only(:,4), cleanedAttright_incongr_corr_only(:,4),'tail','left'); % 1 tailed because we expect cued to be smaller than uncued

[h4 p4] = ttest2(cleanedAttleft_congr_corr_only(:,4), cleanedAttleft_incongr_corr_only(:,4),'tail','left'); % 1 tailed because we expect cued to be smaller than uncued


x = 1:2;

figure
subplot(2,2,1)
data = [ Attleft_congr_corrRT Attleft_incongr_corrRT]';
errhigh = [Attleft_congr_corrERR Attleft_incongr_corrERR];
errlow  = [Attleft_congr_corrERR Attleft_congr_corrERR];
bar(x,data)                
matt(1,:)=data'

hold on
er = errorbar(x,data,[],errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
name = {'cong RT';'incong RT'};
set(gca,'xticklabel',name)
hold on
text(1.5,0.76, ['p = ' num2str(p2)]);
ylim([0 0.8])
hold off
title('Left side RT') 

subplot(2,2,2)
data = [ Attleft_congr_corr Attleft_incongr_corr]';
bar(x,data)                
hold on

name = {' cong %';' incong %'};
set(gca,'xticklabel',name)
hold off
title('Left side % corr') 

subplot(2,2,3)
data = [ Attright_congr_corrRT Attright_incongr_corrRT]';
errhigh = [Attright_congr_corrERR Attright_incongr_corrERR];
errlow  = [Attright_congr_corrERR Attright_congr_corrERR];
bar(x,data)                
matt(2,:)=data'

hold on
er = errorbar(x,data,[],errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
name = {'cong RT';'incong RT'};
hold on
text(1.5,0.76, ['p = ' num2str(p)]);
ylim([0 0.8])
set(gca,'xticklabel',name)
hold off
title('Right side RT') 

subplot(2,2,4)
data = [ Attright_congr_corr Attright_incongr_corr]';
bar(x,data)                
hold on

name = {'cong %';'incong %'};
set(gca,'xticklabel',name)
hold off
title('Right side % corr') 
%suptitle([baseName(end-35:end-34) ' attention task'] )

suptitle([baseName(end-35:end-33) ' attention task'] )

%print([baseName(end-35:end-33) ' attention'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI



%suptitle([baseName(end-34:end-33) ' attention task'] )

print([subj ' attention'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%print([baseName(end-34:end-33) ' attention'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%print([baseName(end-34:end-33) ' attention'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

figure
subplot(2,2,1)
data = [ nanmean(cleanedAttleft_congr_corr_only(:,4)) nanmean(cleanedAttleft_incongr_corr_only(:,4)) ]';
errhigh = [Attleft_congr_corrERR Attleft_incongr_corrERR];
errlow  = [Attleft_congr_corrERR Attleft_congr_corrERR];
bar(x,data)                
matt(3,:)=data'
hold on
er = errorbar(x,data,[],errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
name = {'cong RT';'incong RT'};
set(gca,'xticklabel',name)
hold on
text(1.5,0.76, ['p = ' num2str(p4)]);
ylim([0 0.8])
hold off
title('Left side RT no outlier') 

subplot(2,2,2)
data = [ Attleft_congr_corr Attleft_incongr_corr]';
bar(x,data)                
hold on

name = {' cong %';' incong %'};
set(gca,'xticklabel',name)
hold off
title('Left side % corr') 

subplot(2,2,3)
data = [ nanmean(cleanedAttright_congr_corr_only(:,4)) nanmean(cleanedAttright_incongr_corr_only(:,4)) ]';
matt(4,:)=data'


errhigh = [Attright_congr_corrERR Attright_incongr_corrERR];
errlow  = [Attright_congr_corrERR Attright_congr_corrERR];
bar(x,data)                

hold on
er = errorbar(x,data,[],errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
name = {'cong RT';'incong RT'};
hold on
text(1.5,0.76, ['p = ' num2str(p3)]);
ylim([0 0.8])
set(gca,'xticklabel',name)
hold off
title('Right side RT no outlier') 

subplot(2,2,4)
data = [ Attright_congr_corr Attright_incongr_corr]';
bar(x,data)                
hold on

name = {'cong %';'incong %'};
set(gca,'xticklabel',name)
hold off
title('Right side % corr') 
suptitle([baseName(end-35:end-33) ' attention task no outlier'] )

%print([baseName(end-35:end-33) ' attentionNoOut'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
print([subj ' attentionNoOut'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%print([baseName(end-34:end-33) ' attentionNoOut'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI%
  