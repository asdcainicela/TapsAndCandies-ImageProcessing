function Tfinal = detectarEnImagenes(imgStartPath, imgEndPath, dibujar)
    if nargin < 3
        dibujar = false;
    end

    % Detectar en imágenes
    detStart = detectarObjetos(imgStartPath, 0.5, dibujar);  
    detEnd   = detectarObjetos(imgEndPath, 0.5, dibujar);  

    % Convertir a tablas con la nueva función
    Tstart = convertirDeteccionATabla(detStart, "start");
    Tend   = convertirDeteccionATabla(detEnd, "end");

    % Concatenar
    Tfinal = [Tstart; Tend];
end
