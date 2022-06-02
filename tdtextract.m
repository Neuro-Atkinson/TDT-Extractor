function varargout = tdtextract(varargin)
%Coded with the reference of the MATLAB Newsgroup, the MATLAB Guide Utility, and the TDT OpenDeveloper
%Manual

%Eric Atkinson, UF Movement Disorders Center, 1/23/2012

% TDTEXTRACT M-file for tdtextract.fig
%      TDTEXTRACT, by itself, creates a new TDTEXTRACT or raises the existing
%      singleton*.
%
%      H = TDTEXTRACT returns the handle to a new TDTEXTRACT or the handle
%      to
%      the existing singleton*.
%
% %      TDTEXTRACT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TDTEXTRACT.M with the given input arguments.
%
%      TDTEXTRACT('Property','Value',...) creates a new TDTEXTRACT or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tdtextract_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tdtextract_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tdtextract

% Last Modified by GUIDE v2.5 01-Feb-2019 12:59:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tdtextract_OpeningFcn, ...
                   'gui_OutputFcn',  @tdtextract_OutputFcn, ...
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

% --- Executes just before tdtextract is made visible.
function tdtextract_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tdtextract (see VARARGIN)

% Choose default command line output for tdtextract
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes tdtextract wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tdtextract_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%TRY TO LOAD A USER-SELECTED TANK
%Ask the user to select the tank directory
handles.tankname=uigetdir;
%Input temporary test block variable for testing if block exists (down
%some)
TestBlock='';
%Check if a directory was selected or not... If the tank name is a number (1), it has failed.
if isnumeric(handles.tankname)==1
    handles.tankname='';
else
    set(handles.text18, 'String','Loading...');
    %If a directory exists, try to load the directory as a block.
    handles.TTX=actxcontrol('TTank.X');
    invoke(handles.TTX,'ConnectServer','Local','Me');
    invoke(handles.TTX,'OpenTank',handles.tankname,'R');
    %Use the temporary test block variable to load the first block.  We
    %will use this to test if the tank was correctly loaded.
    TestBlock=handles.TTX.QueryBlockName(1);
end
%FINAL CHECK TO SEE IF TANK IS LOADED CORRECTLY
if strcmp(TestBlock,'');
    %If the tank was not loaded correctly, reset dependent variables
    set(handles.text18, 'String','Error: Please Reselect Tank');
    set(handles.text18, 'BackgroundColor', [1,0,0]);
    %Text17 displays the tank path on the gui.
    set(handles.text17, 'String', '');
    %Emptylist will be fed into the listbox1 to override any previous data.
    emptylist={'Empty'};
    %listbox1 shows blocks, since this tank is empty there should be no
    %blocks displayed
    set(handles.listbox1,'Value',1);
    set(handles.listbox1,'String',emptylist);
    %emptylist2 will be fed into listbox2 to override any previous data.
    emptylist2={'No Events'};
    %listbox2 holds information on what events (DB1S or sPos for instance)
    %are contained inside a block... since there is no block, this
    %information needs to be reset.
    set(handles.listbox2,'Value',1);
    set(handles.listbox2,'String',emptylist2);
    %emptylist 3 will be fed into listbox3 to override any previous data.
    emptylist3={'No Channels'};
    %since there are no channels in a block that does not exist, reset data
    %in the channel listbox (listbox3).
    set(handles.listbox3,'Value',1);
    set(handles.listbox3,'String',emptylist3);
    %Remove the time input boxes since these are not needed when a block is
    %not loaded.
    %Edit6 = Start Time (T1)    Edit8 = End Time (T2)
    set(handles.edit6,'Visible','off');
    set(handles.edit8,'Visible','off');
    %Edit9 is the input for the tank name.
    set(handles.edit9,'String','No Tank');
    %We need to store a variable for when there is a tank loaded or when
    %there is no tank loaded (for later use)... this is that variable.
    handles.tankloaded=0;
