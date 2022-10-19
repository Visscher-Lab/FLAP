
close all
sess='11'
if length(gaptime)==length(targetpres)
array=gaptime-targetpres;
elseif length(gaptime)<length(targetpres)
    newtargetpres=targetpres(1:end-1);
    array=gaptime-newtargetpres;
end
array=array*1000;
scatter(1:length(array), array, 'filled')
xlabel('trial')
ylabel('ms')
xticks(1:1:length(array))
%yline(presentationtime, '-', 'target time')
hold on
y=presentationtime*1000;
line([1, length(array)], [y, y])
hold on
text(length(array)-1, y*1.002, 'presentation time')
ylim([y-100 y+100])
title('Carrasco task Latency Analysis')
print([sess 'CClatencyAnalysis'], '-dpng', '-r300')