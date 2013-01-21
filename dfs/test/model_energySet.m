function model_energySet(energy)

eLast=control_magnetGet('BYD1','BDES');
magList=model_nameConvert({'BEND' 'QUAD' 'XCOR' 'YCOR'},'MAD',{'BSY0' 'LTU0' 'LTU1' 'DMP1'});
[bAct,bDes]=control_magnetGet(magList);
control_magnetSet(magList,bDes*energy/eLast);
nameEn=control_energyNames(magList);
lcaPut(strcat(nameEn,':EDES'),energy);
lcaPut('SIOC:SYS0:ML00:AO409',energy);
lcaPut('SIOC:SYS0:ML00:AO875',energy);
