

ecc_xx=0;
ecc_yy=0;
 funo = 800;   % reference for tone's frequency (in Hz)
 f=funo-ecc_yy*10;
tone = GenerateTone (44100,100,f);
tone = GenerateEnvelope(44100, tone);       
 %   cue_start=cueonset; %if we want to measure reaction time from the
 %   onset of the cue rather than/additionally to from the onset of the
 %   stimulus
%sound(tone, sr);    
%Create our HRTF matrix
elevation=0;


if ecc_xx==12
    azimuth=60;
elseif ecc_xx==-12
    azimuth=-60;
elseif ecc_xx>-12 && ecc_xx<=-9
    azimuth=-45;
elseif ecc_xx<12 && ecc_xx>=9
    azimuth=45;
else
    azimuth=round(ecc_xx/5)*5;
end
   
elevations = zeros(1, length(data));
azimuths = zeros(1, length(data));
for i = 1:length(data)
    elevations(i) = data(i).elevation;
    if (data(i).azimuth == azimuth) && (data(i).elevation == elevation)
        flag = 1;
        IR = zeros(length(data(i).IR), 2);
        IR(:, 1) = data(i).IR(:, 1);
        IR(:, 2) = data(i).IR(:, 2);
        fs  = specs.sampleRate;
        ITD = data(i).ITD;
    end
end


%Implement ITD
if ITD < 0
    leftEar = [IR(:, 1); zeros(round(abs(ITD)), 1)];
    rightEar = [zeros(round(abs(ITD)), 1); IR(:, 2)];
else
    leftEar = [zeros(round(abs(ITD)), 1); IR(:, 1)];
    rightEar = [IR(:, 2); zeros(round(abs(ITD)), 1)];
end
sig(:, 1) = conv(leftEar, tone);
sig(:, 2) = conv(rightEar, tone);
PsychPortAudio('FillBuffer', pahandle, sig'*.25);