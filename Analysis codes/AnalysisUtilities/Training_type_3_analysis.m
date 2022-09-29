close all
figure


xlabel('trial')
ylabel('trial duration (sec)')
ylim([0 10])

title(baseName(8:9))

session= baseName(35);
theadd =baseName(end-4:end);
name=baseName(8:9);
if (trial)==length(Timeperformance)
    scatter(1:trial,movieDuration, 50,'filled')
else
    scatter(1:trial-1,movieDuration,50,'filled')
end
hold on
bar(flickertimetrial)
xlabel('trial','FontSize',15,'FontWeight','bold')
ylabel('trial duration (sec)','FontSize',15,'FontWeight','bold')
title([name ' Training Type 3'],'FontSize',18,'FontWeight','bold')
%ylim([0 10])
      print([name session 'tt3 trial duration' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
      figure
      if (trial)==length(TRLsize)
          scatter(1:trial,TRLsize, 50,'filled')
      else
          scatter(1:trial-1,TRLsize,50,'filled')
      end

      xlabel('trial','FontSize',15,'FontWeight','bold')
ylabel('adaptive TRL size (proportion of 1)','FontSize',15,'FontWeight','bold')
title([name ' Training Type 3'],'FontSize',18,'FontWeight','bold')
      print([name session 'tt3 TRL size' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

      figure
      if (trial)==length(flickOne)
          scatter(1:trial,flickOne, 50,'filled')
          hold on
          scatter(1:trial,flickTwo, 50,'filled')
          
      else
          scatter(1:trial-1,flickOne,50,'filled')
          hold on
          scatter(1:trial-1,flickTwo,50,'filled')
      end
legend( 'flicker in', 'flicker out')
      xlabel('trial','FontSize',15,'FontWeight','bold')
ylabel('Flicker duration (sec)','FontSize',15,'FontWeight','bold')
title([name ' Training Type 3'],'FontSize',18,'FontWeight','bold')
            print([name session 'tt3 flicker duration' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%       %%
%       if (trial)==length(Timeperformance)
%     scatter(1:trial,Timeperformance(), 50,'filled')
% else
%     scatter(1:trial-1,Timeperformance(),50,'filled')
% end
% xlabel('trial')
% ylabel('trial duration (sec)')
% ylim([0 10])
% 
% title(baseName(8:9))
% 
% session= baseName(35)
% theadd =baseName(end-4:end);
% xlabel('trial','FontSize',15,'FontWeight','bold')
% ylabel('trial duration (sec)','FontSize',15,'FontWeight','bold')
% title('Training Type 3','FontSize',18,'FontWeight','bold')
% %ylim([0 10])
%       print([name session 'tt3' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
