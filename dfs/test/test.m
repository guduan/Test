clc;
beamline=model_beamtest;
for n=1:4
    R(:,:,n)=model_rMatElement(beamline{n,[1 3 4]});
end

