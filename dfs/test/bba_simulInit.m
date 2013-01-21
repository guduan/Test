function static = bba_simulInit(varargin)

% Real positions of quads, BPMs, undulators, and beam
global quadOff undOff bpmOff corrB xInit girdPos strayB

optsdef=struct( ...
    'useBPMOff',0, ...
    'useQuadOff',0, ...
    'useUndOff',0, ...
    'useGirdOff',0, ...
    'useGirdSlope',0, ...
    'useUnd',1, ...
    'useStray',0, ...
    'bpmOff',50, ... % um
    'quadOff',100, ... % um
    'undOff',100, ...% um
    'girdOff',[100 -200], ...% um
    'girdSlope',[1000 500], ... % um/100m
    'strayB',1e-3, ...
    'sector','UND', ...
    'noEPlusCorr',0, ...
    'noSLC',0 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

%lcaPut('SIOC:SYS0:ML00:AO877',opts.useUnd);

static=bba_init(opts);

nQuad=length(static.quadList);
nGird=length(static.undList);
nBPM=length(static.bpmList);
nUnd=length(static.undList);
zBPM=static.zBPM;
zQuad=static.zQuad;
zUnd=static.zUnd;
lUnd=static.lUnd;

girdSlope=opts.girdSlope(:)*1e-6/100*opts.useGirdSlope;
girdOff=opts.girdOff(:)*1e-6*opts.useGirdOff;
zBeg=zBPM(min(end,3));
z1=(zBPM-zBeg).*(zBPM > zBeg);
bpmDrift=girdSlope*z1+girdOff*(zBPM*0+1);
quadDrift=girdSlope*(zQuad-zBeg)+girdOff*(zQuad*0+1);
undDrift=girdSlope*(zUnd-lUnd/2-zBeg)+girdOff*(zUnd*0+1);
undDriftE=girdSlope*(zUnd+lUnd/2-zBeg)+girdOff*(zUnd*0+1);

% Quad offsets.
quadOff=opts.quadOff*1e-6*opts.useQuadOff;
quadOff=quadDrift+randn(2,nQuad)*quadOff;%+[1e-3;.5e-3]*sin((1:nGird)*2*pi/nGird);

% BPM offsets.
bpmOff=opts.bpmOff*1e-6*opts.useBPMOff;
bpmOff=bpmDrift+randn(2,nBPM)*bpmOff;

% Und offsets and angles.
undOff=opts.undOff*1e-6*opts.useUndOff;
undOffE=undDriftE+randn(2,nUnd)*undOff;
undOff=undDrift+randn(2,nUnd)*undOff;

undAngle=(undOffE-undOff)./[lUnd;lUnd];
undOff=[undOff(1,:);undAngle(1,:);undOff(2,:);undAngle(2,:)];

% Gird position.
girdPos=zeros(4,nGird); %[xBeg;yBeg;xEnd;yEnd]

% Initial launch.
xInit=[30;-2;-20;-3]*1e-6*1;

% Corrector strengths.
bba_setCorr(static,0,0,'init',1);

% Stray field strength.
strayB=corrB*0+randn(size(corrB))*opts.strayB*opts.useStray;
