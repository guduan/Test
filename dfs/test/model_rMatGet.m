function [rMat, zPos, lEff, twiss, energy, n] = model_rMatGet(nameList, nameTo, opts, param)
%MODEL_RMATGET
% [RMAT, ZPOS, LEFF, TWISS, ENERGY] = MODEL_RMATGET(NAMELIST, NAMETO, OPTS, PARAM)
% gets transport matrix RMAT, z position ZPOS, effective length LEFF, Twiss
% params TWISS [energy phi_x beta_x alpha_x eta_x eta'_x phi_y ... eta'_y]'
% and energy ENERGY for devices in string or cellstr array NAMELIST. Names
% can be in MAD, EPICS, or SLC format. The model data is retrieved from SLC
% or XAL depending on the setting of the global variable "modelSource". If
% set to 'SLC', data is taken from the SLC model, if set to 'EPICS', the
% source is XAL. The default is 'EPICS'. If NAMETO is not empty, the R-matrix
% is calculated from NAMELIST to NAMETO with both being arrays of same
% length or one scalar. OPTS are passed to AIDAGET(). If param is given and
% is 'Z', 'LEFF', 'twiss', or 'EN', then only this value is returned as
% RMAT.

% Features:

% Input arguments:
%    NAMELIST: Char or cellstr (array) of device names in MAD, EPICS, or SLC
%    NAMETO: Char or cellstr (array) of device names for from-to matrix (optional)
%    OPTS: Options passed to aidaget(), optional
%    PARAM: Optional parameter to only get 'Z', 'LEFF', 'twiss', or 'EN' returned

