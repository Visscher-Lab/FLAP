function soundout = GenerateEnvelope(sf, soundin, onsetdur, offsetdur)
%
% soundout = GenerateEnvelope(sf, soundin)
% soundout = GenerateEnvelope(sf, soundin, gatedur)
% soundout = GenerateEnvelope(sf, soundin, onsetdur, offsetdur)
%
% This function apply onset and offset raised cosine gates to a sound. By
% default, gates have identical duration of 10-ms. The function works with
% monophonic and stereophonic sounds.
%
% SF: sample frequency in Hz of the input sound
% SOUNDIN: an array containing the input sound
% ONSETDUR: the duration of onset gate in ms. If the values of the onset
% and offset gate is omitted the default gate duration is 10-ms.
% OFFSETDUR: the duration of offset gate in ms. If this value is omitted,
% the function generates two gates of onsetdur duration.

if nargin == 2, onsetdur=10; offsetdur=onsetdur; end
if nargin == 3, offsetdur=onsetdur; end

% cut one sample in case the length of the sound array is an odd number
if rem(length(soundin), 2)~=0 && size(soundin, 2)==1
    soundin = soundin(1:end-1);
elseif rem(length(soundin), 2)~=0 && size(soundin, 2)==2
    soundin = soundin(1:end-1, 1:2);
end

onsetdurationinsamples = round(onsetdur*(sf/1000));
offsetdurationinsamples = round(offsetdur*(sf/1000));
if (onsetdurationinsamples+offsetdurationinsamples) > length(soundin)
    error ('The duration of onset and offset gates exceedes the overall duration of the sound');
end
% create an array of one of the same lenght of the input sound
onsetgate = (sin(pi*(3/2):pi/(onsetdurationinsamples-1):pi*(5/2))+1)/2;
offsetgate = (sin(pi*(3/2):pi/(offsetdurationinsamples-1):pi*(5/2))+1)/2;
sustain = ones(1, length(soundin)-(length(onsetgate)+length(offsetgate)));
envelope = [onsetgate, sustain, fliplr(offsetgate)];
% apply the gates
if size(soundin, 2)==2
    soundout = [envelope' .* soundin(:, 1), envelope' .* soundin(:, 2)];
else
    soundout = envelope' .* soundin;
end