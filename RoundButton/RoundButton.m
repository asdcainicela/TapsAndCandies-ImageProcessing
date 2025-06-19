classdef RoundButton < matlab.ui.componentcontainer.ComponentContainer
    properties
        Color (1,:) char = '#ffffff'                % Color del botón
        FontColor (1,:) char = 'black'              % Color del texto
        BackgroundHexColor (1,:) char = '#ffffff'   % Fondo del HTML
        Text (1,:) char = 'Button'                  % Texto del botón
        Bold (1,1) logical = false                  % Texto en negrita (por defecto: false)
    end

    properties (Access = private, Transient, NonCopyable)
        HTMLComponent matlab.ui.control.HTML
    end

    events (HasCallbackProperty, NotifyAccess = protected)
        ButtonPushed
    end 

    methods
        % Validadores para colores hexadecimales
        function set.Color(obj, val)
            assert(~isempty(regexp(val, '^#[0-9a-fA-F]{6}$', 'once')), ...
                "Color must be a hex code like '#45ff89'.");
            obj.Color = val;
        end

        function set.BackgroundHexColor(obj, val)
            assert(~isempty(regexp(val, '^#[0-9a-fA-F]{6}$', 'once')), ...
                "BackgroundHexColor must be a hex code like '#ffffff'.");
            obj.BackgroundHexColor = val;
        end
    end

    methods (Access=protected)
        function setup(obj)
            obj.Position = [100 100 80 40];
            obj.HTMLComponent = uihtml(obj, ...
                "Position", [1 1 obj.Position(3:4)], ...
                "HTMLSource", fullfile(pwd, "RoundButton.html"));
            obj.HTMLComponent.HTMLEventReceivedFcn = @(src, event) notify(obj, "ButtonPushed");
        end

        function update(obj)
            obj.HTMLComponent.Data = struct( ...
                "Color", obj.Color, ...
                "FontColor", obj.FontColor, ...
                "Text", obj.Text, ...
                "BackgroundColor", obj.BackgroundHexColor, ...
                "Bold", obj.Bold ...
            );
            obj.HTMLComponent.Position = [1 1 obj.Position(3:4)];
        end
    end
end
