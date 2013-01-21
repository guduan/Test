function [f_t, t] = util_ifourier(f_nu, nu, dim, expand)
%FOURIER
%  [F_T, T] = IFOURIER(F_NU, NU, EXPAND)
%  Calculates the inverse Fourier transform of F_NU given at frequencies nu as:
%  F_T = 1/2/pi int(d_om exp(i om T) F_NU). It returns the transform and the
%  frequencies NU. The signal F is supposed to have the zero time in the
%  center and the transform will have the zero frequency in the center as
%  well.

if nargin < 3, dim=find(size(f_nu) ~= 1,1);end

n=size(f_nu,dim);
dims=size(f_nu);dims(dim)=1;dims1=ones(size(dims));dims1(dim)=n;nu0=nu;
if isvector(nu0), nu=repmat(reshape(nu,dims1),dims);end
dnu=mean(diff(nu,1,dim),dim);
dt=1/n./dnu;
if ~isvector(nu0)
    t=repmat(reshape(-n/2:n/2-1,dims1),dims).*repmat(dt,dims1);
else
    t=reshape(-n/2:n/2-1,size(nu0))*dt(1);
end
f_t=fftshift(ifft(ifftshift(f_nu,dim),[],dim),dim)./repmat(dt,dims1);
