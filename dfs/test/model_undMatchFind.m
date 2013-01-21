function model_undMatchFind()

%modelSimul=0;%
[opts.source,opts.online,opts.simul,opts.useBDES]=model_init();
model_init('source','MATLAB','online',0,'simul',1,'useBDES',1);

nEnergy=10;              % # energy points to calc matrices
eMin=3.5;eMax=13.64;
%energyList=1./linspace(1./eMin,1./eMax,nEnergy);
ex=1;
energyList=linspace(eMin^ex,eMax^ex,nEnergy).^ex;
energyFit=linspace(.9*eMin,1.1*eMax,100);

bdes=zeros(nEnergy,4);
ho=util_appFind('matching_gui');figure(ho);
for j=nEnergy:-1:1
    disp(num2str(j,'Set energy #%d'));
    lcaPut('SIOC:SYS0:ML00:AO875',energyList(j));
    model_energySet(energyList(j));
%    [twiss(:,:,j),r(:,:,:,j)]=model_undMatch;
    matching_gui('UND1_Callback',ho,[],guidata(ho));
    matching_gui('Run_Callback',ho,[],guidata(ho));
    handles=guidata(ho);
    nquad = handles.optics(1).location;
    bdes(j,:)=[handles.optics(nquad).KL];
end

nDeg=5;                  % # degree of fit polynomial
p=zeros(4,nDeg+1);
bdesf=zeros(numel(energyFit),4);
bdesf0=zeros(nEnergy,4);
for j=1:4
    p(j,:)=polyfit(energyList,bdes(:,j)',nDeg);
    bdesf(:,j)=polyval(p(j,:),energyFit);
    bdesf0(:,j)=polyval(p(j,:),energyList);
end

clf;subplot(2,1,1);
plot(energyList,bdes,'.');hold on
plot(energyFit,bdesf);hold off
subplot(2,1,2);
plot(energyList,bdes-bdesf0,'.',energyFit,bdesf*NaN);hold on

model_init(opts);
