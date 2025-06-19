function J = my_imcomplement(I)
    % my_imcomplement - Calcula el complemento de una imagen
    %
    % Para imágenes binarias (0 o 1): invierte a 1 - I.
    % Para imágenes uint8: 255 - I.
    % Para imágenes double/single entre 0 y 1: 1 - I.

    if islogical(I)
        J = ~I;
    elseif isa(I, 'uint8')
        J = 255 - I;
    elseif isa(I, 'double') || isa(I, 'single')
        % Suponemos que está entre 0 y 1
        J = 1 - I;
    else
        error('Tipo de dato no soportado. Usa logical, uint8, double o single.');
    end

end
