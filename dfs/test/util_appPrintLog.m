function util_appPrintLog(fig, header, name, ts)

% Check if FIG is handle.
if ~ishandle(fig), return, end

[sys, accelerator] = getSystem();

if strcmp(accelerator, 'LCLS')
    print(fig,'-dpsc2','-Pphysics-lclslog');
    return
    [dev,rem]=strtok(name,':');[seg,rem]=strtok(rem,':');pos=strtok(rem,':');
    if ~isempty(dev)
        name=model_nameConvert([dev ':' seg ':' pos],'MAD');
    end
    opts.title=[header ' ' name];
    switch seg(1:min(2,end))
        case 'LR', opts.segment='LCLS_LASER';
        case 'IN', opts.segment='LCLS_INJECTOR';
        case 'LI', opts.segment='LCLS';
        case 'LT', opts.segment='LCLS_LTU';
        otherwise, opts.segment='LCLS';
    end
    util_eLogEntry(fig,ts,'lcls',opts);
end
