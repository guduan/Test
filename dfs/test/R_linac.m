function R = R_linac(L,Ein,DE,Phi,lambda)
%
% USAGE: 
%   R = R_linac(L,Ein,DE,Phi,lambda)
%
% INPUT:  
%   L       : effective length of accelerator   (m)
%   Ein     : Particle energy at start sector   (MeV)
%   DE      : Energy gain over sector length    (MeV)
%   Phi     : RF phase w.r.t crest              (degrees)
%   lambda  : wavelength accelerating wave      (m)
%
% OUTPUT:
%   R       : Transport matrix following K.Brown "Transport" manual P91
%
%

PhiRad = Phi/180*pi;
R = zeros(6,6);
con=DE/Ein*cos(PhiRad);

if DE ~= 0
    R(1,1) = 1;
    R(1,2) = L/con*log(1+con);
    R(2,2) = 1/(1+con);
    R(3,3) = 1;
    R(3,4) = L/con*log(1+con);
    R(4,4) = 1/(1+con);
    R(5,5) = 1;
    R(6,5) = DE/Ein*sin(PhiRad)/(1+con)*(2*pi/lambda);
    R(6,6) = 1/(1+con);
else 
    R = eye(6,6);
end
