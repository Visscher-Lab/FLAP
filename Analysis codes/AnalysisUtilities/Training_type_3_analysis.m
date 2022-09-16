close all
figure
if (trial)==length(Timeperformance)
    scatter(1:trial,Timeperformance())
else
    scatter(1:trial-1,Timeperformance())
end
xlabel('trial')
ylabel('trial duration (sec)')
ylim([0 10])

title(baseName(8:9))

session= baseName(35)
theadd =baseName(end-4:end);
      print([name session 'tt3' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI