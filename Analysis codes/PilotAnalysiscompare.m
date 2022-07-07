%pilot comparison

load ACAPilotdata.mat
% 
% 
% %scatter(1:length(ucr_new(1,:)),ucr_new(1,:), 'filled')
% 
% % VA	cw_rad	cw_tan	attshortCueRT	attshortUncueRT	attshortCueperc	attshortUncuePerc	attlongCueRT	attlongUncueRT	attlongCueperc	attlongUncuePerc
% 
% 
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,1)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,1)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,1)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,1)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,1),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,1),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,1),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,1),'b')
% hold on
% end
% xlim([-1 1])
% title('Visual acuity')
% set(gca, 'FontSize', 14)
% 
% ylabel('degrees of visual angle')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' VA_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,2)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,2)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,2)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,2)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,2),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,2),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,2),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,2),'b')
% hold on
% end
% xlim([-1 1])
% title('Crowding rad')
% set(gca, 'FontSize', 14)
% 
% ylabel('degrees of visual angle')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' CRrad_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,3)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,3)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,3)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,3)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,3),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,3),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,3),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,3),'b')
% hold on
% end
% xlim([-1 1])
% title('Crowding tan')
% set(gca, 'FontSize', 14)
% 
% ylabel('degrees of visual angle')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' CRtan_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,2))/mean(ucr_old(:,3)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,2))/mean(ucr_new(:,3)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,2))/mean(uab_old(:,3)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,2))/mean(uab_new(:,3)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,2)/ucr_old(ui,3),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,2)/ucr_new(ui,3),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,2)/uab_old(ui,3),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,2)/uab_new(ui,3),'b')
% hold on
% end
% xlim([-1 1])
% title('Crowding ratio')
% set(gca, 'FontSize', 14)
% 
% ylabel('degrees of visual angle')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' CRratio_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,4))-mean(ucr_old(:,5)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,4))-mean(ucr_new(:,5)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,4))-mean(uab_old(:,5)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,4))-mean(uab_new(:,5)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,4)-ucr_old(ui,5),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,4)-ucr_new(ui,5),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,4)-uab_old(ui,5),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,4)-uab_new(ui,5),'b')
% hold on
% end
% xlim([-1 1])
% title('Attention task short RT')
% set(gca, 'FontSize', 14)
% 
% ylabel('cued minus uncued RT')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' Attention_short_RT_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,6))-mean(ucr_old(:,7)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,6))-mean(ucr_new(:,7)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,6))-mean(uab_old(:,7)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,6))-mean(uab_new(:,7)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,6)-ucr_old(ui,7),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,6)-ucr_new(ui,7),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,6)-uab_old(ui,7),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,6)-uab_new(ui,7),'b')
% hold on
% end
% xlim([-1 1])
% title('Attention task short accuracy')
% set(gca, 'FontSize', 14)
% 
% ylabel('cued minus uncued % accuracy')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' Attention_short_acc_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,8))-mean(ucr_old(:,9)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,8))-mean(ucr_new(:,9)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,8))-mean(uab_old(:,9)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,8))-mean(uab_new(:,9)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,8)-ucr_old(ui,9),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,8)-ucr_new(ui,9),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,8)-uab_old(ui,9),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,8)-uab_new(ui,9),'b')
% hold on
% end
% xlim([-1 1])
% title('Attention task long RT')
% set(gca, 'FontSize', 14)
% 
% ylabel('cued minus uncued RT')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' Attention_long_RT_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% 
% figure
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_old(:,10))-mean(ucr_old(:,11)),140,'r', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(ucr_new(:,10))-mean(ucr_new(:,11)),140,'r')
% hold on
% end
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_old(:,10))-mean(uab_old(:,11)),140,'b', 'filled')
% hold on
% end
% hold on
% for ui=1
% scatter(1*(rand(1)-0.5),mean(uab_new(:,10))-mean(uab_new(:,11)),140,'b')
% hold on
% end
% hold on
% for ui=1:length(ucr_old(:,1))
% scatter(1*(rand(1)-0.5),ucr_old(ui,10)-ucr_old(ui,11),'r', 'filled')
% hold on
% end
% hold on
% for ui=1:length(ucr_new(:,1))
% scatter(1*(rand(1)-0.5),ucr_new(ui,10)-ucr_new(ui,11),'r')
% hold on
% end
% for ui=1:length(uab_old(:,1))
% scatter(1*(rand(1)-0.5),uab_old(ui,10)-uab_old(ui,11),'b', 'filled')
% hold on
% end
% hold on
% for ui=1:length(uab_new(:,1))
% scatter(1*(rand(1)-0.5),uab_new(ui,10)-uab_new(ui,11),'b')
% hold on
% end
% xlim([-1 1])
% title('Attention task long accuracy')
% set(gca, 'FontSize', 14)
% 
% ylabel('cued minus uncued % accuracy')
% legend('UCR old', 'UCR new', 'UAB old', 'UAB new')
% print([' Attention_long_acc_pilot_comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
% 
% close all
%%

for ui=1:length(ucr_old(1,:))
themean=[mean(ucr_old(:,ui)) mean(ucr_new(:,ui)) mean(uab_old(:,ui)) mean(uab_new(:,ui))]
figure
theerr=[std(ucr_old(:,ui))/sqrt(length(ucr_old(:,ui))) std(ucr_new(:,ui))/sqrt(length(ucr_new(:,ui))) std(uab_old(:,ui))/sqrt(length(uab_old(:,ui))) std(uab_new(:,ui))/sqrt(length(uab_new(:,ui)))];
c = bar(themean);
set(gca, 'XTickLabel',{'UCR old','UCR new','UAB old', 'UAB new'})
tasksName={'VA',	'CW rad'	,'CW tan',	'attshortCueRT',	'attshortUncueRT',	'attshortCueperc',	'attshortUncuePerc',	'attlongCueRT',	'attlongUncueRT',	'attlongCueperc',	'attlongUncuePerc'};
if ui<4
ylabel('degrees of visual angle')
elseif ui>3 && ui<6 || ui>7 && ui<10 
    ylabel('Reaction time (s)')
    ylim([0 max(themean)*1.2])
elseif ui>5 && ui<8 || ui>9 && ui<100 
    ylabel('accuracy (% correct)')
    ylim([0 100])

end
c.FaceColor = 'flat';
% c.CData(1,:) = [0 0 1 ];
% c.CData(2,:) = [0.32 0.32 1];
% c.CData(3,:) = [0.54 0.54 1];
% c.CData(4,:) = [0.76 0.76 1];
c.CData(1,:) = [1 0 0 ];
c.CData(3,:) = [0 0 1];
c.CData(2,:) = [0 1 0 ];
c.CData(4,:) = [0.54 0.54 0.54];
%c.CData(5,:) = [0 0 1];
set(gca, 'FontSize', 18)

%errlow=(std(AcuityAcc)/sqrt(length(AcuityAcc(:,1))));
%errhigh=(std(AcuityAcc)/sqrt(length(AcuityAcc(:,1))));
errlow=theerr;
errhigh=errlow;
hold on

er = errorbar(c.XData,themean,errlow,errhigh);  
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold on
 plot(1,ucr_old(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                    plot(2,ucr_new(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                                       plot(3,uab_old(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                                       plot(4,uab_new(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                   title( [tasksName{ui} ' comparison'])
print([tasksName{ui} 'comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
end


%% crowding ratio

ucr_old(:,12)=ucr_old(:,2)./ucr_old(:,3);
ucr_new(:,12)=ucr_new(:,2)./ucr_new(:,3);
uab_old(:,12)=uab_old(:,2)./uab_old(:,3);
uab_new(:,12)=uab_new(:,2)./uab_new(:,3);

ui=12
themean=[mean(ucr_old(:,ui)) mean(ucr_new(:,ui)) mean(uab_old(:,ui)) mean(uab_new(:,ui))]
figure
theerr=[std(ucr_old(:,ui))/sqrt(length(ucr_old(:,ui))) std(ucr_new(:,ui))/sqrt(length(ucr_new(:,ui))) std(uab_old(:,ui))/sqrt(length(uab_old(:,ui))) std(uab_new(:,ui))/sqrt(length(uab_new(:,ui)))];
c = bar(themean);
set(gca, 'XTickLabel',{'UCR old','UCR new','UAB old', 'UAB new'})

    ylabel('radial/tangential crowding')
    ylim([0 3])

c.FaceColor = 'flat';
% c.CData(1,:) = [0 0 1 ];
% c.CData(2,:) = [0.32 0.32 1];
% c.CData(3,:) = [0.54 0.54 1];
% c.CData(4,:) = [0.76 0.76 1];
c.CData(1,:) = [1 0 0 ];
c.CData(3,:) = [0 0 1];
c.CData(2,:) = [0 1 0 ];
c.CData(4,:) = [0.54 0.54 0.54];
%c.CData(5,:) = [0 0 1];
set(gca, 'FontSize', 18)

%errlow=(std(AcuityAcc)/sqrt(length(AcuityAcc(:,1))));
%errhigh=(std(AcuityAcc)/sqrt(length(AcuityAcc(:,1))));
errlow=theerr;
errhigh=errlow;
hold on

er = errorbar(c.XData,themean,errlow,errhigh);  
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold on
 plot(1,ucr_old(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                    plot(2,ucr_new(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                                       plot(3,uab_old(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                                       plot(4,uab_new(:,ui),'o','LineWidth',1,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',7)
                   title( ['Crowding ratio comparison'])
print(['Crowding ratio comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% attention

listsz=[1 3 5 7 ];
%1=short cue RT
%3= short accuracy
%5=long cue RT
%7=long accuract
for uii=1:4
    ui=listsz(uii)
themean=[mean(ucr_old(:,3+ui)) mean(ucr_new(:,3+ui)) mean(uab_old(:,3+ui)) mean(uab_new(:,3+ui))]
themean2=[mean(ucr_old(:,4+ui)) mean(ucr_new(:,4+ui)) mean(uab_old(:,4+ui)) mean(uab_new(:,4+ui))]
dio=[themean' themean2'];
figure
theerr=[std(ucr_old(:,3+ui))/sqrt(length(ucr_old(:,3+ui))) std(ucr_new(:,3+ui))/sqrt(length(ucr_new(:,3+ui))) std(uab_old(:,3+ui))/sqrt(length(uab_old(:,3+ui))) std(uab_new(:,3+ui))/sqrt(length(uab_new(:,3+ui)))];
theerr2=[std(ucr_old(:,4+ui))/sqrt(length(ucr_old(:,4+ui))) std(ucr_new(:,4+ui))/sqrt(length(ucr_new(:,4+ui))) std(uab_old(:,4+ui))/sqrt(length(uab_old(:,4+ui))) std(uab_new(:,4+ui))/sqrt(length(uab_new(:,4+ui)))];
c = bar(dio);
set(gca, 'XTickLabel',{'UCR old','UCR new','UAB old', 'UAB new'})
tasksName={'cued vs uncued RT (short cue)',	'cued vs uncued Accuracy (short cue)', 'cued vs uncued RT (long cue)', 'cued vs uncued Accuracy (long cue)'};
if uii==1 || uii==3
    ylabel('Reaction time (s)')
    ylim([0 max(themean)*1.2])

elseif uii==2 || uii==4
    ylabel('accuracy (% correct)')
ylim([0 100])

end
%c.FaceColor = 'flat';
% c.CData(1,:) = [0 0 1 ];
% c.CData(2,:) = [0.32 0.32 1];
% c.CData(3,:) = [0.54 0.54 1];
% c.CData(4,:) = [0.76 0.76 1];

% c.CData(1,:) = [1 0 0 ];
% c.CData(3,:) = [0 0 1];
% c.CData(2,:) = [0 1 0 ];
% c.CData(4,:) = [0.54 0.54 0.54];
%c.CData(5,:) = [0 0 1];
set(gca, 'FontSize', 18)

%errlow=(std(AcuityAcc)/sqrt(length(AcuityAcc(:,1))));
%errhigh=(std(AcuityAcc)/sqrt(length(AcuityAcc(:,1))));
errlow=[theerr' theerr2'] ;
errhigh=errlow;
hold on

%er = errorbar(c.XData,dio,errlow,errhigh);  
%er.Color = [0 0 0];                            
%er.LineStyle = 'none';
%errorbar(c.XData,dio,errlow);  
er=errorbar([0.85 1.15; 1.85 2.15; 2.85 3.15; 3.85 4.15],dio,errlow, '.');
%er.Color = [0 0 0; 0 0 0]; 
hold on
%  plot(1,ucr_old(:,ui),'o','LineWidth',1,...
%                        'MarkerEdgeColor','k',...
%                        'MarkerFaceColor','w',...
%                        'MarkerSize',7)
%                     plot(2,ucr_new(:,ui),'o','LineWidth',1,...
%                        'MarkerEdgeColor','k',...
%                        'MarkerFaceColor','w',...
%                        'MarkerSize',7)
%                                        plot(3,uab_old(:,ui),'o','LineWidth',1,...
%                        'MarkerEdgeColor','k',...
%                        'MarkerFaceColor','w',...
%                        'MarkerSize',7)
%                                        plot(4,uab_new(:,ui),'o','LineWidth',1,...
%                        'MarkerEdgeColor','k',...
%                        'MarkerFaceColor','w',...
%                        'MarkerSize',7)
if uii==1 || uii==3
    legend('cued','uncued')
end
                   title( [tasksName{uii} ' comparison'])
print([tasksName{uii} 'comparison'], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
end

