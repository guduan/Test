function [beamSize, beamPos] = model_beamSize(name)

[twiss,sigma]=model_twissGet(name);
emit=lcaGet('EMIT')*1e6;
beamSize=sqrt(sigma(1,:)*emit);
r=model_rMatGet(name);
ph=control_phaseGet('TCAV0');
beamPos=r*[0 0 0 0 cosd(ph)*180/pi*.3*1e-3 0]';
beamPos=beamPos([1 3]);
%beamPos=[1 1.4]'*1e-3;

if strcmp(name,'OTRS:LI21:237')
    ph=control_phaseGet('L1S');
    eta=-0.2311;
    beamPos(1)=beamPos(1)+(250-135)/cosd(-22)/250*(cosd(ph)-cosd(-22))*eta*(ph ~= 0);
elseif strcmp(name,'OTRS:LI24:807')
    ph=control_phaseGet('L2');
    eta=-0.3620;
    beamPos(1)=beamPos(1)+(4300-250)/cosd(-36)/4300*(cosd(ph)-cosd(-36))*eta*(ph ~= 0);
end

delta=lcaGet('DELTA');
tau=lcaGet('TAU');
sigma=[tau;0;delta].^2;
%sigmap=sigma([1 2;2 3]);
%sigma2=r(5:6,5:6)*sigmap*r(5:6,5:6)';sigma2=sigma2([1 2 4]');
t=model_sigma2Twiss(sigma);
t=model_twissTrans(t,r(5:6,5:6));
sigma=model_twiss2Sigma(t)*det(r(5:6,5:6));disp([sqrt(sigma(1))*1e6 sqrt(sigma(3))*1e3 sigma(2)/sigma(1)]);
delta=sqrt(sigma(end));%disp(sqrt(sigma(1))*1e6);
beamSize(1)=sqrt(beamSize(1)^2+(delta*r(1,6)/r(6,6))^2);
