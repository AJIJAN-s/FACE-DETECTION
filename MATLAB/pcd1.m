function varargout = pcd1(varargin)
% PCD1 MATLAB code for pcd1.fig
%      PCD1, by itself, creates a new PCD1 or raises the existing
%      singleton*.
%
%      H = PCD1 returns the handle to a new PCD1 or the handle to
%      the existing singleton*.
%
%      PCD1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCD1.M with the given input arguments.
%
%      PCD1('Property','Value',...) creates a new PCD1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcd1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pcd1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pcd1

% Last Modified by GUIDE v2.5 24-Dec-2017 08:36:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pcd1_OpeningFcn, ...
                   'gui_OutputFcn',  @pcd1_OutputFcn, ...
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


% --- Executes just before pcd1 is made visible.
function pcd1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pcd1 (see VARARGIN)

% Choose default command line output for pcd1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pcd1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pcd1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    data = 21;
    imcell = cell(1,data);
    %ColVec=zeros(256*256,1);
    ColVec1=zeros(256*256,data);
    imcell3 = zeros(data,1);
for gbr = 1:data
    imcell2 = zeros(256*256,1);
    %DD = strcat('C:\Users\Sistem_Informasi\Documents\MATLAB\gambar\',int2str(gbr));
    %location = 'C:\Users\Sistem_Informasi\Documents\MATLAB\gambar\',int2str(gbr);
    %D = dir([DD,'*.jpg']);
    %D = dir([DD,'\*.jpg']);
    %imcell = cell(1,7);
    %ColVec=zeros(256*256,1);
    %ColVec1=zeros(256*256,2);
    %imcell2 = zeros(256*256,1);
    for ij = 1:7
        D = strcat('C:\Users\Sistem_Informasi\Documents\MATLAB\gambar\',int2str(gbr),'\',int2str(ij),'.jpg');
        imcell{ij} = imread(D);
        %figure,imshow(D(ij).name);
        im = imcell{ij};
        
        %grayscale
        im2 = uint8(zeros(size(im,1),size(im,2)));
        for iiii = 1:size(im,1)
            for jjjj = 1:size(im,2)
                im2(iiii,jjjj) = 0.2989*im(iiii,jjjj,1)+0.5870*im(iiii,jjjj,2)+0.1140*im(iiii,jjjj,3);
            end
        end
        
        %gauss
        i = double(im2);
        sigma = 1;%standar deviasi
        sz = 1;
        [x,y] = meshgrid(-sz:sz,-sz:sz);
        m = size(x,1)-1;
        n = size(y,1)-1;
        exp_comp = -(x.^2+y.^2)/(2*sigma*sigma);
        Kernel = exp(exp_comp)/(2*pi*sigma*sigma);
        out = zeros(size(i));%inisialisai
        i = padarray(i,[sz sz]);%pad vector
        
        %convolution
        for ii = 1:size(i,1)-m
            for jj = 1:size(i,2)-n
                temp = i(ii:ii+m,jj:jj+m).*Kernel;
                out(ii,jj)=sum(temp(:));
            end
        end
        %gambar tanpa noise
        out = uint8(out);
        
        %Log Transformation
        ad = im2double(out);
        x = ad;
        [r,c] = size(ad);
        factor = 4;
        for iii = 1:r
            for jjj = 1:c
                x(iii,jjj) = factor *log(1+ ad(iii,jjj));
            end
        end
        
        x2 = imresize(x,[256 256]);
        
        %fusion vektor
        c=0;
        for iiiii=1:256
            for jjjjj=1:256
                c=c+1;
                imcell2(c) = ((imcell2(c)) + x2(256*(jjjjj-1)+iiiii));
                %imc = imcell2{c};
                %ColVec(c,ij) = x2(256*(jjjjj-1)+iiiii);
                %ColVec1(c,1) = imcell2(c);
                ColVec1(c,gbr) = imcell2(c)/7;
            end
        end
        %save('data.mat','ColVec')
        save('data.mat','ColVec1')
        
        %figure, imshow(x2);
    end
        
end

[FileName,PathName]=uigetfile('*.jpg','Select Image File');
img=imread([PathName, FileName]);
handles.img=img;%buat nyimpen nilai variable
guidata(hObject,handles);%instruksi simpen objek
axes(handles.axes1);%memasukkan nilai variabel pada axis
imshow(img);%menampilkan image hasil browse
%img2 = imnoise(img,'gaussian',0.09);
img2 = img;
%handles.img2=img2;
%guidata(hObject,handles);
%axes(handles.axes4);
%imshow(img2);

%grayscale
%im2 = rgb2gray(im);
img3 = uint8(zeros(size(img2,1),size(img2,2)));
for iiii = 1:size(img2,1)
    for jjjj = 1:size(img2,2)
        img3(iiii,jjjj) = 0.2989*img2(iiii,jjjj,2)+0.5870*img2(iiii,jjjj,2)+0.1140*img2(iiii,jjjj,3);
    end
end
handles.img3=img3;
guidata(hObject,handles);
axes(handles.axes5);
imshow(img3);

%gaussian
inn = double(img3);
sigma2 = 1;%standar deviasi
sz2 = 1;
[x2,y2] = meshgrid(-sz2:sz2,-sz2:sz2);
m2 = size(x2,1)-1;
n2 = size(y2,1)-1;
exp_comp2 = -(x2.^2+y2.^2)/(2*sigma2*sigma2);
Kernel2 = exp(exp_comp2)/(2*pi*sigma2*sigma2);
out2 = zeros(size(inn));%inisialisai
inn = padarray(inn,[sz2 sz2]);%pad vector

%convolution
for ii2 = 1:size(inn,1)-m2
    for jj2 = 1:size(inn,2)-n2
        temp = inn(ii2:ii2+m2,jj2:jj2+m2).*Kernel2;
        out2(ii2,jj2)=sum(temp(:));
    end
end

%gambar tanpa noise
out2 = uint8(out2);
handles.out2=out2;
guidata(hObject,handles);
axes(handles.axes6);
imshow(out2);

%Log Transformation
ad2 = im2double(out2);
x3 = ad2;
%y = ad;
[r2,c2] = size(ad2);
factor2 = 4;
for iii2 = 1:r2
    for jjj2 = 1:c2
        x3(iii2,jjj2) = factor2 *log(1+ ad2(iii2,jjj2));
        %y(iii,jjj) = factor *ad(iii,jjj) ^20;
    end
end
%subplot(1,2,2);
%imshow(x);
%imshow(y);
handles.x3=x3;
guidata(hObject,handles);
axes(handles.axes7);
imshow(x3);

x4 = imresize(x3,[256 256]);

%vektor
    ColVec2 = zeros(256*256,1);
    ColVec3 = zeros(256*256,1);
    load('data.mat','ColVec1');
for ij2 = 1:data
    c2=0;
    c3=0;
    c4=0;
    c5=0;
    for iiiii2=1:256
        for jjjjj2=1:256
           c2=c2+1;
           ColVec2(c2,1) = (x4(256*(jjjjj2-1)+iiiii2));
           %ColVec3(c2,1) = (x4(256*(jjjjj2-1)+iiiii2));
           %ColVec3(c2,1) = ((ColVec1(c2,1)) - x4(256*(jjjjj2-1)+iiiii2));
           ColVec3(c2,ij2) = sqrt(((ColVec1(c2,ij2)) - x4(256*(jjjjj2-1)+iiiii2))^2);
           if (ColVec3(c2,ij2)==0)
               c3=c3+1;
               %set(handles.edit1,'string',c3);
           elseif (ColVec3(c2,ij2) > 0 && ColVec3(c2,ij2) < 1)
               c4=c4+1;
               %set(handles.edit1,'string',c3);
               %set(handles.edit2,'string',c4);
           else
               c5=c5+1;
               %set(handles.edit3,'string',c5);
           end
        end
    end
    imcell3(ij2) = c5;
    %save('data.mat','ColVec','ColVec1','ColVec3')
    save('data.mat','ColVec1','ColVec2','ColVec3')
end

min = imcell3(1);
for cari = 2:data
    if (imcell3(cari)<min)
        min = imcell3(cari);
        set(handles.edit3,'string',min);
        if (min == imcell3(1))
            set(handles.text10,'string','BILL');
        elseif (min == imcell3(2))
            set(handles.text10,'string','JHON');
        elseif (min == imcell3(3))
            set(handles.text10,'string','BRAYEN');
        elseif (min == imcell3(4))
            set(handles.text10,'string','BIM');
        elseif (min == imcell3(5))
            set(handles.text10,'string','CIKA');
        elseif (min == imcell3(6))
            set(handles.text10,'string','JESS');
        elseif (min == imcell3(7))
            set(handles.text10,'string','SENN');
        elseif (min == imcell3(8))
            set(handles.text10,'string','OBAMA');
        elseif (min == imcell3(9))
            set(handles.text10,'string','RADITYA');
        elseif (min == imcell3(10))
            set(handles.text10,'string','RUDDY');
        elseif (min == imcell3(11))
            set(handles.text10,'string','ZEN');
        elseif (min == imcell3(12))
            set(handles.text10,'string','GEORGE');
        elseif (min == imcell3(13))
            set(handles.text10,'string','LIYA');
        elseif (min == imcell3(14))
            set(handles.text10,'string','UDIN');
        elseif (min == imcell3(15))
            set(handles.text10,'string','AJI');
        elseif (min == imcell3(16))
            set(handles.text10,'string','BUDI');
        elseif (min == imcell3(17))
            set(handles.text10,'string','GILANG');
        elseif (min == imcell3(18))
            set(handles.text10,'string','ILHAM');
        elseif (min == imcell3(19))
            set(handles.text10,'string','LAILY');
        elseif (min == imcell3(20))
            set(handles.text10,'string','REZA');
        elseif (min == imcell3(21))
            set(handles.text10,'string','WHO');
        else
            set(handles.text10,'string','not found');
        end
    else
        set(handles.edit3,'string',min);
        if (min == imcell3(1))
            set(handles.text10,'string','BILL');
        elseif (min == imcell3(2))
            set(handles.text10,'string','JHON');
        elseif (min == imcell3(3))
            set(handles.text10,'string','BRAYEN');
        elseif (min == imcell3(4))
            set(handles.text10,'string','BIM');
        elseif (min == imcell3(5))
            set(handles.text10,'string','CIKA');
        elseif (min == imcell3(6))
            set(handles.text10,'string','JESS');
        elseif (min == imcell3(7))
            set(handles.text10,'string','SENN');
        elseif (min == imcell3(8))
            set(handles.text10,'string','OBAMA');
        elseif (min == imcell3(9))
            set(handles.text10,'string','RADITYA');
        elseif (min == imcell3(10))
            set(handles.text10,'string','RUDDY');
        elseif (min == imcell3(11))
            set(handles.text10,'string','ZEN');
        elseif (min == imcell3(12))
            set(handles.text10,'string','GEORGE');
        elseif (min == imcell3(13))
            set(handles.text10,'string','LIYA');
        elseif (min == imcell3(14))
            set(handles.text10,'string','UDIN');
        elseif (min == imcell3(15))
            set(handles.text10,'string','AJI');
        elseif (min == imcell3(16))
            set(handles.text10,'string','BUDI');
        elseif (min == imcell3(17))
            set(handles.text10,'string','GILANG');
        elseif (min == imcell3(18))
            set(handles.text10,'string','ILHAM');
        elseif (min == imcell3(19))
            set(handles.text10,'string','LAILY');
        elseif (min == imcell3(20))
            set(handles.text10,'string','REZA');
        elseif (min == imcell3(21))
            set(handles.text10,'string','WHO');
        else
            set(handles.text10,'string','not found');
        end
    end
end
if (min>2000)
    set(handles.text10,'string','Not Found');
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
