function varargout = bba(varargin)
% BBA M-file for bba.fig
%      BBA, by itself, creates a new BBA or raises the existing
%      singleton*.
%
%      H = BBA returns the handle to a new BBA or the handle to
%      the existing singleton*.
%
%      BBA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BBA.M with the given input arguments.
%
%      BBA('Property','Value',...) creates a new BBA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bba_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bba_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bba

% Last Modified by GUIDE v2.5 22-Mar-2012 21:32:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @bba_OpeningFcn, ...
    'gui_OutputFcn',  @bba_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bba is made visible.
function bba_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bba (see VARARGIN)

% Choose default command line output for bba
handles.output = hObject;
%handles=appInit(hObject,handles);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bba wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bba_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% % ------------------------------------------------------------------------
% function handles = appInit(hObject, handles)
%
% handles.simul=struct( ...
%     'uselaunch',0, ...
%     'usebpmoff',0, ...
%     'usequadoff',0, ...
%     'useundoff',0, ...
%     'launchpos',0, ... % um
%     'launchang',0, ... % urad
%     'bpmoff',0, ... % um
%     'quadoff',0, ... % um
%     'undoff',0, ... % um
%     'nEnergy',2, ...
%     'enRange',[4.3 13.64], ...
%     'init',0, ...
%     'noEPlusCorr',1 ...
%     );
%
% %handles.sectorSel='und';
% handles.keepRMat=0;
%
%
% %gui_statusDisp(handles,'GUI ready for Undulator BBA.');
% set(handles.output,'Name','Beam Based Undulator Alignment');


% --- Executes on button press in linacbba.
function linacbba_Callback(hObject, eventdata, handles)
% hObject    handle to linacbba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
global region
if button_state==get(hObject,'Max')
    set(handles.linacbba,'BackgroundColor','green');
    region='linac';
    set(handles.uipanel5,'Title','Klystron Value Set');
    set(handles.text7,'String',' ');
    set(handles.text8,'String',' ');

elseif button_state==get(hObject,'Min')
    set(handles.linacbba,'BackgroundColor',[0.941 0.941 0.941]);
end
guidata(hObject,handles);
% --- Executes on button press in undbba.
function undbba_Callback(hObject, eventdata, handles)
% hObject    handle to undbba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
global region
if button_state==get(hObject,'Max')
    set(handles.undbba,'BackgroundColor','green');
    region='und';
    set(handles.uipanel5,'Title','Energy select');
    set(handles.text7,'String','Gev');
    set(handles.text8,'String','Gev');
elseif button_state==get(hObject,'Min')
    set(handles.undbba,'BackgroundColor',[0.941 0.941 0.941]);
end
guidata(hObject,handles);
%region=region

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
if(get(hObject,'Value')==get(hObject,'Max'))
    handles.simul.uselaunch=1;
end
guidata(hObject,handles);
% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if(get(hObject,'Value')==get(hObject,'Max'))
    handles.simul.usequadoff=1;
    %    handles.simul.quadoff
end
guidata(hObject,handles);
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
if(get(hObject,'Value')==get(hObject,'Max'))
    handles.simul.usebpmoff=1;
    %    handles.simul.bpmoff
end
guidata(hObject,handles);
% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
if(get(hObject,'Value')==get(hObject,'Max'))
    handles.simul.useundoff=1;
    %     handles.simul.undoff
end
guidata(hObject,handles);
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Global', 'DFS'});

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%gui_statusDisp('Running BBA Simulation ...');

global region nBpm nCorr nQuad zBpm c q b
En1=str2num(get(handles.edit6,'String'));
En2=str2num(get(handles.edit7,'String'));

str1=[region '_' num2str(En1) '_' 'Resmat','.mat'];
str2=[region '_' num2str(En2) '_' 'Resmat','.mat'];

