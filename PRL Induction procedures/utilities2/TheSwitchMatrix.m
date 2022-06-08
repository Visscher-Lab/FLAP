position_to_switch=6;
number_of_hold_trials=6;
number_of_repetition_matrix=1;

a=fullfact([position_to_switch number_of_hold_trials]);
a(1:number_of_hold_trials,2)=3;
a(number_of_hold_trials+1:2*number_of_hold_trials,2)=4;
a(2*number_of_hold_trials+1:3*number_of_hold_trials,2)=5;
a(3*number_of_hold_trials+1:4*number_of_hold_trials,2)=6;
a(4*number_of_hold_trials+1:5*number_of_hold_trials,2)=7;
a(5*number_of_hold_trials+1:6*number_of_hold_trials,2)=8;

d=fullfact([ 3 3]);
c=d(:,1)==d(:,2);
f=d(~c,:)
doh=[f(a(1:36),:) a(:,2)];

randum=randi(length(doh));
newmatrix=doh(randum,:,:);

tot_trial=sum(doh(:,3));
lastblock=3;
g2=doh;
mixtr=[];
finder=10000;
counteromval=0;
for q=1:number_of_repetition_matrix
    for fff=1:length(doh)
        for ww=1:newmatrix(1,3)
            pp=newmatrix(:,1:2)
            if numel(finder)>0 & finder==0 | isempty(finder)==1
                mixtr=[pp; mixtr];
            else
                mixtr=[mixtr; pp];
            end
        end
        if fff<length(doh)
            re=find(g2(:,1)==newmatrix(1,1) & g2(:,2)==newmatrix(1,2) & g2(:,3)==newmatrix(1,3));
            re=re(1);
            g2(re,:)=[];
            nextbin=newmatrix(1,2)

            a=find(g2(:,1)==nextbin)
            if isempty(a)
                finder=mixtr(1,1)
                newmatrix2=finder
                a=find(g2(:,2)==finder)
                newmatrix=g2(a,:)
            else
                finder=g2(:,1)==nextbin
                newmatrix2=randi(length(find(finder)))
                newmatrix=g2(a(newmatrix2),:)
            end
        end
    end
end

rrr=mixtr(end,2)
for dr=1:lastblock
    ppp=[rrr, 1]
    mixtr=[mixtr; ppp]
end

rep=length(find(doh(:,1)==3));
ori=[1 2 3 4];
orientarray=[]
for i=1:rep/length(ori)
    a=randperm(length(ori))
    orientarray=[orientarray a]
end
trialmatrix=[mixtr zeros(length(mixtr),1)];
cntr1=0;
cntr2=0;
cntr3=0;
for do=2:length(mixtr)
    if    mixtr(do,1)==1 & mixtr(do-1,1)~=1
        cntr1=cntr1+1
        trialmatrix(do,3)=orientarray(cntr1)
    end
    if    mixtr(do,1)==2 & mixtr(do-1,1)~=2
        cntr2=cntr2+1
        trialmatrix(do,3)=orientarray(cntr2)
    end
    if    mixtr(do,1)==3 & mixtr(do-1,1)~=3
        cntr3=cntr3+1
        trialmatrix(do,3)=orientarray(cntr3)
    end

end
for do=2:length(mixtr)
    if    mixtr(do,1)==mixtr(do-1,1)
        trialmatrix(do,3)=randi(4);

    end
end

trialmatrix(1,3)=randi(4);
      
        mixtr2=mixtr;
        
        
        
mixtr=[mixtr2(:,1), ones(length(mixtr2),1)]
        
      
        response=zeros(length(mixtr),2)-1; %intialize response matrix with -1