else
    %TANK WAS LOADED CORRECTLY.  SELECT FIRST BLOCK BY DEFAULT AND FILL IN
    %DATA ABOUT BLOCK
    
    %Since a tank has been successfully loaded, we need to know that for
    %later in the program... tankloaded stores that information as a binary
    %value.
    handles.tankloaded=1;
    %We need the block name to select the block, so we will use our
    %previous variable for the first block and load it.
    handles.TTX.SelectBlock(TestBlock);
    set(handles.text18, 'String','Tank Loaded');
    set(handles.text18, 'BackgroundColor', [0,.5,0]);
    %text17 is the tank path.  Tank name stores the tank directory path, so
    %that information is just pumped into text17.
    set(handles.text17, 'String', handles.tankname);
    %When a new tank is loaded, the default block displayed is block 1.
    blocknum=1;
    %This loop will query the tank for all block names.  These names are
    %stored in newlist to be used later for displaying in the GUI.
    while (~isempty(handles.TTX.QueryBlockName(blocknum)))
        newlist{blocknum,1}=handles.TTX.QueryBlockName(blocknum);
        blocknum=blocknum+1;
    end
    %Here we send the list of blocks in the tank "newlist" into listbox1.
    set(handles.listbox1, 'String', newlist);
    %eventcodes stores all of the events in the default block 1.
    eventcodes=handles.TTX.GetEventCodes(0);
    %You need the event string as an input for later block functions, 
    %so here we create a matrix to store those which will be filled later.
    eventstring{1,1}='';
    %This loops fills the eventstring so we can use the event names for
    %block functions later.
    for i=1:length(eventcodes)
        %This converts the event codes to event strings.
        thisevent=handles.TTX.CodeToString(eventcodes(1,i));
        %here we add the event string to the matrix for that information.
        %NOTE: Rows are events.  There is only one column.
        eventstrings{i,1}=thisevent;
    end
    %To store the information, we need to keep it in the GUI handles.
    handles.eventstrings=eventstrings;
    
    %Listbox2 contains the event information in the GUI.  Now that we have 
    %all of the event strings stored for later block functions, we can use 
    %it to also display in the GUI.
    set(handles.listbox2, 'String', eventstrings);
    %The number of channels in an event is needed for later block
    %functions.  ChanInfo is declared as a temporary matrix to store this
    %information for a specific event which will then be fed into a larger
    %structure that contains channel/event information.
    ChanInfo(1,1)=0;
    %tempval is simply a variable that is needed to store channel names in
    %while looping.
    tempval=NaN;
    %This loop goes through each event in the block and extracts a small
    %segment of data from all channels in that event.  This data is
    %examined to see how many channels there are in the event and stores
    %that information.
    for i=1:length(eventcodes)
        %This reads a small amount of data from all channels in an event
        N=handles.TTX.ReadEvents(40,eventcodes(1,i),0,0,0,1,0);
        %This pulls out only the channels for the event.
        ChanInfo=handles.TTX.ParseEvInfoV(0,N,4);
        %For every channel discovered in the event, the name is stored in a
        %temporary matrix which will be fed into a larger structure later
        %that contains all the channel information for all events.
        UniqueChans=unique(ChanInfo);
    
    %We need to output this information to the GUI later, so a string
    %matrix (struc) is created to store the information.
        for j=1:length(UniqueChans)
            handles.NumofChans{i,j}=num2str(UniqueChans(1,j));
        end
    end
    %Now that the information for this block's channels is stored, the
    %default block loaded is 1.  This information needs to be displayed in
    %the GUI, but they are stored as numbers.  I like the "channel #" view,
    %so I create that by turning the numbers into strings then merging
    %them to a string matrix that is fed into listbox3.  Listbox3 is the
    %box that contains channel information.
    %
    FirstLoadChans=str2num(handles.NumofChans{1,1});
    if FirstLoadChans==0
        %If there are no channels in the first event, do nothing since the
        %GUI box for channels is "No Channels" by default.
    else
        %Here we create the string matrix to display in the GUI using the
        %channel information of the first event since it is displayed by
        %default on tank load.
        ChannelStrings{1,1}='';
        for i=1:FirstLoadChans
            ChannelStrings{i,1}=sprintf('Channel %i',i);
        end
        set(handles.listbox3,'String',ChannelStrings);
    end
    %Here we load variables into the GUI to display to the user.
      totaltime = floor(invoke(handles.TTX,'CurBlockStopTime')- invoke(handles.TTX,'CurBlockStartTime'));
      timestring=sprintf('Block Max Time: %i',totaltime);
      set(handles.text19,'String',timestring);
      set(handles.edit8,'Value',totaltime);
      set(handles.edit6,'Value',0);
      %edit8 needs a string in the box, so we convert total time to a
      %string here.
      editstring=sprintf('%i',totaltime);
      set(handles.edit8,'String',editstring);
      set(handles.edit6,'String','0');
      %T2 = end time    T1 = start time
      handles.T2=totaltime;
      handles.T1=0;
      %Display time inputs since the data is loaded correctly now.
      set(handles.edit6,'Visible','on');
      set(handles.edit8,'Visible','on');
