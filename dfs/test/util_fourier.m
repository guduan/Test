function [f_nu, nu] = util_fourier(f_t, t, dim)
%FOURIER
%  [F_NU, NU] = FOURIER(F_T, T)
%  Calculates the Fourier transform of F_T given at times T as:
%  F_NU = int(dt exp(-i om T) F). It returns the transform and the
%  frequencies NU. The signal F is supposed to have the zero time in the
%  center and the transform will have the zero frequency in the center as
%  well.

if nargin < 3, dim=find(size(f_t) ~= 1,1);end

n=size(f_t,dim);
dims=size(f_t);dims(dim)=1;dims1=ones(size(dims));dims1(dim)=n;t0=t;
if isvector(t0), t=repmat(reshape(t,dims1),dims);end
dt=mean(diff(t,1,dim),dim);
dnu=1/n./dt;
if ~isvector(t0)
    nu=repmat(reshape(-n/2:n/2-1,dims1),dims).*repmat(dnu,dims1);
else
    nu=reshape(-n/2:n/2-1,size(t0))*dnu(1);
end
f_nu=fftshift(fft(ifftshift(f_t,dim),[],dim),dim).*repmat(dt,dims1);
