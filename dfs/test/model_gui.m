function varargout = model_gui(varargin)
% MODEL_GUI M-file for model_gui.fig
%      MODEL_GUI, by itself, creates a new MODEL_GUI or raises the existing
%      singleton*.
%
%      H = MODEL_GUI returns the handle to a new MODEL_GUI or the handle to
%      the existing singleton*.
%
%      MODEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL_GUI.M with the given input arguments.
%
%      MODEL_GUI('Property','Value',...) creates a new MODEL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model_gui

% Last Modified by GUIDE v2.5 04-Apr-2011 18:30:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @model_gui_OutputFcn, ...
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


% --- Executes just before model_gui is made visible.
function model_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_gui (see VARARGIN)

% Choose default command line output for model_gui
handles.output = hObject;

handles.region={};
handles.modelRef='';
handles.modelSource1='MATLAB';
handles.modelSource2='MATLAB';
handles.modelType1='DESIGN';
handles.modelType2='DESIGN';
handles.displayR=0;
handles.displayTwiss=0;
handles.displayDiff=0;
handles=modelSourceControl(hObject,handles,1,[]);
handles=modelSourceControl(hObject,handles,2,[]);
handles=modelTypeControl(hObject,handles,1,[]);
handles=modelTypeControl(hObject,handles,2,[]);
handles=regionControl(hObject,handles,[]);
handles=modelRefControl(hObject,handles,[]);
handles=displayBoxControl(hObject,handles,'displayR',0);
handles=displayBoxControl(hObject,handles,'displayTwiss',0);
handles=displayBoxControl(hObject,handles,'displayDiff',0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Hint: delete(hObject) closes the figure
util_appClose(hObject);


% ------------------------------------------------------------------------
function handles = modelSourceControl(hObject, handles, num, tag)

handles=gui_popupMenuControl(hObject,handles,['modelSource' num2str(num)], ...
    tag,{'EPICS' 'MATLAB'},{'XAL' 'Matlab'});


% ------------------------------------------------------------------------
function handles = modelTypeControl(hObject, handles, num, tag)

handles=gui_popupMenuControl(hObject,handles,['modelType' num2str(num)], ...
    tag,{'EXTANT' 'DESIGN'},{'Extant' 'Design'});


% ------------------------------------------------------------------------
function handles = regionControl(hObject, handles, name)

if isempty(name)
    set(handles.region_txt,'String',sprintf('%s ',handles.region{:}));
else
    handles.region=name;
end

%handles=gui_textControl(hObject,handles,'region',name);

prim={'PROF' 'OTRS' 'YAGS' 'WIRE' 'BPMS' 'QUAD' 'BEND' 'XCOR' 'YCOR' 'SOLN'};
n=model_nameConvert(model_nameRegion(prim,handles.region,'LEM',0),'MAD');
n(ismember(n,{'SOL1BK' 'Q30615' 'Q30715'}))=[];
handles.names=n;
guidata(hObject,handles);


% ------------------------------------------------------------------------
function handles = modelRefControl(hObject, handles, name)

handles=gui_textControl(hObject,handles,'modelRef',name);


% ------------------------------------------------------------------------
function handles = displayBoxControl(hObject, handles, tag, val)

handles=gui_checkBoxControl(hObject,handles,tag,val);
modelPlot(hObject,handles);


% ------------------------------------------------------------------------
function modelPlot(hObject, handles)

if handles.displayTwiss
fig=2;
figure(fig);
nBPM=numel(handles.names);
t1=reshape(handles.twiss1([2:6 1 7:end 1],:),[],2,nBPM);
t2=reshape(handles.twiss2([2:6 1 7:end 1],:),[],2,nBPM);
[z1,id1]=sort(handles.z1);
[z2,id2]=sort(handles.z2);
if handles.displayDiff, t1=t1-t2;t2(:)=NaN;end

ind=[2 2 3 3 4 4 5 5 1 1;1 2 1 2 1 2 1 2 1 2];
nAx=size(ind,2);ax=zeros(1,nAx);lab={'\beta' '\alpha' '\eta' '\eta'''};l2={'x' 'y'};
for j=1:nAx-2
    k=ind(1,j);l=ind(2,j);
    ax(j)=subplot(nAx/2,2,j);
    plot(z1,squeeze(t1(k,l,id1)),'-',z2,squeeze(t2(k,l,id2)),'-r');
    ylabel([lab{k-1} '_' l2{l}]);
end
ax(j+1)=subplot(nAx/2,2,j+(1:2));
plot(z1,squeeze(t1(6,1,id1)),'-',z2,squeeze(t2(6,1,id2)),'-r');
ylabel('Energy');
xlabel(ax(end-1),'z  (m)');
%xlabel(ax(end),'z  (m)');
%title(ax(1),['Reference ' handles.data.static.bpmList{iRef}]);
set(ax(1:end-2),'XTicklabel',[]);
util_marginSet(fig,[.08 .08 .04],[.08 repmat(.02,1,nAx/2-1) .04]);
end

if handles.displayR
fig=1;
figure(fig);clf
nBPM=numel(handles.names);
r1=reshape(handles.r1,[],6,nBPM);
r2=reshape(handles.r2,[],6,nBPM);
[z1,id1]=sort(handles.z1);
[z2,id2]=sort(handles.z2);
if handles.displayDiff, r1=r1-r2;r2(:)=NaN;end

%ind=[1 1 2 2 3 3 4 4 1 2 3 4 5 5 6 6;1 2 1 2 3 4 3 4 6 6 6 6 5 6 5 6];
[i1,i2]=ndgrid(1:6);ind=[i1(:) i2(:)]';
nAx=size(ind,2);ax=zeros(1,nAx);nCol=6;
for j=1:nAx
    k=ind(1,j);l=ind(2,j);
    ax(j)=subplot(ceil(nAx/nCol),nCol,j);
%    plot(z(iRef),0,'xg');
    h=plot(z1,squeeze(r1(k,l,id1)),'-',z2,squeeze(r2(k,l,id2)),'r');
    ylabel(['R_{' num2str([k l],'%d') '}']);hold off
%    if j==1, legend(h,{'Measured' 'Model'});legend boxoff, end
    if j > (ceil(nAx/nCol)-1)*nCol, xlabel(ax(j),'z  (m)');end
end
set(ax(1:end-2),'XTicklabel',[]);
%title(ax(1),['Reference ' handles.data.static.bpmList{iRef}]);
util_marginSet(1,[.08 repmat(.08,1,nCol-1) .04],[.08 repmat(.02,1,ceil(nAx/nCol)-1) .04]);
end


% --- Executes on button press in modelGet1_btn.
function modelGet1_btn_Callback(hObject, eventdata, handles)

set(handles.output,'Pointer','watch');drawnow;
model_init('source',handles.modelSource1,'online',~strcmp(handles.modelSource1,'MATLAB'));
[r,z,lEff,twiss,en]=model_rMatGet(handles.names,[],['TYPE=' handles.modelType1]);
if ~isempty(handles.modelRef)
    r=model_rMatGet(handles.modelRef,handles.names,['TYPE=' handles.modelType1]);
end
handles.z1=z;handles.r1=r;handles.twiss1=twiss;handles.en1=en;
set(handles.output,'Pointer','arrow');drawnow;
guidata(hObject,handles);


% --- Executes on button press in modelGet2_btn.
function modelGet2_btn_Callback(hObject, eventdata, handles)

set(handles.output,'Pointer','watch');drawnow;
model_init('source',handles.modelSource2,'online',~strcmp(handles.modelSource2,'MATLAB'));
[r,z,lEff,twiss,en]=model_rMatGet(handles.names,[],['TYPE=' handles.modelType2]);
if ~isempty(handles.modelRef)
    r=model_rMatGet(handles.modelRef,handles.names,['TYPE=' handles.modelType2]);
end
handles.z2=z;handles.r2=r;handles.twiss2=twiss;handles.en2=en;
set(handles.output,'Pointer','arrow');drawnow;
guidata(hObject,handles);


% --- Executes on selection change in modelSource1_pmu.
function modelSource1_pmu_Callback(hObject, eventdata, handles)

modelSourceControl(hObject,handles,1,get(hObject,'Value'));


% --- Executes on selection change in modelSource2_pmu.
function modelSource2_pmu_Callback(hObject, eventdata, handles)

modelSourceControl(hObject,handles,2,get(hObject,'Value'));


% --- Executes on button press in modelType1_pmu.
function modelType1_pmu_Callback(hObject, eventdata, handles)

modelTypeControl(hObject,handles,1,get(hObject,'Value'));


% --- Executes on button press in modelType2_pmu.
function modelType2_pmu_Callback(hObject, eventdata, handles)

modelTypeControl(hObject,handles,2,get(hObject,'Value'));


function modelRef_txt_Callback(hObject, eventdata, handles)

modelRefControl(hObject,handles,get(hObject,'String'));


% --- Executes on button press in displayR_box.
function displayR_box_Callback(hObject, eventdata, handles)

displayBoxControl(hObject,handles,'displayR',get(hObject,'Value'));


% --- Executes on button press in displayDiff_box.
function displayDiff_box_Callback(hObject, eventdata, handles)

displayBoxControl(hObject,handles,'displayDiff',get(hObject,'Value'));


% --- Executes on button press in displayTwiss_box.
function displayTwiss_box_Callback(hObject, eventdata, handles)

displayBoxControl(hObject,handles,'displayTwiss',get(hObject,'Value'));


function region_txt_Callback(hObject, eventdata, handles)

regionControl(hObject,handles,regexp(strtrim(get(hObject,'String')),' ','split'));
