function img = cargarEscalarImagen(imgInput, scaleFactor)
    % CARGARESCALARIMAGEN: Carga imagen desde path o usa matriz dada, y la redimensiona.
    if ischar(imgInput) || isstring(imgInput)
        img = imread(imgInput);    % Desde path
    elseif isnumeric(imgInput)
        img = imgInput;            % Ya es imagen
    else
        error('cargarEscalarImagen: tipo no soportado. Usa path o matriz numérica.');
    end
    img = imresize(img, scaleFactor);
end
