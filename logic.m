clc; clear; close all;

basePath = fullfile(pwd, 'functions');  % carpeta raíz
addpath(genpath(basePath));             % agrega todas las subcarpetas automáticamente

% Procesamiento
Tfinal    = detectarEnImagenes('media/img-test/imagen1.png', 'media/img-test/imagen2.png', false);
Taligned  = emparejarDetecciones(Tfinal);
counts    = calcularConteos(Taligned);

% Guardar
guardarResultados(Tfinal, Taligned, counts, fullfile(pwd, 'result'));

% Mostrar resultados
disp(counts);
disp(Taligned);


disp('=== Conteos por Tipo y Color (con totales) ===')
disp(counts)

[files, products] = matlab.codetools.requiredFilesAndProducts('app_prueba.m');

disp('=== Archivos dependientes ===')
disp(files')

disp('=== Toolboxes utilizados ===')
disp({products.Name}')
