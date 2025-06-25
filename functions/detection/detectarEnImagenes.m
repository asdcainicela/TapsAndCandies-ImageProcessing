function [Tfinal, datos]= detectarEnImagenes(imgStart, imgEnd)
    % DETECTARENIMAGENES
    % Recibe:
    %   - imgStart, imgEnd: path (char/string) o matriz de imagen.
    %   - dibujar: true/false para visualizar resultados.
    %
    % Retorna:
    %   - Tfinal: tabla combinada con Tipo, Color, Área, X0, Y0, Imagen.

    %if nargin < 3
    %    dibujar = false;
    %end

    % Si es path, leer imágenes
    if ischar(imgStart) || isstring(imgStart)
        imgStart = imread(imgStart);
    end
    if ischar(imgEnd) || isstring(imgEnd)
        imgEnd = imread(imgEnd);
    end

    % Detectar objetos
    [imgStart, detStart, cmXStart, cmYStart] = detectarObjetos(imgStart, 0.8);%, dibujar);  % 
    [imgEnd, detEnd, cmXEnd, cmYEnd]  = detectarObjetos(imgEnd, 0.8);%, dibujar);
    
    %  Convertir resultados a tablas
    T1 = convertirDeteccionATabla(detStart, "start");
    T2 = convertirDeteccionATabla(detEnd, "end");


    T1.Imagen = repmat("start", height(T1), 1);
    T2.Imagen = repmat("end", height(T2), 1);

    % Unir en una sola tabla
    Tfinal = [T1; T2];
    % necesario guardado de imagen
    datos.start.img  = imgStart;
    datos.start.cmX  = cmXStart;
    datos.start.cmY  = cmYStart;
    datos.start.det  = detStart;
    
    datos.end.img    = imgEnd;
    datos.end.cmX    = cmXEnd;
    datos.end.cmY    = cmYEnd;
    datos.end.det    = detEnd;

end
