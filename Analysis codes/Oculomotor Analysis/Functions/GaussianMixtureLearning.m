function   [new_means,new_converiances,new_P,log_p_self,liklihood] = GaussianMixtureLearning(x,means,converiances,k,r)
keepLooping = true;
MaxIteration = 100;
logliklihoodThreshold = 10e-9;
logliklihoodThresNew = 0;
logliklihoodThresOld = 0;
count = 0;
liklihood(1:k)=1/k;
log_p_self=[];

%%
    log_p= ComputeLogLiklihood(x,means,converiances,liklihood);
    logliklihoodThresNew = log_p;
    log_p_self=[log_p_self log_p];

%%
converiancess = converiances;
meanss = means;
while keepLooping
    display('Keep looping');
    r
    count = count+1;
    i=count
     logliklihoodThresOld = logliklihoodThresNew;
    
    P = E_Step(x,liklihood,meanss,converiancess);
    
    
    
    meanss_1=meanss;
    [meanss,converiancess,liklihood,log_p]=M_Step(P,x,meanss_1);
   
    logliklihoodThresNew = log_p;
    log_p_self=[log_p_self log_p];
    val = abs((logliklihoodThresNew - logliklihoodThresOld)/logliklihoodThresOld);
    if(count >= MaxIteration || val<logliklihoodThreshold)
        keepLooping = false;
    end
  
end
new_means = meanss;
new_converiances = {converiances,converiancess};
new_P = P;
end