% Output arguments:
%    RMAT: Transport matrix(es) to NAMELIST or from NAMELIST to NAMETO
%    ZPOS: z-position of element(s) in NAMELIST (element.S from XAL, //Z from SCP
%    LEFF: Effective length of element(s) in NAMELIST
%    TWISS: Twiss parameters a element(s) in NAMELIST
%    ENERGY: Energy at element(s) in NAMELIST

% Compatibility: Version 7 and higher
% Called functions: aidaget, model_nameConvert, model_rMatModel,
%                   model_twissGet

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
[modelSource,modelOnline]=model_init;

paramDef={'R' 'Z' 'LEFF' 'twiss' 'EN'};
if nargin < 4, param=[];end
if isempty(param), param=paramDef;end
[d,id1]=ismember(param,paramDef);
[d,id2]=setdiff(paramDef,param);idPar=[id1 sort(id2)];
param=paramDef(idPar(1:min(max(1,nargout),5)));

if nargin < 3, opts={};end
if nargin < 2, nameTo={};end    
if isempty(opts), opts={};end
if isempty(nameTo), nameTo={};end

nameList=cellstr(nameList);
nameTo=cellstr(nameTo);
opts=cellstr(opts);
nList=max(numel(nameList),numel(nameTo));
rMat=repmat(eye(6),[1 1 nList]);
twiss=repmat([1 0 1 0 0 0 0 1 0 0 0]',1,nList);
zPos=zeros(1,nList);lEff=zeros(1,nList);energy=ones(1,nList);

if modelOnline && ~ismember(modelSource,{'MATLAB'})
    zLCLS=2014.701916; % in m, begin of LCLS injector relative to linac
    if any(strcmp(nameList,'*'))
            [rMat,pos,twiss,lEff,n,zPos]=getAllTwiss('FullMachine',opts);
            zPos=zPos'-zLCLS;energy=twiss(1,:);
        return
    end
    nameList=model_nameConvert(nameList,modelSource);
    nameTo=model_nameConvert(nameTo,modelSource);
    rzDone=0;
    if strcmp(modelSource,'EPICS')
        nameList=model_nameXAL(nameList,1);
        nameTo=model_nameXAL(nameTo,1);
    end

    % Get R and/or Z from table
    useTable=nList > 4 & strcmp(modelSource,'EPICS') & ~any(strncmp(opts(:),'RUN=',4));
    if useTable && any(ismember(param,{'R' 'Z'}))
        resList=0;
        blList={'FullMachine' 'CathodeTo135MeVSpect' 'CathodeTo52SL2' 'CathodeToGunSpect'};
        for bl=blList
            [nameEpics,pos,r,z,n]=getAllR(bl{:},opts);
            beamLine=[nameEpics pos reshape(num2cell(z),[],1) n];
            [res,id,idTo,z,l]=parseBeamLine(beamLine,nameList,nameTo,opts);
            res=res & ~resList;
            if any(res)
                resList=resList | res;
                zPos(res)=z(res)-zLCLS;
                rMat(:,:,res & ~idTo)=r(:,:,id(res & ~idTo));
                for j=find(idTo)
                    rMat(:,:,j)=r(:,:,idTo(j))*inv(r(:,:,id(j)));
                end
            end
            if all(resList), break, end
        end
        rzDone=1;
        if nargout < 3, nList=0;end % Skip to the end
    end
    
% Get twiss and/or LEFF from table
    if useTable && any(ismember(param,{'LEFF' 'twiss' 'EN'}))
        resList=0;
        blList={'FullMachine' 'CathodeTo135MeVSpect' 'CathodeTo52SL2' 'CathodeToGunSpect'};
        for bl=blList
            [nameEpics,pos,t,l,n]=getAllTwiss(bl{:},opts);
            beamLine=[nameEpics pos reshape(num2cell(l),[],1) n];
            [res,id,idTo,l]=parseBeamLine(beamLine,nameList,{},opts);
            res=res & ~resList;
            if any(res)
                resList=resList | res;
                lEff(res)=l(res);
                twiss(:,res)=t(:,id(res));
                energy(res)=twiss(1,res);
            end
            if all(resList), break, end
        end
        rzDone=1;
        if nargout < 6, nList=0;end % Skip to the end
    end
    
    % Different default for XAL (A-B)
    if ~isempty(nameTo) && strcmp(modelSource,'EPICS')
        opts(:,3:end+2)=opts;
        opts(:,1)={'POS=MID'};
        opts(:,2)={'POSB=MID'};
    end

    for j=1:nList
        name=nameList{min(end,j)};
        if ~mod(j,50), disp({j name});end
        micro=name(find(name == ':',1)+1:find(name == ':',1,'last')-1);
        useE=ismember(micro,{'BSY0' 'LTU0' 'LTU1' 'UND1' 'DMP1'});
        nT=nameTo;if ~isempty(nT), nT=strcat('B=',nT(min(end,j)));end
        opt=opts;if ~isempty(opt), opt=opt(min(end,j),:);end
%        if isempty(param) && ~rzDone
        if ismember('R',param) && ~rzDone
            try
                rMat(:,:,j)=reshape(cell2mat(aidaget([name '//R'],'doublea',[nT opt])),6,6)';
            catch
                disp(['AIDA Error: No R matrix available for ' name]);
            end
        end
        str='Z';if strcmp(modelSource,'EPICS') || useE, str='element.S';end
%        if (nargout > 1 || strcmp(param,'Z')) && ~rzDone
        if ismember('Z',param) && ~rzDone
            try
                zPos(j)=getLen([name '//' str])-zLCLS;
            catch
                disp(['AIDA Error: No Z location available for ' name]);
            end
        end
        str='LEFF';if strcmp(modelSource,'EPICS') || useE, str='element.effective_length';end
        if ismember('LEFF',param) && (any(strncmp(name,{'SOLN' 'QUAD'},4)) || strcmp(modelSource,'EPICS')) && ~rzDone
            try
                lEff(j)=getLen([name '//' str]);
            catch
                disp(['AIDA Error: No effective length available for ' name]);
            end
        end
        if any(ismember({'twiss' 'EN'},param)) && ~strncmp(name,'SOLN',4)
            % Twiss parameters are [En (mu b a D Dp)_x (mu b a D Dp)_y]
            try
                t=cell2mat(aidaget([name '//twiss'],'doublea',opts));
                twiss(:,j)=t(1:11);energy(j)=t(1);
            catch
                disp(['AIDA Error: No twiss parameters available for ' name]);
            end
        end
    end
else
    if any(ismember({'R' 'twiss'},param))
        [rMat,zPos,lEff,energy,reg]=model_rMatModel(nameList,nameTo,opts);
    elseif ismember('EN',param)
        [d,zPos,lEff,energy]=model_rMatModel(nameList,nameTo,opts,'Z',1,'LEFF',1,'EN',1);
%        energy(:)=model_energy(nameList,opts);
    elseif any(ismember({'Z' 'LEFF'},param))
        [d,zPos,lEff]=model_rMatModel(nameList,nameTo,opts,'Z',1,'LEFF',1);
    end
    if ismember('twiss',param)
        % Twiss parameters are [En (mu b a D Dp)_x (mu b a D Dp)_y]
%        if ~isempty(nameTo), for j=1:size(rMat,3), rMat(:,:,j)=inv(rMat(:,:,j));end, end
        [twissT,d,d,psi]=model_twissGet(nameList,opts,'rMat',rMat,'en',energy,'reg',reg);
%        twissT=[0 0;twissT(2:end,:);0 0;0 0];
%        twiss(1,:)=energy;
        twiss([1 2 7 3 4 8 9],:)=[energy;psi;reshape(twissT(2:3,:),4,[])];
        twiss([5 6 10 11],:)=squeeze(rMat(1:4,6,:))./repmat(squeeze(rMat(6,6,:))',4,1); % Dispersion, R_16,26/R_66
    end
end

% Assemble list of requested output values.
val={rMat,zPos,lEff,twiss,energy};
[rMat,zPos,lEff,twiss,energy]=deal(val{idPar});


function len = getLen(name)

global da
aidainit;
if isempty(da), da=DaObject;end

%
% Connect to message log
%
Logger = edu.stanford.slac.err.Err.getInstance('model_rMatGet.m');

da.reset;
try
    len=da.getDaValue(name).elementAt(0);
catch
    Logger.logl(sprintf('Aida getDaValue(%s) failure in function getLen(%s).',name,name));
end
if ~strcmp(class(len),'double')
    len=len.getDouble;
end


function [nameEpics, pos, r, zPos, nameMad] = getAllR(name, opts)

global da
aidainit;
if isempty(da), da=DaObject;end

%
% Connect to message log
%
Logger = edu.stanford.slac.err.Err.getInstance('model_rMatGet.m');

type='extant';
typOpt=[opts{find(strncmp(opts,'TYPE=',5),1,'last')}];
if ~isempty(typOpt), type=lower(typOpt(6:end));end
if strcmp(type,'database'), type='extant';end
type(1)=upper(type(1));

da.reset;
for opt=opts(:)', da.setParam(opt);end
try
    tbl=da.getDaValue(['modelRmats//' type '.' name]);
%{
    num=tbl.get(0).getDoubles;
    nameMad=cellstr(char(tbl.get(1).getStrings));
    nameEpics=cellstr(char(tbl.get(2).getStrings));
    pos=cellstr(char(tbl.get(3).getStrings));
    zPos=tbl.get(4).getDoubles;
%}
    num=cell2mat(cell(tbl.get(0).toArray));
    nameMad=cellstr(char(tbl.get(1).toArray));
    nameEpics=cellstr(char(tbl.get(2).toArray));
    pos=cellstr(char(tbl.get(3).toArray));
    zPos=cell2mat(cell(tbl.get(4).toArray));

    r=zeros(36,length(num));
    for j=1:36
%        r(j,:)=tbl.get(4+j).getDoubles;
        r(j,:)=cell2mat(cell(tbl.get(4+j).toArray));
    end
catch
    [nameEpics,pos,nameMad]=deal(cell(0,1));
    [r,zPos]=deal(zeros(0,1));
    Logger.logl(sprintf('Aida getDaValue(%s) failure in function getAllR.',['modelRmats//' type '.' name]));
end
r=permute(reshape(r,6,6,[]),[2 1 3]);


function [nameEpics, pos, twiss, lEff, nameMad, zPos] = getAllTwiss(name, opts)

global da
aidainit;
if isempty(da), da=DaObject;end

%
% Connect to message log
%
Logger = edu.stanford.slac.err.Err.getInstance('model_rMatGet.m');

type='extant';
typOpt=[opts{find(strncmp(opts,'TYPE=',5),1,'last')}];
if ~isempty(typOpt), type=lower(typOpt(6:end));end
if strcmp(type,'database'), type='extant';end
type(1)=upper(type(1));

da.reset;
for opt=opts(:)', da.setParam(opt);end
try
    tbl=da.getDaValue(['modelTwiss//' type '.' name]);
%{
    num=tbl.get(0).getDoubles;
    nameMad=cellstr(char(tbl.get(1).getStrings));
    nameEpics=cellstr(char(tbl.get(2).getStrings));
    pos=cellstr(char(tbl.get(4).getStrings));
    zPos=tbl.get(3).getDoubles;
    lEff=tbl.get(5).getDoubles;
%}
    num=cell2mat(cell(tbl.get(0).toArray));
    nameMad=cellstr(char(tbl.get(1).toArray));
    nameEpics=cellstr(char(tbl.get(2).toArray));
    pos=cellstr(char(tbl.get(4).toArray));
    zPos=cell2mat(cell(tbl.get(3).toArray));
    lEff=cell2mat(cell(tbl.get(5).toArray));

    twiss=zeros(11,length(num));
    for j=1:11
%        twiss(j,:)=tbl.get(5+j).getDoubles;
        twiss(j,:)=cell2mat(cell(tbl.get(5+j).toArray));
    end
catch
    [nameEpics,pos,nameMad]=deal(cell(0,1));
    [twiss,lEff,zPos]=deal(zeros(0,1));
    Logger.logl(sprintf('Aida getDaValue(%s) failure in function getAllTwiss.',['modelTwiss//' type '.' name]));
end


function [res, id, idTo, zPos, lEff] = parseBeamLine(beamLine, name, nameTo, opts)

% Init names.
nList=max([numel(name) numel(nameTo) size(opts,1)]);
[res,id,idTo,idZ,zPos,lEff]=deal(zeros(1,nList));
res=logical(res);

% Loop through names.
for j=1:nList
    opt=opts;if ~isempty(opt), opt=opt(min(end,j),:);end
    
    [res(j),idB,idZ(j),idE,lEff(j)]=findId(beamLine,name{min(end,j)});
    if ~res(j), continue, end
    % Default position is 'END'
    id(j)=idE;

    % Default position is 'MID'
    if ~isempty(nameTo)
        [res(j),idToB,idTo(j),idToE]=findId(beamLine,nameTo{min(end,j)});
        if ~res(j), continue, end
        id(j)=idZ(j);
        idTo(j)=selPos(opt,'POSB=',idTo(j),[idToB idTo(j) idToE]);
    end
    id(j)=selPos(opt,'POS=',id(j),[idB idZ(j) idE]);
end
zPos(res)=[beamLine{idZ(res),3}];


function [res, idB, idM, idE, lEff] = findId(beamLine, name)

[id,idB,idM,idE,lEff]=deal(0);
idList=find(strcmp(beamLine(:,1),name));
res=~isempty(idList);
if ~res, return, end

%idB=idList(1);
%idM=idList(ceil(end/2));
%idE=idList(end);

idB=idList(find(strcmp(beamLine(idList,2),'BEGIN'),1));
idM=idList(find(strcmp(beamLine(idList,2),'MIDDLE'),1));
idE=idList(find(strcmp(beamLine(idList,2),'END'),1,'last'));
if isempty(idM), idM=idB;end
if isempty(idB), idB=idM;end
if isempty(idE), idE=idB;end

lEff=diff([beamLine{[idB idE],3}]);


function pos = selPos(opt, str, pos, posList)

isPos=find(strncmp(upper(opt),str,length(str)),1,'last');
if ~isempty(isPos)
    switch upper(opt{isPos}(length(str)+1:end))
        case 'BEG'
            pos=posList(1);
        case 'MID'
            pos=posList(2);
        case 'END'
            pos=posList(3);
    end
end
