function GUI_slider
clc;
clear;

%// Create GUI controls
handles.figure = figure('Position',[100 100 1300 500],'Units','Pixels');

handles.axes1 = axes('Units','Pixels','Position',[30,100,400,300]);
handles.axes2 = axes('Units','Pixels','Position',[450,100,400,300]);
handles.axes3 = axes('Units','Pixels','Position',[870,100,400,300]);

set(handles.axes2, 'xtick', [], 'ytick',[]);
set(handles.axes3, 'xtick', [], 'ytick',[]);
set(handles.axes1, 'xtick', [], 'ytick',[]);

handles.Slider1 = uicontrol('Style','slider','Position',[60 20 1200 20],'Min',0,'Max',255,'SliderStep',[.1 .1],'Callback',@SliderCallback);

handles.Button1 = uicontrol('Style','pushbutton','String','Select Image','Position',[250 450 100 20],'Callback', @setmap);

handles.Edit1 = uicontrol('Style','Edit','Position',[100 450 100 20],'String','0.00');

handles.Text1 = uicontrol('Style','Text','Position',[30 450 65 20],'String','Threshold');

handles.path = 'peppers.png';

guidata(handles.figure,handles); %// Update the handles structure.

    function setmap(~,~)
        [filename pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector');
        handles.path = strcat(pathname, filename);
        guidata(handles.figure,handles); 
    end

    function SliderCallback(~,~) %// This is the slider callback, executed when you release the it or press the arrows at each extremity. 
        
  
        handles = guidata(gcf);
        
        SliderValue = get(handles.Slider1,'Value');
        set(handles.Edit1,'String',num2str(SliderValue));
        
        % read image from latest handle path
        img = imread(handles.path);
                
        % Convert to grayscale for applying sobel filter
        B=rgb2gray(img);
        
        imshow(B, 'Parent', handles.axes1)
     
        % Convert to double to increase precision
        C=double(B);
        for i=1:size(C,1)-2
            for j=1:size(C,2)-2
                %Sobel mask for x-direction:
                Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
                %Sobel mask for y-direction:
                Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));      
                %The gradient of the image
                B(i,j)=sqrt(Gx.^2+Gy.^2);
            end
        end
        
        imshow(B, 'Parent', handles.axes2)
        
        % Apply threshold on the obtained intensity gradient to get the
        % edge image
        thresh = SliderValue;
        B = max(B,thresh);
        B(B==round(thresh)) = 0;
        B = uint8(B);

        imshow(B,'Parent',handles.axes3);
        
        title(handles.axes2,'Intensity Gradient');
        title(handles.axes1,'Input Image');
        title(handles.axes3,'Edge Detected Image');
        
        set(handles.axes2, 'xtick', [], 'ytick',[]);
        set(handles.axes3, 'xtick', [], 'ytick',[]);
        set(handles.axes1, 'xtick', [], 'ytick',[]);
        
    end

end