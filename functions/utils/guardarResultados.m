function guardarResultados(Tfinal, Taligned, counts, outputDir, datos, doShow)
    % Crear carpeta si no existe
    if ~exist(outputDir, 'dir')
        mkdir(outputDir); 
    end

    % Guardar tablas
    writetable(Tfinal, fullfile(outputDir, 'Raw_Detections.csv'));
    writetable(Taligned, fullfile(outputDir, 'Matched_Detections.csv'));
    save(fullfile(outputDir, 'counts.mat'), 'counts');

    % Llamar a función que guarda imágenes
    guardarDeteccionesImagenes(datos, outputDir, doShow);
end
