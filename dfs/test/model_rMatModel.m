function [rMat, zPos, lEff, en, reg] = model_rMatModel(name, nameTo, rOpts, varargin)

if nargin < 3, rOpts={};end
if nargin < 2, nameTo={};end
if isempty(rOpts), rOpts={};end
if isempty(nameTo), nameTo={};end
name=model_nameConvert(cellstr(name),'MAD');
nameTo=model_nameConvert(cellstr(nameTo),'MAD');
rOpts=cellstr(rOpts);
nList=max([numel(name) numel(nameTo) size(rOpts,1)])*(numel(name) > 0);
rMat=zeros(6,6,nList);
[zPos,lEff,en,reg,k]=deal(zeros(1,nList));

optsdef=struct( ...
    'Z',0, ...
    'LEFF',0, ...
    'EN',0, ...
    'K',0, ...
    'design',0, ...
    'init',0 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

% Determine if DESIGN.
if ~isempty(rOpts)
    isType=find(strncmpi(rOpts(1,:),'TYPE=',5),1,'last');
    if ~isempty(isType) && strcmpi(rOpts{isType}(6:end),'DESIGN')
        opts.design=1;
    end
end

%bl=model_beamLineInj('ALL',opts);
%bl.L2=model_beamLineL2;
%bl.L3=model_beamLineL3;
%[bl.UN,bl.B5,bl.BS]=model_beamLineUnd;
%bl.AL=model_beamLineA;
%blNLCTA=model_beamLineNLCTA;
%blLCLS2=model_beamLineLCLSII;

%blFull=[bl.IN;bl.DL;bl.B1;bl.L2;bl.B2;bl.L3;bl.UN];
%blSP=[bl.IN;bl.SP];
%bl52=[bl.IN;bl.DL;bl.B1;bl.L2;bl.B2;bl.L3;bl.B5];
%blAL=[bl.BS;bl.AL];
%[blFull,blSP,bl52,bl.GS]=model_beamLineLCLS;

% Determine proper beamline.
%           beamline definition       start z     start E  E0 #  tw0 #
%           E def # 1:GUN, 2:DL1, 3:BC1, 4:BC2, 5:DMP
blList={@() model_beamLineLCLS      0.000000  0.006  1  1; ...
    @() model_beamLineA      1053.068368  13.64  5  9; ...
    @() model_beamLineNLCTA     0.000000  0.006  1  1; ...
    @() model_beamLineLCLSII    0.000000  0.006  1  10; ...
    };

%{
blList={@() blFull                  0.000000  0.006  1  1; ...
@() bl.GS                   0.000000  0.006  1  1; ...
@() blSP                    0.000000  0.006  1  1; ...
@() bl52                    0.000000  0.006  1  1; ...
@() model_beamLineA      1053.068368  13.64  5  9; ...
%        @() blAL                 1031.243825  13.64  5  4; ...
@() model_beamLineNLCTA     0.000000  0.006  1  1; ...
@() model_beamLineLCLSII    0.000000  0.006  1  10; ...
};
%}

%{
blList={@() [bl.IN;bl.DL]     0.000000  0.006  1  1; ...
@() bl.GS             0.000000  0.006  1  1; ...
@() [bl.IN;bl.SP]     0.000000  0.006  1  1; ...
@() bl.B1    20.333214  0.135  2  2; ...
@() bl.B2   396.015887  4.300  4  3; ...
@() blUN   1031.243825  13.64  5  4; ...
@() bl52   1031.243825  13.64  5  4; ...
@() blAL   1053.068368  13.64  5  4; ...
@() blL2     45.050387  0.250  3  5; ...
@() blL3    423.729825  4.300  4  6; ...
};
%}

%{
blList={@() model_injModel({'IN' 'DL'})  0.000000  0.006  1  1; ...
@() model_injModel('GS')         0.000000  0.006  1  1; ...
@() model_injModel({'IN' 'SP'})  0.000000  0.006  1  1; ...
%        @() model_injModel({'IN' 'SP'})  4.554244  0.006  1  1; ...
@() model_injModel('BC1')       20.333214  0.135  2  2; ...
%        @() model_injModel('BC1')       30.349789  0.250  3  2; ...
@() model_injModel('BC2')      396.015887  4.300  4  3; ...
@() model_undModel            1031.243825  13.64  5  4; ...
@() model_undModel('52-Line') 1031.243825  13.64  5  4; ...
@() model_ALineModel          1053.068368  13.64  5  4; ...
@() model_linacModel            45.050387  0.250  3  5; ...
@() model_linac3Model          423.729825  4.300  4  6; ...
};
%}

energyDef=model_energySetPoints;

resList=0;
for bl=blList'
    bLine=feval(bl{1});
    if ~isstruct(bLine), bLine=struct('bl',{bLine});end
    for bLine=struct2cell(bLine)'
        beamLine=bLine{:};
        [res,id,idTo,idZ]=parseBeamLine(beamLine,name,nameTo,rOpts);
        res=res & ~resList;

        if any(res)
            resList=resList | res;
            enDef=bl{3};
            beamLine=model_beamLineKlysNameChange(beamLine);
            beamLine=model_beamLineZAppend(beamLine,bl{2});
            beamLine=model_beamLineLAppend(beamLine);
            beamLine=model_beamLineEAppend(beamLine,enDef);
            %        [v,vp]=model_beamLineSAppend(beamLine,[10.448935 0 2017.911482],[-0.610865 0]);
            %        iBX02=find(strcmp(beamLine(:,2),'BX02'),1,'last');
            %        iS100=find(strcmp(beamLine(:,2),'S100'),1,'last');
            %        beamLine(iS100:end,3)=num2cell([beamLine{iS100:end,3}]'+v(iS100,3)-v(iBX02,3)+beamLine{iBX02,3}-beamLine{iS100,3});
            %        beamLine(iBX02:iS100,3)=num2cell(v(iBX02:iS100,3)-v(iBX02,3)+beamLine{iBX02,3});
            %        beamLine(:,8)=beamLine(:,6);
            if (~opts.Z && ~opts.LEFF || opts.EN) && ~opts.design
                enDef=energyDef(bl{4});
                beamLine=model_beamLineAmpPhUpdate(beamLine,id,idTo);
                beamLine=model_beamLineEAppend(beamLine,enDef);
            end
            if nargout > 1 || opts.Z
                zPos(res)=[beamLine{idZ(res),5}];
            end
            if nargout > 2 || opts.LEFF
                lEff(res)=[beamLine{idZ(res),7}];
            end
            if nargout > 3 || opts.EN
                en(res)=[beamLine{idZ(res),6}];
                reg(res)=bl{5};
            end
            if nargout > 4 || opts.K
                isQ=res;isQ(res)=strcmp(beamLine(idZ(res),1),'qu');
                k(res & isQ)=[beamLine{idZ(res & isQ),4}];
            end
            if ~opts.Z && ~opts.LEFF && ~opts.EN && ~opts.K
                idOff=0;
                if ~opts.init
                    idAdd=0;
                    beamLine=beamLine(1:min(end,max([id(res);idTo(res)]+idAdd)),:);
                    if ~any(res & ~idTo)
                        idOff=max(0,min([id(res);idTo(res)]-1-idAdd));
                        beamLine=beamLine(idOff+1:end,:);
                    end
                end
                beamLine=model_beamLineUpdate(beamLine,opts);
                rList=getRMat(beamLine);
                rMat(:,:,res & ~idTo)=rList(:,:,id(res & ~idTo));
                for j=find(res & idTo)'
                    rMat(:,:,j)=rList(:,:,idTo(j)-idOff)*inv(rList(:,:,id(j)-idOff));
                end
            end
        end
        if all(resList), break, end
    end
    if all(resList), break, end
end

if opts.Z, rMat=zPos;end
if opts.LEFF, rMat=lEff;end
if opts.EN, rMat=en;end
if opts.K, rMat=k;end


function [res, id, idTo, idZ] = parseBeamLine(beamLine, name, nameTo, opts)

% Init names.
nList=max([numel(name) numel(nameTo) size(opts,1)])*(numel(name) > 0);
if numel(name) == 1, name(end+1:nList)=name;end
[res,idB,idZ,idE]=findId(beamLine,name);

if isempty(nameTo)
    % Default position is 'END'
    id=selPos(opts,'POS=',idE,[idB idZ idE]);
    idTo=zeros(nList,1);
else
    % Default position is 'MID'
    [idToB,idToM,idToE]=deal(zeros(nList,1));
    [resTo,idToB(:),idToM(:),idToE(:)]=findId(beamLine,nameTo);
    id=selPos(opts,'POS=',idZ,[idB idZ idE]);
    idTo=selPos(opts,'POSB=',idToM,[idToB idToM idToE]);
    res=res & resTo;
end


function [res, idB, idM, idE] = findId(beamLine, name)

[name,d,idU]=unique(name);
[isName,idName]=ismember(beamLine(:,2),name);
num=find(isName);idName=idName(isName);
idB=accumarray(idName,num,[numel(name) 1],@min)-1;
idE=accumarray(idName,num,[numel(name) 1],@max);
idM=accumarray(idName,num,[numel(name) 1],@(x) subsref(sort(x),struct('type','()','subs',{{ceil(numel(x)/2)}})));
idB=idB(idU,1);idM=idM(idU,1);idE=idE(idU,1);
res=idE > 0;


function pos = selPos(opts, tag, pos, posList)

if isempty(opts), return, end
is=strncmpi(opts,tag,length(tag));
use=any(is,2);
id=max(is(use,:)*diag(1:size(opts,2)),[],2);

tags={'BEG' 'MID' 'END'};
for j=1:numel(tags)
    isTag=use;
    isTag(use)=strcmpi(opts(reshape(find(use),[],1)+(id-1)*numel(use)),[tag tags{j}]);
    if numel(use) == 1 && any(isTag), isTag=':';end
    pos(isTag)=posList(isTag,j);
end


function beamLine = model_beamLineZAppend(beamLine, z0)

z=reshape(cumsum([beamLine{:,3}]),[],1);
beamLine(:,5)=reshape(num2cell(z0+z),[],1);


function [v, vp] = model_beamLineSAppend(beamLine, v0, vp0)

n=size(beamLine,1);
[th,ph]=deal(zeros(n,1));
isB=strcmp(beamLine(:,1),'be');
item4List=reshape(vertcat(beamLine{isB,4}),[],7)*[eye(7,1) [zeros(6,1);1]];
th(isB)=-item4List(:,1).*cos(item4List(:,2));
ph(isB)=-item4List(:,1).*sin(item4List(:,2));

cth=vp0(1)+cumsum(th);cph=vp0(2)+cumsum(ph);
cth2=cth-th/2;cph2=cph-ph/2;
lEff=reshape([beamLine{:,4}],[],1);
lEff(isB)=lEff(isB).*util_sinc(item4List(:,1)/2);
vp=lEff(:,[1 1 1]).*[sin(cth2) sin(cph2) cos(cth2).*cos(cph2)];
v=repmat(v0,n,1)+cumsum(vp);
vp=[cth cph];


function beamLine = model_beamLineLAppend(beamLine)

[a,d,idU]=unique(beamLine(:,2));
lEff=accumarray(idU(:),reshape([beamLine{:,3}],[],1));
beamLine(:,7)=reshape(num2cell(lEff(idU,1)),[],1);


function beamLine = model_beamLineEAppend(beamLine, e0)

isACC=strcmp(beamLine(:,1),'lc');
gain=zeros(size(beamLine,1),1);
ampPh=reshape(vertcat(beamLine{isACC,4}),[],3);
gain(isACC)=ampPh(:,2).*cos(ampPh(:,3))*1e-3; % GeV
beamLine(:,6)=reshape(num2cell(e0+cumsum(gain)),[],1);


function [beamLine, nameAcc, isAcc] = model_beamLineKlysNameChange(beamLine)

% Find unique names of accelerating structures in BEAMLINE.
isAcc=strcmp(beamLine(:,1),'lc');
nameAcc=beamLine(isAcc,2);
nameAcc=strrep(nameAcc,'K','');
nameAcc=strrep(nameAcc,'a','');
nameAcc=strrep(nameAcc,'b','');
nameAcc=strrep(nameAcc,'c','');
nameAcc=strrep(nameAcc,'d','');
nameAcc=strrep(nameAcc,'_','-');
nameAcc=strrep(nameAcc,'21-1','L1S');
beamLine(isAcc,2)=nameAcc;


function beamLine = model_beamLineAmpPhUpdate(beamLine, id, idTo)

% Find unique names of accelerating structures in BEAMLINE.
[beamLine,nameAcc,isAcc]=model_beamLineKlysNameChange(beamLine);
[nameAcc,d,idAcc]=unique(nameAcc);idAcc=reshape(idAcc,[],1);

% Find device request range.
is=model_energyKlys(nameAcc,1);
is0=[is.L0 is.L1 is.L2 is.L3];
id=[id;idTo];
range=[min(id(id > 0)) max(id(id > 0))];
if ~any(idTo), range(1)=1;end
idK=is0(idAcc,:).*repmat(find(isAcc),1,4);
idK(idK < range(1) | idK > range(2))=0;
use=any(idK);is0(:,~use)=0;
isU=any(is0,2);

%num=find(isAcc);

% Get actual amplitude & phase.
[aDes(isU,1),pDes(isU,1)]=model_energyKlys(nameAcc(isU));
aDes(~isU,1)=1;pDes(~isU,1)=0;

% Fudge amplitude & phase.
[d,d,aDes,pDes]=model_energyFudge(aDes,pDes,is);

% Get design energy profile from BEAMLINE.
ampPh=reshape(vertcat(beamLine{isAcc,4}),[],3);
ampU=accumarray(idAcc,ampPh(:,2));
powFac=ampPh(:,2)./ampU(idAcc,1);

% Update amp and phase in BEAMLINE.
ampPh(:,2)=aDes(idAcc).*powFac; % in MeV
ampPh(:,3)=pDes(idAcc)*pi/180; % in radians
beamLine(isAcc,4)=reshape(num2cell(ampPh,2),[],1);


function beamLine = model_beamLineUpdate(beamLine, opts)

[d,d,modelSimul]=model_init;
name=beamLine(:,2);

% Find energy
energyList=reshape([beamLine{:,6}],[],1);
%enDes=reshape([beamLine{:,8}],[],1);

% Find lengths
lenList=reshape([beamLine{:,7}],[],1);

% Find cases
isQ=strcmp(beamLine(:,1),'qu');
isB=strcmp(beamLine(:,1),'be');
isU=strcmp(beamLine(:,1),'un');
isL=strcmp(beamLine(:,1),'lc');
isT=strcmp(beamLine(:,1),'tc');

% Keep original params for non undulator magnets.
isQBnU=ismember(beamLine(:,1),{'qu' 'be'}) & ~ismember(name,strcat('QU',num2str((1:33)','%02d')));
bl=beamLine(isQBnU,4);

% Quad
if opts.init
    bpList=energyList(isQ,1)/299.792458*1e4; % kG m
    control_magnetSet(name(isQ),reshape([beamLine{isQ,4}],[],1).*bpList.*lenList(isQ,1),'action','SAVE_BDES');
elseif ~opts.design
    k10=reshape([beamLine{isQ,4}],[],1);
    k1=model_k1Get(name(isQ),lenList(isQ)',energyList(isQ)');
    k1(isnan(k1))=k10(isnan(k1));
    beamLine(isQ,4)=reshape(num2cell(k1),[],1);
end

% Bend
itemB=beamLine(isB,:);
item4List=reshape(vertcat(itemB{:,4}),[],7);
use=abs(item4List(:,1)) > 0.15 | reshape([itemB{:,5}],[],1) > 1.2e3; % non-chicane bends in GeV/c
use(strncmp(itemB(:,2),'B2',2))=false;
lenB=lenList(isB,1);energyB=energyList(isB,1);
isKIK=strncmp(itemB(:,2),'BXKIK',5) | strncmp(itemB(:,2),'BYKIK',5);
use(isKIK)=false;
if opts.init
    val(use)=energyB(use);
    bpList=energyB(~use,1)/299.792458*1e4; % kG m
    val(~use)=abs(item4List(~use,1))./reshape([itemB{~use,3}],[],1).*bpList.*lenB(~use,1);
    control_magnetSet(name(isB),val,'action','SAVE_BDES');
elseif ~opts.design
    [k1,bAct]=model_k1Get(name(isB),lenB',energyB');
    k1(isKIK)=0;bAct(isKIK)=0;
    bad=reshape(isnan(k1),[],1);u1=use & ~bad;u2=~use & ~bad;
    item4List(u1,[1 3 4])=item4List(u1,[1 3 4]).*repmat(bAct(u1,1)./energyB(u1,1),1,3);
    %    k1=1/rho=angle/l;item{5}(1)=angle=l*k1, item{5}(3:4)=E1,2
    tmp=k1(1,u2)'.*reshape([itemB{u2,3}],[],1);
    item4List(u2,3:4)=item4List(u2,3:4).*repmat(tmp./abs(item4List(u2,1)),1,2);
    item4List(u2,1)=sign(item4List(u2,1)).*tmp;
    beamLine(isB,4)=reshape(num2cell(item4List,2),[],1);
end

% Restore original params for non undulator magnets in model simul.
if modelSimul, beamLine(isQBnU,4)=bl;end

% Undulator
item4List=reshape(vertcat(beamLine{isU,4}),[],2);
lamuList=item4List(:,2);
if opts.init
    Kund=sqrt(item4List(:,1))/2/pi.*lamuList*sqrt(2).*(energyList(isU,1)/510.99906e-6);
    if any(isU), lcaPutSmart(strcat(model_nameConvert(name(isU)),':KACT'),Kund);end
elseif ~opts.design
    Kund=control_magnetGet(name(isU));
    if modelSimul
        Kund=Kund.*lcaGet('SIOC:SYS0:ML00:AO877');
    end
    kqund=(Kund*2*pi./lamuList/sqrt(2)./(energyList(isU,1)/510.99906e-6)).^2;
    item4List(:,1)=kqund;
    beamLine(isU,4)=reshape(num2cell(item4List,2),[],1);
end

% Acceleration
itemL=beamLine(isL,:);
item4List=reshape(vertcat(itemL{:,4}),[],3);
item4List(:,4)=energyList(isL,1)*1e3-item4List(:,2).*cosd(item4List(:,3)); % MeV, initial energy
beamLine(isL,4)=reshape(num2cell(item4List,2),[],1);

% Tranverse deflector
item4List=reshape(vertcat(beamLine{isT,4}),[],2);
if opts.init
    %    bp=model_energy(name(isT))/299.792458*1e4; % kG m
    %    control_magnetSet(name(isT),item{5}*bp*2*item{4});
elseif ~opts.design
    aAct=bitand(control_klysStatGet(name(isT)),1);
    pAct=control_phaseGet(name(isT));
    item4List(:,1)=reshape(aAct,[],1)*.5e-1;
    item4List(:,2)=reshape(pAct,[],1);
    beamLine(isT,4)=reshape(num2cell(item4List,2),[],1);
end


function rList = getRMat(beamLine)

r=eye(6);
nElem=size(beamLine,1);
rList=repmat(r,[1 1 nElem]);

if 0
    r0=rList;
    for j=1:nElem
        r0(:,:,j)=model_rMatElement(beamLine{j,[1 3 4]});
    end
else
    r0=model_rMatElements(beamLine(:,1),beamLine(:,3),beamLine(:,4));
end

r0(5,6,:)=r0(5,6,:)+reshape([beamLine{:,3}]./([beamLine{:,6}]/510.99906e-6).^2,1,1,[]);
for j=1:nElem
    r=r0(:,:,j)*r;
    rList(:,:,j)=r;
end


function val = util_sinc(phi)

bad=~phi;
val(bad)=1;
val(~bad)=sin(phi(~bad))./phi(~bad);
val=reshape(val,size(phi));
