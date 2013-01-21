function plotOrbit(List, xMeas, xMeasStd, xMeasF, en, varargin)
%BBA_PLOTORBIT
%  BBA_PLOTORBIT(List, XMEAS, XMEASSTD, XMEASF, EN, OPTS) .

% Features:

% Input arguments:
%    List: Struct of device lists
%    OPTS: Options stucture with fields (optional):
%        FIGURE: Figure handle
%        AXES: Axes handle
%        XLAB: Label for x-axis
%        UNITS: Units label for y-axis
%        SCALE: Scale factor for y-axis
%        STR: String to display in plot
%        XLIM, YLIM: Limits for x- and y-axis

% Output arguments: none

% Compatibility: Version 7 and higher
% Called functions: parseOptions

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Set default options.
optsdef=struct( ...
    'figure',1, ...
    'axes',{{2 1}}, ...
    'title','', ...
    'useBPMNoise',1, ...
    'bpmNoise',3, ... % um
    'nEnergy',3, ...
    'enRange',[4.3 13.64], ...
    'fitResult',[], ...
    'corrB',[], ...
    'R',[], ...
    'iVal',[], ...
    'init',1);

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

% Setup figure and axes.
hAxes=util_plotInit(opts);

% Plot Orbit.
zBpm=List.zBpm;zQuad=List.zQuad;
xM=permute(xMeas,[2 3 1]);xMF=permute(xMeasF,[2 3 1]);
xMStd=permute(xMeasStd,[2 3 1]);

if isempty(xM), xM=nan(length(zBpm),1,2);xMF=xM;end
if isempty(xMF), xMF=nan*xM;end

if ~isempty(opts.corrB)
    isX=strncmp(List.corrList,'X',1);
    isY=strncmp(List.corrList,'Y',1);
    if ~any(isY), isY=isX;end
    opts.corrB(~[isX isY]')=NaN;
    [zUq,iUq]=unique(List.zCorr);
end

legX=cellstr(num2str([std(xM(:,:,1),0,1)'*1e6],'En = 0.2 GeV, \\sigma_x = %6.1f \\mum'));
legY=cellstr(num2str([std(xM(:,:,2),0,1)'*1e6],'En = 0.2 GeV, \\sigma_y = %6.1f \\mum'));

ax=hAxes(1);%画x方向
col='r';siz=size(xM,2);
if siz > 1, col='';end
scl=1e6;units='\mum';
if max(abs(xM(:))) > 1e-3, scl=1e3;units='mm';end
if ~isempty(xMeasStd)
    h=errorbar(ax,repmat(zBpm(:),1,siz),xM(:,:,1)*scl,xMStd(:,:,1)*scl);
else
    h=plot(ax,zBpm,xM(:,:,1)*scl);
end
hold(ax,'on');
h2=plot(ax,zBpm,xM(:,:,1)*NaN,zBpm,xMF(:,:,1)*scl,[col '.--']);
plot(ax,zQuad,zQuad*0,'k.','Color',[.5 .5 .5]);
plot(ax,zBpm,zBpm*0,'k.');
if ~isempty(opts.corrB)
    h3=bar(ax,zUq,opts.corrB(1,iUq)*scl/10,'g','EdgeColor','g');
    set(get(h3,'BaseLine'),'LineStyle','none');
    legX{end+1}='Predicted Orbit';
    h=[h(:);h2(end/2+1)];
end
hold(ax,'off');
ylabel(ax,['x Pos  (' units ')']);
if ~isempty(en), legend(ax,h,legX,'Location','NorthWest');legend(ax,'boxoff');end
if ~isempty(opts.title)
    title(ax,opts.title);
end

ax=hAxes(2);%画y方向
if ~isempty(xMeasStd)
    h=errorbar(ax,repmat(zBpm(:),1,siz),xM(:,:,2)*scl,xMStd(:,:,2)*scl);
else
    h=plot(ax,zBpm,xM(:,:,2)*scl);
end
hold(ax,'on');
h2=plot(ax,zBpm,xM(:,:,2)*NaN,zBpm,xMF(:,:,2)*scl,[col '.--']);
plot(ax,zQuad,zQuad*0,'k.','Color',[.5 .5 .5]);
plot(ax,zBpm,zBpm*0,'k.');
if ~isempty(opts.corrB)
    h3=bar(ax,zUq,opts.corrB(2,iUq)*scl/10,'g','EdgeColor','g');
    set(get(h3,'BaseLine'),'LineStyle','none');
    legY{end+1}='Predicted Orbit';
    h=[h(:);h2(end/2+1)];
end
hold(ax,'off');
ylabel(ax,['y Pos  (' units ')']);
xlabel(ax,'z  (m)');
if ~isempty(en), legend(ax,h,legY,'Location','NorthWest');legend(ax,'boxoff');end
