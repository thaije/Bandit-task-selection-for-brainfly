classdef BanditPresentation < PresentationMethod
   properties
       sequenceList
       idx = 0;
   end
   methods
      % constructor
      function gobj = BanditPresentation(nTypes, nTrials)
         if nargin > 0
            gobj.nTypes = nTypes;
            if nargin > 1
                gobj.nTrials = nTrials;
                tgtSeq = [];
                % replace this by a function
                tgtSeq = mkStimSeqRand(nTypes,nTrials);
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
      
     function gobj = getClassifierForBestType(~)
         gobj.laal = 1;
     end
   end
   
   
end