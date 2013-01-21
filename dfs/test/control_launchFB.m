function control_launchFB(region, varargin)

optsdef=struct( ...
    'gain',.5, ...
    'nSample',10 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

model_init('source','MATLAB','online',0);
handles.dataSample.nVal=opts.nSample;
handles.eDefNumber=eDefReserve(['LAUNCHFB_' upper(region)]);
eDefParams(handles.eDefNumber,1,2800);

switch region
    case 'UND'
        bpms={'RFB07' 'RFBU00' 'RFBU03' 'RFBU07' 'RFBU10'};
        corrsX={'XCE35' 'XCUM4'}';
        corrsY={'YCE34' 'YCUM3'}';
    case 'LTU'
        bpms={%'BPMEM1' 'BPMEM2' 'BPMEM3' 'BPMEM4' ...
            'BPME31' 'BPME32' 'BPME33' 'BPME34'};% 'BPME35' 'BPME36'};
        corrsX={'XCQT32' 'XCDL4'}';
        corrsY={'YCQT32' 'YCQT42'}';
end

corrs=[corrsX;corrsY];
handles.static.bpmList=bpms';
r=model_rMatGet(repmat(corrs,numel(bpms),1),repmat(bpms,4,1));
r=reshape(r,6,6,4,[]);
Rx=squeeze(r(1,2,1:2,:))';
Ry=squeeze(r(3,4,3:4,:))';
R=blkdiag(Rx,Ry);

while 1
    xMeas=bba_bpmDataGet(handles.static,[],1,handles);
    [d,ix]=ismember(bpms,handles.static.bpmList);
    x=mean(xMeas(:,ix,:),3)';
    tmit=lcaGet(strcat(model_nameConvert(bpms'),':TMITBR'));
    if any(tmit < 1.5e8), disp('TMIT too low');continue, end

    [d,en]=control_magnetGet('BYD1');
    bp=en/299.792458*1e4; % kG m
%    cVal=inv(R)*x(:)*bp;  x=R*cVal/bp
    cVal=lscov(R,x(:)*bp);
    val=control_magnetGet(corrs);
    lcaPut(strcat(model_nameConvert(corrs),':BCTRL'),val-cVal*opts.gain);
    pause(.5);
%    control_magnetSet(corrs,val-cVal);
end
eDefRelease(handles.eDefNumber);
