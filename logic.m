clc; clear; close all;

basePath = fullfile(pwd, 'functions');  % carpeta raíz
addpath(genpath(basePath));             % agrega todas las subcarpetas automáticamente

% Procesamiento
[Tfinal, datos]   = detectarEnImagenes('media/img-test/test2/imagen1.png', 'media/img-test/test2/imagen2.png'); 
Tfinal = formatearDecimales(Tfinal,2);
Taligned  = emparejarDetecciones(Tfinal);
counts    = calcularConteos(Taligned);

% Mostrar resultados
%disp(Tfinal);
disp(Taligned);


% Guardar
guardar = 0;
if guardar == 1
    guardarResultados(Tfinal, Taligned, counts, fullfile(pwd, 'result'), datos, true);

    %guardar imagenes
    guardar = 0;
end


