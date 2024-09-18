% close all
% figure
% 
% 
% xlabel('trial')
% ylabel('trial duration (sec)')
% ylim([0 10])
% 
title(baseName(8:9))
% 
session= baseName(35);
theadd =baseName(end-4:end);
name=baseName(8:9);
% if (trial)==length(Timeperformance)
%     scatter(1:trial,unadjustedTimeperformance, 50,'filled')
% else
%     scatter(1:trial-1,unadjustedTimeperformance,50,'filled')
% end
% hold on
% bar(flickertimetrial)
% xlabel('trial','FontSize',15,'FontWeight','bold')
% ylabel('trial duration (sec)','FontSize',15,'FontWeight','bold')
% title([name ' Training Type 3'],'FontSize',18,'FontWeight','bold')
%ylim([0 10])
      %print([name session 'tt3 trial duration' theadd], '-dpng', '-r300'); %<-Save as PNG with 300 DPI
      figure
      if (trial)==length(TRLsize)
          scatter(1:trial,TRLsize, 50,'filled')
      else
          scatter(1:trial-1,TRLsize,50,'filled')
      end
        
      hold on
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




            % separate and mark exo and endo trials
            endoicounter = [];
            exoicounter = [];
            newlocationendocounter = [];
            newlocationexocounter = [];
            endocuecounter = 0;
            exocuecounter = 0;

            countermixtr = [[zeros(1,(size(mixtr,2)))];mixtr];
for endoexoi = 1:trial+1
    if countermixtr(endoexoi,2) == 1 && countermixtr(endoexoi-1,2) ~= 1
        endocuecounter = endocuecounter + 1;
        endoicounter = [endoicounter;endoexoi-1];
    elseif countermixtr(endoexoi,2) == 2 && countermixtr(endoexoi-1,2) ~= 2
        exocuecounter = exocuecounter + 1;
        exoicounter = [exoicounter;endoexoi-1];
    end
    if countermixtr(endoexoi,2) == 1 && countermixtr(endoexoi,4) ~= countermixtr(endoexoi-1,4)
        newlocationendocounter = [newlocationendocounter;endoexoi-1];
    elseif countermixtr(endoexoi,2) == 2 && countermixtr(endoexoi,4) ~= countermixtr(endoexoi-1,4)
        newlocationexocounter = [newlocationexocounter;endoexoi-1];
    end
end


figure


xlabel('trial')
ylabel('trial duration (sec)')
ylim([0 10])

title(baseName(8:9))

% plot unadjustedtimeperformance against trials, AKA difference between
% trial duration and trial flicker time
session= baseName(35);
theadd =baseName(end-4:end);
name=baseName(8:9);
if (trial)==length(Timeperformance)
    scatter(1:trial,unadjustedTimeperformance, 50,'filled')
else
    scatter(1:trial-1,unadjustedTimeperformance,50,'filled')
end
hold on
% bar(flickertimetrial)
scatter(newlocationendocounter(1:end),unadjustedTimeperformance(newlocationendocounter),80,"red","filled","square")
scatter(newlocationexocounter(1:end),unadjustedTimeperformance(newlocationexocounter),50,"black","filled","diamond")
xlabel('trial','FontSize',15,'FontWeight','bold')
ylabel('total trial duration - flicker duration (sec)','FontSize',15,'FontWeight','bold')
title([name ' Training Type 3'],'FontSize',18,'FontWeight','bold')
legend ('Uncued Trial','Endogenous Trial','Exogenous Trial')



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
