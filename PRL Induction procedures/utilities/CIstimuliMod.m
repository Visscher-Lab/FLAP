            %jittering location of the target within the patch of distractors
            
            if jitterCI==1
                jitterxci(trial)=possibleoffset(randi(length(possibleoffset)));
                jitteryci(trial)=possibleoffset(randi(length(possibleoffset)));
                
            elseif jitterCI==0
                jitterxci(trial)=0;
                jitteryci(trial)=0;
            end
            
            % here I define the shapes
            
            newTargy=Targy{shapesoftheDay(mixtr(trial,1))}+jitteryci(trial);
            newTargx=Targx{shapesoftheDay(mixtr(trial,1))}+jitterxci(trial);
            
            targetcord =newTargy(theans(trial),:)+yTrans  + (newTargx(theans(trial),:)+xTrans - 1)*ymax;


            xJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat; %plus or minus .25 deg
            yJitLoc=pix_deg*(rand(1,length(eccentricity_XCI))-.5)/JitRat;
            
            xModLoc=zeros(1,length(eccentricity_XCI));
            yModLoc=zeros(1,length(eccentricity_XCI));

            
            % here I adjust the offset of distractors to avoid cluttering the CI shape
            
            for i=1:length(xJitLoc)
                if sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
                    %1 down right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    newyJitLoc(i)=abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=1;
                elseif sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
                    %2 up left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=2;
                elseif sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
                    %3 up
                    newyJitLoc(i)=abs(yJitLoc(i))*5;
                    replacementcounterx(i)=3;
                    
                elseif sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
                    %4 down
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    replacementcounterx(i)=4;
                    
                elseif sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
                    %5 right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    replacementcounterx(i)=5;
                    
                elseif sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
                    %6 left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    replacementcounterx(i)=6;
                    
                elseif sum((xlocsCI(i)-xlocsCI(targetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
                    %7 up right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=7;
                elseif sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
                    %8 down left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    newyJitLoc(i)= abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=8;
                    
                else
                    newxJitLoc(i)=xJitLoc(i);
                    newyJitLoc(i)=yJitLoc(i);
                    
                    replacementcounterx(i)=99;
                end
            end
            
            
         
            yJitLoc=newyJitLoc;
            xJitLoc=newxJitLoc;
            
            
            xJitLoc(xJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
            xJitLoc(xJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
            yJitLoc(yJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
            yJitLoc(yJitLoc< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
            %sum(replacementcounterx~=99)
            
            xJitLoc(targetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/coeffCI;%+xJitLoc(targetcord);
            yJitLoc(targetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(theans(trial),:))/coeffCI;%+xJitLoc(targetcord);
            theori=180*rand(1,length(eccentricity_XCI));
            
            theori(targetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(theans(trial),:) +Orijit;
            
            if test==1
                theori(targetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(theans(trial),:);
            end
            
            
            %this is for the instructions
            
                        examplenewTargy=Targy{shapesoftheDay(mixtr(trial,1))};
            examplenewTargx=Targx{shapesoftheDay(mixtr(trial,1))};

            exampletargetcord =examplenewTargy(1,:)+yTrans  + (examplenewTargx(1,:)+xTrans - 1)*ymax;
            exampletargetcord2 =examplenewTargy(2,:)+yTrans  + (examplenewTargx(2,:)+xTrans - 1)*ymax;
            
            
            
                     % here I adjust the offset of distractors to avoid
                     % cluttering the CI shape (left stimulus example)
            
            for i=1:length(xJitLoc)
                if sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
                    %1 down right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    newyJitLoc(i)=abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=1;
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
                    %2 up left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=2;
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
                    %3 up
                    newyJitLoc(i)=abs(yJitLoc(i))*5;
                    replacementcounterx(i)=3;
                    
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
                    %4 down
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    replacementcounterx(i)=4;
                    
                elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
                    %5 right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    replacementcounterx(i)=5;
                    
                elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
                    %6 left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    replacementcounterx(i)=6;
                    
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
                    %7 up right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=7;
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
                    %8 down left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    newyJitLoc(i)= abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=8;
                    
                else
                    newxJitLoc(i)=xJitLoc(i);
                    newyJitLoc(i)=yJitLoc(i);
                    
                    replacementcounterx(i)=99;
                end
            end
    
            exampleyJitLoc=newyJitLoc;
            examplexJitLoc=newxJitLoc;
            
                        clear newyJitLoc newxJitLoc

            
                       for i=1:length(xJitLoc)
                if sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
                    %1 down right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    newyJitLoc(i)=abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=1;
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
                    %2 up left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=2;
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
                    %3 up
                    newyJitLoc(i)=abs(yJitLoc(i))*5;
                    replacementcounterx(i)=3;
                    
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==0)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==0)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-1)>0
                    %4 down
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    replacementcounterx(i)=4;
                    
                elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
                    %5 right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    replacementcounterx(i)=5;
                    
                elseif sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==0)>0 && sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 %|| sum((ylocsCI(i)-ylocsCI(targetcord))==0)>0 && sum((xlocsCI(i)-xlocsCI(targetcord))==-1)>0
                    %6 left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    replacementcounterx(i)=6;
                    
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==-1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==-2)>0
                    %7 up right
                    newxJitLoc(i)=abs(xJitLoc(i))*5;
                    newyJitLoc(i)=- abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=7;
                elseif sum((xlocsCI(i)-xlocsCI(exampletargetcord2))==-1)>0 && sum((ylocsCI(i)-ylocsCI(exampletargetcord2))==1)>0 %|| sum((xlocsCI(i)-xlocsCI(targetcord))==-2)>0 && sum((ylocsCI(i)-ylocsCI(targetcord))==2)>0
                    %8 down left
                    newxJitLoc(i)=- abs(xJitLoc(i))*5;
                    newyJitLoc(i)= abs(yJitLoc(i))*5;
                    
                    replacementcounterx(i)=8;
                    
                else
                    newxJitLoc(i)=xJitLoc(i);
                    newyJitLoc(i)=yJitLoc(i);
                    
                    replacementcounterx(i)=99;
                end
            end 
            
   
            exampleyJitLoc2=newyJitLoc;
            examplexJitLoc2=newxJitLoc;
            
            
               examplexJitLoc(examplexJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
            examplexJitLoc(examplexJitLoc< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
            exampleyJitLoc(exampleyJitLoc>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
            exampleyJitLoc(exampleyJitLoc< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3;
                       
               examplexJitLoc2(examplexJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
            examplexJitLoc2(examplexJitLoc2< - pix_deg/ecccoeffCI/3)=-pix_deg/ecccoeffCI/3;
            exampleyJitLoc2(exampleyJitLoc2>pix_deg/ecccoeffCI/3)=pix_deg/ecccoeffCI/3;
            exampleyJitLoc2(exampleyJitLoc2< - pix_deg/ecccoeffCI/3)=- pix_deg/ecccoeffCI/3; 
            
            examplexJitLoc(exampletargetcord)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(1,:))/coeffCI;%+xJitLoc(targetcord);
            exampleyJitLoc(exampletargetcord)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(1,:))/coeffCI;%+xJitLoc(targetcord);
            examplexJitLoc2(exampletargetcord2)=pix_deg*(offsetx{shapesoftheDay(mixtr(trial,1))}(2,:))/coeffCI;%+xJitLoc(targetcord);
            exampleyJitLoc2(exampletargetcord2)=pix_deg*(offsety{shapesoftheDay(mixtr(trial,1))}(2,:))/coeffCI;%+xJitLoc(targetcord);
            
            exampletheori=180*rand(1,length(eccentricity_XCI));
            exampletheori2=exampletheori;
            
            exampletheori(exampletargetcord)=Targori{shapesoftheDay(mixtr(trial,1))}(1,:);
            exampletheori2(exampletargetcord2)=Targori{shapesoftheDay(mixtr(trial,1))}(2,:);
            
            