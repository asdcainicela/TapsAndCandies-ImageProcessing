function Tfinal = detectarEnImagenes(imgStart, imgEnd, dibujar)
    % DETECTARENIMAGENES
    % Recibe:
    %   - imgStart, imgEnd: path (char/string) o matriz de imagen.
    %   - dibujar: true/false para visualizar resultados.
    %
    % Retorna:
    %   - Tfinal: tabla combinada con Tipo, Color, Área, X0, Y0, Imagen.

    if nargin < 3
        dibujar = false;
    end

    % ✅ Si es path, leer imágenes
    if ischar(imgStart) || isstring(imgStart)
        imgStart = imread(imgStart);
    end
    if ischar(imgEnd) || isstring(imgEnd)
        imgEnd = imread(imgEnd);
    end

    % ✅ Detectar objetos
    detStart = detectarObjetos(imgStart, 0.5, dibujar);  % Usa el scale que tú prefieras
    detEnd   = detectarObjetos(imgEnd, 0.5, dibujar);

    % ✅ Convertir resultados a tablas
    T1 = convertirDeteccionATabla(detStart, "start");
    T2 = convertirDeteccionATabla(detEnd, "end");


    T1.Imagen = repmat("start", height(T1), 1);
    T2.Imagen = repmat("end", height(T2), 1);

    % ✅ Unir en una sola tabla
    Tfinal = [T1; T2];
end
