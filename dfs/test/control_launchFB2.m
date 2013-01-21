function control_launchFB2(region, varargin)

optsdef=struct( ...
    'gain',.5, ...
    'nSample',10, ...
    'wait',1 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);


handles.eDefName='test';
handles.eDefNumber=0;
handles=gui_BSAControl([],handles,1,opts.nSample);

handles.dataSample.nVal=opts.nSample;

handles.static=bba_simulInit('sector',region);
[handles.data.R,handles.data.en]=bba_responseMatGet(handles.static,1);

while 1
    handles.data.xMeas=bba_bpmDataGet(handles.static,handles.data.R,1,handles);
    handles.data.ts=now;

    tmit=lcaGet(strcat(model_nameConvert(handles.static.bpmList),':TMITBR'));
    if any(tmit < 1.5e8), disp('TMIT too low');continue, end

    xMeas=handles.data.xMeas;
    xMeasStd=std(xMeas,0,3)/sqrt(size(xMeas,3));
    xMeas=mean(xMeas,3);

    opts.use=struct('init',0,'quad',0,'BPM',0,'corr',1);
    opts.fitSVDRatio=1e-6;
    f=bba_fitOrbit(handles.static,handles.data.R,xMeas,xMeasStd,opts);
    handles.data.xMeasF=xMeas-f.xMeasF;

    opts.figure=3;opts.axes={2 2 2;2 2 4};
    bba_plotCorr(handles.static,-f.corrOff,1,opts);

    % Plot results.
    opts.title=['BBA Scan Orbit ' datestr(handles.data.ts)];
    opts.figure=3;opts.axes={2 2 1;2 2 3};
    bba_plotOrbit(handles.static,xMeas,xMeasStd,handles.data.xMeasF,handles.data.en,opts);

    bDes=bba_corrGet(handles.static,1);
    disp((bDes-f.corrOff*opts.gain)*1e3);
    bba_corrSet(handles.static,-f.corrOff*opts.gain,1,'wait',0);
    pause(opts.wait);
end
