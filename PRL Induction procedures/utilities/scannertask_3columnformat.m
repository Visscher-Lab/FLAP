%this script was written by Pinar Demirayak in March 2023 to create FSL
%formatted 3 cloumn design files from the actual experiment
stim_present=StimulusOnsetTime-startTime;
for z=1:5
    b=activeblocktype(runnumber,z);
    if b==1 %gabors
        if exist('gabor_analysis_matrix')==1
            for zz=17:32
                zzz=zz-16;
                gabor_analysis_matrix(zz,1)=stim_present(z,zzz);
                gabor_analysis_matrix(zz,2)=0.200;
                gabor_analysis_matrix(zz,3)=1;
            end
        else
            for zz=1:16
                gabor_analysis_matrix(zz,1)=stim_present(z,zz);
                gabor_analysis_matrix(zz,2)=0.200;
                gabor_analysis_matrix(zz,3)=1;
            end
        end
    elseif b==2 %eggs
        for zz=1:16
            eggs_analysis_matrix(zz,1)=stim_present(z,zz);
            eggs_analysis_matrix(zz,2)=0.200;
            eggs_analysis_matrix(zz,3)=1;
        end
    elseif b==3 %b/d
        for zz=1:16
            bd_analysis_matrix(zz,1)=stim_present(z,zz);
            bd_analysis_matrix(zz,2)=0.200;
            bd_analysis_matrix(zz,3)=1;
        end
    end
end
base=[SUBJECT '_FLAP_Scanner_PrePost' num2str(prepost) '_RunNum' num2str(runnumber) '_' TimeStart];
writematrix(gabor_analysis_matrix,[base '_gabor_3columnformat.txt'],'Delimiter','\t');
writematrix(eggs_analysis_matrix,[base '_eggs_3columnformat.txt'],'Delimiter','\t');
writematrix(bd_analysis_matrix,[base '_bd_3columnformat.txt'],'Delimiter','\t');
movefile([base '_gabor_3columnformat.txt'], './data/');
movefile([base '_eggs_3columnformat.txt'], './data/');
movefile([base '_bd_3columnformat.txt'], './data/');