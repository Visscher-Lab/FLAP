close all
figure
if (trial)==length(Timeperformance)
    scatter(1:trial,Timeperformance(), 50,'filled')
else
    scatter(1:trial-1,Timeperformance(),50,'filled')
end
xlabel('trial')
ylabel('trial duration (sec)')
ylim([0 10])

title(baseName(8:9))

session= baseName(35)
theadd =baseName(end-4:end);
xlabel('trial','FontSize',15,'FontWeight','bold')
ylabel('trial duration (sec)','FontSize',15,'FontWeight','bold')
title('Training Type 3','FontSize',18,'FontWeight','bold')
%ylim([0 10])
      print([name session 'tt3' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
