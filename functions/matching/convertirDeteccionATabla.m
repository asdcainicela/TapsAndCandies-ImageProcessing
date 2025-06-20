function T = convertirDeteccionATabla(det, imagenLabel)
    T = table(det.Tipo, det.Color, det.Area_cm2, det.X_cm, det.Y_cm, ...
        'VariableNames', {'Tipo', 'Color', 'Area', 'X0', 'Y0'});
    T.Imagen = repmat(string(imagenLabel), height(T), 1); % Añade columna Imagen
end
