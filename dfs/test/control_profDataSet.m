function control_profDataSet(name, beam, tag)

if nargin < 3, tag='xy';end

name=model_nameConvert(cellstr(name));
if ~isempty(strfind(name{1},'LR20')), return, end
stats=beam(1).stats.*[1e-3 1e-3 1 1 1/prod(beam(1).stats(3:4)) 1]; % Data in [mm mm um um 1 cts]
use=true(6,1);
if ~any(tag == 'x'), use([1 3 5])=0;end
if ~any(tag == 'y'), use([2 4 5])=0;end

names={'X' 'Y' 'XRMS' 'YRMS' 'XY' 'SUM'}';
pvList=strcat(name{1},':',names);
lcaPutSmart(pvList(use),stats(use)');
