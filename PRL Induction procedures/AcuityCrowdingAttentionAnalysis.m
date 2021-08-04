% Acuity/crowding/attention analysis
%Marcello A. Maniglia July 2021

%% Acuity
r= (scotomadeg*pix_deg)/2;
th=0:pi/50:2*pi;
xunit= r*cos(th) + wRect(3)/2;
yunit= r*sin(th) + wRect(4)/2;
pgon = fill([wRect(1) wRect(2) wRect(3) wRect(3)], [wRect(4) wRect(2) wRect(1) wRect(4)], [0.5 0.5 0.5]);
   
for ui=1:length(eccentricity_X)
    hold on
    PRL_sc{ui} = ThreshlistVA(ui,:);
    PRL_thresh{ui} = mean(ThreshlistVA(ui,end-2:end));
    PRL_coord{ui}= [eccentricity_X(ui) eccentricity_Y(ui)];
    PRLLoc{ui}=[(wRect(3)/2)+eccentricity_X(ui) (wRect(4)/2)+eccentricity_Y(ui)];

Scores{ui} = text(PRLLoc{ui}(1)*0.9,PRLLoc{ui}(2),num2str(PRL_thresh{ui}));
end


 hold on

fill(xunit,yunit, [200/255 200/255 200/255]);
axis off
title('acuity');


%% Crowding

for ui=1:2
    figure
    pgon = fill([wRect(1) wRect(2) wRect(3) wRect(3)], [wRect(4) wRect(2) wRect(1) wRect(4)], [0.5 0.5 0.5]);

   for si=1:length(eccentricity_X)
    PRL_sc{si,ui} = ThreshlistCW(si,ui);
    PRL_threshCW{si,ui} = mean(ThreshlistCW(si,end-2:end,ui));
Scores{si,ui} = text(PRLLoc{si}(1)*0.9,PRLLoc{si}(2),num2str(PRL_threshCW{si}));
       hold on
   end

fill(xunit,yunit, [200/255 200/255 200/255]);
hold on
axis off
if ui ==1
title('radial crowding');
elseif ui ==2
    title('tangential crowding');
end
   end



thresho=permute(ThreshlistCW, [3 1 2]);

%position 1 (up), radial
uprad=thresho(:,1,1);
%position 2 (right), radial
rightrad=thresho(:,2,1);
%position 3 (down), radial
downrad=thresho(:,3,1);
%position 4 (left), radial
lefttrad=thresho(:,4,1);


%position 1 (up), tangential
uptan=thresho(:,1,2);
%position 2 (right), tangential
righttan=thresho(:,2,2);
%position 3 (down), tangential
downtan=thresho(:,3,2);
%position 4 (left), tangential
lefttan=thresho(:,4,2);



%% Attention



Attmax= [mixtrAtt correx time_stim];

for ui=1:length(eccentricity_X)
    hold on
    PRL_cued_acc{ui} = Attmax(Attmax(:,1)==ui & Attmax(:,2)==1,3);
        PRL_uncued_acc{ui} = Attmax(Attmax(:,1)==ui & Attmax(:,2)==1,3);

    PRL_cued_RT{ui} = Attmax(Attmax(:,1)==ui & Attmax(:,2)==1,4);
        PRL_uncued_RT{ui} = Attmax(Attmax(:,1)==ui & Attmax(:,2)==1,4);
Scores{ui} = text(PRLLoc{ui}(1)*0.9,PRLLoc{ui}(2),num2str(PRL_thresh{ui}));
end
