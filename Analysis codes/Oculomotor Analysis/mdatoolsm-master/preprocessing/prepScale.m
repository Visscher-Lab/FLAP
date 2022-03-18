classdef prepScale < prepItem
   properties (SetAccess = private)
      name = 'scale';
      fullName = 'standardization';      
   end
   
   methods
      function obj = prepScale(varargin)
         obj = obj@prepItem(varargin{:});
      end 
      
      function out = apply(obj, values, excludedRows, excludedCols)
         
         % for calculation parameters of preprocessing 
         % we do not take into account excluded rows (objects)
         % but do it for excluded columns
         
         if isempty(obj.values)
            stds = std(values(~excludedRows, :));            
            obj.values = {stds};
         else
            stds = obj.values{1};
         end
         
         if any(stds < 0.001)
            warning('Some standard deviation values are too small and will be ignored.');
            ind = stds < 0.001;
            out = zeros(size(values));
            out(:, ind) = values(:, ind);
            out(:, ~ind) = bsxfun(@rdivide, values(:, ~ind), stds(~ind));
         else   
            out = bsxfun(@rdivide, values, stds);
         end   
      end   
      
      function out = sweep(obj, values, excludedRows, excludedCols)
         if isempty(obj.values)
            out = values;
            return
         end
         
         stds = obj.values{1};
         
         out = bsxfun(@times, values, stds);
      end
       
   end   
end   