function r = model_rMatElement(type,d,par)

rcant=ones(1,1,2);[kx2,ky2,h,r56,r65,r45]=deal(0);
r66=1;O=eye(6,6);

switch type(1:2)
    case 'qu'
        kx2=par(1);
        ky2=-kx2;
    case 'so'
        kx2=(par(1)*cur./bp/2).^2;
        ky2=kx2;
    case 'be'
        angle=par(1);hgap=par(2);e=par(3:4);
        k1=0;h=angle/d;
        kx2= k1+h.^2;
        ky2=-k1;
        fint=par([5 min(6,end)]); %MADs FINT
        psi=2*hgap*fint*h.*(1+sin(e).^2)./cos(e);
        rcant=repmat(eye(6),[1 1 2]);
        rcant(2,1,:)= [h h].*tan(e);
        rcant(4,3,:)=-[h h].*tan(e-psi);
        if numel(par) > 6
            O([1 8 15 22])=cos(-par(7));
            O([3 10 13 20])=[-1 -1 1 1]*sin(-par(7));
%            c = cos(-par(7));               % -sign gives TRANSPORT convention
%            s = sin(-par(7));
%            O = [ c  0  s  0  0  0; ...
%                  0  c  0  s  0  0; ...
%                 -s  0  c  0  0  0; ...
%                  0 -s  0  c  0  0; ...
%                  0  0  0  0  1  0; ...
%                  0  0  0  0  0  1];
        end
    case 'tc'
        r45=par(1)*sin(par(2)*pi/180);
    case 'lc'
        f=par(1); % MHz
        gain=par(2); % MeV
        ph=par(3); % rad
        e0=par(4); % MeV
        k=2*pi*f*1e6/2.99792458e8;
        con=gain/e0*cos(ph);
        r66=1/(1+con);
        %r65=gain/e0*sin(ph)*k;
        r65=gain/(e0+gain*cos(ph))*sin(ph)*k;
        eta=0; % use focusing with eta > 0
        kx2=eta/8*(gain/e0/d)^2;
        ky2=kx2;
        rcant=repmat(eye(6),[1 1 2]);
        rcant(2,1,:)=[-1 1]*con/d/2;
        rcant(4,3,:)=[-1 1]*con/d/2;
        if con ~= 0
            d=d*log(1+con)/con;
        end
    case 'un'
        kx2=0;
        ky2=par(1);
    otherwise
end

kx=sqrt(kx2);ky=sqrt(ky2);
phix=kx.*d;phiy=ky.*d;
kx2(kx2 == 0)=1;
r56=-d.*(1-sinc(phix)).*h.^2./kx2;
dx=zeros(2,1);

if ~any(kx), mx1=[1 d]';mx2=[0 1]';else
    mx1=[     cos(phix) d.*sinc(phix)]';
    mx2=[-kx.*sin(phix)     cos(phix)]';
    dx =[  h.*(d.*sinc(phix/2)).^2/2 h.*d.*sinc(phix)]';
end
if ~any(ky), my1=[1 d]';my2=[0 1]';else
    my1=[     cos(phiy) d.*sinc(phiy)]';
    my2=[-ky.*sin(phiy)     cos(phiy)]';
end

r=eye(6);
r(1,1:2)=mx1;
r(2,1:2)=mx2;
r(3,3:4)=my1;
r(4,3:4)=my2;
r(1:2,6)=dx;
%r(5,1:2)=-dx([2 1]);
r(5,1:2)=dx([2 1]);
r(4,5  )=r45;
%r(5,6  )=r56;
r(5,6  )=-r56;
r(6,5  )=r65;

if ismember(type(1:2),{'so'})
    % phix=phix*0;
    phi=repmat(reshape(phix,1,1,[]),2,2);
    r(1:4,1:4,:)=repmat(r(1:2,1:2,:),2,2).*cat(1,cat(2,cos(phi),sin(phi)),cat(2,-sin(phi),cos(phi)));
end

% Apply edge focusing.
%r=rcant(:,:,2)*real(r)*rcant(:,:,1);

% Apply roll angle.
r=O*r*O';

% Apply relativistic rescaling.
r=diag([1 r66 1 r66 1 r66])*r;


function y = sinc(x)

zind=x ~= 0;
y=x*0+1;
y(zind)=sin(x(zind))./x(zind);