end
%Update GUI information
guidata(hObject, handles);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
%Change background to red around extract.

set(handles.text22, 'BackgroundColor', [1,0,0]);
pause(.2);
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Selection is being extracted.. Check if a there are multiple items to
%write.
TestIfActions=get(handles.listbox4,'String');

%If there are no events stored in batch, write current selection
if strcmp(TestIfActions,'No Actions To Perform');
%find the current block
blockvalue=get(handles.listbox1,'Value');
%Double check to make sure tank is properly loaded before extract.
blockname=handles.TTX.QueryBlockName(blockvalue);
    if strcmp(blockname,'')
    %DO NOTHING SINCE TANK IS NOT LOADED
    else
        %The following code pulls the needed variables from the currently selected
        %GUI options and extracts the data.  The data is then stored into a text
        %file that has been named based on GUI options.
        channelvalue=get(handles.listbox3,'Value');
        eventvalue=get(handles.listbox2,'Value');
        eventtowrite=handles.eventstrings{eventvalue,1};
        %Set tank variables before writing.
        e=invoke(handles.TTX,'SetGlobals', ['Options = ALL; WavesMemLimit = 100000000;Channel=' num2str(channelvalue) '; T1=' num2str(handles.T1) '; T2=' num2str(handles.T2)]);
        %store extracted data in variable.
        data=invoke(handles.TTX, 'ReadWavesV', eventtowrite);%read data
        %added option to filter data
        filter_check=get(handles.use_filter, 'Value')
        if filter_check==1
            low_freq_input_str=get(handles.filter_lowfreq, 'String');
            high_freq_input_str=get(handles.filter_highfreq, 'String');
            
            low_freq_input=str2num(low_freq_input_str);
            high_freq_input=str2num(high_freq_input_str);
            
            sampling_freq_str=get(handles.sampling_freq, 'String');
            sampling_freq=str2num(sampling_freq_str);
            
            [A, B] = butter(4, [(low_freq_input/sampling_freq) (high_freq_input/sampling_freq)]); %% make filter here
            data_filtered = filtfilt(A, B, data);
            clear data
            data=data_filtered;
            clear data_filtered
        end
        
        %get the tank name for filename write.
        tankname=get(handles.edit9,'String');
        filename=sprintf('%s_%s_Ch%s_%s_%s_%s.bin',tankname,blockname,num2str(channelvalue),eventtowrite,num2str(handles.T1),num2str(handles.T2));
        if isnan(data)
            msgbox('Reduce the time of your extract, lack of memory','Not Enough Memory');
        else
        fid = fopen(filename, 'w');
        fwrite(fid, data,'float32','l');
        fclose(fid);
        end
        pause(1);
        set(handles.text22, 'BackgroundColor', [0,1,0]);
    end
