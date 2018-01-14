fig=figure(2);
set(fig,'Name','Stimulus Display','color',winColor,'menubar','none','toolbar','none','doublebuffer','on');
set(fig,'Units','pixel');wSize=get(fig,'position');set(fig,'units','normalized');% win size in pixels
clf;
ax=axes('position',[0.025 0.025 .95 .95],'units','normalized','visible','off','box','off',...
    'xtick',[],'xticklabelmode','manual','ytick',[],'yticklabelmode','manual',...
    'color',winColor,'DrawMode','fast','nextplot','replacechildren',...
    'xlim',[0 800],'ylim',[0 500],'Ydir','normal');


% axes(handles.layoutAxes);
r = rectangle('Position',[5 5 20 20], 'FaceColor',[0 .5 .5]);

% direction = [1 0 0];
% rotate(ax,direction,50);

t = hgtransform;
surf(peaks(40),'Parent',t)
view(-20,30)
axis manual