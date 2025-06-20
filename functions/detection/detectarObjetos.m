function data = detectarObjetos(imgPath, scaleFactor, showFigure)
    % DETECTAROBJETOS: Orquesta el proceso de detección.
    if nargin < 3
        showFigure = false;
    end
    
    img = cargarEscalarImagen(imgPath, scaleFactor);             % SRP
    [cmX, cmY, bbox_hoja, area_px_hoja] = calcularEscalaDesdeHoja(img); % SRP
    [masks, colorNames] = generarMascarasColor(img);            % SRP
    data = detectarObjetosEnMascaras(masks, colorNames, cmX, cmY); % SRP
    data.cmX = cmX; data.cmY = cmY;
    data.BBox_Hoja = bbox_hoja; data.area_px_hoja = area_px_hoja;

    if showFigure
        visualizarDetecciones(img, data, cmX, cmY);             % SRP
    end
end
