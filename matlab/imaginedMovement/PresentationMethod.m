classdef PresentationMethod < handle
    
properties
   nTypes
   nTrials
end
    
methods (Abstract)
   getNextType(obj)
   update(obj,rewardObserved)
end

end