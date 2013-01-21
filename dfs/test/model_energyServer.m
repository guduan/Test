function model_energyServer()

region=[];
static=[];
is=[1 0 1 0 0];
lcaPutSmart(strcat('SIOC:SYS0:ML01:AO06',cellstr(num2str((1:5)'))),is');
tic;
while is(1) ,toc;tic;
    is=lcaGetSmart(strcat('SIOC:SYS0:ML01:AO06',cellstr(num2str((1:5)'))));
    static=model_energyMagProfile(static,region, ...
            'doPlot',0,'color','k','figure',1,'update',0,'getSCP',is(2));
    drawnow;
    magnet=model_energyMagScale(static,[],'design',is(3), ...
        'designAll',is(4),'undMatch',is(5),'display',0);

%{
    name=model_nameConvert(magnet.name);
    lcaPutSmart(strcat(name,':BLEM'),magnet.bDes);
    lcaPutSmart(strcat(name,':BMAG'),magnet.bMag);

    name=model_nameXAL(static.klys.name);
    lcaPutSmart(strcat(name,':ALEM'),static.klys.gainF);
    lcaPutSmart(strcat(name,':PLEM'),static.klys.gainF);
    lcaPutSmart(strcat(name,':EGLEM'),static.klys.gainF);
    lcaPutSmart(strcat(name,':CHLEM'),static.klys.gainF);
%}
end
toc;
