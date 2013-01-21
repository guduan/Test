function [twiss, rn] = model_undMatch()

n=model_nameConvert({'BPMS'},'MAD','UND1');
rn=model_rMatGet('RFBU01',n);
%r1=model_rMatGet('RFBU01',{'RFBU11' 'RFBU29'});
%r2_4=model_rMatGet('RFBU02','RFBU04');
%r1=model_rMatGet('RFBU01','RFBU07');
%r2=model_rMatGet('RFBU01','RFBU29');
%r2=model_rMatGet('RFBU02','RFBU08');

r=rn(:,:,1+3);
r11=r(1,1);r12=r(1,2);r21=r(2,1);r22=r(2,2);
m=[r11^2 2*r12*r11 r12^2; ...
   r11*r21 r12*r21+r11*r22 r12*r22; ...
   r21^2 2*r22*r21 r22^2];

[v,l]=eig(m);id=1;
n=sqrt(v(1,id).*v(3,id)-v(2,id).^2).*sign(v(1,id));

twissx=[v(1,id)./n;-v(2,id)./n];

r=rn(:,:,1+3);
r11=r(3,3);r12=r(3,4);r21=r(4,3);r22=r(4,4);
m=[r11^2 2*r12*r11 r12^2; ...
   r11*r21 r12*r21+r11*r22 r12*r22; ...
   r21^2 2*r22*r21 r22^2];

[v,l]=eig(m);id=1;
n=sqrt(v(1,id).*v(3,id)-v(2,id).^2).*sign(v(1,id));

twissy=[v(1,id)./n;-v(2,id)./n];

twiss=[twissx twissy];


