classdef BanditPresentation < PresentationMethod
   properties
       sequenceList
       idx = 0;
       policy;
   end
   methods
      % constructor
      function gobj = BanditPresentation(nTypes, nTrials,policy)
         if nargin > 0
            gobj.nTypes = nTypes;
            if nargin > 1
                gobj.nTrials = nTrials;
            end
         % store the policy to be used here
         gobj.policy = policy;
         
         % initialize the policy
         gobj.policy.init(nTypes,nTrials);
         end
      end
      
     % core sampling loop 
     function gobj = getNextType(obj)
         % if we're still allowed to sample further
         if obj.idx < obj.nTrials
            obj.idx = obj.idx + 1;
            % get the next action
            action = obj.policy.decision();
            activity = zeros(obj.nTypes,1);
            activity(action) = 1;
           
            gobj = activity;
         else
            gobj = NaN;     
         end
     end     
     % update based on the observed reward
     function update(obj,rewardObserved)
         obj.policy.getReward(rewardObserved);
     end
   end
   
   
end