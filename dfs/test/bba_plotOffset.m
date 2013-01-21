function bba_plotOffset(static, quadOffF, bpmOffF, appMode, varargin)
%BBA_PLOTORBIT
%  BBA_PLOTORBIT(STATIC, XMEAS, XMEASSTD, XMEASF, EN, OPTS) .

% Features:

% Input arguments:
%    STATIC: Struct of device lists
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

% Real positions of quads, BPMs, undulators, and beam
global quadOff undOff bpmOff corrB xInit

% Set default options.
optsdef=struct( ...
    'figure',2, ...
    'axes',[], ...
    'title','', ...
    'useBPMNoise',1, ...
    'bpmNoise',3, ... % um
    'nEnergy',3, ...
    'enRange',[4.3 13.64], ...
    'init',1);

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

zQuad=static.zQuad;
zBPM=static.zBPM;
bOff=bpmOff;qOff=quadOff;leg={'BPM Offset Fit' 'Quad Offset Fit' 'BPM Simul' 'Quad Simul'};
if numel(zBPM) ~= size(bOff,2), appMode=1;end
nSub=3;
if appMode
    nSub=2;bOff=zeros(2,0);qOff=bOff;leg={'BPM Offset Fit' 'Quad Offset Fit'};
end

if iscell(bpmOffF)
    bpmOffFStd=bpmOffF{2};bpmOffF=bpmOffF{1};
    quadOffFStd=quadOffF{2};quadOffF=quadOffF{1};
else
    bpmOffFStd=[];
end

% Setup figure and axes.
if isempty(opts.axes), opts.axes={nSub 1};end
hAxes=util_plotInit(opts);

% Plot results.
scl=1e6;units='\mum';
if max(abs([bpmOffF(:);quadOffF(:)])) > 1e-3, scl=1e3;units='mm';end
if ~isempty(bpmOffFStd)
    errorbar(hAxes(1),zBPM,bpmOffF(1,:,1)*scl,bpmOffFStd(1,:,1)*scl,'.-b');
    hold(hAxes(1),'on');
    errorbar(hAxes(1),zQuad,quadOffF(1,:,1)*scl,quadOffFStd(1,:,1)*scl,'.-r');
else
    plot(hAxes(1),zBPM,bpmOffF(1,:,1)*scl,'.-b',zQuad,quadOffF(1,:,1)*scl,'.-r');
    hold(hAxes(1),'on');
end
if ~appMode
    plot(hAxes(1),zBPM,bOff(1,:,1)*scl,'.:m',zQuad,qOff(1,:,1)*scl,'.:g');
end
hold(hAxes(1),'off');
ylabel(hAxes(1),['x Off  (' units ')']);
legend(hAxes(1),leg,'Location','NorthWest');legend(hAxes(1),'boxoff');
if ~isempty(opts.title)
    title(hAxes(1),opts.title);
end

if ~isempty(bpmOffFStd)
    errorbar(hAxes(2),zBPM,bpmOffF(2,:,1)*scl,bpmOffFStd(2,:,1)*scl,'.-b');
    hold(hAxes(2),'on');
    errorbar(hAxes(2),zQuad,quadOffF(2,:,1)*scl,quadOffFStd(2,:,1)*scl,'.-r');
else
    plot(hAxes(2),zBPM,bpmOffF(2,:,1)*scl,'.-b',zQuad,quadOffF(2,:,1)*scl,'.-r');
    hold(hAxes(2),'on');
end
if ~appMode
    plot(hAxes(2),zBPM,bOff(2,:,1)*scl,'.:m',zQuad,qOff(2,:,1)*scl,'.:g');
end
hold(hAxes(2),'off');
ylabel(hAxes(2),['y Off  (' units ')']);
legend(hAxes(2),leg,'Location','NorthWest');legend(hAxes(2),'boxoff');
if appMode, return, end

plot(hAxes(3),zBPM,(bpmOffF(:,:,1)-bpmOff(:,:,1))*scl,'.-',zQuad,(quadOffF(:,:,1)-quadOff(:,:,1))*scl,'.-');
ylabel(hAxes(3),['Off  (' units ')']);
xlabel(hAxes(3),'z  (m)');
legend(hAxes(3),{'Error BPM Fit x' 'Error BPM Fit y' 'Error Quad Fit x' 'Error Quad Fit y'},'Location','NorthWest');legend(hAxes(3),'boxoff');
