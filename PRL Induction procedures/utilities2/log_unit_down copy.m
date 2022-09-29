% function caclola range log unit

function contr_array = log_unit_down(modulation, lu_step, len)

% Calculate an array of Michelson Contrasts in step of n log units
% from the initial contrast value 
%
% usage: 

% if ....
%         controlla zero
% end;

incr = 10^lu_step;
contr_array = modulation ./ incr.^[1:len];

return;