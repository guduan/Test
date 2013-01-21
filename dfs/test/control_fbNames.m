function fdbkList = control_fbNames(name)

if nargin < 1, name='';end

fdbkList={};
list0={ ...
    'IOC:BSY0:MP01:BYKIKCTL'; ... % MPS BYKIK disable during scan (0=KICK,1=PASS)
    'SIOC:SYS0:ML00:AO058'; ...   % Joe's 6x6 feedback (0=OFF,1=ON)
    'FBCK:FB04:LG01:MODE'; ...    % New 6x6 feedback (0=OFF,1=ON)
};
listDL2={ ...
    'DUMP:LTU1:970:TDUND_PNEU'; ... % TDUND (0=Insert,1=Retract)
    'SIOC:SYS0:ML00:AO058'; ...   % Joe's 6x6 feedback (0=OFF,1=ON)
    'FBCK:FB04:LG01:MODE'; ...    % New 6x6 feedback (0=OFF,1=ON)
    'FBCK:LNG9:1:ENABLE'; ...     % DL2 EPICS energy feedback (0=OFF,1=ON)
    'FBCK:LNG8:1:ENABLE'; ...     % DL2 EPICS energy feedback (0=OFF,1=ON)
    'FBCK:FB02:TR02:MODE'; ...    % new LI28 launch feedback (0=OFF, 1=ON)
    'FBCK:L280:1:ENABLE'; ...     % LI28 launch feedback (0=OFF, 1=ON)
    'FBCK:FB02:TR03:MODE'; ...    % new BSY launch feedback (0=OFF, 1=ON)
    'FBCK:BSY0:1:ENABLE'; ...     % BSY launch feedback (0=OFF, 1=ON)
    'FBCK:FB03:TR01:MODE'; ...    % new LTU launch feedback (0=OFF, 1=ON)
    'FBCK:LTL0:1:ENABLE'; ...     % LTU launch feedback (0=OFF, 1=ON)
    'FBCK:UND0:1:ENABLE'; ...     % Undulator launch feedback (0=OFF, 1=ON)
};
listL3=[list0;{ ...
    'FBCK:LNG9:1:ENABLE'; ...     % DL2 EPICS energy feedback (0=OFF,1=ON)
    'FBCK:LNG8:1:ENABLE'; ...     % DL2 EPICS energy feedback (0=OFF,1=ON)
}];
listL2=[listL3;{ ...
%    'SIOC:SYS0:ML00:AO023'; ...   % BC2 energy feedback (0=OFF,1=ON)
    'FBCK:FB02:TR02:MODE'; ...    % new LI28 launch feedback (0=OFF, 1=ON)
    'FBCK:L280:1:ENABLE'; ...     % LI28 launch feedback (0=OFF, 1=ON)
    'FBCK:FB02:TR01:MODE'; ...    % new L3 launch feedback (0=OFF, 1=ON)
    'FBCK:L3L0:1:ENABLE'; ...     % L3 launch feedback (0=OFF, 1=ON)
    'FBCK:LNG7:1:ENABLE'; ...     % BC2 EPICS energy feedback (0=OFF,1=ON)
    'FBCK:LNG6:1:ENABLE'; ...     % BC2 EPICS energy feedback (0=OFF,1=ON)
    'FBCK:LNG5:1:ENABLE'; ...     % BC2 EPICS energy feedback (0=OFF,1=ON)
    'FBCK:LNG4:1:ENABLE'; ...     % BC2 EPICS energy feedback (0=OFF,1=ON)
}];
listL1=[listL2;{ ...
    'FBCK:FB01:TR04:MODE'; ...    % new L2 launch feedback (0=OFF, 1=ON)
    'FBCK:L2L0:1:ENABLE'; ...     % L2 launch feedback (0=OFF, 1=ON)
    'FBCK:LNG3:1:ENABLE'; ...     % longitudinal feedback in the injector (0=OFF,1=ON)
    'FBCK:LNG2:1:ENABLE'; ...     % longitudinal feedback in the injector (0=OFF,1=ON)
}];
listL0=[listL1;{ ...
    'FBCK:LNG1:1:ENABLE'; ...     % longitudinal feedback in the injector (0=OFF,1=ON)
    'FBCK:LNG0:1:ENABLE'; ...     % longitudinal feedback in the injector (0=OFF,1=ON)
    'FBCK:FB01:TR02:MODE'; ...    % new transverse feedback in the injector (0=OFF,1=ON)
    'FBCK:INL1:1:ENABLE'; ...     % transverse feedback in the injector (0=OFF,1=ON)
    'FBCK:INL0:1:ENABLE'; ...     % transverse feedback in the injector (0=OFF,1=ON)
}];
listL0A=[listL0;{ ...
    'FBCK:FB01:TR01:MODE'; ...    % new gun launch feedback (0=OFF,1=ON)
    'FBCK:B5L0:1:ENABLE'; ...     % gun launch feedback (0=OFF,1=ON)
}];
listLSR={ ...
    'FBCK:FB01:TR01:MODE'; ...    % new gun launch feedback (0=OFF,1=ON)
    'FBCK:B5L0:1:ENABLE'; ...     % gun launch feedback (0=OFF,1=ON)
    'FBCK:BCI0:1:ENABLE'; ...     % charge feedback in the injector (0=OFF,1=ON)
};
listMisc={ ...
    'FBCK:FB01:TR03:MODE'; ...    % new x-cavity position (0=OFF,1=ON)
    'FBCK:B1L0:1:ENABLE'; ...     % x-cavity position (0=OFF,1=ON)
    'FBCK:FB02:TR03:MODE'; ...    % new BSY launch feedback (0=OFF, 1=ON)
    'FBCK:BSY0:1:ENABLE'; ...     % BSY launch feedback (0=OFF, 1=ON)
    'FBCK:DL20:1:ENABLE'; ...     % DL2A launch feedback (0=OFF, 1=ON)
    'FBCK:LTU0:1:ENABLE'; ...     % DL2B launch feedback (0=OFF, 1=ON)
    'FBCK:FB03:TR01:MODE'; ...    % new LTU launch feedback (0=OFF, 1=ON)
    'FBCK:LTL0:1:ENABLE'; ...     % LTU launch feedback (0=OFF, 1=ON)
    'FBCK:UND0:1:ENABLE'; ...     % Undulator launch feedback (0=OFF, 1=ON)
    'SIOC:SYS0:ML00:AO290'; ...   % Joe's DL1 energy feedback (0=OFF,1=ON)
    'SIOC:SYS0:ML00:AO292'; ...   % Joe's BC1 energy feedback (0=OFF,1=ON)
    'SIOC:SYS0:ML00:AO293'; ...   % Joe's BC1 bunch length feedback (0=OFF,1=ON)
    'SIOC:SYS0:ML00:AO294'; ...   % Joe's BC2 energy feedback (0=OFF,1=ON)
    'SIOC:SYS0:ML00:AO295'; ...   % Joe's BC2 peak current feedback (0=OFF,1=ON)
    'SIOC:SYS0:ML00:AO296'; ...   % Joe's LTU/BSY energy feedback (0=OFF,1=ON)
};
listAll=setdiff(unique([listL0A;listLSR;listMisc]),list0(1));
switch name(:,1:min(end,3))
    case 'LAS'
        fdbkList=listLSR;
    case 'L0A'
        fdbkList=listL0A;
    case {'L0B' 'TCA'}
        fdbkList=listL0;
    case {'L1S' 'L1X'}
        fdbkList=listL1;
    case {'L2' '21-' '22-' '23-' '24-'}
        fdbkList=listL2;
    case {'L3' '25-' '26-' '27-' '28-' '29-' '30-'}
        fdbkList=listL3;
    case 'DL2'
        fdbkList=listDL2;
    case ''
        fdbkList=listAll;
end
