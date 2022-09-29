%Script to generate the trialmatrix for the Carrasco exo-endo attention task
%Marcello Maniglia August 2022
clear all
close all
clc
PRLlocations=4;

%%
d=fullfact([ PRLlocations PRLlocations]);
c=d(:,1)==d(:,2);
f=d(~c,:);
repetitions=20;
blocks=5;
alltrials=repmat(f,repetitions,1);
newalltrials=alltrials(randperm(length(alltrials)),:);


%endo
    for ui=1:blocks
randum=randi(length(newalltrials));
newmatrix=newalltrials(randum,:,:);
mixtr=[];
g2=newalltrials;
counteromval=1;
mixtr=newmatrix;
try
while length(mixtr)<length(alltrials)      
    re=find(g2(:,1)==newmatrix(1,2));
re=re(1);
    counteromval=counteromval+1;
mixtr(counteromval,:)=g2(re,:);
g2(re,:)=[];
newmatrix=mixtr(end,:);
end
end

tot{ui}=mixtr;
    end

%exo
    for ui=1:blocks

randum=randi(length(newalltrials));
newmatrix2=newalltrials(randum,:,:);

g2=newalltrials;
mixtr2=[];
counteromval=1;
mixtr2=newmatrix2;
try
while length(mixtr2)<length(alltrials)      
    re=find(g2(:,1)==newmatrix2(1,2));
re=re(1);
    counteromval=counteromval+1;
mixtr2(counteromval,:)=g2(re,:);
g2(re,:)=[];
newmatrix2=mixtr2(end,:);
end
end
tot2{ui}=mixtr2;
end


%left column: cue location
%right column: target location

% newmixtr=[mixtr(:,1) ones(length(mixtr(:,1)),1)];
% 
% newmixtr2=[mixtr2(:,1) ones(length(mixtr2(:,1)),1)*2];
totalmatrix=[newmixtr;newmixtr2];

%%

endotrials=[mixtr ones(length(mixtr),1)*2];
exotrials=[mixtr2 ones(length(mixtr2),1)];
totalmixtr=[endotrials; exotrials];
congruentIncongruentEndo=[ones(length(endotrials)*0.8,1); zeros(length(endotrials)*0.2,1)];
randcongruentIncongruentEndo=congruentIncongruentEndo(randperm(length(congruentIncongruentEndo)));
congruentIncongruentExo=[ones(length(exotrials)*0.5,1); zeros(length(exotrials)*0.5,1)];
randcongruentIncongruentExo=congruentIncongruentExo(randperm(length(congruentIncongruentExo)));

totalmixtr=[endotrials randcongruentIncongruentEndo; exotrials randcongruentIncongruentExo];



