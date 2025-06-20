function data = detectarObjetos(imgInput, scaleFactor, showFigure)
    % DETECTAROBJETOS: Orquesta el proceso de detección.
    if nargin < 3
        showFigure = false;
    end
    
    % Cargar y escalar imagen desde path o matriz
    img = cargarEscalarImagen(imgInput, scaleFactor);             % SRP
    
    % Calcular escala
    [cmX, cmY, bbox_hoja, area_px_hoja] = calcularEscalaDesdeHoja(img); % SRP
    
    % Generar máscaras de color
    [masks, colorNames] = generarMascarasColor(img);             % SRP
    
    % Detectar objetos en las máscaras
    data = detectarObjetosEnMascaras(masks, colorNames, cmX, cmY); % SRP
    data.cmX = cmX; 
    data.cmY = cmY;
    data.BBox_Hoja = bbox_hoja; 
    data.area_px_hoja = area_px_hoja;

    % Visualización opcional
    if showFigure
        visualizarDetecciones(img, data, cmX, cmY);             % SRP
    end
end
