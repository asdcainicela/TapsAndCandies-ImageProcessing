classdef app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        DropDownLanguage  matlab.ui.control.DropDown
        UITableCount      matlab.ui.control.Table
        UITableObject     matlab.ui.control.Table
        ImagePhoto2       matlab.ui.control.Image
        ImagePhoto1       matlab.ui.control.Image
        ImageVideo        matlab.ui.control.Image
        Image_en          matlab.ui.control.Image
        Image_es          matlab.ui.control.Image
        UIAxesPhoto2      matlab.ui.control.UIAxes
        UIAxesPhoto1      matlab.ui.control.UIAxes
        UIAxesVideo       matlab.ui.control.UIAxes
    end

    
    properties (Access = public) 
    StartVideoBtn   % Botón Start Video
    Capture1Btn     % Botón Capture 1
    Capture2Btn     % Botón Capture 2
    Load1Btn        % Botón Load 1
    Load2Btn        % Botón Load 2
    Save1Btn        % Botón Save 1
    ClearAllBtn     % Botón Clear all
    Save2Btn        % Botón Save 2
    ProcessBtn      % Botón Process
    ExportBtn       % Botón export data

    % ---- camera ---- %
    cam             % Objeto de webcam
    timerObj        % Objeto de temporizador para actualizar video
    isCameraRunning = false

    imagePhoto1Data % Data de la imagen 1
    imagePhoto2Data % Data de la imagen 2

    % save data
    isProcessOk = false
    Data_           % guardar los datos de todo 
    Tfinal_         % tablita sin procesar
    Taligned_       % ella ya limpiado
    counts_         % conteo

    % idioma
    Language = "en"

    ButtonsByID

    % propeidades para la configuracion---
    translations    % para la tabla de traducciones
    styles          % para la tabla de estilos
    layout          % para la tabla de layout
