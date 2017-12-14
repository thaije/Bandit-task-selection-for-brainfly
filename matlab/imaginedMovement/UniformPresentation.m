classdef UniformPresentation < PresentationMethod
   properties
       sequenceList
       idx = 0;
   end
   methods
      % constructor
      function gobj = UniformPresentation(nTypes, nTrials)
         if nargin > 0
            gobj.nTypes = nTypes;
            if nargin > 1
                gobj.nTrials = nTrials;
                tgtSeq = [];
                % replace this by a function
                for symb=1:nTypes
                    temp = zeros(nTypes, nTrials/4);
                    temp(symb, :) = 1;
                    tgtSeq = cat(2,tgtSeq, temp);
                end
                gobj.sequenceList = tgtSeq;
            end
         end
      end
      
     function gobj = getNextType(obj)
         if obj.idx < obj.nTrials
            obj.idx = obj.idx + 1;
            gobj = obj.sequenceList(:,obj.idx);
         else
            gobj = NaN;     
         end
     end
     
     % no-op for this method
     function update(~,~)

     end 
   end
   
   
end