
clear all
load FLAP_updated_2022_with_PRL.mat


% find the most used ('best') PRL
for ui=1:length(frameDistributionPRL(:,1))

newval=find(frameDistributionPRL(ui,:)==max(frameDistributionPRL(ui,:)));
if length(newval)>1
   newval=newval(1); 
end
BestPRL_array(ui)=newval;

clear newval

end

BestPRL_array=BestPRL_array';
fullmat=overall_score_uab;

%break big matrix into each ACA score
VAAcc=fullmat(1:10:end,:);
VART=fullmat(2:10:end,:);
CWRAcc=fullmat(3:10:end,:);
CWRART=fullmat(4:10:end,:);
CWTAcc=fullmat(5:10:end,:);
CWTRT=fullmat(6:10:end,:);
AttSAcc=fullmat(7:10:end,:);
AttSRT=fullmat(8:10:end,:);
AttLAcc=fullmat(9:10:end,:);
AttLRT=fullmat(10:10:end,:);


%find the score corresponding to the best PRL for each score
for ui=1:length(frameDistributionPRL(:,1))
bestVAAcc(ui)=VAAcc(ui,BestPRL_array(ui));
bestCWRAcc(ui)=CWRAcc(ui,BestPRL_array(ui));
bestCWTAcc(ui)=CWTAcc(ui,BestPRL_array(ui));
bestAttSAcc(ui)=AttSAcc(ui,BestPRL_array(ui));
bestAttLAcc(ui)=AttLAcc(ui,BestPRL_array(ui));
bestPRL(ui)=frameDistributionPRL(ui,BestPRL_array(ui));
end

bestVAAcc=bestVAAcc';
bestCWRAcc=bestCWRAcc';
bestCWTAcc=bestCWTAcc';
bestAttSAcc=bestAttSAcc';
bestAttLAcc=bestAttLAcc';
bestPRL=bestPRL';

%remove 13 (we don't have induction data for them)
bestVAAcc=[bestVAAcc(1:12); bestVAAcc(14:end)];
bestCWRAcc=[bestCWRAcc(1:12); bestCWRAcc(14:end)];
bestCWTAcc=[bestCWTAcc(1:12); bestCWTAcc(14:end)];
bestAttSAcc=[bestAttSAcc(1:12); bestAttSAcc(14:end)];
bestAttLAcc=[bestAttLAcc(1:12); bestAttLAcc(14:end)];
bestPRL=[bestPRL(1:12); bestPRL(14:end)];

% normalize score and transform so that high score = better performance
normbestVAAcc=mat2gray(bestVAAcc);
normbestVAAcc=1-normbestVAAcc;
normbestCWRAcc=mat2gray(bestCWRAcc);
normbestCWRAcc=1-normbestCWRAcc;
normbestCWTAcc=mat2gray(bestCWTAcc);
normbestCWTAcc=1-normbestCWTAcc;
normbestAttSAcc=mat2gray(bestAttSAcc);
normbestAttLAcc=mat2gray(bestAttLAcc);
normbestPRL=mat2gray(bestPRL);

XX=[normbestVAAcc normbestCWRAcc normbestCWTAcc normbestAttSAcc normbestAttLAcc];
YY=[normbestPRL];

mdl = fitlm(XX,YY)
anova(mdl,'summary')


% with interactions
tbl = table(normbestVAAcc,normbestCWRAcc,normbestCWTAcc,normbestAttSAcc, normbestAttLAcc, normbestPRL,...
    'VariableNames',{'VA','CrowdingR','CrowdingT','AttS','AttL', 'PRL'});


mdl = stepwiselm(tbl,'interactions')


figure
plotSlice(mdl)

figure
plotInteraction(mdl,'VA','CrowdingT')

plotEffects(mdl)

figure
plotInteraction(mdl,'VA','CrowdingT','predictions')




%% RT analysis

%find the score corresponding to the best PRL for each score

for ui=1:length(frameDistributionPRL(:,1))
bestVART(ui)=VART(ui,BestPRL_array(ui));
bestCWART(ui)=CWRART(ui,BestPRL_array(ui));
bestCWTRT(ui)=CWTRT(ui,BestPRL_array(ui));
bestAttSRT(ui)=AttSRT(ui,BestPRL_array(ui));
bestAttLRT(ui)=AttLRT(ui,BestPRL_array(ui));
end

bestVART=bestVART';
bestCWART=bestCWART';
bestCWTRT=bestCWTRT';
bestAttSRT=bestAttSRT';
bestAttLRT=bestAttLRT';

%remove 13 (we don't have induction data for them)
bestVART=[bestVART(1:12); bestVART(14:end)];
bestCWART=[bestCWART(1:12); bestCWART(14:end)];
bestCWTRT=[bestCWTRT(1:12); bestCWTRT(14:end)];
bestAttSRT=[bestAttSRT(1:12); bestAttSRT(14:end)];
bestAttLRT=[bestAttLRT(1:12); bestAttLRT(14:end)];

% normalize score and transform so that high score = better performance
normbestVART=mat2gray(bestVART);
normbestVART=1-normbestVART;
normbestCWART=mat2gray(bestCWART);
normbestCWART=1-normbestCWART;
normbestCWTRT=mat2gray(bestCWTRT);
normbestCWTRT=1-normbestCWTRT;
normbestAttSART=mat2gray(bestAttSRT);
normbestAttLART=mat2gray(bestAttLRT);

XX=[normbestVART normbestCWART normbestCWTRT normbestAttSART normbestAttLART];
YY=[normbestPRL];

mdl = fitlm(XX,YY)
anova(mdl,'summary')
