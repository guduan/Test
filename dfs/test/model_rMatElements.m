function r = model_rMatElements(type, d, par0)

type=cellstr(type);
if iscell(d), d=vertcat(d{:});end
d=reshape(d,[],1);
if isnumeric(par0), par0=num2cell(par0,2);end

nElem=numel(type);
r=repmat(eye(6),[1 1 nElem]);
rcant=cat(4,r,r);
[O,rgam]=deal(reshape(r,[],nElem));
[kx2,ky2,h,r56,r65,r45,r66]=deal(zeros(nElem,1));
r66(:)=1;

for tag={'Q' 'S' 'B' 'T' 'L' 'U';'qu' 'so' 'be' 'tc' 'lc' 'un';1 1 7 2 4 2}
    is.(tag{1})=strncmp(type,tag{2},2);
    par.(tag{1})=vertcat(par0{is.(tag{1})});
    if isempty(par.(tag{1})), par.(tag{1})=zeros(0,1);end
    par.(tag{1})(:,end+1:tag{3})=0;
end

% Quadrupole
kx2(is.Q)=par.Q(:,1);
ky2(is.Q)=-kx2(is.Q,1);

% Solenoid
%kx2(is.S)=(par.S(:,1)*cur./bp/2).^2;
%ky2(is.S)=kx2(is.S,1);

% Bend
angle=par.B(:,1);hgap=par.B(:,2);e=par.B(:,3:4);
k1=0;h(is.B)=angle./d(is.B,1);
kx2(is.B)= k1+h(is.B,1).^2;
ky2(is.B)=-k1;
fint=par.B(:,5:6); %MADs FINT
psi=2*h(is.B,[1 1]).*fint.*[hgap hgap].*(1+sin(e).^2)./cos(e);
rcant(2,1,is.B,:)= h(is.B,[1 1]).*tan(e);
rcant(4,3,is.B,:)=-h(is.B,[1 1]).*tan(e-psi);
O([1  8 15 22],is.B)=[ 1; 1;1;1]*cos(-par.B(:,7))';
O([3 10 13 20],is.B)=[-1;-1;1;1]*sin(-par.B(:,7))';
%            c = cos(-par(7));               % -sign gives TRANSPORT convention
%            s = sin(-par(7));
%            O = [ c  0  s  0  0  0; ...
%                  0  c  0  s  0  0; ...
%                 -s  0  c  0  0  0; ...
%                  0 -s  0  c  0  0; ...
%                  0  0  0  0  1  0; ...
%                  0  0  0  0  0  1];

% Transverse deflector
r45(is.T)=par.T(:,1).*sind(par.T(:,2));

% Accelerator
f=par.L(:,1); % MHz
gain=par.L(:,2); % MeV
ph=par.L(:,3); % rad
e0=par.L(:,4); % MeV
k=2*pi*f*1e6/2.99792458e8;
con=gain./e0.*cos(ph);
r66(is.L)=1./(1+con);
r65(is.L)=gain./e0.*sin(ph).*k;
eta=0; % use focusing with eta > 0
kx2(is.L)=eta/8*(gain./e0./d(is.L,1)).^2;
ky2(is.L)=kx2(is.L,1);
rcant(2,1,is.L,:)=(con./d(is.L,1))*[-1 1]/2;
rcant(4,3,is.L,:)=(con./d(is.L,1))*[-1 1]/2;
idL=find(is.L);isCon=con ~= 0;
d(idL(isCon))=d(idL(isCon),1).*log(1+con(isCon,1))./con(isCon,1);
rgam([8 22 36],:)=[1;1;1]*r66';

% Undulator
kx2(is.U)=0;
ky2(is.U)=par.U(:,1);

% Calc R-matrix elements.
kx=sqrt(kx2);ky=sqrt(ky2);
phix=kx.*d;phiy=ky.*d;
kx2(kx2 == 0)=1;
r56=-d.*(1-sinc(phix)).*h.^2./kx2;

mx1=[     cos(phix) d.*sinc(phix)]';
mx2=[-kx.*sin(phix)     cos(phix)]';
dx =[  h.*(d.*sinc(phix/2)).^2/2 h.*d.*sinc(phix)]';
my1=[     cos(phiy) d.*sinc(phiy)]';
my2=[-ky.*sin(phiy)     cos(phiy)]';

% Assemble R-matrix.
r(1,1:2,:)=mx1;
r(2,1:2,:)=mx2;
r(3,3:4,:)=my1;
r(4,3:4,:)=my2;
r(1:2,6,:)=dx;
r(5,1:2,:)=-dx([2 1],:);
r(4,5  ,:)=r45;
r(5,6  ,:)=r56;
r(6,5  ,:)=r65;
r=real(r);

%{
if ismember(type(1:2),{'so'})
    % phix=phix*0;
    phi=repmat(reshape(phix,1,1,[]),2,2);
    r(1:4,1:4,:)=repmat(r(1:2,1:2,:),2,2).*cat(1,cat(2,cos(phi),sin(phi)),cat(2,-sin(phi),cos(phi)));
end
%}

% Apply edge focusing.
r(:,:,is.B | is.L)=tensorprod(rcant(:,:,is.B | is.L,2),tensorprod(r(:,:,is.B | is.L),rcant(:,:,is.B | is.L,1))); % r=rcant2*r*rcant1

% Apply roll angle.
O=reshape(O,6,6,[]);
r(:,:,is.B)=tensorprod(O(:,:,is.B),tensorprod(r(:,:,is.B),permute(O(:,:,is.B),[2 1 3]))); % r=O*r*O'

% Apply relativistic rescaling.
rgam=reshape(rgam,6,6,[]);
r(:,:,is.L)=tensorprod(rgam(:,:,is.L),r(:,:,is.L)); % r=rgam*r


function y = sinc(x)

zind=x ~= 0;
y=x*0+1;
y(zind)=sin(x(zind))./x(zind);


function c=tensorprod(a, b)

c=zeros(size(a,1),size(b,2),size(a,3));
for j=1:size(a,3)
    c(:,:,j)=a(:,:,j)*b(:,:,j);
end
    