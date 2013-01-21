function bDes = model_energyUndMatch(energy)
%ENERGYUNDMATCH
%  ENERGYUNDMATCH(ENERGY) calculates the BDES for the undulator matching quads.

% Input arguments:
%    ENERGY: Beam energy at undulator

% Output arguments:
%    BDES: Value for the four undulator matching quads QUM1-4

% Compatibility: Version 7 and higher
% Called functions: none

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------


par=[ ...
      0.001440932276622  -0.065671867979583   1.129362971200801   -9.140620748051006       40.002595677852995      -55.170142534713342; ...
     -0.002690662989677   0.126470979242408  -2.282727322527234   19.967017780515143      -90.688691404059909   1.519764504917391e+002; ...
      0.009508835253187  -0.430921475710557   7.364853994242910  -59.562466591845279   2.356254597673058e+002  -3.824319128831168e+002; ...
     -0.006647978831156   0.300711544833774  -5.126216026510940   41.032743027608213  -1.532153457006428e+002   2.434655705648818e+002; ...
    ];

bDes=zeros(4,1);
for j=1:4
    bDes(j)=polyval(par(j,:),energy);
end
