classdef RoundButton < matlab.ui.componentcontainer.ComponentContainer
    properties
        Color (1,:) char = '#ffffff'
        FontColor (1,:) char = 'black'
        BackgroundHexColor (1,:) char = '#ffffff'  % ✅ Renombrado
        Text (1,:) char = 'Button'
    end

    properties (Access = private, Transient, NonCopyable)
        HTMLComponent matlab.ui.control.HTML
    end

    events (HasCallbackProperty, NotifyAccess = protected)
        ButtonPushed
    end 

    methods
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
                "BackgroundColor", obj.BackgroundHexColor ... ✅ Aquí lo pasas al HTML como 'BackgroundColor'
            );
            obj.HTMLComponent.Position = [1 1 obj.Position(3:4)];
        end
    end
end
