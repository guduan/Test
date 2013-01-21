function lines = model_parseMAD(file, nOut, blList)

if nargin < 3, blList={'LCLS2' 'LCLS2H' 'LCLS2S' 'SPECT6' 'SPECT135'};end
if nargin < 2, nOut=[];end
if nargin < 1, file='LCLSII_MAIN.mad8';nOut='LCLSII';end
if strcmp(file,'LCLS_MAIN.mad8')
    blList={'LCLS'   {'GUNL0A' 'L0B' 'LCLS'}; ...
            'SPECBL' {'GUNL0A' 'L0B' 'DL1A' 'SPECBL'}; ...
            'B52'    {'GUNL0A' 'L0B' 'DL1' 'L1' 'BC1' 'L2' 'BC2' 'L3' 'RWWAKESS' 'BSY' 'B52LIN'}; ...
            'GSPEC'  {'GUNBXG' 'GSPEC'}};
end

% Read MAD file.
str=textread(file,'%s','whitespace','\b\t');
disp(['Read MAD file ' file ' done.']);
%str0=str;
tags={};

lines={};
if ~isempty(nOut)
    lines={['function beamLine = model_beamLine' nOut '()']; ...
        ''; ...
        'CLIGHT = 2.99792458e8;  % speed of light [m/s]'; ...
        'TWOPI  = 2*pi;'; ...
        'RADDEG = pi/180;'; ...
        'EMASS  = 0.510998910e-3;  % electron rest mass [GeV/c]'; ...
        ''; ...
        'clight = 2.99792458e8;  % speed of light [m/s]'; ...
        'LQGX   = 0.076;                  % QG quadrupole effective length [m]'; ...
        'IMS1={''mo'' ''IMS1'' 0 []}'';%135-MeV spectrometer'; ...
        'LBRL = 0.52974;'; ...
        'UNDSTART={''mo'' ''UNDSTART'' 0 []}'';'; ...
        'UNDTERM={''mo'' ''UNDTERM'' 0 []}'';'; ...
        'LSTPR  = 0.3046;'; ...
        'LSOL1    = 0.200;'; ...
        'DLD3    = 0.300+0.167527-0.1799554;'; ...
        'DLD4    = 0.200+0.1799554;'; ...
        'XC11={''mo'' ''XC11'' 0 []}'';'; ...
        'YC11={''mo'' ''YC11'' 0 []}'';'; ...
        'XCA11={''mo'' ''XCA11'' 0 []}'';'; ...
        'YCA11={''mo'' ''YCA11'' 0 []}'';'; ...
        'XCA12={''mo'' ''XCA12'' 0 []}'';'; ...
        'YCA12={''mo'' ''YCA12'' 0 []}'';'; ...
        'SC11=[XC11,YC11];'; ...
        'SCA11=[XCA11,YCA11];'; ...
        'SCA12=[XCA12,YCA12];'; ...
        };
end

out=struct('comment',{},'assign',{},'name',{},'items',{});
while ~isempty(str)
    [tag,str]=getTag(str);
    tags=[tags(1:end);{tag}];
    out=[out(1:end);parseTag(tag)];
    lines=[lines(1:end);{makeLine(out(end))}];
    if ~isempty(out(end).items) && strcmp(out(end).items{1},'CALL')
        lines=[lines(1:end-1);model_parseMAD(out(end).items{2,2}(2:end-1))];
    end
end
disp(['Parse MAD file ' file ' done.']);

% Fix undulator mess.
isU=find(~cellfun('isempty',strfind(lines,'''un''')));
a=regexp(lines(isU),'(?<=\[)\w*','match');

for j=1:numel(a)
    id=find(strncmpi({out.assign},a{j},numel(a{j}{1})),1);
    tag=regexp(out(id).assign,'(?<=2*pi/)\w*(?=/sqrt)','match');
    lines(isU(j))=strrep(lines(isU(j)),[a{j}{1} ' ' a{j}{1}],[a{j}{1} ' ' tag{1}]);
end
disp('Miscellaneous done.');

