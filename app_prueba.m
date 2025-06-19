clc, clear all, close all;
% Añadir carpeta de funciones al path
addpath(fullfile(pwd, 'functions'));

% Detectar dos imágenes
det1 = detectarObjetos('media/img-test/imagen1.png', 0.5); % corresponde a start
det2 = detectarObjetos('media/img-test/imagen2.png', 0.5); % corresponde a end

% Convertir struct a tabla para inicio (start)
T1 = table(det1.Tipo, det1.Color, det1.Area_cm2, det1.X_cm, det1.Y_cm, ...
    'VariableNames', {'Tipo', 'Color', 'Area', 'X0', 'Y0'});
T1.Imagen = repmat("start", height(T1), 1); % usar "start"

% Convertir struct a tabla para fin (end)
T2 = table(det2.Tipo, det2.Color, det2.Area_cm2, det2.X_cm, det2.Y_cm, ...
    'VariableNames', {'Tipo', 'Color', 'Area', 'X0', 'Y0'});
T2.Imagen = repmat("end", height(T2), 1); % usar "end"

% Unir en una sola tabla
Tfinal = [T1; T2];

% Mostrar
disp(Tfinal);

% Guardar CSV
%% 1) Guardar CSV crudo
outputDir = fullfile(pwd, 'config'); % ruta absoluta a config

if ~exist(outputDir, 'dir')
    mkdir(outputDir); % crea la carpeta si no existe
end

writetable(Tfinal, fullfile(outputDir, 'ResultadosDeteccionCrudo.csv'));

%% 2) Emparejar por tipo, color y área (como antes)
% Separar por Imagen
Tstart = Tfinal(strcmp(Tfinal.Imagen, 'start'), :);
Tend = Tfinal(strcmp(Tfinal.Imagen, 'end'), :);

% Pares únicos Tipo-Color
uniquePairs = unique(table(Tstart.Tipo, Tstart.Color, ...
    'VariableNames', {'Tipo', 'Color'}), 'rows');

Tipos = {};
Colores = {};
Areas = [];
X0 = []; Y0 = []; X1 = []; Y1 = [];

for iPair = 1:height(uniquePairs)
    tipoCurrent = uniquePairs.Tipo{iPair};
    colorCurrent = uniquePairs.Color{iPair};

    subStart = Tstart(strcmp(Tstart.Tipo, tipoCurrent) & ...
        strcmp(Tstart.Color, colorCurrent), :);
    subEnd = Tend(strcmp(Tend.Tipo, tipoCurrent) & ...
        strcmp(Tend.Color, colorCurrent), :);

    nStart = height(subStart);
    nEnd = height(subEnd);
    nMin = min(nStart, nEnd);

    if nStart ~= nEnd
        warning('Cantidad distinta para %s/%s: start=%d end=%d. Usando %d.', ...
            tipoCurrent, colorCurrent, nStart, nEnd, nMin);
    end

    if nMin > 0
        subStart = sortrows(subStart, 'Area', 'ascend');
        subEnd = sortrows(subEnd, 'Area', 'ascend');
        subStart = subStart(1:nMin, :);
        subEnd = subEnd(1:nMin, :);

        Tipos = [Tipos; subStart.Tipo];
        Colores = [Colores; subStart.Color];
        Areas = [Areas; subStart.Area];
        X0 = [X0; subStart.X0];
        Y0 = [Y0; subStart.Y0];
        X1 = [X1; subEnd.X0];
        Y1 = [Y1; subEnd.Y0];
    end

end

Taligned = table(Tipos, Colores, Areas, X0, Y0, X1, Y1, ...
    'VariableNames', {'Tipo', 'Color', 'Area', 'X0', 'Y0', 'X1', 'Y1'});

writetable(Taligned, fullfile(outputDir, 'ResultadosEmparejados.csv'));
disp('== Tabla final =='); disp(Taligned);

% Obtenemos pares únicos de Tipo y Color
uniquePairs = unique(table(Taligned.Tipo, Taligned.Color, ...
    'VariableNames', {'Tipo', 'Color'}), 'rows');

counts = struct();

% Construir campos por tipo y color
for iPair = 1:height(uniquePairs)
    tipoCurrent = uniquePairs.Tipo{iPair};
    colorCurrent = uniquePairs.Color{iPair};
    num = sum(strcmp(Taligned.Tipo, tipoCurrent) & ...
        strcmp(Taligned.Color, colorCurrent));

    tipoField = regexprep(tipoCurrent, '\s+', '_'); % tipo sin espacios
    colorField = regexprep(colorCurrent, '\s+', '_'); % color sin espacios

    if ~isfield(counts, tipoField)
        counts.(tipoField) = struct();
    end

    counts.(tipoField).(colorField) = num;
end

% Agregar totales por tipo
tipoUnique = unique(Taligned.Tipo);

for iTipo = 1:length(tipoUnique)
    tipoCurrent = tipoUnique{iTipo};
    tipoField = regexprep(tipoCurrent, '\s+', '_');
    counts.(tipoField).Total = sum(strcmp(Taligned.Tipo, tipoCurrent));
end

% También puedes agregar un Total general por tipo
%counts.Total_Bottle_Cap = counts.Bottle_Cap.Total;
%counts.Total_Lentil     = counts.Lentil.Total;

disp('=== Conteos por Tipo y Color (con totales) ===')
disp(counts)

[files, products] = matlab.codetools.requiredFilesAndProducts('untitled12.m');

disp('=== Archivos dependientes ===')
disp(files')

disp('=== Toolboxes utilizados ===')
disp({products.Name}')
