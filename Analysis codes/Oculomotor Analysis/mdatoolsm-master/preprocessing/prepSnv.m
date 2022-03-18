classdef prepSnv < prepItem
   
   properties (SetAccess = private)
      name = 'snv';
      fullName = 'Standard Normal Variate';      
   end
   
   methods
      function obj = prepSnv(varargin)
         obj = obj@prepItem(varargin{:});
      end 
      
      function out = apply(obj, values, excludedRows, excludedCols)
         
         % for calculation parameters of preprocessing 
         % we do not take into account excluded rows (objects)
         % but do it for excluded columns

         means = mean(values, 2);
         stds = std(values, 0, 2);
         values = bsxfun(@minus, values', means');
         
         ind = stds < 0.001;
         if any(ind)
            out = zeros(size(values'));
            out(~ind, :) = bsxfun(@rdivide, values(:, ~ind), stds(~ind)')';
         else
            out = bsxfun(@rdivide, values, stds')';
         end
       end   
   end   
end   