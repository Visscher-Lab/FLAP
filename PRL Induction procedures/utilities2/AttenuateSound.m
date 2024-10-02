function soundout = AttenuateSound(soundin, att_dB)
%
% soundout = AttenuateSound(soundin, att_dB)
%
% This function attenuates the overall level of a sound of a certain number
% of decibels. The reference for the attenuation is 0-dB FS (i.e., full
% scale). The function attenuates the sound if the input number of decibels
% is negative and amplify the sound otherwise.
% If the sound is stereophonic the desired attenuation (att_dB) is imposed
% on the loudest channel.
%
% Please, note that a sinusoidal signal with peak amplitude at 1 has an
% overall level of -3.02 dB.
%
% SOUNDIN: the sound we want to attenuate
% ATT_DB: attenuation/amplification in dB
%
% DIGITAL SOUNDS HAVE A MAXIMUM DYNAMIC RANGE OF 96 dB FOR AT 16 BITS
% RESOLUTION:
% 
%       20*log10(2^16)=96.33
%
% See http://en.wikipedia.org/wiki/DBFS for further details on dB FS.

if size(soundin, 2)==2
    rms_sound_dB = max(norm(soundin(:, 1))/sqrt(length(soundin(:, 1))), norm(soundin(:, 1))/sqrt(length(soundin(:, 1))));
    ratio = (10^(att_dB/20))/rms_sound_dB;
    soundout = [ratio*soundin(:, 1), ratio*soundin(:, 2)];
else
    rms_sound_dB = norm(soundin)/sqrt(length(soundin));
    ratio = (10^(att_dB/20))/rms_sound_dB;
    soundout = ratio*soundin;
end
% rms_sound_dB = norm(soundin)/sqrt(length(soundin));
% ratio = (10^(att_dB/20))/rms_sound_dB;
% soundout = ratio*soundin;
if length(find(abs(soundout)>1))>0
    clippedsamples=length(find(abs(soundout)>1));
    fprintf('\n\tWarning! This sound has now %1.0f clipped samples!\n\n', clippedsamples);
end;