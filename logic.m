clc; clear; close all;

basePath = fullfile(pwd, 'functions');  % carpeta raíz
addpath(genpath(basePath));             % agrega todas las subcarpetas automáticamente

% Procesamiento
Tfinal    = detectarEnImagenes('media/img-test/test2/imagen1.png', 'media/img-test/test2/imagen2.png', false);
Tfinal = formatearDecimales(Tfinal,2);
Taligned  = emparejarDetecciones(Tfinal);
counts    = calcularConteos(Taligned);

% Guardar
guardarResultados(Tfinal, Taligned, counts, fullfile(pwd, 'result'));

% Mostrar resultados
disp(Tfinal);
disp(Taligned);
