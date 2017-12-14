% This script listens for data generated during stimulus calibration
% and records it into a file for later use

% general setup stuff
try; cd(fileparts(mfilename('fullpath')));catch; end;
try;
    run ../../matlab/utilities/initPaths.m
catch
    msgbox({'Please change to the directory where this file is saved before running the rest of this code'},'Change directory');
end

buffhost='localhost';buffport=1972;
% wait for the buffer to return valid header information
hdr=[];
while ( isempty(hdr) || ~isstruct(hdr) || (hdr.nchans==0) ) % wait for the buffer to contain valid data
    try
        hdr=buffer('get_hdr',[],buffhost,buffport);
    catch
        hdr=[];
        fprintf('Invalid header info... waiting.\n');
    end;
    pause(1);
end;

% P300 occurs 250 to 500 MS after odball --> use a
% conservative estimate and record this much data whenever the
% target is shown
imDuration=750;

% the initial state
state=[];

baselineData = struct.empty();
baselineEvents = struct.empty();

dataMap = containers.Map;
eventMap = containers.Map;
% loop till the calibration phase ends
endFeedback = false;
while(~endFeedback)
    [data,devents,state]=buffer_waitData(buffhost,buffport,state,'startSet',{{'stimulus.target','stimulus.baseline'}},'trlen_ms',imDuration,'exitSet',{'data' {'stimulus.training'} 'end'});
    
    for ei=1:numel(devents)
        % end of the calibration phase
        if (matchEvents(devents(ei),'stimulus.training','end'))
            endFeedback = true;
            % a baseline to add to the list of baselines
        elseif (matchEvents(devents(ei),{'stimulus.baseline'}))
            % only record start events here, not end events
            if(strcmp(devents(ei).value,'start'))
                baselineData = horzcat(baselineData, data(ei));
                baselineEvents = horzcat(baselineEvents, devents(ei));
            end
        elseif (matchEvents(devents(ei),{'stimulus.target'}))
            type = devents(ei).value;
            % check if we've already observed this type
            if(~dataMap.isKey(type))
                dataMap(type) = struct.empty();
            end
            storedData = dataMap(type);
            storedData = horzcat(storedData, data(ei));
            remove(dataMap,type);
            dataMap(type) = storedData;
            
            
            % same logic here
            % TODO streamline this
            if(~eventMap.isKey(type))
                % TODO find out if this works
                eventMap(type) = struct.empty();
            end
            storedEvent = eventMap(type);
            storedEvent = horzcat(storedEvent, devents(ei));
            remove(eventMap,type);
            eventMap(type) = storedEvent;
        end
    end
end
performances = zeros(1,length(dataMap));
classifiers = struct.empty(1,length(dataMap));
% finally, store all the data
k = keys(dataMap);
val = values(dataMap);
val2 = values(eventMap);
for i = 1:length(dataMap)
    % concatenate baseline with data for this condition
    outputData = horzcat(val{1,i}, baselineData);
    outputEvents = horzcat(val2{1,i}, baselineEvents);
    name = strcat(k{i},'.mat');
    [clsfr,res,X,Y]=buffer_train_ersp_clsfr(outputData,outputEvents,hdr,'visualize',0);
    classifiers(i) = clsfr;
    performances(i) = res.opt.tst;
    %save(name,'outputData','outputEvents');
end

[x,i] = max(performances)
bestClassifier = classifiers(i);
name = strcat(k{i},'.mat');
save(name,'bestClassifier');



