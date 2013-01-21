function [twiss, twissStd] = control_emitGet(name)

name=model_nameConvert(cellstr(name));
tag='xy';

twiss=zeros(4,2,length(name));
twissStd=zeros(4,2,length(name));
for j=1:length(name)
    for iPlane=1:length(tag)
        names=strcat({'EMITN' 'BETA' 'ALPHA' 'BMAG'}','_',upper(tag(iPlane)));
        pvList=strcat(name{j},':',names);
        pvStdList=strcat(name{j},':D',names);
        twiss(:,iPlane,j)=lcaGetSmart(pvList);
        if nargout > 1
            twissStd(:,iPlane,j)=lcaGetSmart(pvStdList);
        end
    end
end

twiss(1,:)=twiss(1,:)*1e-6; % Normalized emittance in m
twissStd(1,:)=twissStd(1,:)*1e-6; % Normalized emittance in m