if ~isempty(nOut)
    if isvector(blList)
        lines=[lines;strcat('beamLine.',blList(:),'=',blList(:),''';')];
    else
        for j=1:size(blList,1)
            lines=[lines(1:end); ...
                {['beamLine.' blList{j,1} '=[' sprintf('%s,',blList{j,2}{1:end-1}) blList{j,2}{end} ']'';']}];
        end
    end
    fid=fopen(['model_beamLine' nOut '.m'],'w');
    fprintf(fid,'%s\n',lines{:});
    fclose(fid);
    disp(['Write Matlab file ' ['model_beamLine' nOut '.m'] ' done.']);
end


function [tag, lines] = getTag(lines)

tag=regexp(lines{1},'!','split');tcom=[tag{2:end}];tag=tag{1};
if ~isempty(tcom), tcom=['!' tcom];end
lines(1)=[];comment={};
while any(tag == '&')
    if strncmp(lines(1),'!',1)
        comment=[comment(1:end);lines(1)];
    else
        l=regexp(lines{1},'!','split');rem=[l{2:end}];l=l{1};
        if ~isempty(rem), rem=['!' rem];end
        id=find(tag == '&',1);
        tag=[tag(1:id-1) l tag(id+1:end) tcom rem];
    end
    lines(1)=[];
end
tag=[tag tcom];
lines=[comment;lines];


function tag = repTag(tag)

tag=strrep(tag,'ASIN(','asin(');
tag=strrep(tag,'ACOS(','acos(');
tag=strrep(tag,'ATAN2(','atan2(');
tag=strrep(tag,'SIN(','sin(');
tag=strrep(tag,'COS(','cos(');
tag=strrep(tag,'SQRT(','sqrt(');
tag=strrep(tag,'2*PI','2*pi'); % only if upper() is used
tag=strrep(tag,'[L]','{3}');
tag=regexprep(tag,'\[(\w*)\]','.$1');

tag=strrep(tag,'GBpm0','GBpm'); % Special for LCLS
tag=strrep(tag,'GBPM0','GBPM'); % Special for LCLS


function out = parseTag(tag)

tag=[regexp(tag,'!','split') {''}];
out=struct('comment',tag{2},'assign','','name','','items',{{}});
tag{1}=upper(tag{1});

% Replace strings
tag=repTag(tag{1});

% Comment
if isempty(tag), return, end

% Assignment
if any(strfind(tag,':=')) || any(strfind(tag,': ='))
    out.assign=[regexprep(tag,':=|: =','=') ';'];
    return
end

% Definition
if any(strfind(tag,':'))
    tag=regexp(tag,':','split');
    out.name=strtrim(tag{1});tag=tag{2};
end

% Command
patt='(?<!\([^\)]*),';
out.items=regexp(tag,patt,'split');
out.items=regexp(out.items,'=','split');
out.items=makeArray(out);


function items = makeArray(out)

use=cellfun('length',out.items)==1;
items(use,:)=[reshape(vertcat(out.items{use}),[],1) repmat({''},sum(use),1)];
items(~use,:)=reshape(vertcat(out.items{~use}),[],2);
items=strtrim(items);


function line = makeLine(out)

% Assignment
if ~isempty(out.assign)
    line=out.assign;
else
    line='';
end

% Definition
if ~isempty(out.name) && ~isempty(out.items)
    switch out.items{1}
        case 'CONSTANT'
            line=[out.name '=' out.items{2} ';'];
        case {'DRIF' 'DRIFT'}
            vals=findTags(out.items,{'L'});
            line=[out.name '={''dr'' ''' ''' ' vals{1} ' []}'';'];
        case {'MONI' 'HKIC' 'HKICK' 'VKIC' 'VKICK' 'PROF' 'WIRE' 'IMON' 'BLMO' 'INST'}
            vals=findTags(out.items,{'L'});
            line=[out.name '={''mo'' ''' out.name ''' ' vals{1} ' []}'';'];
        case 'MARK'
%            line=[out.name '={''mo'' ''' ''' 0 []}'';'];
            line=[out.name '={''mo'' ''' out.name ''' 0 []}'';'];
        case {'RCOL' 'ECOL' 'SOLE' 'SOLENOID'}
            vals=findTags(out.items,{'L'});
            line=[out.name '={''dr'' ''' out.name ''' ' vals{1} ' []}'';'];
        case 'QUAD'
            vals=findTags(out.items,{'L' 'K1'});
            line=[out.name '={''qu'' ''' out.name ''' ' vals{1} ' ' vals{2} '}'';'];
        case 'SBEN'
            vals=findTags(out.items,{'L' 'ANGLE' 'HGAP' 'E1' 'E2' 'FINT' 'FINTX' 'TILT'});
            if isempty(vals{8}), vals{8}='pi/2';end
            line=[out.name '={''be'' ''' out.name(1:end-1) ''' ' vals{1} ' [' vals{2} ' ' ...
                vals{3} ' ' vals{4} ' ' vals{5} ' ' vals{6} ' ' vals{7} ' ' vals{8} ']}'';'];
        case 'LCAV'
            vals=findTags(out.items,{'L' 'FREQ' 'DELTAE' 'PHI0'});
            name=regexprep(out.name,'___.','');
            name=regexprep(name,'__.','');
            name=regexprep(name,'(_..).','$1');
            line=[out.name '={''lc'' ''' name ''' ' vals{1} ...
                ' [' vals{2} ' ' vals{3} ' ' vals{4} '*TWOPI]}'';'];
        case {'MATR' 'MATRIX'}
            vals=findTags(out.items,{'L' 'RM(3,3)'});
            vals(2)=regexp(vals{2},'(?<=sqrt\()\w*(?=\))','match');
            line=[out.name '={''un'' ''' out.name ''' ' vals{1} ...
                ' [' vals{2} ' ' vals{2} ']}'';'];
        case 'LINE'
            out.items{1,2}=regexprep(out.items{1,2},'(\d*)\*(\w*)','${repmat([$2 '',''],1,str2num($1)-1)}$2');
            line=[out.name '=' strrep(strrep(out.items{1,2},'(','['),')',']') ';'];
        case 'SUBROUTINE'
        case 'BETA0'
            vals=[strcat('''',out.items(2:end,1)','''');out.items(2:end,2)'];
            if ~isempty(vals)
                line=[out.name '=struct(' sprintf('%s,%s,',vals{1:end-1}),vals{end},');'];
            end
        otherwise
            if size(out.items,1) == 1 && ~any(strfind(out.name,'"')) && isempty(out.items{1,2})
                line=[out.name '=' out.items{1} ';' out.name '{2}=''' out.name ''';'];
            end
    end
end

% Add comment.
if ~isempty(out.comment)
    line=[line '%' out.comment];
end


function tagVals = findTags(items, tags)

tagVals=repmat({'0'},numel(tags),1);
for j=1:numel(tags)
    id=find(strcmp(items(:,1),tags{j}),1,'last');
    if any(id), tagVals{j}=items{id,2};end
end
