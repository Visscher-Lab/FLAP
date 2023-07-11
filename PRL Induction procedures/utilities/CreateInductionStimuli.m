%% create induction stimuli
    
    separation=round(separationdeg*pix_deg);
    
    totalstimulussize=separation+imsize*2;
    totalstimulussize=[totalstimulussize totalstimulussize]; %seems to not be used. saved in workspace? %it's just to keep track of the stimulus size 
    [x,y]=meshgrid(-imsize:imsize,-imsize:imsize);
    xylim = imsize; %radius of circular mask
    circle = x.^2 + y.^2 <= xylim^2;
    [nrw, ncl]=size(x);
    
    angles= [15 75 105 165 195 255 285 345];
    
    %negative= right;
    %positive= left;
 
    
    constrain = 1;
    
    theFolder = [cd '/utilities/'];

    theTargets_left={};
    theTargets_right={};
    a=size(theTargets_left);
    a=a(:,1);
    b=size(theTargets_right);
    b=b(:,1);
    i=1;
    lefty=0;
    righty=0;
    %Marcello -The section in this while loop appears to create the images used in the
    %trials. Does it do anything else? (creating the trials themselves,etc)
    %it creates the trials so that the number of responses left and right
    %are balanced. It does so by computing the overall angle to be biased
    %left or right
    while a<=trials || b<=trials
        
        a=size(theTargets_left);
        a=a(:,2);
        b=size(theTargets_right);
        b=b(:,2);
        
        pos_one(i)=angles(randi(length(angles)));
        if pos_one(i)>180
            computepos_one(i)=180-pos_one(i);
        else
            computepos_one(i)=pos_one(i);
            
        end
        if constrain == 1
            newangles=angles;
            newangles(find(newangles==pos_one(i)))=[];
            pos_two(i)=newangles(randi(length(newangles)));
            if pos_two(i)>180
                computepos_two(i)=180-pos_two(i);
            else
                computepos_two(i)=pos_two(i);
            end
            newangles(find(newangles==pos_two(i)))=[];
            pos_three(i)= newangles(randi(length(newangles)));
            if pos_three(i)>180
                computepos_three(i)=180-pos_three(i);
            else
                computepos_three(i)=pos_three(i);
            end
            newangles(find(newangles==pos_three(i)))=[];
            pos_four(i)= newangles(randi(length(newangles)));
            if pos_four(i)>180
                computepos_four(i)=180-pos_four(i);
            else
                computepos_four(i)=pos_four(i);
            end
            newangles(find(newangles==pos_four(i)))=[];
            
            if (computepos_one(i)+computepos_two(i)+computepos_three(i)+computepos_four(i)) == 0
                while (computepos_one(i)+computepos_two(i)+computepos_three(i)+computepos_four(i)) == 0
                    newangles=angles;
                    newangles(find(newangles==pos_one(i)))=[];
                    pos_two(i)=newangles(randi(length(newangles)));
                    if pos_two(i)>180
                        computepos_two(i)=180-pos_two(i);
                    else
                        computepos_two(i)=pos_two(i);
                    end
                    newangles(find(newangles==pos_two(i)))=[];
                    pos_three(i)= newangles(randi(length(newangles)));
                    if pos_three(i)>180
                        computepos_three(i)=180-pos_three(i);
                    else
                        computepos_three(i)=pos_three(i);
                    end
                    newangles(find(newangles==pos_three(i)))=[];
                    pos_four(i)= newangles(randi(length(newangles)));
                    if pos_four(i)>180
                        computepos_four(i)=180-pos_four(i);
                    else
                        computepos_four(i)=pos_four(i);
                    end
                    newangles(find(newangles==pos_four(i)))=[];
                    
                end
            end           
        elseif constrain == 0
            pos_two(i)=angles(randi(length(angles))) ;
            pos_three(i)= angles(randi(length(angles)));
            pos_four(i)= angles(randi(length(angles)));
            newangles=angles;
        end
        set_dist{i}=[pos_one(i) pos_two(i) pos_three(i) pos_four(i)];
        lesangles=[computepos_one(i) computepos_two(i) computepos_three(i) computepos_four(i)];
        thesetDist=set_dist{i};
               
        theLetter=imread([theFolder 'newletterc22.tiff']);
        theLetter=theLetter(:,:,1);
        theLetter=imresize(theLetter,[nrw nrw],'bicubic');
        theLetter=imrotate(theLetter,90);
                
        theLetter = double(circle) .* double(theLetter)+bg_index * ~double(circle);
        rotLetterone=imrotate(theLetter,thesetDist(1));
        rotLetterone(rotLetterone==0)=127;
        [rotrwi, rotcli]=size(rotLetterone);
        
        rotLettertwo=imrotate(theLetter,thesetDist(2));
        rotLettertwo(rotLettertwo==0)=127;
        [rotrwii, rotclii]=size(rotLettertwo);
        
        rotLetterthree=imrotate(theLetter,thesetDist(3));
        rotLetterthree(rotLetterthree==0)=127;
        [rotrwiii, rotcliii]=size(rotLetterthree);
        
        rotLetterfour=imrotate(theLetter,thesetDist(4));
        rotLetterfour(rotLetterfour==0)=127;
        [rotrwiv, rotcliv]=size(rotLetterfour);
        
        thesizes= [rotrwi rotrwii rotrwiii rotrwiv];
        
        thisize=max(thesizes);
        
        blankimage = ones(thisize,thisize)*bg_index;
        largerBlankimage=ones(thisize+separation,thisize+separation)*bg_index;
        
        border_two=round(((thisize+separation)-nrw)/2);
        border_one=border_two+1;
        
        [largrotrw, largrotcl]=size(largerBlankimage);
        
        largerrotLetterone=largerBlankimage;
        
        border_two_rot =round(largrotrw-rotrwi)/2;
        border_one_rot=border_two_rot+1;
        
        try
            largerrotLetterone(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
        end
        
        try
            largerrotLetterone(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterone(1:end,1:end);
        end
        
        try
            largerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
        end
        
        largerrotLettertwo=largerBlankimage;
        
        border_two_rot =round(largrotrw-rotrwii)/2;
        border_one_rot=border_two_rot+1;
        
        try
            largerrotLettertwo(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLettertwo(1:end,1:end);
        end
        
        try
            largerrotLettertwo(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLettertwo(1:end,1:end);
        end
        
        try
            largerrotLetterone(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterone(1:end,1:end);
        end
             
        largerrotLetterthree=largerBlankimage;
        
        border_two_rot =round(largrotrw-rotrwiii)/2;
        border_one_rot=border_two_rot+1;
        
        try
            largerrotLetterthree(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
        end
        
        try
            largerrotLetterthree(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterthree(1:end,1:end);
        end
        
        try
            largerrotLetterthree(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterthree(1:end,1:end);
        end
        
        largerrotLetterfour=largerBlankimage;
        
        border_two_rot =round(largrotrw-rotrwiv)/2;
        border_one_rot=border_two_rot+1;
        
        try
            largerrotLetterfour(border_one_rot:end-border_two_rot,border_one_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
        end
        
        try
            largerrotLetterfour(border_one_rot:end-border_one_rot,border_one_rot:end-border_one_rot)=rotLetterfour(1:end,1:end);
        end
        
        try
            largerrotLetterfour(border_two_rot:end-border_two_rot,border_two_rot:end-border_two_rot)=rotLetterfour(1:end,1:end);
        end
        
        clear largerimaj
        
        largerimaj(:,:,1)=largerrotLetterone;
        largerimaj(:,:,2)=largerrotLettertwo;
        largerimaj(:,:,3)=largerrotLetterthree;
        largerimaj(:,:,4)=largerrotLetterfour;
        largerout = imtile(largerimaj,'Frames', 1:4, 'GridSize', [2 2]);
        
        if (computepos_one(i)+computepos_two(i)+computepos_three(i)+computepos_four(i))> 0
            lefty=lefty+1;
            theTargets_left{lefty}=Screen('MakeTexture', w, largerout);
            coordleft{lefty}=thesetDist;
            lesanglesleft{lefty}=lesangles;
        elseif (computepos_one(i)+computepos_two(i)+computepos_three(i)+computepos_four(i))< 0
            righty=righty+1;
            theTargets_right{righty}=Screen('MakeTexture', w, largerout);
            coordright{righty}=thesetDist;
            lesanglesrighty{righty}=lesangles;
        end
        i=i+1;
        lowest=min(a,b);
        
        thephrase= ['Creating images - Please wait: ' num2str((lowest/(trials+1))*100) '%'];
        DrawFormattedText(w, thephrase, 'center', 'center', white);
        Screen('Flip', w);
        
    end
    
    