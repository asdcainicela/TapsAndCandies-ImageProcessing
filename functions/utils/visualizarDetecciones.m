function visualizarDetecciones(img, data, cmX, cmY, outputPath, doShow)
    if nargin < 6, doShow = false; end
    if nargin < 5, outputPath = ''; end

    % Solo abrir figura si hay que mostrar o guardar
    if doShow
        fig = figure;             % visible
    elseif ~isempty(outputPath)
        fig = figure('Visible', 'off'); % invisible solo para guardar
    else
        return; % nada que hacer si no mostramos y tampoco guardamos
    end

    imshow(img); hold on;
    for i = 1:length(data.Tipo)
        X_pix = data.X_cm(i)/cmX;
        Y_pix = data.Y_cm(i)/cmY;
        plot(X_pix, Y_pix, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
        text(X_pix+10, Y_pix, sprintf('%s (%s)', data.Tipo{i}, data.Color{i}), ...
             'Color','red','FontSize',10,'FontWeight','bold');
    end
    hold off;

    % Guardar si outputPath es válido
    if ~isempty(outputPath)
        [folder,~,~] = fileparts(outputPath);
        if ~exist(folder, 'dir')
            mkdir(folder); 
        end
        saveas(fig, outputPath);  
    end

    % Cerrar figura solo si no mostramos
    if ~doShow
        close(fig);
    end
end
