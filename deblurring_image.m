                       %% This is the initialization code 
% The following lines are written by the author himself:
% 1-8,41-52,55-110,113-175,178-445,448-455
% Lines 9-40 and 455-497 got generated during GUI creation
% Lines 53,54,111,112,176,177,446,447 are for creating a dialog
% box for loading/saving an image that author has copied from
% https://in.mathworks.com/matlabcentral/answers/75430-how-i-can-upload-a-picture-using-gui-when-i-push-a-pushbutton
% Formulae for deblurring an image are used from Digital Image Processing by Rafael Gonzales
function varargout = deblurring_image(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @deblurring_image_OpeningFcn, ...
                   'gui_OutputFcn',  @deblurring_image_OutputFcn, ...
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


% --- Executes just before deblurring_image is made visible.
function deblurring_image_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;


guidata(hObject, handles);
clear global
clearvars
clc;
% --- Outputs from this function are returned to the command line.
function varargout = deblurring_image_OutputFcn(hObject, eventdata, handles) 
                        %% My Code begins here
%Code implements following features :
% 1. Inverse Filtering
% 2. Radial Filtering / Truncated Inverse Filtering
% 3. Wiener Filtering
% 4. Constrained Least Squares Filtering

                        %%    Load an image
% --- Executes on button press in load_image.
                            
function load_image_Callback(hObject, eventdata, handles) 

handles=guidata(hObject);
[file,path]=uigetfile({'*.jpg';'*.png'},'Select the image'); 

%Pop up to load image. By default, .jpg images will be displayed 

if file==0             %If 'Cancel' button is pressed, then return
    return             %Return from the function
end

file_name=strcat(path,file);        % Name of an image with its path
global img orig_img img_past blurred_img size_blurred_img ...
    blurred_fft_r blurred_fft_g blurred_fft_b; % Declaring global variables

img=im2double(imread(file_name));   %Reading image & convert to double
orig_img=img;                       %Saving the original image
                                    %Retrieve on pressing'Undo all changes'
axes(handles.display_area)          % Display area
imshow(orig_img)                    %Show original image

text=sprintf('Image Loaded:\n%s',file_name);   %Text
set(handles.display_text,'string',text)        %Text display

blurred_img=zeros(2*size(orig_img,1),2*size(orig_img,2),3); %Image repeating periodically

% Repeating the same image to the right, bottom and right diagonal
blurred_img(1:size(orig_img,1),1:size(orig_img,2),:)=orig_img;
blurred_img(size(orig_img,1)+1:2*size(orig_img,1),1:size(orig_img,2),:)...
    =blurred_img(1:size(orig_img,1),1:size(orig_img,2),:);
blurred_img(1:size(orig_img,1),size(orig_img,2)+1:2*size(orig_img,2),:)...
    =blurred_img(1:size(orig_img,1),1:size(orig_img,2),:);
blurred_img(size(orig_img,1)+1:2*size(orig_img,1),size(orig_img,2)+1:2*size(orig_img,2),:)...
    =blurred_img(1:size(orig_img,1),1:size(orig_img,2),:);


size_blurred_img=size(blurred_img); %size of blurred image

% Red Channel of blurred image
blurred_img_r=blurred_img(:,:,1); %Red
blurred_fft_r=fft2(blurred_img_r,size_blurred_img(1),size_blurred_img(2)); %FFT of red channel

% Green Channel of blurred image
blurred_img_g=blurred_img(:,:,2); %Green
blurred_fft_g=fft2(blurred_img_g,size_blurred_img(1),size_blurred_img(2)); %FFT of green channel

% Blue Channel of blurred image
blurred_img_b=blurred_img(:,:,3); %Blue
blurred_fft_b=fft2(blurred_img_b,size_blurred_img(1),size_blurred_img(2)); %FFT of blue channel

img_past=img;         %Create copy of img,
                      %take a backup everytime before any operation and
                      %to retrieve on pressing 'Undo Last change'
                      
                      
                      %% Load Kernel Image
% --- Executes on button press in kernel_pb.

function kernel_pb_Callback(hObject, eventdata, handles)

handles=guidata(hObject);
[file,path]=uigetfile({'*.png';'*.jpg';'*.tif'},'Select the image'); 
%Pop up to load image. By default, .png images will be displayed 

if file==0             %If 'Cancel' button is pressed, then return
    return             %Return from the function
end

file_name=strcat(path,file);        % Name of a kernel image with its path
global kernel kernel_temp kernel_fft size_blurred_img % Declaring global variables
kernel=im2double(imread(file_name));              %Reading kernel

axes(handles.kernel)
imshow(kernel)                    %Show original image

text=sprintf('Kernel Loaded:\n%s',file_name);           %Text
set(handles.display_text,'string',text)                 %Text display

kernel_temp=kernel;%Temp variable to store kernel(needed for Wiener filter)
kernel=kernel/sum(sum(kernel(:,:))); %Normalising the kernel coefficients
kernel_fft=fft2(kernel,size_blurred_img(1),size_blurred_img(2)); %FFT of kernel


                            %% Undo Last Change
                            
% --- Executes on button press in undo_last.
function undo_last_Callback(hObject, eventdata, handles)

global img img_past orig_img;      %Declaring global variables
handles=guidata(hObject);
set(handles.display_text,'string','')

img=img_past;              %Undo Last change by taking img = img_past 
axes(handles.display_area) %Display Area
imshow(img)                % Check certain things
axes(handles.display_area) %Display Area
imshow(img)                %Show the image

set(handles.display_text,'string','Last change undone') %Display Text
guidata(hObject, handles);

                            %% Undo All Changes
                            
% --- Executes on button press in undo_all.
function undo_all_Callback(hObject, eventdata, handles)
global img orig_img img_past flag;  %Declaring global variables

handles=guidata(hObject);
set(handles.display_text,'string','')

img_past=img;              %Backup
img=orig_img;              % Undo All changes: set img = orig_img
axes(handles.display_area) %Display Area
imshow(img)                %Show the image

set(handles.display_text,'string','All changes undone') %Display Text
guidata(hObject, handles);

                               %% Save an Image
                               
% --- Executes on button press in save_img.
function save_img_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
global recovered_img_final;                        %Declaring global variables

 % Prompt to save the file
[file, path] = uiputfile({'*.png';'*.jpg';'*.bmp'},'Save the file');

if file==0 %If Cancel button pressed, return
    return %Return from the function
end

img_name=strcat(path,file);               %Image name
imwrite(recovered_img_final, img_name);                   %Save image
text=sprintf('Image saved \n:%s',img_name); %Text
set(handles.display_text,'string',text)   %Display Text
guidata(hObject, handles);


                      %%     Inverse Filtering

% --- Executes on button press in inverse_pb.
function inverse_pb_Callback(hObject, eventdata, handles) 

handles=guidata(hObject);
global kernel orig_img img img_past recovered_img recovered_img_final kernel_fft...
    blurred_fft_r blurred_fft_g blurred_fft_b;%Declaring global variables
img_past=img;

inverse_filter_r=blurred_fft_r./kernel_fft; %Inverse filtering on Red channel
inverse_filter_g=blurred_fft_g./kernel_fft; %Inverse filtering on Green channel
inverse_filter_b=blurred_fft_b./kernel_fft; %Inverse filtering on Blue channel

recovered_img_r=real(ifft2(inverse_filter_r)); % Red channel
recovered_img_g=real(ifft2(inverse_filter_g)); % Green channel
recovered_img_b=real(ifft2(inverse_filter_b)); % Blue channel 

clear recovered_img %Clear the variable before initialising again
%Combining channels
recovered_img(:,:,1)=recovered_img_r;
recovered_img(:,:,2)=recovered_img_g;
recovered_img(:,:,3)=recovered_img_b;

recovered_img=recovered_img(1:size(orig_img,1),1:size(orig_img,2),1:size(orig_img,3)); 
%Image with size of blurred input image

%% Performing some spatial operations to bring back the pixels of the 
%%output image to their original position 


recovered_img_temp=zeros(size(orig_img));
recovered_img_final=recovered_img_temp;

%Row operations
recovered_img_temp(round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:)=...
     recovered_img(1:size(orig_img,1)-round(size(kernel,1)/2+1),1:size(orig_img,2),:);
recovered_img_temp(1:round(size(kernel,1)/2+1),1:size(orig_img,2),:)=...
     recovered_img(size(orig_img,1)-round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:);
recovered_img=recovered_img_temp;

 %Column operations
recovered_img_final(:,round(size(kernel,2)/2+1)+1:size(orig_img,2),:)=...
      recovered_img(:,1:size(orig_img,2)-round(size(kernel,2)/2+1),:);
 recovered_img_final(:,1:round(size(kernel,2)/2+1),:)=...
      recovered_img(:,size(orig_img,2)-round(size(kernel,2)/2+1)+1:size(orig_img,2),:);
axes(handles.display_area)                 %Display Area
imshow(recovered_img_final)                %Show the image
img=recovered_img_final;
set(handles.display_text,'string','Inverse Filtering Performed')    %Text display
guidata(hObject, handles);

                      

                        %%  Radial Filtering     
                        
% --- Executes on button press in radius_pb.
function radius_pb_Callback(hObject, eventdata, handles)
global orig_img img img_past size_blurred_img kernel_fft kernel...
    blurred_fft_r blurred_fft_g blurred_fft_b reconstructed_img_final;  %Declaring global variables

img_past=img;                           %Backup
set(handles.display_text,'string','')

radius=get(handles.radius_slider,'value');  %Get the value based on slider's position
order=10; %Order of butterworth filter

butterworthf=butterworth_lpf(size_blurred_img(1:2),radius,order); %Butterworth LPF
butterworthf=my_fftshift(butterworthf); %fft-shifting

inverse_filter_r=blurred_fft_r./kernel_fft; % Red channel
inverse_filter_g=blurred_fft_g./kernel_fft; % Green channel
inverse_filter_b=blurred_fft_b./kernel_fft; % Blue channel
reconstructed_img_butterworth_r=real(ifft2(inverse_filter_r.*butterworthf)); %Reconstructed image
reconstructed_img_butterworth_g=real(ifft2(inverse_filter_g.*butterworthf)); %Reconstructed image
reconstructed_img_butterworth_b=real(ifft2(inverse_filter_b.*butterworthf)); %Reconstructed image

clear reconstructed_img %Clear the variable before initialising
reconstructed_img(:,:,1)=reconstructed_img_butterworth_r;
reconstructed_img(:,:,2)=reconstructed_img_butterworth_g;
reconstructed_img(:,:,3)=reconstructed_img_butterworth_b;

reconstructed_img=reconstructed_img(1:size(orig_img,1),1:size(orig_img,2),1:size(orig_img,3));
%Image with size of blurred input image

%% Performing some spatial operations to bring back the pixels of the 
%output image to their original position 

reconstructed_img_temp=zeros(size(orig_img));
reconstructed_img_final=zeros(size(orig_img));

%Row operations
reconstructed_img_temp(round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:)=...
     reconstructed_img(1:size(orig_img,1)-round(size(kernel,1)/2+1),1:size(orig_img,2),:);
reconstructed_img_temp(1:round(size(kernel,1)/2+1),1:size(orig_img,2),:)=...
     reconstructed_img(size(orig_img,1)-round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:);
reconstructed_img=reconstructed_img_temp;

 %Column operations
reconstructed_img_final(:,round(size(kernel,2)/2+1)+1:size(orig_img,2),:)=...
      reconstructed_img(:,1:size(orig_img,2)-round(size(kernel,2)/2+1),:);
 reconstructed_img_final(:,1:round(size(kernel,2)/2+1),:)=...
      reconstructed_img(:,size(orig_img,2)-round(size(kernel,2)/2+1)+1:size(orig_img,2),:);
%%
set(handles.display_text,'string','Processing ...') % text display
axes(handles.display_area)                          %Display Area
imshow(reconstructed_img_final)                     %Show the image
img=reconstructed_img_final;
text=sprintf('Radial Inverse Filter (radius=%f',radius); %Text
set(handles.display_text,'string',text)              %Display Text

guidata(hObject, handles);

                           %% Slider (radius in radial filtering)

function radius_slider_Callback(hObject, eventdata, handles)
 sliderValue = get(handles.radius_slider,'Value');%Value based on slider's position
 
 set(handles.radius_text,'String',num2str(sliderValue));
 %Display slider value in text box
 
 
 
 
                           %% CLS Filtering
                           
function cls_pb_Callback(hObject, eventdata, handles)
global orig_img img img_past size_blurred_img kernel_fft kernel...
    blurred_fft_r blurred_fft_g blurred_fft_b reconstructed_img_final;  %Declaring global variables

img_past=img;                           %Backup
set(handles.display_text,'string','')
gamma=get(handles.cls_slider,'value');  %Get the value based on slider's position
kernel_mag_squared=(abs(kernel_fft)).^2; %Magnitude square of kernel fft
P=[0 -1  0;                                       %Laplacian Matrix
   -1 4 -1;
   0 -1  0];

P_fft=fft2(P,size_blurred_img(1),size_blurred_img(2)); %FFT of P
P_fft_squared=(abs(P_fft)).^2; %Magnitude square of P fft

%Perform CLS Filtering
cl_filter_r=(conj(kernel_fft)./(kernel_mag_squared+(gamma*P_fft_squared))).*blurred_fft_r;
cl_filter_g=(conj(kernel_fft)./(kernel_mag_squared+(gamma*P_fft_squared))).*blurred_fft_g;
cl_filter_b=(conj(kernel_fft)./(kernel_mag_squared+(gamma*P_fft_squared))).*blurred_fft_b;

%Outputs
cl_filtered_output(:,:,1)=real(ifft2(cl_filter_r));
cl_filtered_output(:,:,2)=real(ifft2(cl_filter_g));
cl_filtered_output(:,:,3)=real(ifft2(cl_filter_b));

%% Performing some spatial operations to bring back the pixels of the 
%%output image to their original position 

reconstructed_img_temp=zeros(size(orig_img));
reconstructed_img_final=zeros(size(orig_img));

%Row operations
reconstructed_img_temp(round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:)=...
     cl_filtered_output(1:size(orig_img,1)-round(size(kernel,1)/2+1),1:size(orig_img,2),:);
reconstructed_img_temp(1:round(size(kernel,1)/2+1),1:size(orig_img,2),:)=...
     cl_filtered_output(size(orig_img,1)-round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:);
cl_filtered_output=reconstructed_img_temp;

 %Column operations
reconstructed_img_final(:,round(size(kernel,2)/2+1)+1:size(orig_img,2),:)=...
      cl_filtered_output(:,1:size(orig_img,2)-round(size(kernel,2)/2+1),:);
 reconstructed_img_final(:,1:round(size(kernel,2)/2+1),:)=...
      cl_filtered_output(:,size(orig_img,2)-round(size(kernel,2)/2+1)+1:size(orig_img,2),:);

set(handles.display_text,'string','Processing ...') % text display
axes(handles.display_area)                          %Display Area
imshow(reconstructed_img_final)                     %Show the image
img=reconstructed_img_final;
text=sprintf('CLS Filter (gamma=%f',gamma);         %Text
set(handles.display_text,'string',text)             %Display Text
guidata(hObject, handles);

                                %% CLS:Gamma value
function cls_slider_Callback(hObject, eventdata, handles)
sliderValue = get(handles.cls_slider,'Value');%Value based on slider's position 
 set(handles.gamma_text,'String',num2str(sliderValue));


                                %% Wiener:K value

function wiener_slider_Callback(hObject, eventdata, handles)

sliderValue = get(handles.wiener_slider,'Value');%Value based on slider's position
 set(handles.wiener_text,'String',num2str(sliderValue));



                                %% Wiener Filtering

function wiener_pb_Callback(hObject, eventdata, handles)
global orig_img img img_past size_blurred_img kernel_temp kernel...
    blurred_fft_r blurred_fft_g blurred_fft_b reconstructed_img_final;  %Declaring global variables

img_past=img;                           %Backup
set(handles.display_text,'string','')
K=get(handles.wiener_slider,'value');  %Get the value based on slider's position
kernel_fft=fft2(kernel_temp,size_blurred_img(1),size_blurred_img(2)); %FFT of kernel
kernel_mag_squared=(abs(kernel_fft)).^2; %Magnitude square of kernel fft
kernel_fft=kernel_fft/sum(sum(kernel_temp(:,:))); %Normalise kernel
inverse_filter_r=blurred_fft_r./kernel_fft; % Red channel
inverse_filter_g=blurred_fft_g./kernel_fft; % Green channel
inverse_filter_b=blurred_fft_b./kernel_fft; % Blue channel

%Perform Wiener filtering
weiner_filter_r=(kernel_mag_squared./(kernel_mag_squared+K)).*(inverse_filter_r);
weiner_filter_g=(kernel_mag_squared./(kernel_mag_squared+K)).*(inverse_filter_g);
weiner_filter_b=(kernel_mag_squared./(kernel_mag_squared+K)).*(inverse_filter_b);

%Output
reconstructed_img(:,:,1)=real(ifft2(weiner_filter_r));
reconstructed_img(:,:,2)=real(ifft2(weiner_filter_g));
reconstructed_img(:,:,3)=real(ifft2(weiner_filter_b));


reconstructed_img=reconstructed_img(1:size(orig_img,1),1:size(orig_img,2),1:size(orig_img,3));
%% Performing some spatial operations to bring back the pixels of the 
%output image to their original position 

reconstructed_img_temp=zeros(size(orig_img));
reconstructed_img_final=zeros(size(orig_img));

%Row operations
reconstructed_img_temp(round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:)=...
     reconstructed_img(1:size(orig_img,1)-round(size(kernel,1)/2+1),1:size(orig_img,2),:);
reconstructed_img_temp(1:round(size(kernel,1)/2+1),1:size(orig_img,2),:)=...
     reconstructed_img(size(orig_img,1)-round(size(kernel,1)/2+1)+1:size(orig_img,1),1:size(orig_img,2),:);
reconstructed_img=reconstructed_img_temp;

 %Column operations
reconstructed_img_final(:,round(size(kernel,2)/2+1)+1:size(orig_img,2),:)=...
      reconstructed_img(:,1:size(orig_img,2)-round(size(kernel,2)/2+1),:);
 reconstructed_img_final(:,1:round(size(kernel,2)/2+1),:)=...
      reconstructed_img(:,size(orig_img,2)-round(size(kernel,2)/2+1)+1:size(orig_img,2),:);
set(handles.display_text,'string','Processing ...') % text display
axes(handles.display_area) %Display Area
imshow(reconstructed_img_final)                     %Show the image
img=reconstructed_img_final;
text=sprintf('Wiener Filter (K=%f',K); %Text
set(handles.display_text,'string',text)              %Display Text
guidata(hObject, handles);
% handles    structure with handles and user data (see GUIDATA)
                           
                            %% PSNR and SSIM calculation
% --- Executes on button press in metrics.
function metrics_Callback(hObject, eventdata, handles)
% hObject    handle to metrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img;  %Declaring global variables
[file,path]=uigetfile({'*.jpg'},'Select the image w.r.t. which you want to calculate metrics'); 
                       
file_name=strcat(path,file);            % Name of an image with its path
gt=im2double(imread(file_name));
set(handles.display_text,'string','')
ssim_img=ssim(img,gt);           %Calculate SSIM
psnr_img=psnr(img,gt);           %Calculate PSNR

text=sprintf('PSNR is %f and SSIM is %f',psnr_img,ssim_img); %Text
set(handles.display_text,'string',text)              %Display Text
                        %% Other created functions not used in GUI


% --- Executes during object creation, after setting all properties.
function radius_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function radius_text_CreateFcn(hObject, eventdata, handles)





% --- Executes during object creation, after setting all properties.
function cls_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cls_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function wiener_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wiener_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end