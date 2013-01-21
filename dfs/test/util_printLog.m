function util_printLog(fig)
%PRINTLOG
%  PRINTLOG(FIG) prints figure FIG to lcls logbook.

% Features:

% Input arguments:
%    FIG: Handle of figure to print

% Output arguments:

% Compatibility: Version 7 and higher
% Called functions: none

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Check if FIG is handle.
fig(~ishandle(fig))=[];

for f=fig(:)'
    %opts.fontName='Times';opts.fontSize=12;opts.lineWidth=1.5;
    %util_appFonts(f,opts);
    print(f,'-dpsc2','-Pphysics-lclslog');
    %hAxes=findobj(f,'type','axes');
    %opts.title=get(get(hAxes(1),'Title'),'String');
    %opts.title='Matlab Figure';
    %util_eLogEntry(f,now,'lcls',opts);
end
