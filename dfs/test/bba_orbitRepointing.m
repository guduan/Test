function static = bba_orbitRepointing(pos, static)

%x and y at undulator exit [mm]
if nargin < 1, pos=[0.33 -.2];end

if nargin < 2
    % Get static beamline data.
    static.beamLine=bba_init; % this only do once.

    %beamLine=bba_simulInit; % for simulation only
    %bba_corrSet(beamLine,0,1,'init',1); % for simulation only

    % Get response matrix for present energy.
    [static.rMat,static.en]=bba_responseMatGet(static.beamLine,1); % this only do once or when energy changes
end

% Set up desired orbit (0 at RFBU01 and POS at RFBU33).
beamLine=static.beamLine;
if iscell(pos)
    xMeas=interp1(beamLine.zBPM([4 36]),[0 0;0 0]*1e-3,beamLine.zBPM',[],'extrap')';
    xMeas(:,4:36)=pos{:}*1e-3;
else
    xMeas=interp1(beamLine.zBPM([4 36]),[0 0;pos]*1e-3,beamLine.zBPM',[],'extrap')';
end

% Fit corrector strengths for orbit.
opts.use=struct('init',0,'quad',0,'BPM',0,'corr',1);
f=bba_fitOrbit(beamLine,static.rMat,xMeas,[],opts);

% Plot results (optional).
bba_plotCorr(beamLine,f.corrOff,1);
bba_plotOrbit(beamLine,xMeas,[],f.xMeasF,static.en,'title','FEL Repointing Orbit');

% Set correctors.
bba_corrSet(beamLine,f.corrOff,1);

%global xInit % for simulation only
%xInit=xInit*0;
%xMeas=bba_bpmDataGet(beamLine,rMat,1,1);
%bba_plotOrbit(beamLine,xMeas,[],[],static.en);

if iscell(pos), return, end

% Set orbit angle for undulator launch feedback.
ang=pos/diff(beamLine.zBPM([4 36])); % Orbit angle [mrad]
ang0=lcaGet(strcat('FBCK:UND0:1:',{'X';'Y'},'ANGSP'));
lcaPut(strcat('FBCK:UND0:1:',{'X';'Y'},'ANGSP'),ang0+ang(:));
