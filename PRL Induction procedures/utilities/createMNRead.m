    
        
    
if expDay==2
    StimuliFolder='./utilities/MNRead_sentences/ChartB/'; %to be updated! AS now updated.
elseif expDay==1
    StimuliFolder='./utilities/MNRead_sentences/ChartA/'; %to be updated! AS now updated.
elseif expDay==3
    StimuliFolder='./utilities/MNRead_sentences/ChartC/'; %to be updated! AS now updated.
elseif expDay==4
    StimuliFolder='./utilities/MNRead_sentences/ChartD/'; %to be updated! AS now updated.
elseif expDay==5
    StimuliFolder='./utilities/MNRead_sentences/ChartB/'; %to be updated! AS now updated.
end
    thesentences=dir([StimuliFolder '*sentenc*']);
   
    conversionfactor=2.5313; %2.2730
    
    
    for fg=1:length(thesentences)
        inputImage=imread([StimuliFolder thesentences(fg).name]);
        inputImage=inputImage(:,:,1);
        inputImage=inputImage(300:1050, 300:2200);
        round([sizes(fg)*pix_deg (sizes(fg)/conversionfactor)*pix_deg]);
        nrr=round(sizes(fg)*pix_deg);
        nrc=round((sizes(fg)/conversionfactor)*pix_deg);
        inputImage=imresize(inputImage,[nrc nrr],'bicubic');
        TheSentence(fg)=Screen('MakeTexture', w, inputImage);
    end
    
    