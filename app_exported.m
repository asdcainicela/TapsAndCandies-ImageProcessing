classdef app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        ImagePhoto2   matlab.ui.control.Image
        ImagePhoto1   matlab.ui.control.Image
        ImageVideo    matlab.ui.control.Image
        Image         matlab.ui.control.Image
        UIAxesPhoto2  matlab.ui.control.UIAxes
        UIAxesPhoto1  matlab.ui.control.UIAxes
        UIAxesVideo   matlab.ui.control.UIAxes
    end

    
    properties (Access = public) 
        StartVideoBtn   % Botón Start Video
        Capture1Btn     % Botón Capture 1
        Capture2Btn     % Botón Capture 2
        Load1Btn        % Botón Load 1
        Load2Btn        % Botón Load 2
        Save1Btn        % Botón Save 1
        ClearAllBtn     % Botón Clear all
        Save2Btn       % Botón Save 2
        ProcessBtn     % Botón Process

        % ---- camera ---- %
        cam % Objeto de webcam
        timerObj % Objeto de temporizador para actualizar video
        isCameraRunning = false % Estado de la cámara

        imagePhoto1Data % Data de la imagen 1
        imagePhoto2Data % Data de la imagen 2

    end
    
    methods (Access = private)
        
         % Función para manejar el clic en cualquier botón
        function onButtonClicked(app, btnName)
            uialert(app.UIFigure, sprintf("Botón %s presionado!", btnName), "Aviso");
        end
        function IniciarVideoButtonPushed(app)
            if app.isCameraRunning
                % Si la cámara está activa, la pausamos
                stop(app.timerObj);
                delete(app.timerObj);
                app.timerObj = [];
                app.isCameraRunning = false;
                
                % Restauramos el botón a estado inicial
                app.StartVideoBtn.Text = 'Start Video';
                app.StartVideoBtn.Color = '#0097a7';
                app.StartVideoBtn.BackgroundHexColor = '#c7e9e9';
                
                % Mostramos el placeholder
                app.ImageVideo.Visible = 'on';
            else
                % Si la cámara no está activa, la iniciamos
                if isempty(app.cam) || ~isvalid(app.cam)
                    app.cam = webcam;
                end
                
                app.ImageVideo.Visible = 'off';
                cla(app.UIAxesVideo, "reset");
                
                app.timerObj = timer(...
                    'ExecutionMode', 'fixedRate', ...
                    'Period', 0.2, ...
                    'TimerFcn', @(~,~) mostrarVideo(app));
                
                start(app.timerObj);
                app.isCameraRunning = true;
                
                % Cambiamos el botón a estado "Pause"
                app.StartVideoBtn.Text = 'Stop Video';
                app.StartVideoBtn.Color = '#FF8C00';
                app.StartVideoBtn.BackgroundHexColor = '#c7e9e9';
            end
        end
        
        function FotoButtonPushed(app, value)
            if ~app.isCameraRunning
                uialert(app.UIFigure, 'First, you must start the camera', 'Error');
                return;
            end
            
            try
                foto = snapshot(app.cam);
                if value == "Camera 1"
                    app.ImagePhoto1.Visible = "off";
                    cla(app.UIAxesPhoto1, "reset");
                    image(app.UIAxesPhoto1, foto);
                    app.UIAxesPhoto1.XTick = [];
                    app.UIAxesPhoto1.YTick = [];
                    app.imagePhoto1Data = foto; % Guardamos imagen
                elseif value == "Camera 2"
                    app.ImagePhoto2.Visible = "off";
                    cla(app.UIAxesPhoto2, "reset");
                    image(app.UIAxesPhoto2, foto);
                    app.UIAxesPhoto2.XTick = [];
                    app.UIAxesPhoto2.YTick = [];
                    app.imagePhoto2Data = foto; % Guardamos imagen
                end
            catch ME
                uialert(app.UIFigure, ME.message, 'Error capturing photo');
            end
        end

        % Guardar imagen en archivo
        function SaveImage(app, imageData, fileName)
            if isempty(imageData)
                uialert(app.UIFigure, "No image to save.", "Warning");
                return;
            end
            [file, path] = uiputfile({'*.png'; '*.jpg'}, fileName);
            if isequal(file, 0)
                return;
            end
            imwrite(imageData, fullfile(path, file));
        end
        
        % Cargar imagen desde archivo
        function LoadImage(app, camName)
            [file, path] = uigetfile({'*.png;*.jpg;*.jpeg'}, 'Select an image');
            if isequal(file, 0)
                return;
            end
            img = imread(fullfile(path, file));
            if camName == "Camera 1"
                app.imagePhoto1Data = img;
                app.ImagePhoto1.Visible = "off";
                cla(app.UIAxesPhoto1, "reset");
                image(app.UIAxesPhoto1, img);
                app.UIAxesPhoto1.XTick = [];
                app.UIAxesPhoto1.YTick = [];
            elseif camName == "Camera 2"
                app.imagePhoto2Data = img;
                app.ImagePhoto2.Visible = "off";
                cla(app.UIAxesPhoto2, "reset");
                image(app.UIAxesPhoto2, img);
                app.UIAxesPhoto2.XTick = [];
                app.UIAxesPhoto2.YTick = [];
            end
        end
        
        % Limpiar todas las imágenes
        function ClearAll(app)
            % Limpiar los datos
            app.imagePhoto1Data = [];
            app.imagePhoto2Data = [];
            
            % Restaurar imágenes por defecto
            app.ImagePhoto1.Visible = 'on';
            cla(app.UIAxesPhoto1, 'reset');
        
            app.ImagePhoto2.Visible = 'on';
            cla(app.UIAxesPhoto2, 'reset');
        
            %app.ImageVideo.Visible = 'on';
            %cla(app.UIAxesVideo, 'reset');
        end

    end
    
    
    methods (Access = public)
         function mostrarVideo(app)
            try
                frame = snapshot(app.cam);
                image(app.UIAxesVideo, frame);
                app.UIAxesVideo.XTick = [];
                app.UIAxesVideo.YTick = [];
            catch ME
                % Si hay error, restauramos el estado
                app.isCameraRunning = false;
                app.StartVideoBtn.Text = 'Start Video';
                app.StartVideoBtn.Color = '#0097a7';
                app.StartVideoBtn.BackgroundHexColor = '#c7e9e9';
                app.ImageVideo.Visible = 'on';
                uialert(app.UIFigure, ME.message, 'Camera error');
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            addpath(genpath(fullfile(pwd, 'RoundButton'))); % path de los botones
            bgHex = "#1a1a1a";
            app.UIFigure.Color = bgHex;
            
            btnWidth = 170; %185.3;
            btnHeight = 50; %59.7;
            
            % Create buttons with adjusted positions
            % Note: Font size must be handled within RoundButton's implementation
            app.StartVideoBtn = RoundButton(app.UIFigure, ...
                "Position", [421 572.3+11 btnWidth btnHeight], ...
                "Color", "#0097a7", ...
                "FontColor", "white", ...
                "Text", "Start Video", ...
                "Bold", true, ...
                "BackgroundHexColor", "#c7e9e9");
            %app.StartVideoBtn.ButtonPushedFcn = @(src, event) app.onButtonClicked("Start Video");
            app.StartVideoBtn.ButtonPushedFcn = @(src,event) app.IniciarVideoButtonPushed();
            
            app.Capture1Btn = RoundButton(app.UIFigure, ...
                "Position", [421 504.3+11 btnWidth btnHeight], ...
                "Color", "#81d4fa", ...
                "FontColor", "black", ...
                "Text", "Capture 1", ...
                "Bold", false, ...
                "BackgroundHexColor", "#c8e8e8");
            app.Capture1Btn.ButtonPushedFcn = @(src, event) app.FotoButtonPushed("Camera 1");
            
            app.Capture2Btn = RoundButton(app.UIFigure, ...
                "Position", [421 431.8+11 btnWidth btnHeight], ...
                "Color", "#81d4fa", ...
                "FontColor", "black", ...
                "Text", "Capture 2", ...
                "Bold", false, ...
                "BackgroundHexColor", "#caeaea");
            app.Capture2Btn.ButtonPushedFcn = @(src, event) app.FotoButtonPushed("Camera 2");
            
            app.Load1Btn = RoundButton(app.UIFigure, ...
                "Position", [90 321.9+11 btnWidth btnHeight], ...
                "Color", "#4dd0e1", ...
                "FontColor", "black", ...
                "Text", "Load 1", ...
                "Bold", false, ...
                "BackgroundHexColor", "#c4e9ea");
            app.Load1Btn.ButtonPushedFcn = @(src, event) LoadImage(app, "Camera 1");
            
            app.Load2Btn = RoundButton(app.UIFigure, ...
                "Position", [421 321.9+11 btnWidth btnHeight], ...
                "Color", "#4dd0e1", ...
                "FontColor", "black", ...
                "Text", "Load 2", ...
                "Bold", false, ...
                "BackgroundHexColor", "#d0e8e4");
            app.Load2Btn.ButtonPushedFcn = @(src, event) LoadImage(app, "Camera 2");
            
            app.Save1Btn = RoundButton(app.UIFigure, ...
                "Position", [46 10.3+11 btnWidth btnHeight], ...
                "Color", "#00e4ff", ...
                "FontColor", "black", ...
                "Text", "Save 1", ...
                "Bold", false, ...
                "BackgroundHexColor", "#cee8e5");
            app.Save1Btn.ButtonPushedFcn = @(src, event) SaveImage(app, app.imagePhoto1Data, 'Save Camera 1');
            
            app.ClearAllBtn = RoundButton(app.UIFigure, ...
                "Position", [243 10.3+11 btnWidth btnHeight], ...
                "Color", "#00e4ff", ...
                "FontColor", "black", ...
                "Text", "Clear all", ...
                "Bold", false, ...
                "BackgroundHexColor","#d2e8e3");
            %app.ClearAllBtn.ButtonPushedFcn = @(src, event) app.onButtonClicked("Clear all");
            app.ClearAllBtn.ButtonPushedFcn = @(src, event) ClearAll(app);

            app.Save2Btn = RoundButton(app.UIFigure, ...
                "Position", [441 10.3+11 btnWidth btnHeight], ...
                "Color", "#00e4ff", ...
                "FontColor", "black", ...
                "Text", "Save 2", ...
                "Bold", false, ...
                "BackgroundHexColor", "#d6e7e1");
            %app.Save2Btn.ButtonPushedFcn = @(src, event) app.onButtonClicked("Save 2");
            app.Save2Btn.ButtonPushedFcn = @(src, event) SaveImage(app, app.imagePhoto2Data, 'Save Camera 2');
 
            app.ProcessBtn = RoundButton(app.UIFigure, ...
                "Position", [929 596.3+11 btnWidth btnHeight], ...
                "Color", "#ff0a0a", ...
                "FontColor", "white", ...
                "Text", "Process", ...
                "Bold", true, ...
                "BackgroundHexColor", "#dbe7db");
            app.ProcessBtn.ButtonPushedFcn = @(src, event) app.onButtonClicked("Process");

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [10 50 1366 768];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Resize = 'off';
            app.UIFigure.Theme = 'light';

            % Create UIAxesVideo
            app.UIAxesVideo = uiaxes(app.UIFigure);
            title(app.UIAxesVideo, 'Title')
            xlabel(app.UIAxesVideo, 'X')
            ylabel(app.UIAxesVideo, 'Y')
            zlabel(app.UIAxesVideo, 'Z')
            app.UIAxesVideo.TickLength = [0 0];
            app.UIAxesVideo.XTick = [];
            app.UIAxesVideo.YTick = [];
            app.UIAxesVideo.ZTick = [];
            app.UIAxesVideo.Position = [44 411 365 262];

            % Create UIAxesPhoto1
            app.UIAxesPhoto1 = uiaxes(app.UIFigure);
            title(app.UIAxesPhoto1, 'Title')
            xlabel(app.UIAxesPhoto1, 'X')
            ylabel(app.UIAxesPhoto1, 'Y')
            zlabel(app.UIAxesPhoto1, 'Z')
            app.UIAxesPhoto1.XLimitMethod = 'padded';
            app.UIAxesPhoto1.YLimitMethod = 'padded';
            app.UIAxesPhoto1.ZLimitMethod = 'padded';
            app.UIAxesPhoto1.Position = [44 101 293 224];

            % Create UIAxesPhoto2
            app.UIAxesPhoto2 = uiaxes(app.UIFigure);
            title(app.UIAxesPhoto2, 'Title')
            xlabel(app.UIAxesPhoto2, 'X')
            ylabel(app.UIAxesPhoto2, 'Y')
            zlabel(app.UIAxesPhoto2, 'Z')
            app.UIAxesPhoto2.Position = [348 101 293 224];

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [0 0 1366 768];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'img-src', 'resultado_blanco_puro_grande.png');

            % Create ImageVideo
            app.ImageVideo = uiimage(app.UIFigure);
            app.ImageVideo.Position = [44 411 365 262];
            app.ImageVideo.ImageSource = fullfile(pathToMLAPP, 'img-src', 'img-video.png');

            % Create ImagePhoto1
            app.ImagePhoto1 = uiimage(app.UIFigure);
            app.ImagePhoto1.Position = [44 101 293 224];
            app.ImagePhoto1.ImageSource = fullfile(pathToMLAPP, 'img-src', 'img-photo.png');

            % Create ImagePhoto2
            app.ImagePhoto2 = uiimage(app.UIFigure);
            app.ImagePhoto2.Position = [348 101 293 224];
            app.ImagePhoto2.ImageSource = fullfile(pathToMLAPP, 'img-src', 'img-photo.png');

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end