

%switch cost analysis



for ww=1:length(mixtr)
mixtr(ww,1)

end


switch_cost_array_PRL_to_NoPRL=[]
switch_cost_array_PRL_to_ThirdPos=[]

switch_cost_array_NoPRL_to_PRL=[]
switch_cost_array_NoPRL_to_ThirdPos=[]


switch_cost_array_ThirdPos_to_PRL=[]
switch_cost_array_ThirdPos_to_NoPRL=[]

for do=2:length(mixtr)
    if    mixtr(do,1)==2 & mixtr(do-1,1)==1
        
       
        switch_cost_array_PRL_to_NoPRL=[]

    end
    if    mixtr(do,1)==3 & mixtr(do-1,1)==1
switch_cost_array_PRL_to_ThirdPos=[]

    end
    if    mixtr(do,1)==1 & mixtr(do-1,1)==2

switch_cost_array_NoPRL_to_PRL
    end
    
    if mixtr(do,1)==1 & mixtr(do-1,1)==2