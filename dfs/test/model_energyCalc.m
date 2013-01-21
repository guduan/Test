function klys = model_energyCalc()

% Get present klystron complement
klys=getKlys;
act=reshape(klys.act,8,[]);

% Useable klystrons in 29,30
good=bitand(act,4) == 0;
use29_30=min(sum(good(:,5:6)));

% Get energy
en=model_energySetPoints;
dKlys=reshape(klys.enld*1e-3,8,[]);
dE=diff(en(4:5));en=en(5);

% Needed klystrons in 29,30
use29_30=min(round(interp1([4.3 13.64],[2 8],en,'linear',7)),use29_30);
%use29_30=min(7,use29_30);
use2=cumsum(good(:,5:6)) <= use29_30;
%phi=45;
phi=interp1([4.3 13.64],[145 45],en,'linear',45);
dE29_30=sum(sum(use2.*dKlys(:,5:6)))*cosd(phi);

% Needed klyystrons in 25-28
dE25_28=dE-dE29_30;
%use25_28=round(dE25_28/dKlys);

% Set klystrons in 25-28
use1=reshape(cumsum(reshape(good(:,1:4).*dKlys(:,1:4),[],1)) <= dE25_28,8,[]);
%use1=reshape(cumsum(reshape(good(:,1:4),[],1)) <= use25_28,8,[]);
act([use1 use2] & good)=1;act(~[use1 use2] & good)=2;

klys.act=act(:);


function klys = getKlys()

names=model_nameConvert(model_nameRegion({'KLYS'},'L3'),'MAD');
[act,d,d,d,d,enld]=control_klysStatGet(names);
klys.name=names;
klys.act=act;
klys.enld=enld;
