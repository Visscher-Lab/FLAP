

imageRectDotsCue = CenterRect([0, 0, dotsize*pix_deg dotsize*pix_deg], wRect);
cueoffsetpix= [0 -dotecc; dotecc 0; 0 dotecc; -dotecc 0]*pix_deg;
cueoffset=repmat(cueoffsetpix,4,1);
PRLlocspix=[0 -PRLecc; PRLecc 0; 0 PRLecc; -PRLecc 0 ]*pix_deg;
PRLlocs=repmat(PRLlocspix,4,1);
%  PRLeccentricity_X=PRLlocs(:,1);
%  PRLeccentricity_Y=PRLlocs(:,2);
PRLeccentricity=[repmat(PRLlocspix(1,:),4,1); repmat(PRLlocspix(2,:),4,1); repmat(PRLlocspix(3,:),4,1); repmat(PRLlocspix(4,:),4,1)];
PRLeccentricity_X=PRLeccentricity(:,1);
PRLeccentricity_Y=PRLeccentricity(:,2);
for i=1:length(PRLeccentricity_X)
    imageRect_offs_cue(i,:) =[imageRectDotsCue(1)+PRLeccentricity_X(i)+cueoffset(i,1), imageRectDotsCue(2)+PRLeccentricity_Y(i)+cueoffset(i,2),...
        imageRectDotsCue(3)+PRLeccentricity_X(i)+cueoffset(i,1), imageRectDotsCue(4)+PRLeccentricity_Y(i)+cueoffset(i,2)];
end


%Screen('DrawTextures',w, theDot, [], imageRect_offs_cue',0,[],1);
                Screen('FillOval', w, [0 0 0], imageRect_offs_cue');