else
    %There is stuff in batch to write.
    %CHECK FOR MERGE
    binarymerge=get(handles.checkbox1,'Value');
    %IF MERGE IS NOT SELECTED
    if binarymerge==0
        %donumber tells how many actions to write.
        donumber=length(handles.batchaction);
        %location keeps track of which action is being written.
        location=1;
    for z=1:donumber
        %When actions are stored via "add to batch", they are stored as a
        %string.  These strings are sequentially evaluated as commands.
        docommand=sprintf('%s',handles.batchaction{z,1});
        eval(docommand)
        %There are 3 commands that need to be performed for each action.
        %The following code writes the action, updates the GUI, and finally
        %updates the location for the next action.
        CheckifThree = rem(z,3);
        if CheckifThree==0
            %WRITE TO FILE
            filename=handles.filename{location,1};
            %we need a loop to check if the file is done writing so the gui
            %will update.
            handles.batchlist{location,1}='WRITING';
            pause(.7);
            set(handles.listbox4,'Value',1);
            set(handles.listbox4,'String',handles.batchlist);
            if isnan(data)
            msgbox('Reduce the time of your extract, lack of memory','Not Enough Memory');
            else
            fid = fopen(filename, 'w');
            fwrite(fid, data,'float32','l');
            fclose(fid);
            end
            handles.batchlist{location,1}='DONE';
            pause(.7);
            set(handles.listbox4,'Value',1);
            set(handles.listbox4,'String',handles.batchlist);
            location=location+1;
            drawnow; %force GUI update
        end
    end
    %Now that the batch has been written, update variables and GUI
    clear handles.batchlist;
    resetlistbox4{1,1}='No Actions To Perform';
    handles.batchlist=resetlistbox4;
    set(handles.listbox4,'Value',1);
    set(handles.listbox4,'String',handles.batchlist);
    handles.batchnum=0;
    handles.batchaction=resetlistbox4;
    handles.filename=resetlistbox4;
    set(handles.text22, 'BackgroundColor', [0,1,0]);
    else
    %RUN BATCH FILES WITH MERGE ON
    donumber=length(handles.batchaction);
    location=1;
    for z=1:donumber
        %set(handles.text22, 'BackgroundColor', [1,0,0]);
        docommand=sprintf('%s',handles.batchaction{z,1});
        eval(docommand)
        CheckifThree = rem(z,3);
        if CheckifThree==0
            if location == 1

                filter_check=get(handles.use_filter, 'Value');
                if filter_check==1
                    low_freq_input_str=get(handles.filter_lowfreq, 'String');
                    high_freq_input_str=get(handles.filter_highfreq, 'String');

                    low_freq_input=str2num(low_freq_input_str);
                    high_freq_input=str2num(high_freq_input_str);

                    sampling_freq_str=get(handles.sampling_freq, 'String');
                    sampling_freq=str2num(sampling_freq_str);

                    [A, B] = butter(4, [(low_freq_input/sampling_freq) (high_freq_input/sampling_freq)]); %% make filter here
                    data_filtered = filtfilt(A, B, double(data));
                    clear data
                    data=single(data_filtered);
                    clear data_filtered
                end
                command=sprintf('handles.data%s(:,1)=data;',num2str(location));
                eval(command);
            else
            %It is nice to be able to merge different sampling frequency
            %channels together, so we need to be able to add variable
            %length data vectors together in the matrix.
            filter_check=get(handles.use_filter, 'Value');
            if filter_check==1
                low_freq_input_str=get(handles.filter_lowfreq, 'String');
                high_freq_input_str=get(handles.filter_highfreq, 'String');

                low_freq_input=str2num(low_freq_input_str);
                high_freq_input=str2num(high_freq_input_str);

                sampling_freq_str=get(handles.sampling_freq, 'String');
                sampling_freq=str2num(sampling_freq_str);

                [A, B] = butter(4, [(low_freq_input/sampling_freq) (high_freq_input/sampling_freq)]); %% make filter here
                data_filtered = filtfilt(A, B, double(data));
                clear data
                data=single(data_filtered);
                clear data_filtered
            end
            command=sprintf('handles.data%s(:,1)=data;',num2str(location));
            eval(command);
            %handles.data(1:numel(data),location)=data;
            end
            handles.batchlist{location,1}='DONE';
            set(handles.listbox4,'Value',1);
            set(handles.listbox4,'String',handles.batchlist);
            location=location+1;
            drawnow; %force GUI update
        end
    end
    %Get data columns
    DataColumns=location-1;
    
    %We need to check if there are different sampling frequencies.
    for dc=1:DataColumns
        command=sprintf('dataelements(1,dc)=numel(handles.data%s(:,1));',num2str(dc));
        eval(command);
    end
    if length(unique(dataelements)) > 1 %If this is true, we need to linear interpolate to upsample lower sampling frequencies.
        %find highest sampling frequency
       LargestSF=max(dataelements);
       %interpolate lower frequencies and create data matrix
       for dc=1:DataColumns          
           if dataelements(1,dc) < LargestSF
             command=sprintf('handles.data(:,dc)=interpft(handles.data%s(:,1),LargestSF);',num2str(dc));
             eval(command);
             command=sprintf('clear handles.data%s;',num2str(dc));
             eval(command);
           else
             command=sprintf('handles.data(:,dc)=handles.data%s(:,1);',num2str(dc));
             eval(command);
             command=sprintf('clear handles.data%s;',num2str(dc));
             eval(command);
           end
       end
    else
        %If handles.data exists then we need to clear it because we will
        %have errors due to dimension mismatch.
        handles.data=[];
           for dc=1:DataColumns          
             command=sprintf('handles.data(:,dc)=handles.data%s(:,1);',num2str(dc));
             eval(command);
             command=sprintf('handles.data%s=[];',num2str(dc));
             eval(command);
           end
    end
        
        
                        %WRITE MERGED TO FILE
            tankname=get(handles.edit9,'String');
            numofexport=num2str(handles.batchnum/3);
            if isnan(handles.data)
            msgbox('Reduce the time of your extract, lack of memory','Not Enough Memory');
            else
            filename=sprintf('MergedFile_Num%s_%s.bin',numofexport,tankname);
            %fid = fopen(filename, 'w');
            %fwrite(fid, handles.data,'float32','l');
            %fclose(fid);
            multibandwrite(handles.data,filename,'bip', 'precision','float32','machfmt','ieee-le');
            end
