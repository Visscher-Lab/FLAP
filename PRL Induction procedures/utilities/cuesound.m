clc;
clear all;
freqC=278.4375;
numNotes=13;
noteNumbers=[0:(numNotes-1)];
whiteKeys=[1 3 5 6 8 10 12 13];
multFac=2.^(noteNumbers/12);
allFreqs=freqC*multFac;
dur=.25;
ISI=1;
sampRate=44100;
nTimeSamples=dur*sampRate;
t=linspace(0,dur,nTimeSamples);
tic
for i=1:length(whiteKeys)
    freq=allFreqs(whiteKeys(i));
    y=sin(2*pi*freq*t)';
    sndmat=repmat(y,1,2);
    if mod(i,2)==0
        sndmat(:,1)=0;
    else
        sndmat(:,2)=0;
    end
    sound(sndmat,sampRate);
    while toc<i*ISI
    end 
end
