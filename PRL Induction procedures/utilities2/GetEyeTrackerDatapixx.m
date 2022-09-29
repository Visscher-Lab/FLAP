% % % %
% Script does not assume that CheckCount is pre-initialized.
% CheckCount count may be periodically reset to zero as needed in an outer script.
%
% Necessary inputs are:
% EyetrackerType, eye_used, driftoffsetx, driftoffsety, el (optional, required for eyelink interface)
% % % %
if ~exist('CheckCount','var')
    CheckCount = 0;
end
ErrorFlag = 0;
CheckCount = CheckCount + 1;
if CheckCount == 1
    ErrorCount = 0;
    clear ErrorData EvtInfo
end
switch EyetrackerType
    case 1 % EyeLink
        [SummaryData EyeTrackerData ErrorData] = CheckTracker(EyetrackerType,eye_used,ScreenHeightPix,ScreenWidthPix,driftoffsetx,driftoffsety,ViewpointRefresh,el);
    
        case 2 % VPixx
        [SummaryData EyeTrackerData ErrorData] = CheckTrackerpixx(EyetrackerType,eye_used,ScreenHeightPix,ScreenWidthPix,driftoffsetx,driftoffsety,ViewpointRefresh);

    case 3 % Arrington
        [SummaryData EyeTrackerData ErrorData] = CheckTracker(EyetrackerType,eye_used,ScreenHeightPix,ScreenWidthPix,driftoffsetx,driftoffsety,ViewpointRefresh);
end
if  max(SummaryData) ~= -1   % data is good
    EyeData(CheckCount,:) = SummaryData;
    EvtInfo{CheckCount} = EyeTrackerData;
    ErrorCount = 0;
    if EyeData(end,4) == -1 && (CheckCount > 1) % occurrs with Eyelink system, if is easier than switch/case
        EyeData(end,4) = (sqrt(((EyeData(end,1) - EyeData(end-1,1))^2) + ((EyeData(end,2) - EyeData(end-1,2))^2)))/...
            ((EyeData(end,5) - EyeData(end-1,5))); % compute velocity (noisy, only two datapoints) in px/ms
    end
elseif (min(SummaryData) == -1) && ~isstruct(ErrorData) && (EyetrackerType == 1) % no available data, but no error (for Eyelink only)
    CheckCount = CheckCount - 1;
    ErrorFlag = 1;
else                    % data quality is bad or something else occurred
    ErrorCount = ErrorCount + 1;
    ErrorInfo{CheckCount,ErrorCount} = ErrorData;
    CheckCount = CheckCount - 1;
    ErrorFlag = 1;
end
if ~exist('EyeData','var')
    EyeData = ones(1,5)*9001;
end
if CheckCount == 1
    Refs = [-1 -1];
    FixOnsetIndex = -1;
end