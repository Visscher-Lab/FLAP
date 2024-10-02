function retinotopy(subjName)

%   This master function was written by Pinar Demirayak to call retinotopy functions:
%
%       Bar stimulus
%       Wedge stimulus
%       Ring stimulus
%
%   Inputs to these functions are created through prompts to the user

%% Set defaults
%clc;
%clear all;
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
addpath([cd '/utilities']); %add folder with utilities files
% Choose stimulus
sessNames = {...
    'Bars' ...
    'Wedges' ...
    'Rings'};
%% Get the subject name
if ~exist ('subjName', 'var')
    error('Pass subject name when calling function!')
end
%% Get the session date
tmp = datestr(now,2);
sessDate = tmp([1,2,4,5,7,8]);
%% Get the session name
sprintf(['\nRetinotopy Stimulus:\n' ...
    '\n1 - Bars' ...
    '\n2 - Wedges' ...
    '\n3 - Rings\n'])
sessNum = input('Which run type? 1/2/3:\n','s');
if isempty(sessNum)
    error('no session number!');
elseif sessNum=='1';
    sessNum2=1;
elseif sessNum=='2';
    sessNum2=2;
elseif sessNum=='3';
    sessNum2=3;
end
%% Set output directory
outDir = fullfile(pwd,'data','Retinotopy_Data',sessNames{sessNum2},subjName,sessDate);

if ~exist(outDir,'dir')
    mkdir(outDir);
end

%% Get the function input
saveInfo.subjectName        = subjName;
switch sessNum
    case '1'
        runName     = 'tfMRI_RETINO_BAR';
        sparams=load('bars.mat');
        saveInfo.fileName   = fullfile(outDir,[runName '.mat']);
        % move file if re-running
        if exist(saveInfo.fileName,'file')
            if ~exist(fullfile(outDir,'abortedRuns'),'dir')
                mkdir(fullfile(outDir,'abortedRuns'));
            end
            system(['mv ' saveInfo.fileName ' ' fullfile(outDir,'abortedRuns',[runName '.mat'])]);
        end
        bars_retinotopy(saveInfo, sparams);
    case '2'
        runName = 'tfMRI_RETINO_WEDGE';
        sparams=load('wedges.mat');
        saveInfo.fileName   = fullfile(outDir,[runName '.mat']);
        % move file if re-running
        if exist(saveInfo.fileName,'file')
            if ~exist(fullfile(outDir,'abortedRuns'),'dir')
                mkdir(fullfile(outDir,'abortedRuns'));
            end
            system(['mv ' saveInfo.fileName ' ' fullfile(outDir,'abortedRuns',[runName '.mat'])]);
        end
        wedges_retinotopy(saveInfo, sparams);
    case '3'
        runName     = 'tfMRI_RETINO_RING';
        sparams=load('rings.mat');
        saveInfo.fileName   = fullfile(outDir,[runName '.mat']);
        % move file if re-running
        if exist(saveInfo.fileName,'file')
            if ~exist(fullfile(outDir,'abortedRuns'),'dir')
                mkdir(fullfile(outDir,'abortedRuns'));
            end
            system(['mv ' saveInfo.fileName ' ' fullfile(outDir,'abortedRuns',[runName '.mat'])]);
        end
        rings_retinotopy(saveInfo, sparams);
    otherwise
        disp('unknown run type');
end