end

    
    methods (Access = private)
        
         % Función para manejar el clic en cualquier botón
        function onButtonClicked(app, btnName)
            uialert(app.UIFigure, sprintf("Botón %s presionado!", btnName), "Aviso");
        end

        function toggleVideo(app)
            stCurrent = app.styles(app.styles.ID==1, :);  % estilo "Start Video"
            btn = app.ButtonsByID(1);                    % el botón que cambia
        
            if app.isCameraRunning
                % === detener video ===
                stop(app.timerObj); delete(app.timerObj);
                app.timerObj = [];
                app.isCameraRunning = false;
                app.ImageVideo.Visible = "on";
        
                % Volvemos al estilo original (Start Video, verde-azul)
                btn.Text = app.translations(app.translations.ID==1, :).(app.Language);  
                btn.Color = stCurrent.Color;
                btn.BackgroundHexColor = stCurrent.BGColor;
                btn.HoverColor = stCurrent.HoverColor;
        
            else
                % === iniciar video ===
                if isempty(app.cam) || ~isvalid(app.cam)
                    app.cam = webcam;
                end 
                app.ImageVideo.Visible = "off";
                cla(app.UIAxesVideo,"reset");
                app.timerObj = timer(...
                    'ExecutionMode', 'fixedRate', ...
                    'Period', 0.2, ...
                    'TimerFcn', @(~,~) mostrarVideo(app));
                start(app.timerObj);
                app.isCameraRunning = true;
        
                % Aplicamos estilo alternativo (Stop Video, naranja)
                idAlt = stCurrent.toggleId;                               
                stAlt = app.styles(app.styles.ID==idAlt, :);  
                trAlt = app.translations(app.translations.ID==idAlt, :);  
                btn.Text = trAlt.(app.Language);   % "Detener Video"/"Stop Video"
                btn.Color = stAlt.Color;
                btn.BackgroundHexColor = stAlt.BGColor;
                btn.HoverColor = stAlt.HoverColor;
            end 
        end

        function ScreenButton(app, value)
            if ~app.isCameraRunning
                uialert(app.UIFigure, 'First, you must start the camera', 'Error');
                return;
            end
            
            try
                foto = snapshot(app.cam);
                if value == 1
                    app.ImagePhoto1.Visible = "off";
                    cla(app.UIAxesPhoto1, "reset");
                    image(app.UIAxesPhoto1, foto);
                    app.UIAxesPhoto1.XTick = [];
                    app.UIAxesPhoto1.YTick = [];
                    app.imagePhoto1Data = foto; % Guardamos imagen
                elseif value == 2
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
            if camName == 1
                app.imagePhoto1Data = img;
                app.ImagePhoto1.Visible = "off";
                cla(app.UIAxesPhoto1, "reset");
                image(app.UIAxesPhoto1, img);
                app.UIAxesPhoto1.XTick = [];
                app.UIAxesPhoto1.YTick = [];
            elseif camName == 2
                app.imagePhoto2Data = img;
                app.ImagePhoto2.Visible = "off";
                cla(app.UIAxesPhoto2, "reset");
                image(app.UIAxesPhoto2, img);
                app.UIAxesPhoto2.XTick = [];
                app.UIAxesPhoto2.YTick = [];
            end
        end

        function ProcessImages(app)
            % === Antes que nada, verifica que hay imágenes cargadas ===
            if isempty(app.imagePhoto1Data) || isempty(app.imagePhoto2Data)
                uialert(app.UIFigure, ...
                    'Please capture or load both images first.', ...
                    'Error');
                return;
            end
            
            try
                % == Ejecutar la detección y conteos ===
                [Tfinal, datos] = detectarEnImagenes(app.imagePhoto1Data, app.imagePhoto2Data);
                app.Data_ = datos;
                Taligned = emparejarDetecciones(Tfinal);
                counts = calcularConteos(Taligned);
            
                bottle = counts.Bottle_Cap;
                lentil = counts.Lentil;
            
                % === Configuración de idioma ===
                if app.Language == "es"
                    firstColBottle    = 'Tapas';
                    firstColLentil    = 'Lentejas';
                    columnHeadersCount = {'Tipo', 'Morado', 'Amarillo', 'Verde', 'Azul', 'Total'};
                    %columnHeadersObj   = {'Tipo', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
                else
                    firstColBottle    = 'Bottle Cap';
                    firstColLentil    = 'Lentil';
                    columnHeadersCount = {'Type', 'Purple', 'Yellow', 'Green', 'Blue', 'Total'};
                    %columnHeadersObj   = {'Type', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
                end
            
                % === Llenar UITableCount (tabla de conteos) ===
                dataCount = {
                    firstColBottle, getFieldOrZero(bottle, 'Purple'), getFieldOrZero(bottle, 'Yellow'), ...
                                    getFieldOrZero(bottle, 'Green'),  getFieldOrZero(bottle, 'Blue'), bottle.Total;
                    firstColLentil, getFieldOrZero(lentil, 'Purple'), getFieldOrZero(lentil, 'Yellow'), ...
                                    getFieldOrZero(lentil, 'Green'),  getFieldOrZero(lentil, 'Blue'), lentil.Total;
                };
                bgColor = [238, 242, 247]/255;  % Color de fondo común
                app.UITableCount.BackgroundColor = bgColor;
                app.UITableCount.ColumnName      = columnHeadersCount;
                app.UITableCount.Data            = dataCount;
                app.UITableCount.Visible         = 'on';

                 % === Llenar UITableObject (tabla de objetos detectados) ===
                Tmostrar = Taligned;
                
                % Selecciona solo las columnas que quieres
                colsDeseadas = {'Tipo', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
                Tmostrar = Tmostrar(:, colsDeseadas);  % quedarnos solo con las columnas que nos interesan
                Tmostrar = formatearDecimales(Tmostrar, 2); 
                
                if app.Language == "es"
                    % Traducir automáticamente ciertas columnas que sean categóricas
                    if ismember('Tipo', Tmostrar.Properties.VariableNames)
                        Tmostrar.Tipo = strrep(Tmostrar.Tipo, "Bottle Cap", "Tapas");   % Ojo aquí el "_"
                        Tmostrar.Tipo = strrep(Tmostrar.Tipo, "Lentil", "Lentejas");
                    end
                    if ismember('Color', Tmostrar.Properties.VariableNames)
                        Tmostrar.Color = strrep(Tmostrar.Color, "Purple", "Morado");
                        Tmostrar.Color = strrep(Tmostrar.Color, "Yellow", "Amarillo");
                        Tmostrar.Color = strrep(Tmostrar.Color, "Green", "Verde");
                        Tmostrar.Color = strrep(Tmostrar.Color, "Blue", "Azul");
                    end
                    columnHeadersObj = {'Tipo', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
                else
                    columnHeadersObj = {'Type', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
                end
                
                % Configuración visual
                bgColor = [238, 242, 247]/255;
                app.UITableObject.BackgroundColor = bgColor;
                app.UITableObject.ColumnName      = columnHeadersObj;
                app.UITableObject.Data            = Tmostrar;
                app.UITableObject.Visible         = 'on';
 
                            
                % === Guardar resultados en propiedades ===
                app.Tfinal_  = Tfinal;
                app.Taligned_= Taligned;
                app.counts_  = counts;
                app.isProcessOk = true;
            
            catch ME
                uialert(app.UIFigure, ME.message, 'Error al procesar imágenes');
            end

        end
        
       %guardar en la carpeta result/
       function ExportData(app)
            if app.isProcessOk
                %  app.Data_ sea el struct tipo:
                % app.Data_.start.img, app.Data_.start.det, app.Data_.start.cmX, ...
                outputDir = fullfile(pwd, 'result');
                guardarResultados(app.Tfinal_, app.Taligned_, app.counts_, outputDir, app.Data_, false);
                disp("Guardado en la carpeta result")
            else
                uialert(app.UIFigure, ...
                    'Please process the data before exporting.', ...
                    'Error');
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

        function updateTables(app)
            if isempty(app.Taligned_) || isempty(app.counts_)
                return;
            end
        
            bottle = app.counts_.Bottle_Cap;
            lentil = app.counts_.Lentil;
        
            if app.Language == "es"
                firstColBottle    = 'Tapas';
                firstColLentil    = 'Lentejas';
                columnHeadersCount = {'Tipo', 'Morado', 'Amarillo', 'Verde', 'Azul', 'Total'};
                columnHeadersObj   = {'Tipo', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
            else
                firstColBottle    = 'Bottle Cap';
                firstColLentil    = 'Lentil';
                columnHeadersCount = {'Type', 'Purple', 'Yellow', 'Green', 'Blue', 'Total'};
                columnHeadersObj   = {'Type', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
            end
        
            % Tabla de conteos
            dataCount = {
                firstColBottle, getFieldOrZero(bottle, 'Purple'), getFieldOrZero(bottle, 'Yellow'), ...
                                getFieldOrZero(bottle, 'Green'),  getFieldOrZero(bottle, 'Blue'), bottle.Total;
                firstColLentil, getFieldOrZero(lentil, 'Purple'), getFieldOrZero(lentil, 'Yellow'), ...
                                getFieldOrZero(lentil, 'Green'),  getFieldOrZero(lentil, 'Blue'), lentil.Total;
            };
            app.UITableCount.ColumnName = columnHeadersCount;
            app.UITableCount.Data = dataCount;
        
            % Tabla de objetos
            Tmostrar = app.Taligned_;
            colsDeseadas = {'Tipo', 'Color', 'X0', 'Y0', 'X1', 'Y1'};
            Tmostrar = Tmostrar(:, colsDeseadas); 
            Tmostrar = formatearDecimales(Tmostrar, 2); 
        
            if app.Language == "es"
                Tmostrar.Tipo = strrep(Tmostrar.Tipo, "Bottle Cap", "Tapas");
                Tmostrar.Tipo = strrep(Tmostrar.Tipo, "Lentil", "Lentejas");
                Tmostrar.Color = strrep(Tmostrar.Color, "Purple", "Morado");
                Tmostrar.Color = strrep(Tmostrar.Color, "Yellow", "Amarillo");
                Tmostrar.Color = strrep(Tmostrar.Color, "Green", "Verde");
                Tmostrar.Color = strrep(Tmostrar.Color, "Blue", "Azul");
            end
        
            app.UITableObject.ColumnName = columnHeadersObj;
            app.UITableObject.Data = Tmostrar;
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
                app.ImageVideo.Visible = 'on';
                uialert(app.UIFigure, ME.message, 'Camera error');
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
            if app.Language == "es"
                app.Image_es.Visible = "on";
                app.Image_en.Visible = "off";
            else
                app.Image_es.Visible = "off";
                app.Image_en.Visible = "on";
            end
            basePath_ = fullfile(pwd, 'functions');  % carpeta raíz para todas las funciones
            addpath(genpath(basePath_));             % agrega todas las funciones a la ruta
        
            basePath = fullfile(pwd, 'config');  
            
            % --- Leer CSVs y asignar a propiedades ---
            app.translations = readtable(fullfile(basePath, 'translations.csv'), ...
                'TextType', 'string', 'VariableNamingRule', 'preserve');
        
            app.styles = readtable(fullfile(basePath, 'styles.csv'), ...
                'TextType', 'string', 'VariableNamingRule', 'preserve', ...
                'Delimiter', ',');  % usa el delimitador correcto
            app.layout = readtable(fullfile(basePath, 'layout.csv'), ...
                'TextType', 'string', 'VariableNamingRule', 'preserve');
        
            % Limpiar espacios en encabezados
            app.styles.Properties.VariableNames = strtrim(app.styles.Properties.VariableNames);
            disp('Columnas en styles:'); disp(app.styles.Properties.VariableNames)
            disp(app.translations.Properties.VariableNames)
            disp(app.layout.Properties.VariableNames)
        
            app.ButtonsByID = containers.Map('KeyType','double','ValueType','any');
        
            % Convertir columna Bold a logical
            app.styles.Bold = strcmpi(strtrim(app.styles.Bold), "true"); 
        
            idsToCreate = 1:10;  % solo hasta 10
            for id = idsToCreate
                tr = app.translations(app.translations.ID == id, :);
                st = app.styles(app.styles.ID == id, :);
                pos = app.layout(app.layout.ID == id, :);
        
                btnText = tr.(app.Language);  % es o en
        
                btn = round_button(app.UIFigure, ...
                    "Position", [pos.PosX, pos.PosY, pos.Width, pos.Height], ...
                    "Text", btnText, ...
                    "FontColor", st.FontColor, ...
                    "Bold", st.Bold, ...
                    "Color", st.Color, ...
                    "HoverColor", st.HoverColor, ...
                    "BackgroundHexColor", st.BGColor);
        
                app.ButtonsByID(id) = btn;
        
                switch id
                    case 1
                        btn.ButtonPushedFcn = @(~,~) app.toggleVideo(); 
                    case 2
                        btn.ButtonPushedFcn = @(~,~) app.ScreenButton(1);
                    case 3
                        btn.ButtonPushedFcn = @(~,~) app.ScreenButton(2);
                    case 4
                        btn.ButtonPushedFcn = @(~,~) app.LoadImage(1);
                    case 5
                        btn.ButtonPushedFcn = @(~,~) app.LoadImage(2);
                    case 6
                        btn.ButtonPushedFcn = @(~,~) app.SaveImage(app.imagePhoto1Data, "Save Camera 1");
                    case 7
                        btn.ButtonPushedFcn = @(~,~) app.ClearAll();
                    case 8
                        btn.ButtonPushedFcn = @(~,~) app.SaveImage(app.imagePhoto2Data, "Save Camera 2");
                    case 9
                        btn.ButtonPushedFcn = @(~,~) app.ProcessImages();
                    case 10
                        btn.ButtonPushedFcn = @(~,~) app.ExportData();
                end
            end 

        end

        % Value changed function: DropDownLanguage
        function DropDownLanguageValueChanged(app, event)
            app.Language = app.DropDownLanguage.Value;
            if app.Language == "es"
                app.Image_es.Visible = "on";
                app.Image_en.Visible = "off";
            else
                app.Image_es.Visible = "off";
                app.Image_en.Visible = "on";
            end
        
            allIDs = keys(app.ButtonsByID);  % IDs de todos los botones
            for i = 1:numel(allIDs)
                id = allIDs{i};
                btn = app.ButtonsByID(id);           % el botón
                trCurrent = app.translations(app.translations.ID==id, :); % traducción base
                stCurrent = app.styles(app.styles.ID==id, :);             % estilo base
        
                if id == 1
                    % Este es el botón Start/Stop Video
                    if app.isCameraRunning
                        % Cámara encendida => usar traducción y estilo alternativos
                        idAlt = stCurrent.toggleId;  % obtener id alternativo
                        trAlt = app.translations(app.translations.ID==idAlt, :);  
                        stAlt = app.styles(app.styles.ID==idAlt, :);  
                        btn.Text = trAlt.(app.Language);         % texto alternativo
                        btn.Color = stAlt.Color;
                        btn.BackgroundHexColor = stAlt.BGColor;
                        btn.HoverColor = stAlt.HoverColor;
                    else
                        % Cámara apagada => usar texto original
                        btn.Text = trCurrent.(app.Language);     % texto por defecto
                        btn.Color = stCurrent.Color;
                        btn.BackgroundHexColor = stCurrent.BGColor;
                        btn.HoverColor = stCurrent.HoverColor;
                    end
                else
                    % Otros botones: solo texto
                    btn.Text = trCurrent.(app.Language);
                end
            end
        
            disp("Idioma seleccionado: " + app.Language) 
            if app.isProcessOk
                app.updateTables();
            end


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

            % Create Image_es
            app.Image_es = uiimage(app.UIFigure);
            app.Image_es.Position = [0 0 1366 768];
            app.Image_es.ImageSource = fullfile(pathToMLAPP, 'media', 'img-src', 'background-es.png');

            % Create Image_en
            app.Image_en = uiimage(app.UIFigure);
            app.Image_en.Position = [0 0 1366 768];
            app.Image_en.ImageSource = fullfile(pathToMLAPP, 'media', 'img-src', 'background-en.png');

            % Create ImageVideo
            app.ImageVideo = uiimage(app.UIFigure);
            app.ImageVideo.Position = [44 411 365 262];
            app.ImageVideo.ImageSource = fullfile(pathToMLAPP, 'media', 'img-src', 'img-video.png');

            % Create ImagePhoto1
            app.ImagePhoto1 = uiimage(app.UIFigure);
            app.ImagePhoto1.Position = [44 101 293 224];
            app.ImagePhoto1.ImageSource = fullfile(pathToMLAPP, 'media', 'img-src', 'img-photo.png');

            % Create ImagePhoto2
            app.ImagePhoto2 = uiimage(app.UIFigure);
            app.ImagePhoto2.Position = [348 101 293 224];
            app.ImagePhoto2.ImageSource = fullfile(pathToMLAPP, 'media', 'img-src', 'img-photo.png');

            % Create UITableObject
            app.UITableObject = uitable(app.UIFigure);
            app.UITableObject.ColumnName = {'Type'; 'Color'; 'x0'; 'y0'; 'x1'; 'y1'};
            app.UITableObject.RowName = {};
            app.UITableObject.Visible = 'off';
            app.UITableObject.FontSize = 14;
            app.UITableObject.Position = [739 36 561 289];

            % Create UITableCount
            app.UITableCount = uitable(app.UIFigure);
            app.UITableCount.BackgroundColor = [1 1 1;1 1 1];
            app.UITableCount.ColumnName = '';
            app.UITableCount.RowName = {};
            app.UITableCount.Visible = 'off';
            app.UITableCount.FontSize = 14;
            app.UITableCount.Position = [739 433 561 80];

            % Create DropDownLanguage
            app.DropDownLanguage = uidropdown(app.UIFigure);
            app.DropDownLanguage.Items = {'en', 'es'};
            app.DropDownLanguage.ValueChangedFcn = createCallbackFcn(app, @DropDownLanguageValueChanged, true);
            app.DropDownLanguage.Position = [1 746 70 22];
            app.DropDownLanguage.Value = 'en';

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