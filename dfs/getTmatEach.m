function Tmat = getTmatEach(beamline)

n=size(beamline,2);
Tmat(:,:,n)=zeros(6);

for a=1:n
	Tmat(:,:,a)=getTmat(beamline{[1 3 4],a});
end



