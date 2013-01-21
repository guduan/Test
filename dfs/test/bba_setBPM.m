function bba_setBPM(static, bpmDelta, appMode, varargin)

% Real positions of quads, BPMs, undulators, and beam
global quadOff undOff bpmOff corrB xInit girdPos

optsdef=struct( ...
    'init',0);

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

% Change BPM offsets by desired shift.
if ~appMode
    bpmOff=bpmOff+bpmDelta;
end

if appMode
    pvList=model_nameConvert(static.bpmList,'EPICS');
    pvOff=[strcat(pvList(:),':XAOFF') strcat(pvList(:),':YAOFF')]';
    off=lcaGet(pvOff(:));
    if opts.init, off=0;end
    lcaPut(pvOff(:),off-bpmDelta(:)*1e3);
    cData=[static.bpmList num2cell(reshape([off;off-bpmDelta(:)*1e3],[],4))]';
    disp('BPM Off   Old x    Old Y    New X    New Y');
    disp(sprintf('%-6s %8.3f %8.3f %8.3f %8.3f\n',cData{:}));
end
