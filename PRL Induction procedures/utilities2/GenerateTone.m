function tone = GenerateTone(sf, dur, freqs, amps, phases, ITD, ILD);
%
% tone = GenerateTone(sf, dur, freqs)
% tone = GenerateTone(sf, dur, freqs, amps)
% tone = GenerateTone(sf, dur, freqs, amps, phases)
% tone = GenerateTone(sf, dur, freqs, amps, phases, ITD)
% tone = GenerateTone(sf, dur, freqs, amps, phases, ITD, ILD)
%
% This function generates tones, either simple or complex (harmonic or 
% inharmonic). If ITD and ILD values are inputed, the returned sound is
% stereophonic. On the contrary, the sound is monophonic. To obtain
% stereophonic sounds with no ITD (or ILD) set ITD and ILD values to zero.
% The output sound is always normalized in amplitude (i.e., peak amplitude
% is 1 (or -1). To manipulate the sound's amplitude use AttenuateSound.
%
% SF: sample frequency of the tone in Hz
% DUR: duration of the tone in ms
% FREQS: a variable containing the frequencies of the tone components in Hz
% AMPS: a variable containing the linear amplitude of each frequency
% component (default is 1)
% PHASES: a variable containing the phases of the frequency components in
% radians (default is 0)
% ITD: sound's ITD in milliseconds
% ILD: sound's ILD in decibel
% If ITD and ILD are positive the sound comes from the left, if they are
% negative the sound comes from the right.
%
% % EXAMPLE: generate a pure tone of 1000-Hz, 250-ms duration
% puretone = GenerateTone(44100, 250, 1000);
% 
% % EXAMPLE: generate a sawtooh wave of 500-ms with five harmonics
% freqs = [100, 200, 300, 400, 500];
% amps = [1, 1/2, 1/4, 1/8, 1/16];
% sawtooth = GenerateTone(44100, 500, freqs, amps);
%
% % EXAMPLE: generate a inharmonic complex tone of 600-ms with three
% % frequency components
% freqs = [100, 223, 445];
% inharmonic = GenerateTone(44100, 600, freqs);
%
% % EXAMPLE: generate a 1-kHz, 200-ms long pure tone with 0.2-milliseconds
% ITD and 5 dB of ILD
% pureITD = GenerateTone(44100, 250, 1000, 1, 0, 0.2, 5);

numberofsamples = sf * dur/1000;
t = (0:numberofsamples-1) / sf;

if nargin<6
    if nargin<5, phases=zeros(size(freqs)); end
    if nargin<4, amps=ones(size(freqs)); end

    tone = zeros(size(t));
    % generate and add each frequency component
    for i=1:length(freqs)
        f_component = amps(i) * sin(2*pi*freqs(i)*t+phases(i));
        tone = tone + f_component;
    end
    % amplitude normalisation
    tone = tone' / max(abs(tone));
    % little correction
    tone = tone * .999;
else
    if nargin<7, ILD=0; end
    
    toneL = zeros(size(t));
    toneR = toneL;
    
    ITD = ITD/10^3; % changes ITD value from milliseconds to seconds
    IPD = 2*pi*freqs(1)*ITD;
    phases_left = phases + IPD;
    phases_right = phases;
    
    % generate and add each frequency component
    for i=1:length(freqs)
        f_component_L = amps(i) * sin(2*pi*freqs(i)*t+phases_left(i));
        f_component_R = amps(i) * sin(2*pi*freqs(i)*t+phases_right(i));
        toneL = toneL + f_component_L;
        toneR = toneR + f_component_R;
    end
    tone = [toneL*10^(ILD/20); toneR];
    % amplitude normalisation
    tone = tone' / max(max(abs(tone)));
    % little correction
    tone = tone * .999;
end