%             dlmwrite(filename,handles.data,'delimiter','\t');
%              while notdonewriting == 0
%                  pause(.1);
%                  information = dir(filename);
%                  sizeoffile = information.bytes;
%                      if sizeoffile == previoussize
%                          notdonewriting=1;
%                      end
%                  previoussize=sizeoffile;
%              end
            pause(1);
            set(handles.text22, 'BackgroundColor', [0,1,0]);
            set(handles.checkbox1,'Value',0);
            handles.data(:,:)=[];
            clear handles.data;
    resetlistbox4{1,1}='No Actions To Perform';
    handles.batchlist=resetlistbox4;
    set(handles.listbox4,'Value',1);
    set(handles.listbox4,'String',handles.batchlist);
    handles.batchnum=0;
    handles.batchaction=resetlistbox4;
    handles.filename=resetlistbox4;
    end
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.tankname='';
handles.NumofChans{1,1}='initalized';
handles.T1=0;
handles.T2=1;
handles.batchnum=0;
handles.tankloaded=0;
% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

%When a value in listbox1 is selected, the user desires a new block to be
%loaded.  The following code is almost identical to the reset code, but
%modified to load a new block.  For comments, see the reset function.
blockvalue=get(hObject,'Value');
blocktest=get(hObject,'String');
if strcmp(blocktest,'Empty')==1
    %Do nothing since there is no tank loaded.
else
blockname=handles.TTX.QueryBlockName(blockvalue);
invoke(handles.TTX,'SelectBlock',blockname);
    eventcodes=handles.TTX.GetEventCodes(0);
    eventstring{1,1}='';
    %HANDLE FILLING LISTBOX OF EVENTS
    for i=1:length(eventcodes)
        thisevent=handles.TTX.CodeToString(eventcodes(1,i));
        eventstrings{i,1}=thisevent;
    end
    handles.eventstrings=eventstrings;
    set(handles.listbox2, 'String', eventstrings);
    ChanInfo(1,1)=0;
    %HANDLE FILLING CHANNELS OF EVENTS
    for i=1:length(eventcodes)
        N=handles.TTX.ReadEvents(40,eventcodes(1,i),0,0,0,1,0);
        ChanInfo=handles.TTX.ParseEvInfoV(0,N,4);
        UniqueChans=unique(ChanInfo);
    
    %We need to output this information to the GUI later, so a string
    %matrix (struc) is created to store the information.
        for j=1:length(UniqueChans)
            handles.NumofChans{i,j}=num2str(UniqueChans(1,j));
        end
    end
    FirstLoadChans=str2num(handles.NumofChans{1,1});
    if FirstLoadChans==0
        %Do Nothing
    else
        %load new channels in the GUI
        ChannelStrings{1,1}='';
        [chanx chany]=size(handles.NumofChans);
        for i=1:chany
            if isempty(handles.NumofChans{1,i})==0
            ChannelStrings{i,1}=sprintf('Channel %i',i);
            else
                %do nothing
            end
        end
        set(handles.listbox3,'Value',1);
        set(handles.listbox3,'String',ChannelStrings);
    end
            
            
      %UPDATE GUI WITH NEW BLOCK TIME  
      totaltime = floor(invoke(handles.TTX,'CurBlockStopTime')- invoke(handles.TTX,'CurBlockStartTime'));
      timestring=sprintf('Block Max Time: %i',totaltime);
      editstring=sprintf('%i',totaltime);
      set(handles.text19,'String',timestring);
      set(handles.edit8,'String',editstring);
      set(handles.edit8,'Value',totaltime);
      set(handles.edit8,'Visible','on');
      set(handles.edit6,'String','0');
      set(handles.edit6,'Value',0);
      set(handles.edit6,'Visible','on');
      handles.T2=totaltime;
      handles.T1=0;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

%GET VALUE OF CLICKED-ON EVENT
    %HANDLE FILLING CHANNELS OF EVENTS
    eventvalue=get(hObject,'Value');
    blocktest=get(hObject,'String');
if strcmp(blocktest,'No Events')==1
    %Do nothing since there is no tank loaded.
