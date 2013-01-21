function model_energyMagCheck(magnet)

if isfield(magnet,'magnet'), magnet=magnet.magnet;end
if isfield(magnet,'name'), magnet=magnet.name;end
names=cellstr(magnet);

hsta=control_magnetGet(names,'HSTA');
isOOS=4;isOff=16;isNoT=1024;
isTrim=~bitand(max(0,min(ceil(hsta),2^16-1)),isOOS+isOff+isNoT);
names=names(isTrim);
stat=lcaGetStatus(strcat(model_nameConvert(names),':BACT')) > 1;
if any(stat)
    disp('Not all magnets trimmed');disp(names(stat));
    if strcmp('Yes',questdlg('Do you want to trim magnets again','Trim Magnets'))
        control_magnetSet(names(stat),[],'action','TRIM');
    end
end
