function beamline=EAppend(beamline,list)

energylist=list.energy;
lcenergylist=energylist(list.lcid);
item4list=cell2mat(reshape(beamline(4,list.lcid),[],1));
item4list=horzcat(item4list,lcenergylist');
item4list=mat2cell(item4list,ones(1,length(item4list)),4);
beamline(4,list.lcid)=item4list;
