function control_emitSet(name, twiss, twissStd, tag)

if nargin < 3, twissStd=[];end
if nargin < 4, tag='xy';end

name=model_nameConvert(cellstr(name));
twiss(1,:)=twiss(1,:)*1e6; % Normalized emittance in um

for j=1:length(name)
    for iPlane=1:length(tag)
        names=strcat({'EMITN' 'BETA' 'ALPHA' 'BMAG'}','_',upper(tag(iPlane)));
        pvList=strcat(name{j},':',names);
        pvStdList=strcat(name{j},':D',names);
        val=twiss(:,iPlane,j);
        if ~val(1), continue, end
        lcaPut(pvList(1:size(val,1)),val);
        if ~isempty(twissStd)
            valStd=twissStd(:,iPlane,j);valStd(1)=valStd(1)*1e6;
            lcaPut(pvStdList(1:size(val,1)),valStd);
        end
    end
end
