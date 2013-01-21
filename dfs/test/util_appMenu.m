function util_appMenu(fig, opts)

% --------------------------------------------------------------------

% Set default options.
optsdef=struct( ...
    'menubar',0, ...
    'toolbar',0 ...
    );

% Use default options if OPTS undefined.
if nargin < 2, opts=struct;end
opts=util_parseOptions(opts,optsdef);

% Get name and title of GUI
name=get(fig,'Tag');
figTitle=strtok(get(fig,'Name'),'-');
helpcmd='open(''lcls_gui.pdf'')';
if ~ispc
    helpcmd=['system(''ggv ' which('lcls_gui.pdf') ''')'];
end

% Set menu bar
if opts.menubar
hFile=uimenu(fig,'Label','File');
uimenu(hFile,'Label','Open ...','Callback',[name '(''dataOpen'',gcbo,guidata(gcbo))']);
uimenu(hFile,'Label','Save','Callback',[name '(''dataSave'',gcbo,guidata(gcbo),0)']);
uimenu(hFile,'Label','Save as ...','Callback',[name '(''dataSave'',gcbo,guidata(gcbo),1)']);
uimenu(hFile,'Label','Export ...','Callback',[name '(''dataExport'',gcbo,guidata(gcbo),0)']);
uimenu(hFile,'Label','Add to Logbook','Callback',[name '(''dataExport'',gcbo,guidata(gcbo),1)']);

fontSizes={'8' '10' '12' '14' '18'};
fontNames={'Helvetica' 'Times'};
hDisp=uimenu(fig,'Label','Display');
hSize=uimenu(hDisp,'Label','Font Size');
hName=uimenu(hDisp,'Label','Font Name');
hPSize=uimenu(hDisp,'Label','Export Font Size','Separator','on');
hPName=uimenu(hDisp,'Label','Export Font Name');
for tag=fontSizes
    optsStr=['struct(''fontSize'',' tag{:} ')'];
    uimenu(hSize,'Label',tag{:},'Callback',['util_appFonts(gcbf,' optsStr ')']);
    uimenu(hPSize,'Label',tag{:},'Callback',[name '(''exportSetup'',gcbo,guidata(gcbo),' optsStr ')']);
end
for tag=fontNames
    optsStr=['struct(''fontName'',''' tag{:} ''')'];
    uimenu(hName,'Label',tag{:},'Callback',['util_appFonts(gcbf,' optsStr ')']);
    uimenu(hPName,'Label',tag{:},'Callback',[name '(''exportSetup'',gcbo,guidata(gcbo),' optsStr ')']);
end

hHelp=uimenu(fig,'Label','Help');
uimenu(hHelp,'Label','Show Documentation','Callback',helpcmd);
uimenu(hHelp,'Label','About','Callback',['msgbox(''' figTitle ''',''About ' name ''')']);
end

% Set toolbar
if opts.toolbar
fontSizes={'8' '10' '12' '14' '18'};
fontNames={'Helvetica' 'Times'};
hDisp=uicontextmenu('Parent',fig);
hSize=uimenu(hDisp,'Label','Font Size');
hName=uimenu(hDisp,'Label','Font Name');
hPSize=uimenu(hDisp,'Label','Export Font Size','Separator','on');
hPName=uimenu(hDisp,'Label','Export Font Name');
for tag=fontSizes
    optsStr=['struct(''fontSize'',' tag{:} ')'];
    uimenu(hSize,'Label',tag{:},'Callback',['util_appFonts(gcbf,' optsStr ')']);
    uimenu(hPSize,'Label',tag{:},'Callback',[name '(''exportSetup'',gcbo,guidata(gcbo),' optsStr ')']);
end
for tag=fontNames
    optsStr=['struct(''fontName'',''' tag{:} ''')'];
    uimenu(hName,'Label',tag{:},'Callback',['util_appFonts(gcbf,' optsStr ')']);
    uimenu(hPName,'Label',tag{:},'Callback',[name '(''exportSetup'',gcbo,guidata(gcbo),' optsStr ')']);
end
htool=uitoolbar(fig);
iconPath=fullfile(matlabroot,'toolbox','matlab','icons');
uipushtool(htool,'CData', ...
    cell2mat(struct2cell(load(fullfile(iconPath,'opendoc')))), ...
    'ClickedCallback',[name '(''dataOpen'',gcbo,guidata(gcbo))']);
uipushtool(htool,'CData', ...
    cell2mat(struct2cell(load(fullfile(iconPath,'savedoc')))), ...
    'ClickedCallback',[name '(''dataSave'',gcbo,guidata(gcbo),0)']);
uipushtool(htool,'CData', ...
    cell2mat(struct2cell(load(fullfile(iconPath,'printdoc')))), ...
    'ClickedCallback',[name '(''dataExport'',gcbo,guidata(gcbo),0)']);
uipushtool(htool,'CData', ...
    cell2mat(struct2cell(load(fullfile(iconPath,'font')))), ...
    'ClickedCallback','set(gcbf,''Units'',''Pixel'');set(get(gcbo,''UIContextMenu''),''Position'',[0 get(gcbf,''Position'')*[0 0 0 1]''],''Visible'',''on'');set(gcbf,''Units'',''Characters'');', ...
    'UIContextMenu',hDisp);
[img,col]=imread(fullfile(iconPath,'greenarrowicon.gif'));col(9,:)=NaN;
uitoggletool(htool,'CData', ...
    reshape(col(img+1,:),16,16,3), ...
    'ClickedCallback',[name '(''start_btn_Callback'',gcbo,[],guidata(gcbo))']);
uitoggletool(htool,'CData', ...
    cell2mat(struct2cell(load(fullfile(iconPath,'zoom')))), ...
    'OnCallback',[name '(''zoomControl'',gcbo,guidata(gcbo),1)'], ...
    'OffCallback',[name '(''zoomControl'',gcbo,guidata(gcbo),0)']);
[img,col]=imread(fullfile(iconPath,'helpicon.gif'));col(8,:)=NaN;
uipushtool(htool,'CData', ...
    reshape(col(img+1,:),16,16,3), ...
    'ClickedCallback',helpcmd);
end