if isequal([exist(str1) exist(str2)],[2 2])% if Response matrix already exist,load them
    load(str1);
    load(str2);
    str=[region '_' 'ele_num']; 
    load(str);%save element numbers
else
    [R1,R2]=bba_simulate1(region,En1,En2);% if Response matrix not exist,creat them
end

handles.simul.launchpos=get(handles.edit1,'String');
handles.simul.launchang=get(handles.edit2,'String');
handles.simul.quadoff=str2double(get(handles.edit3,'String'));
handles.simul.bpmoff=str2double(get(handles.edit4,'String'));
handles.simul.undoff=str2double(get(handles.edit5,'String'));

xinit=zeros(2,1);
xinit(1)=str2num(get(handles.edit1,'String'))*1e-6*handles.simul.uselaunch;
xinit(2)=str2num(get(handles.edit2,'String'))*1e-6*handles.simul.uselaunch;

c=zeros(nCorr,1);
q=str2num(get(handles.edit3,'String'))*randn(nQuad,1)*1e-6*handles.simul.usequadoff;
b=str2num(get(handles.edit4,'String'))*randn(nBpm,1)*1e-6*handles.simul.usebpmoff;

xx=[xinit;c;q;b];
% size(c)
% size(q)
% size(b)
% size(R1)
% size(R2)
% size(xx)

y1=R1*xx;
y2=R2*xx;

delta_y=y2-y1;

y=[y1;delta_y];
R=[R1;R2-R1];

if zBpm(1)~=0
    temp=zeros(1,nBpm);
    for n=1:nBpm-1
        temp(n+1)=zBpm(n);
    end
    zBpm=temp;
end

axes(handles.axes1);
cla;
plot(zBpm,y1);


popup_sel_index = get(handles.popupmenu1, 'Value');%choose bba method from pop-up menu 1.
switch popup_sel_index
    case 1                 %global correction
        xfinal1=lssvd(R1,y1);
        for n=1:1 %correction times
            [xfinal1,y1]=correct(xinit,xfinal1,R1);
        end
        axes(handles.axes2);
        cla;
        plot(zBpm,y1);
        set(gca, 'YLim', [-1e-3 1e-3 ]);
    case 2                 %DFS correction
        w=ones(2*nBpm,1);
        w(1:nBpm)=1;
        w(nBpm+1:end)=5000;
        xfinal=lssvd(R,y,w);
        for n=1:1 %correction times  ??????????Problem
            [xfinal,y]=correct(xinit,xfinal,R);
        end
        orbit=y(1:length(y)/2);
        axes(handles.axes2);
        cla;
        plot(zBpm,orbit);
end

%--------------------------------------------------------------------
function [xfinal0,y0]=correct(xinit,xfinal0,R0)
global nBpm nCorr nQuad zBpm c q b

corr_xoffset=xfinal0(3:2+nCorr);
quad_xoffset=xfinal0(3+nCorr:2+nCorr+nQuad);
bpm_xoffset=xfinal0(3+nCorr+nQuad:2+nCorr+nQuad+nBpm);

xinit=xinit-xfinal0(1:2);
c=c-corr_xoffset;
q=q-quad_xoffset;
%b=b-bpm_xoffset;

xx=[xinit;c;q;b];
y0=R0*xx;
xfinal0=lssvd(R0,y0);

%--------------------------------------------------------------------
function [R1,R2]=bba_simulate1(region,En1,En2)

global nBpm nCorr nQuad zBpm

switch region
    case 'und'
        beamline1 = getline_und(region,En1);
        beamline2 = getline_und(region,En2);
        List1=getList(beamline1,En1);%MeV
        List2=getList(beamline2,En2);%MeV
    case 'linac'
        beamline1 = getline_test(region,En1);
        List1=getList(beamline1,En1);%MeV
        beamline1 = EAppend(beamline1,List1);

        beamline2 = getline_test(region,En2);
        List2=getList(beamline2,En2);%MeV
        beamline2 = EAppend(beamline2,List2);
    case 'sduvlinac'
        beamline1 = getline_sduv(region,En1);
        List1=getList(beamline1,En1);%MeV
        beamline1 = EAppend(beamline1,List1);

        beamline2 = getline_sduv(region,En2);
        List2=getList(beamline2,En2);%MeV
        beamline2 = EAppend(beamline2,List2);
