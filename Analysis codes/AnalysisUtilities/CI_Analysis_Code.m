clear all
close all
clc

%% Loading and reading Participant data
cd('..\..\..\FLAP\PRL Induction procedures\data') % enter the path to datafolder for future analyses
% load('DAContourPixx_2_123_7_20_9_51.mat') % Load participant specific .mat file here
load('ACContourPixx_2_123_7_20_9_29.mat')
% load('CSContourPixx_2_123_7_20_12_1.mat')
cd('..\..\Analysis codes\AnalysisUtilities')

name = baseName(71:79);
session = baseName(87);
if session == '1'
    sess = 'baseline';
else
    sess = 'posttest';
end

%% graph stats
shapes_type={'d/b left','d/b right','q/p left','q/p right'}; % if changing shapes for assessment, change the name

% Rearranging the Threshlist and iscorr in order of Shape 1, left --> Shape 1
% right --> Shape 2 left --> Shape 2 right
Threshmat = Threshlist';
Threshmat = Threshmat(:);
corrmat = iscorr';
corrmat = corrmat(:);

figure(1)
for i = 1:length(Threshmat) % no.of shapes and location for assessment
    subplot(2,2,i)
    for j = 1:length(Threshmat{i,1})
        if corrmat{i,1}(1,j) == 1
            plot(j,Threshmat{i,1}(1,j), '.b','MarkerSize',14) % correct responses
            hold on
        else
            plot(j,Threshmat{i,1}(1,j), '*k','MarkerSize',4.5) % incorrect responses (not looking at timedout trials)
            hold on
        end
    end
    hold on
    xlabel('Trials','FontSize',12)
    ylabel('Orientation Jitter','FontSize',14)
    ylim([0 30])
    title(shapes_type{i}, 'FontSize',15)
end
sgtitle(name,'FontSize',16)

print([name sess 'tracks'],'-dpng', '-r300'); %<-Save as PNG with 300 DPI


%% Reaction Time Analysis

% Cleaning the time_stim variable
rxnT = time_stim';
rxnT = rxnT(:);
for k = 1:length(rxnT)
    for l = 1:length(rxnT{k,1})
        if rxnT{k,1}(1,l) == 999 % if 999, then trial timed out and participant didn't respond
            rxnT{k,1}(1,l) = NaN;
        end
    end
    RT{k,1} = nonzeros(rxnT{k,1});
end

% Overall RT
RTmean_all = cellfun(@nanmean,RT);
RTstd_all = cellfun(@nanstd,RT);

% Calculating RT only for correct trials
count = zeros(length(RT),1);
for m = 1:length(RT)
    for n = 1:length(RT{m,1})
        if corrmat{m,1}(1,n) == 0 || corrmat{m,1}(1,n) == 99  
            RT_corr{m,1}(n,1) = NaN; % changing the RT's of incorrect responses to NaN's
        else
            RT_corr{m,1}(n,1) = RT{m,1}(n,1); % isolating only correct response RT's
            count(m,1) = count(m,1)+1; % no.of correct trials
        end
    end
end

RTmean_corr = cellfun(@nanmean,RT_corr);
RTstd_corr = cellfun(@nanstd,RT_corr);
Accuracy = (count/60)*100;

RT_mean = [RTmean_all, RTmean_corr];
RT_std = [RTstd_all, RTstd_corr];

%% Plotting RT graphs
x_id = 1:2;
names = {'All','Corr'};
figure(2)
for o = 1:length(RTmean_all)
    subplot(2,2,o)
    y = RT_mean(o,:);
    err = RT_std(o,:);
    bar(x_id,y)
    hold on
    er = errorbar(x_id,y,err);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    set(gca,'xtick',x_id,'xticklabel',names,'fontsize',15)
    xtickangle(45)
    xlim([0 3])
    ylim([-1 3])
    ylabel('Reaction Times','fontsize',15);
    grid on;
    title(shapes_type{o}, 'FontSize',16)
    axis('square')
end
sgtitle(name,'FontSize',17)
print([name sess 'RT'],'-dpng', '-r300'); %<-Save as PNG with 300 DPI

%% Calculating Accuracy during progressive tracks
for p = 1:length(corrmat)
    progaccuracy(p,1) = (sum(corrmat{p,1}(1:24))/24)*100;
end
figure(3)
x_id = 1:4;
names = {'d/b L', 'd/b R', 'q/p L', 'q/p R'};
bar(x_id,progaccuracy)
hold on
set(gca,'xtick',x_id,'xticklabel',names,'fontsize',15)
xtickangle(45)
xlim([0 5])
ylim([0 100])
ylabel('Acuracy','fontsize',15)
grid on;
t = 'Prog Staircase Accuracy ';
titlestr = strcat(t,name);
title(titlestr, 'Fontsize',17)
print([name sess 'ProgAcc'],'-dpng','-r300');