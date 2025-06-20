function BW = my_imbinarize(I, level)
    % my_imbinarize - Binariza una imagen en nivel [0,1].
    % Si la imagen es uint8, escala el nivel a 0-255 automáticamente.

    if isa(I, 'uint8')
        level = level * 255; % Escala el nivel al rango de 0-255
    elseif isa(I, 'double') || isa(I, 'single')
        % Si es tipo double/single y sup. está entre 0 y 1, ya está bien.
    else
        % Para cualquier otro tipo numérico, convertir a double entre 0 y 1
        I = double(I) / double(max(I(:)));
    end

    BW = I >= level; % La binarización en sí
end