end

R1=getmatrix(beamline1,List1);
R2=getmatrix(beamline2,List2);

str1=[region '_' num2str(En1) '_' 'Resmat','.mat'];
str2=[region '_' num2str(En2) '_' 'Resmat','.mat'];

save(str1,'R1');
save(str2,'R2');
%------------------------------------------------------------------
function R=getmatrix(beamline,List)
global nBpm nCorr nQuad zBpm region

corrid=List.corrid;
zCorr=List.zCorr;
bpmid=List.bpmid;
zBpm=List.zBpm;
quadid=List.quadid;
zQuad=List.zQuad;

nBpm=length(bpmid);
nCorr=length(corrid);
nQuad=length(quadid);

str=[region '_' 'ele_num'];
save(str,'nBpm','nCorr','nQuad','zBpm');%save element numbers

%Rbpm(:,:,:)
for n=1:nBpm
    Rbpm(:,:,n)=getTmatAll(beamline,bpmid(1),bpmid(n));
end


%Rquad
for j=1:nQuad
    for i=1:length(bpmid)
        if quadid(j)< bpmid(i)
            Rquad(:,:,j,i)=getTmatAll(beamline,quadid(j),bpmid(i));
        end
    end
end

%Rcorr
for j=1:nCorr
    for i=1:length(bpmid)
        if corrid(j)< bpmid(i)
            Rcorr(:,:,j,i)=getTmatAll(beamline,corrid(j),bpmid(i));
        elseif corrid(j)>bpmid(i)
            Rcorr(:,:,j,i)=zeros(6);
        end
    end
end

rbpm=Rbpm(1,1:2,:);
rquad=Rquad(1,1,:,:);
rcorr=Rcorr(1,2,:,:);

rbpm=reshape(rbpm,nBpm,2);
for a=1:nBpm
    rcorr1(a,:)=rcorr(:,:,:,a);
end

for a=1:nBpm
    rquad1(a,:)=rquad(:,:,:,a);
end

R=[rbpm rcorr1 rquad1 -eye(nBpm)];

%--------------------------------------------------------------------
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over linacbba.
function linacbba_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to linacbba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over undbba.
function undbba_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to undbba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'String',50);
set(handles.edit2,'String',-30);
set(handles.edit3,'String',150);
set(handles.edit4,'String',150);
set(handles.edit6,'String',0.99);
set(handles.edit7,'String',1);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global region

En1=str2num(get(handles.edit6,'String'));
En2=str2num(get(handles.edit7,'String'));

str1=[region '_' num2str(En1) '_' 'Resmat','.mat'];
str2=[region '_' num2str(En2) '_' 'Resmat','.mat'];

delete(str1);
delete(str2);

% --- Executes on button press in sduvlinacbba.
function sduvlinacbba_Callback(hObject, eventdata, handles)
% hObject    handle to sduvlinacbba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sduvlinacbba
button_state = get(hObject,'Value');
global region
if button_state==get(hObject,'Max')
    set(handles.sduvlinacbba,'BackgroundColor','green');
    region='sduvlinac';
    set(handles.uipanel5,'Title','Klystron Value Set');
    set(handles.text7,'String',' ');
    set(handles.text8,'String',' ');

elseif button_state==get(hObject,'Min')
    set(handles.sduvlinacbba,'BackgroundColor',[0.941 0.941 0.941]);
end
guidata(hObject,handles);

% --- Executes on button press in sduvundbba.
function sduvundbba_Callback(hObject, eventdata, handles)
% hObject    handle to sduvundbba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
