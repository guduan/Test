function fwhm = util_fwhm(x, f, dim)

if nargin < 3
    dims=size(f);
    dim=find(dims ~= 1,1);
end

fmax=max(f,[],dim);
fmin=min(f,[],dim);

fwhm=zeros(1,size(f,2));
ind=repmat({':'},1,ndims(f));

for j=1:size(f,2)
%    ind{dim}=j;
    ind{2}=j;
    i1=find(2*f(ind{:}) >= fmin(j)+fmax(j),1);
    i2=find(2*f(ind{:}) >= fmin(j)+fmax(j),1,'last');
    fwhm(j)=diff(x([i1 i2]));
end
