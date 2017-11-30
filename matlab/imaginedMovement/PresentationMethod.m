classdef PresentationMethod < handle
    
properties
   nTypes
   nTrials
end
    
methods (Abstract)
   getNextType(obj)
   getClassifierForBestType(obj)
end

end