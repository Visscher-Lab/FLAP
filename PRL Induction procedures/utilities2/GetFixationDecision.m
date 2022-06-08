% % % %
% Script is intended to follow GetEyeTrackerData and assumes it's data structure.
% Does assume that CheckCount is pre-initialized, but this would be
% handled by GetEyeTrackerData.
%
% Necessary inputs are:
% CheckCount,EyeData,VelocityThreshs,FixationTimeThreshold,FixationLocThreshold
% Note: Refs and FixOnsetIndex are handled entirely by this script.
%
% EyeCode Key:
%               0 = Fixation
%               1 = Saccade
%               2 = Corrective movement
%               3 = Micro saccade
%               4 = Eye has moved far enough from beginning of fixation
%                   to no longer be considered part of that fixation
%                   but has not exceeded saccade or micro saccade
%                   velocity threshold.
% % % %
try
% Add datapoint to the running list of eyecodes
[EyeCode(CheckCount)] = CheckFixation(EyeData,VelocityThreshs);

% If any ambiguity about datapoint exists, resolve it if possible
% Will only occur when eye velocity is between the two thresholds
if (min(EyeCode) == -1) && (EyeCode(CheckCount) == 1)
    EyeCode(find(EyeCode == -1)) = 1;
elseif (min(EyeCode) == -1) && (EyeCode(CheckCount) == 0)
    EyeCode(find(EyeCode == -1)) = 3;
end

% Identify fixation onset or offset.
% Toggle reference coordinates for the location of the fixation as needed
% and update the index for the beginning of a fixation, if applicable.
if CheckCount > 1
    if (EyeCode(CheckCount) == 0) && (EyeCode(CheckCount-1) > 0)
        FixOnsetIndex = CheckCount;
        Refs = [-1 -1];
    elseif (EyeCode(CheckCount) > 0) && max((Refs ~= [-1 -1]))
        FixOnsetIndex = -1;
        Refs = [-1 -1];
    end
end

% If a fixation has begun, and enough time has passed, and reference coordinates
% are not already established, calculate reference coordinates
if (FixOnsetIndex ~= -1) && ((EyeData(CheckCount,5) - EyeData(FixOnsetIndex,5)) >= FixationTimeThreshold) && min((Refs == [-1 -1]))
    Refs(1) = mean(EyeData(FixOnsetIndex:CheckCount,1));
    Refs(2) = mean(EyeData(FixOnsetIndex:CheckCount,2));
end

% If a fixation is ongoing (indicated by valid reference coordinates)
% and the eye has moved "too far" from the reference coordinates to be
% considered part of the same fixation (without ever exceeding the velocity
% thresholds), then interrupt the fixation by inserting a single, special
% eye code for this purpose.
if max((Refs ~= [-1 -1]))
    if ((EyeData(end,1) - Refs(1))^2 + (EyeData(end,2) - Refs(2))^2) > ((FixationLocThreshold*PixelsPerDegree)^2)
        EyeCode(end) = 4;
    end
end

% Record the reference coordinates and fixation onset indices, for debugging
% RefsHold(CheckCount,1:2) = Refs';
% RefsHold(CheckCount,3) = FixOnsetIndex;

catch ME
    psychlasterror()
end