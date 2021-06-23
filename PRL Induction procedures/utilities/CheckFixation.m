function [EyeCode] = CheckFixation(EyeData,VelocityThreshs)

if EyeData(end,4) <= VelocityThreshs(1)
    EyeCode = 0; % fixation
elseif ((EyeData(end,4) <= VelocityThreshs(2)) && (EyeData(end,4) > VelocityThreshs(1)))
    if size(EyeData,1) > 8
        if (max(EyeData(end-8:end-1,4)) > VelocityThreshs(2))
            EyeCode = 2; % correction
        else
            EyeCode = -1; % microsaccade or beginning of real saccade
        end
    else
        EyeCode = -1; % microsaccade or beginning of real saccade
    end
elseif EyeData(end,4) > VelocityThreshs(2)
    EyeCode = 1; % saccade
end