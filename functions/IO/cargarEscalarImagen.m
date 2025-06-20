function img = cargarEscalarImagen(imgPath, scaleFactor)
    img = imread(imgPath);
    img = imresize(img, scaleFactor);
end
