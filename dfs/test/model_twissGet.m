function [twiss, sigma, energy, phase] = model_twissGet(name, rOpts, varargin)

[modelSource,modelOnline]=model_init;

optsdef=struct( ...
    'rMat',[], ...
    'en',[], ...
    'reg',[], ...
    'doPhase',0, ...
    'design',0, ...
    'init',0 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

if nargin < 2, rOpts={};end

name=cellstr(name);
nList=numel(name);
twiss=ones(3,2,nList);
phase=zeros(2,nList);
rOpts=cellstr(rOpts);

% Determine if DESIGN.
if ~isempty(rOpts)
    isType=find(strncmpi(rOpts(1,:),'TYPE=',5),1,'last');
    if ~isempty(isType) && strcmpi(rOpts{isType}(6:end),'DESIGN')
        opts.design=1;
    end
end

if modelOnline && ~ismember(modelSource,{'MATLAB'})
    t=model_rMatGet(name,[],rOpts,'twiss');
    energy=t(1,:);
    twiss(2:3,:,:)=reshape(t([3 4 8 9],:),2,2,[]);
    twiss(1,:,:)=1e-6;
    phase=t([2 7],:);
else
    if isempty(opts.rMat)
        [opts.rMat,d,d,opts.en,opts.reg]=model_rMatModel(name,[],rOpts);
%        [opts.rMat,opts.en]=model_rMatGet(name,[],rOpts,{'R' 'EN'});
    end

%    Initial Twiss parameter definitions.
    twiss0(:,:,1)=[1e-6 1e-6;15.574 0.391;-3.081 0.0055]; % MAD deck begin of Gun
%    twiss0(:,:,1)=[1e-6 1e-6;15.5274 0.3918;-3.0745 0.0074]; % begin of Gun to match OTR2
%    twiss0(:,:,1)=[1e-6 1e-6; 1.113  1.113;-0.069 -0.070]; % MAD deck at OTR2
    twiss0(:,:,2)=[1e-6 1e-6; 9.947  2.411; 1.960 -0.549]; % BC1 at L1 entrance
    twiss0(:,:,3)=[1e-6 1e-6;49.920 26.946;-0.379 -1.347]; % BC2
%    twiss0(:,:,4)=[1e-6 1e-6;32.029 67.490; 0.782 -1.485]; % At BSY entrance, old design
    twiss0(:,:,4)=[1e-6 1e-6;118.8491 103.0493; 2.0570 -3.8641]; % At BSY entrance, new design
%    twiss0(:,:,4)=[1e-6 1e-6;50.484 72.941; 1.808 -9.155]; % At LTU entrance
%    twiss0(:,:,4)=[1e-6 1e-6;48.864 97.026; 3.136  3.636]; % At Und entrance ?
    twiss0(:,:,5)=[1e-6 1e-6; 6.604 27.511;-0.918  1.550]; % At L2 entrance
    twiss0(:,:,6)=[1e-6 1e-6;11.060 71.028;-0.949  2.204]; % At L3 entrance
    twiss0(:,:,7)=[1e-6 1e-6; 1.408  6.690;-2.607  0.503]; % MAD deck end of L0a
    twiss0(:,:,8)=[1e-6 1e-6;11.359  9.019;-0.326 -1.661]; % BC1 after L1X
    twiss0(:,:,9)=[1e-6 1e-6;36.578 41.455; 0.181  1.063]; % At 50B1 for A-Line
    twiss0(:,:,10)=[1e-6 1e-6;3.661161685118 3.031222969461;1.645438867265 1.195981434528]; % LCLS-II MAD deck begin of Gun

    phase0(:,1)=[0    ;0    ]*2*pi; % MAD deck begin of Gun
    phase0(:,2)=[1.775;1.237]*2*pi; % BC1 at L1 entrance
    phase0(:,3)=[5.173;4.870]*2*pi; % BC2
    phase0(:,4)=[7.635;7.320]*2*pi; % At BSY entrance
    phase0(:,5)=[2.750;2.428]*2*pi; % At L2 entrance
    phase0(:,6)=[5.518;5.254]*2*pi; % At L3 entrance
    phase0(:,7)=[0.444;0.274]*2*pi; % MAD deck end of L0a
    phase0(:,8)=[2.041;1.613]*2*pi; % BC1 after L1X
    phase0(:,9)=[7.711;7.405]*2*pi; % At 50B1 for A-Line
    phase0(:,10)=[0    ;0    ]*2*pi; % MAD deck begin of Gun

%    en0(:,1)=model_energy({'YAG01' 'BPM15' 'OTR21' 'OTR33' 'OTR21' 'OTR33' 'YAG03' 'OTR12' 'OTR33'},rOpts);

    if ~opts.design
%        twiss0(:,:,1)=[1e-6 1e-6;62.404 35.417;-1.248 0.672]; % At WS28144
%        twiss0(:,:,1)=eye(3,4)*control_emitGet('WS28144');
    end

%    [energy,reg]=model_energy(name,rOpts);
    energy=opts.en;reg=opts.reg;
    for j=1:size(twiss0,3)
        twiss(:,:,reg == j)=repmat(twiss0(:,:,j),[1 1 sum(reg == j)]);
        phase(:,reg == j)=repmat(phase0(:,j),[1 sum(reg == j)]);
%        energy0(reg == j)=en0(:,j); % BC1 energy in GeV
    end

    if opts.doPhase, phase=phase+model_twissPhase(twiss,opts.rMat);end
    twiss=model_twissTrans(twiss,opts.rMat);

%    blen=lcaGet('SIOC:SYS0:ML00:AO878');
%    sigma0=model_twiss2Sigma(twiss,repmat(energy0(:)',2,1));
%    for j=1:nList
%        sig=eye(6);sig([1 2 7 8 15 16 21 22 29 36])=[reshape(sigma0([1 2 2 3],:,j),1,[]) blen 0];
%        sig=rMat(:,:,j)*sig*rMat(:,:,j)';
%        sigma(:,:,j)=reshape(sig([1 7 8 15 21 22]),3,2);
%    end
%    twiss=model_sigma2Twiss(sigma,[],repmat(energy(:)',2,1));
end

sigma=model_twiss2Sigma(twiss,repmat(energy(:)',2,1));
