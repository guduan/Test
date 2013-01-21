if 1
d={'QUAD' 'BEND' 'XCOR' 'YCOR' 'BPMS' 'WIRE' 'OTRS' 'YAGS'}; s=[{'IN20'} strcat('LI',cellstr(num2str((21:30)'))')];
n=model_nameConvert(d,[],s);
global modelSource;

modelSource='EPICS';disp('XAL');
%[ax,bx,cx,dx,ex]=model_rMatGet(n,[],'TYPE=DATABASE');
[rx,zx,lx,tx,ex]=model_rMatGet(n,[],'TYPE=DESIGN');

modelSource='SLC';disp('SLC');
%[as,bs,cs,ds,es]=model_rMatGet(n,[],'TYPE=DATABASE');
[rs,zs,ls,ts,es]=model_rMatGet(n,[],'TYPE=DESIGN');

eb=abs(es-ex)./es > 1e-2;
lb=abs(ls-lx) > 1e-6;
zb=abs(zs-zx) > 1e-1;
end

disp([n(eb) num2cell([ex(eb)' es(eb)'])]);
disp([n(lb) num2cell([lx(lb)' ls(lb)'])]);
disp([n(zb) num2cell([zx(zb)' zs(zb)'])]);
