
% What does this script do?
%
% This script runs the stimulus presentation for the practice / calibration
% phase. It uses some configuration parameters from
% /matlab/brainfly/configureGame.m.
% The biggest difference with the default imCalibrateStimulus.m is that
% this script works with images for each movement type. Also can two
% approaches be chosen, the uniform approach (sequential trials) or
% multi-armed bandit approach (random trials).


% auto-configure if not done?
%if ( ~exist('preConfigured','var') || ~isequal(preConfigured,true) ) configureIM; end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stimulus sequence
if(~exist('selectedApproach') & ~selectedApproach)
    error('selectedApproach does not exist, please do not run directly')  
%%%%%%%%%%%%%
% Multi-armed bandit approach
% Make the random target sequence (multi-armed bandit approach)
elseif(strcmp(selectedApproach,'bandit'))
%     tgtSeq=mkStimSeqRand(nSymbs,nSeq);
    % select UCB policy here
    presMode = BanditPresentation(nSymbs,nSeq,policyUCB()); 

%%%%%%%%%%%%%
% Uniform approach
% E.g. if we have 4 movements, and 80 trials. Then create an array af length
% 4x80 where each movement is done (80/4=) 20 trials sequentually.
elseif(strcmp(selectedApproach,'uniform'))
    presMode = UniformPresentation(nSymbs,nSeq); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% make the stimulus
%figure;
fig=figure(2);
set(fig,'Name','Stimulus Display','color',winColor,'menubar','none','toolbar','none','doublebuffer','on');
set(fig,'Units','pixel');wSize=get(fig,'position');set(fig,'units','normalized');% win size in pixels
clf;
ax=axes('position',[0.025 0.025 .95 .95],'units','normalized','visible','off','box','off',...
    'xtick',[],'xticklabelmode','manual','ytick',[],'yticklabelmode','manual',...
    'color',winColor,'DrawMode','fast','nextplot','replacechildren',...
    'xlim',axLim,'ylim',axLim,'Ydir','normal');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read in files
[feetBgX, feetBgMap] = imread('../brainfly/img/feetBG.jpg');
[feetFgX, feetFgMap] = imread('../brainfly/img/feet.jpg');
[tongueBgX, tongueBgMap] = imread('../brainfly/img/tongueBG.png');
[tongueFgX, tongueFgMap] = imread('../brainfly/img/tongue.png');
[lefthandBgX, lefthandBgMap] = imread('../brainfly/img/lefthandBG.jpg');
[lefthandFgX, lefthandFgMap] = imread('../brainfly/img/lefthand.jpg');
[righthandBgX, righthandBgMap] = imread('../brainfly/img/righthandBG.jpg');
[righthandFgX, righthandFgMap] = imread('../brainfly/img/righthand.jpg');

% get current axis and shove to bottom of UI stack
uiAxes = gca;
uistack(uiAxes,'bottom');
haPos = get(uiAxes,'position');

