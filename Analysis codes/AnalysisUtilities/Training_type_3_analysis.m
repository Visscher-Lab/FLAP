close all
figure
scatter(1:trial-1,Timeperformance())
xlabel('trial')
ylabel('trial duration (sec)')
ylim([0 10])