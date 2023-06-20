Datapixx('RegWrRd');
buttonLogStatus = Datapixx('GetDinStatus');
if buttonLogStatus.logRunning~=1;
         Datapixx('SetDinLog'); %added by Jerry
         Datapixx('StartDinLog');
         Datapixx('RegWrRd');
end





Datapixx('RegWrRd');
buttonLogStatus = Datapixx('GetDinStatus');
binaryvals=dec2bin(buttonpress(counter)); %convert triggers to binary values Jerry : should use (counter) index
            binaryvals=binaryvals(end: -1:1); %reorder to left to right (edited) 
inter_buttonpress{counter}=buttonpress(counter); %actual output : bits order: ?Right to Left?
            bin_buttonpress{counter}=binaryvals; %saved output: bits order : ?Left to Right?
            inter_timestamp{counter}=timestamp;
            if (bitand(buttonpress(counter),dinRed+dinYellow+dinGreen+dinBlue+mri_trigger) ~=0) && any(str2num(binaryvals(TargList)))
                Bpress=1;
                TheButtons=find(binaryvals(TargList)=='1');
            end

%and you can stop the logging when you don?t need it
Datapixx('StopDinLog');