else
    FirstLoadChans=str2num(handles.NumofChans{eventvalue,1});
    if FirstLoadChans==0
            emptylist3={'No Channels'};
    %since there are no channels in a block that does not exist, reset data
    %in the channel listbox (listbox3).
    set(handles.listbox3,'Value',1);
    set(handles.listbox3,'String',emptylist3);
        %Do Nothing
    else
        %load new channels in the GUI
        ChannelStrings{1,1}='';
        [chanx chany]=size(handles.NumofChans);
        for i=1:chany
            if isempty(handles.NumofChans{eventvalue,i})==0
            ChannelStrings{i,1}=sprintf('Channel %i',i);
            else
                %do nothing
            end
        end
        set(handles.listbox3,'Value',1);
        set(handles.listbox3,'String',ChannelStrings);
    end
%     FirstLoadChans=str2num(handles.NumofChans{eventvalue,1});
%     if FirstLoadChans==0
%             set(handles.listbox3,'String','No Channels');
%             set(handles.listbox3,'Visible','on');
%     else
%         ChannelStrings{1,1}='';
%         if isnan(FirstLoadChans)
%             set(handles.listbox3,'String','No Channels');
%             set(handles.listbox3,'Visible','on');
%         else
%         for i=1:FirstLoadChans
%             ChannelStrings{i,1}=sprintf('Channel %i',i);
%         end
%         set(handles.listbox3,'String',ChannelStrings);
%         set(handles.listbox3,'Visible','on');
%         end
%     end
end
    %updating handles) 
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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
T1 = str2double(get(hObject, 'String'));
totaltime = floor(invoke(handles.TTX,'CurBlockStopTime')- invoke(handles.TTX,'CurBlockStartTime'));
if isnan(T1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number between 0 and Max Block Time','Error');
    handles.T1=0;
elseif T1 > handles.T2
        reset=handles.T2-1;
        resetstring=sprintf('%i',reset);
        set(hObject,'String',resetstring);
        errordlg('End Extract Time must be smaller than Start Extract Time.','Error');
        handles.T1=T2-1;
elseif T1 == totaltime
    set(hObject,'String',0);
    errordlg('Input for Start Extract Time can not equal Total Time.','Error');
    handles.T1=0;
elseif (T1 >= 0) && (T1 <= (totaltime-1))
    set(hObject,'String',T1);
    handles.T1=T1;
else
    set(hObject, 'String', 0);
    errordlg('Input must be a number between 0 and Max Block Time','Error');
    handles.T1=0;
end
guidata(hObject, handles);

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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
T2 = str2double(get(hObject, 'String'));
totaltime = floor(invoke(handles.TTX,'CurBlockStopTime')- invoke(handles.TTX,'CurBlockStartTime'));
if isnan(T2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number between 0 and Max Block Time','Error');
    handles.T2=0;
elseif T2 < handles.T1
        reset=handles.T1+1;
        resetstring=sprintf('%i',reset);
        set(hObject,'String',resetstring);
        errordlg('End Extract Time must be smaller than Start Extract Time.','Error');
        handles.T2=T1+1;
elseif (T2 >= 0) && (T2 <= totaltime)
    set(hObject,'String',T2);
    handles.T2=T2;
else
    resetstring=sprintf('%i',totaltime);
    set(hObject, 'String', resetstring);
    errordlg('Input must be a number between 0 and Max Block Time','Error');
    handles.T2=totaltime;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.tankloaded==1
    blockvalue=get(handles.listbox1,'Value');
    blockname=handles.TTX.QueryBlockName(blockvalue);
    if strcmp(blockname,'')
        %DO NOTHING SINCE TANK IS NOT LOADED
    else
        channelvalue=get(handles.listbox3,'Value');
        eventvalue=get(handles.listbox2,'Value');
        eventtowrite=handles.eventstrings{eventvalue,1};
        batchcommand1=sprintf('handles.TTX.SelectBlock(''%s'');',blockname);
        %CREDIT: Some of the settings were taken from:
        %http://www.mathworks.com/matlabcentral/newsreader/view_thread/250049
        batchcommand2=sprintf('invoke(handles.TTX,''SetGlobals'', [''Options = ALL; WavesMemLimit = 134217728;Channel=%s; T1=%s; T2=%s'']);',num2str(channelvalue),num2str(handles.T1),num2str(handles.T2));
        batchcommand3=sprintf('data=invoke(handles.TTX, ''ReadWavesV'', ''%s'');',eventtowrite);
        if handles.batchnum==0
            handles.batchaction{1,1}=batchcommand1;
        else
            handles.batchaction{end+1,1}=batchcommand1;
        end
            handles.batchaction{end+1,1}=batchcommand2;
            handles.batchaction{end+1,1}=batchcommand3;
            handles.batchnum=handles.batchnum+3;
            oldlistbox=get(handles.listbox4,'String');
            if strcmp(oldlistbox,'No Actions To Perform')
                updatelistbox=sprintf('Block: %s Event: %s Channel: %s T1: %s T2: %s', blockname,eventtowrite,num2str(channelvalue),num2str(handles.T1),num2str(handles.T2));
                tankname=get(handles.edit9,'String');
                handles.filename{1,1}=sprintf('%s_%s_Ch%s_%s_%s_%s.bin',tankname,blockname,num2str(channelvalue),eventtowrite,num2str(handles.T1),num2str(handles.T2));
                handles.batchlist{1,1}=updatelistbox;
                set(handles.listbox4,'Value',1);
                set(handles.listbox4,'String',handles.batchlist);
            else
                tankname=get(handles.edit9,'String');
                updatelistbox=sprintf('Block: %s Event: %s Channel: %s T1: %s T2: %s', blockname,eventtowrite,num2str(channelvalue),num2str(handles.T1),num2str(handles.T2));
                mod=length(oldlistbox)+1;
                handles.filename{mod,1}=sprintf('%s_%s_Ch%s_%s_%s_%s.bin',tankname,blockname,num2str(channelvalue),eventtowrite,num2str(handles.T1),num2str(handles.T2));
                handles.batchlist{mod,1}=updatelistbox;
                set(handles.listbox4,'Value',1);
                set(handles.listbox4,'String',handles.batchlist);
            end
        end
end
guidata(hObject, handles);



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%First check to see if the batch is empty...
TestIfActions=get(handles.listbox4,'String');
if strcmp(TestIfActions,'No Actions To Perform');
    %Do nothing since there is nothing to remove from batch.
else
    %Get value from listbox to delete.
    deletethisbatch=get(handles.listbox4,'Value');
    
    %Remove selection from batch
    %There are 4 variables that need to be updated to accomplish this.
    %First, correct the batchnum value which stores the number of batch
    %actions to take.  There are 3 actions for every batch item.
    handles.batchnum=handles.batchnum-3;
    %Second, correct the filename cell
    handles.filename(deletethisbatch)=[];
    %Third, correct the batch action cell.  Since there are 3 commands for
    %each batch object the equation is (BatchActionNumber x 3)-2 = location
    batchLOC=(deletethisbatch*3)-2;
    %The same location must be deleted 3 times since the matrix corrects
    %its structure each time an element is deleted.
    handles.batchaction(batchLOC)=[];
    handles.batchaction(batchLOC)=[];
    handles.batchaction(batchLOC)=[];
    %Fourth, remove the action from the batch list and update the GUI.
    handles.batchlist(deletethisbatch)=[];
    %If you delete the last batch action, it causes a value error, so make
    %the default listbox 4 selection value 1 after an action is deleted.
    set(handles.listbox4,'Value',1);
    set(handles.listbox4,'String',handles.batchlist);
    %Finally, we need to check if all the batch elements were deleted... if
    %so, we have to correct the variables.
    if handles.batchnum==0
        resetlistbox4{1,1}='No Actions To Perform';
        handles.batchlist=resetlistbox4;
        set(handles.listbox4,'Value',1);
        set(handles.listbox4,'String',handles.batchlist);
    end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
axes(hObject);
imshow('background.jpg');



function fromchan_Callback(hObject, eventdata, handles)
% hObject    handle to fromchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fromchan as text
%        str2double(get(hObject,'String')) returns contents of fromchan as a double


% --- Executes during object creation, after setting all properties.
function fromchan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fromchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tochan_Callback(hObject, eventdata, handles)
% hObject    handle to tochan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tochan as text
%        str2double(get(hObject,'String')) returns contents of tochan as a double


% --- Executes during object creation, after setting all properties.
function tochan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tochan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fromtobutton.
function fromtobutton_Callback(hObject, eventdata, handles)
% hObject    handle to fromtobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fromchan=get(handles.fromchan,'String');
fromchan_num=str2num(fromchan);

tochan=get(handles.tochan,'String');
tochan_num=str2num(tochan);

blocklist=get(handles.listbox1,'String');
totalblocks=length(blocklist);
blockval=get(handles.listbox1,'Value');
for curblock=blockval:totalblocks
blockvalue=curblock;
selectedblockname=blocklist{blockvalue,1};
set(handles.edit9,'String',selectedblockname);
set(handles.listbox1,'Value',curblock);
guidata(hObject, handles);
listbox1_Callback(handles.listbox1, eventdata, handles)
drawnow;

    if handles.tankloaded==1
        blockvalue=curblock;
        blockname=handles.TTX.QueryBlockName(blockvalue);
        
        handles.batchnum=0;
        handles.batchaction={};
        handles.batchlist={};
        handles.filename={};
        handles.T1=0;
        T2=get(handles.edit8,'String');
        handles.T2=str2num(T2);

        for chan=fromchan_num:tochan_num
            channelvalue=chan;
            eventvalue=get(handles.listbox2,'Value');
            eventtowrite=handles.eventstrings{eventvalue,1};
            batchcommand1=sprintf('handles.TTX.SelectBlock(''%s'');',blockname);
            %CREDIT: Some of the settings were taken from:
            %http://www.mathworks.com/matlabcentral/newsreader/view_thread/250049
            batchcommand2=sprintf('invoke(handles.TTX,''SetGlobals'', [''Options = ALL; WavesMemLimit = 134217728;Channel=%s; T1=%s; T2=%s'']);',num2str(channelvalue),num2str(handles.T1),num2str(handles.T2));
            batchcommand3=sprintf('data=invoke(handles.TTX, ''ReadWavesV'', ''%s'');',eventtowrite);
            if handles.batchnum==0
                handles.batchaction{1,1}=batchcommand1;
            else
            handles.batchaction{end+1,1}=batchcommand1;
            end
            handles.batchaction{end+1,1}=batchcommand2;
            handles.batchaction{end+1,1}=batchcommand3;
            handles.batchnum=handles.batchnum+3;
            oldlistbox=get(handles.listbox4,'String');
            if strcmp(oldlistbox,'No Actions To Perform')
            updatelistbox=sprintf('Block: %s Event: %s Channel: %s T1: %s T2: %s', blockname,eventtowrite,num2str(channelvalue),num2str(handles.T1),num2str(handles.T2));
            tankname=get(handles.edit9,'String');
            handles.filename{1,1}=sprintf('%s_%s_Ch%s_%s_%s_%s.bin',tankname,blockname,num2str(channelvalue),eventtowrite,num2str(handles.T1),num2str(handles.T2));
            handles.batchlist{1,1}=updatelistbox;
            set(handles.listbox4,'Value',1);
            set(handles.listbox4,'String',handles.batchlist);
            else
            tankname=get(handles.edit9,'String');
            updatelistbox=sprintf('Block: %s Event: %s Channel: %s T1: %s T2: %s', blockname,eventtowrite,num2str(channelvalue),num2str(handles.T1),num2str(handles.T2));
            mod=length(oldlistbox)+1;
            handles.filename{mod,1}=sprintf('%s_%s_Ch%s_%s_%s_%s.bin',tankname,blockname,num2str(channelvalue),eventtowrite,num2str(handles.T1),num2str(handles.T2));
            handles.batchlist{mod,1}=updatelistbox;
            set(handles.listbox4,'Value',1);
            set(handles.listbox4,'String',handles.batchlist);
            end
        end
    end
    set(handles.checkbox1,'Value',1);
    drawnow;
    guidata(hObject, handles);
    reset_Callback(handles.reset, eventdata, handles)
    
end





% --- Executes on button press in setname.
function setname_Callback(hObject, eventdata, handles)
% hObject    handle to setname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
blockvalue=get(handles.listbox1,'Value');
blocklist=get(handles.listbox1,'String');

selectedblockname=blocklist{blockvalue,1};
set(handles.edit9,'String',selectedblockname);
guidata(hObject, handles);



function filter_lowfreq_Callback(hObject, eventdata, handles)
% hObject    handle to filter_lowfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filter_lowfreq as text
%        str2double(get(hObject,'String')) returns contents of filter_lowfreq as a double


% --- Executes during object creation, after setting all properties.
function filter_lowfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter_lowfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filter_highfreq_Callback(hObject, eventdata, handles)
% hObject    handle to filter_highfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filter_highfreq as text
%        str2double(get(hObject,'String')) returns contents of filter_highfreq as a double


% --- Executes during object creation, after setting all properties.
function filter_highfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter_highfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in use_filter.
function use_filter_Callback(hObject, eventdata, handles)
% hObject    handle to use_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_filter



function sampling_freq_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampling_freq as text
%        str2double(get(hObject,'String')) returns contents of sampling_freq as a double


% --- Executes during object creation, after setting all properties.
function sampling_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