% Code below creates a new axis object, which can contain objects such
% as an image. Each image needs its own axis object as otherwise it will
% clash with other images or other text objects etc in the axis object.
%
% % create new axis and load image into it. X-axis = [0,1] y-axis = [0,1]
% RighthandAxes=axes('position',[0.75, 0.35, 0.25, 0.3,]);
% image(righthandX);
% colormap(righthandMap);
%
% set(RighthandAxes,'handlevisibility','off','visible','off');
% righthandObject = get(RighthandAxes,'children');
% % hide image
% % set(righthandObject,'visible','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feet
% create new axis and load image into it. X-axis = [0,1] y-axis = [0,1]
FeetAxesBG=axes('position',[0.4, 0, 0.20, 0.3,]);
image(feetBgX);
set(FeetAxesBG,'handlevisibility','off','visible','off');

% Overlay foreground image, but hide it
FeetAxesFG=axes('position',[0.4, 0, 0.20, 0.3,]);
image(feetFgX);
set(FeetAxesFG,'handlevisibility','off','visible','off');
feetFG = get(FeetAxesFG,'children');
set(feetFG,'visible','off') % hide image

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tongue
% create new axis and background load image into it. X-axis = [0,1] y-axis = [0,1]
TongueAxesBG=axes('position',[0.375, 0.75, 0.25, 0.25,]);
image(tongueBgX);
set(TongueAxesBG,'handlevisibility','off','visible','off');

% Overlay foreground image, but hide it
TongueAxesFG=axes('position',[0.375, 0.75, 0.25, 0.25,]);
image(tongueFgX);
set(TongueAxesFG,'handlevisibility','off','visible','off');
tongueFG = get(TongueAxesFG,'children');
set(tongueFG,'visible','off') % hide image

%%%%%%%%%%%%%%%%%%%%%%
% Lefthand
% create new axis and load image into it. X-axis = [0,1] y-axis = [0,1]
LefthandAxesBG=axes('position',[0, 0.35, 0.25, 0.3,]);
image(lefthandBgX);
set(LefthandAxesBG,'handlevisibility','off','visible','off');

% Overlay foreground image, but hide it
LefthandAxesFG=axes('position',[0, 0.35, 0.25, 0.3,]);
image(lefthandFgX);
set(LefthandAxesFG,'handlevisibility','off','visible','off');
lefthandFG = get(LefthandAxesFG,'children');
set(lefthandFG,'visible','off') % hide image

%%%%%%
% Righthand
% create new axis and load image into it. X-axis = [0,1] y-axis = [0,1]
RighthandAxesBG=axes('position',[0.75, 0.35, 0.25, 0.3,]);
image(righthandBgX);
set(RighthandAxesBG,'handlevisibility','off','visible','off');

% Overlay foreground image, but hide it
RighthandAxesFG=axes('position',[0.75, 0.35, 0.25, 0.3,]);
image(righthandFgX);
set(RighthandAxesFG,'handlevisibility','off','visible','off');
righthandFG = get(RighthandAxesFG,'children');
set(righthandFG,'visible','off') % hide image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% put all our foreground limb target images in an array, order has to correspond to
% symbCue in brainfly/configureGame.m
tgtLimbImgs = [righthandFG, tongueFG, lefthandFG, feetFG];


drawnow;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize UI objects (texts and dot in middle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stimPos=[]; h=[]; htxt=[];
stimRadius=diff(axLim)/4;
cursorSize=stimRadius/2;

% add symbol for the center of the screen
stimPos(:,1)=[0 0];
h(1)=rectangle('curvature',[1 1],'position',[stimPos(:,1)-cursorSize/2;cursorSize*[1;1]],...
    'facecolor',bgColor);
set(gca,'visible','off');

%Create a text object with no text in it, center it, set font and color
txthdl = text(mean(get(ax,'xlim')),mean(get(ax,'ylim')),' ',...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',...
    'fontunits','pixel','fontsize',.05*wSize(4),...
    'color',txtColor,'visible','off');

% text object for the experiment progress bar
progresshdl=text(axLim(1),axLim(2),sprintf('%2d/%2d',0,nSeq),...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top',...
    'fontunits','pixel','fontsize',.05*wSize(4),...
    'color',txtColor,'visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start of the stimulus presentation loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% play the stimulus
% reset the cue and fixation point to indicate trial has finished
set(h(:),'facecolor',bgColor);
sendEvent('stimulus.training','start');

% wait for user to be ready before starting everything
set(txthdl,'string', {calibrate_instruct{:} '' 'Click mouse when ready'}, 'visible', 'on'); drawnow;
% waitforbuttonpress;
set(txthdl,'visible', 'off'); drawnow; sleepSec(intertrialDuration);

state = [];
waitforkeyTime=getwTime()+calibrateMaxSeqDuration;
for si=1:nSeq;
    
    if ( ~ishandle(fig) ) break; end;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Break time
    % Give user a break if too much time has passed
    if ( getwTime() > waitforkeyTime )
        set(txthdl,'string', {'Break between blocks.' 'Click mouse when ready to continue.'}, 'visible', 'on');
        drawnow;
        waitforbuttonpress;
        set(txthdl,'visible', 'off');
        drawnow;
        waitforkeyTime=getwTime()+calibrateMaxSeqDuration;
        if ( 1.5*calibrateMaxSeqDuration > ...  % close to end of expt = don't wait again
                (nSeq-si)*(baselineDuration+trialDuration+intertrialDuration) )
            waitforkeyTime=inf;
        end
        sleepSec(intertrialDuration);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get baseline signal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % show the screen to alert the subject to trial start
    set(h(1),'facecolor',fixColor); % red fixation indicates trial about to start/baseline
    drawnow;% expose; % N.B. needs a full drawnow for some reason
    ev=sendEvent('stimulus.baseline','start');
    for ei=1:ceil(baselineDuration./epochDuration);  % loop over sub-trials in this phase
        if ( ~isempty(baselineClass) ) % treat baseline as a special class
            sendEvent('stimulus.target',baselineClass);
        end
        if ( animateFix )
            animateDuration=epochDuration;
            t0  =getwTime();
            timetogo=animateDuration;
            fixPos=[stimPos(:,1)-cursorSize/2;cursorSize*[1;1]];
            while ( timetogo > 0 )
                dx=randn(2,1)*animateStep;
                fixPos(1:2) = fixPos(1:2)+dx;
                set(h(1),'position',fixPos);
                drawnow;
                sleepSec(min(max(0,timetogo),frameDuration));
                timetogo = animateDuration- (getwTime()-t0); % time left to run in this trial
            end
        else
            sleepSec(epochDuration);
        end
    end
    sendEvent('stimulus.baseline','end');
    if ( animateFix )										  % reset fix pos
        set(h(1),'position',[stimPos(:,1)-cursorSize/2;cursorSize*[1;1]]);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Show the target cue
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % show the target / show the foreground image
    tgtIdx=find(presMode.getNextType()>0);
    set(tgtLimbImgs(tgtIdx),'visible','on');
    
    % ***WARNING*** Automatically adds position number to the target name!!
    if ( ~isempty(symbCue) )
        set(txthdl,'string',sprintf('%s ',symbCue{tgtIdx}),'color',txtColor,'visible','on');
        tgtNm = '';
        for ti=1:numel(tgtIdx);
            if(ti>1) tgtNm=[tgtNm ' + ']; end;
            tgtNm=sprintf('%s%d %s',tgtNm,tgtIdx,symbCue{tgtIdx});
        end
    else
        tgtNm = tgtIdx; % human-name is position number
    end
    set(h(1),'facecolor',tgtColor); % green fixation indicates trial running
    fprintf('%d) tgt=%10s : ',si,tgtNm);
    sendEvent('stimulus.trial','start');
    for ei=1:ceil(trialDuration./epochDuration);
        sendEvent('stimulus.target',tgtNm);
        if ( animateFix )
            animateDuration=epochDuration;
            t0  =getwTime();
            timetogo=animateDuration;
            fixPos=[stimPos(:,1)-cursorSize/2;cursorSize*[1;1]];
            while ( timetogo > 0 )
                dx=randn(2,1)*animateStep;
                fixPos(1:2) = fixPos(1:2)+dx;
                set(h(1),'position',fixPos);
                drawnow;
                sleepSec(min(max(0,timetogo),frameDuration));
                timetogo = animateDuration- (getwTime()-t0); % time left to run in this trial
            end
            % reset fix pos
            set(h(1),'position',[stimPos(:,1)-cursorSize/2;cursorSize*[1;1]]);
        else
            drawnow;% expose; % N.B. needs a full drawnow for some reason
            % wait for trial end
            sleepSec(epochDuration);
        end
    end
    
    if(strcmp(selectedApproach,'bandit'))
        % signal the buffer to send an estimate
        sendEvent('stimulus.estimate',tgtNm);
        
        % update the sampling method with the observed reward
        name = strcat(tgtNm,'.estimate');
        [events,state]=buffer_newevents(buffhost,buffport,state,name,[],10000);
        estimate = events(1).value;
        presMode.update(estimate)
    end
    if ( animateFix )										  % reset fix pos
        set(h(1),'position',[stimPos(:,1)-cursorSize/2;cursorSize*[1;1]]);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Reset the UI, and save the post-cue data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % reset the cue and fixation point to indicate trial has finished
    set(tgtLimbImgs(tgtIdx),'visible','off');
    % update progress bar
    set(progresshdl,'string',sprintf('%2d/%2d',si,nSeq));
    % wait for the inter-trial
    set(h(:),'facecolor',bgColor);
    if ( ~isempty(symbCue) ) set(txthdl,'visible','off'); end
    drawnow;
    ev=sendEvent('stimulus.trial','end');
    if (~isempty(rtbClass) ) % treat post-trial return-to-baseline as a special class
        for ei=1:ceil(intertrialDuration/epochDuration); % loop over sub-trials
            if ( ischar(rtbClass) && strcmp(rtbClass,'trialClass') ) % label as part of the trial
                sendEvent('stimulus.target',tgtNm,ev.sample);
            elseif ( ischar(rtbClass) && strcmp(rtbClass,'trialClass+rtb')) %return-to-base ver of trial class
                sendEvent('stimulus.target',[tgtNm '_rtb'],ev.sample);
            else
                sendEvent('stimulus.target',rtbClass,ev.sample);
            end
            sleepSec(epochDuration);
        end
    else
        sleepSec(intertrialDuration);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ftime=getwTime();
    fprintf('\n');
end % sequences
% end training marker
sendEvent('stimulus.training','end');

if ( ishandle(fig) ) % thanks message
    set(txthdl,'string',{'That ends the training phase.','Thanks for your patience'}, 'visible', 'on', 'color',[0 1 0]);
    pause(3);
end
