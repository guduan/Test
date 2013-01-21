function varargout = util_subplot(n, j, varargin)

a=ceil(sqrt(n));
b=ceil(n/a);
h=subplot(b,a,j,varargin{:});
if nargout, varargout{1}=h;end
