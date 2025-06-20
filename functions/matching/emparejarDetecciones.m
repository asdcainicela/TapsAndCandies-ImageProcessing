function Taligned = emparejarDetecciones(Tfinal)
    Tstart = Tfinal(strcmp(Tfinal.Imagen, 'start'), :);
    Tend = Tfinal(strcmp(Tfinal.Imagen, 'end'), :);
    uniquePairs = unique(table(Tstart.Tipo, Tstart.Color, ...
        'VariableNames', {'Tipo', 'Color'}), 'rows');

    Tipos = {}; Colores = {}; Areas = [];
    X0 = []; Y0 = []; X1 = []; Y1 = [];

    for iPair = 1:height(uniquePairs)
        tipoCurrent = uniquePairs.Tipo{iPair};
        colorCurrent = uniquePairs.Color{iPair};

        subStart = Tstart(strcmp(Tstart.Tipo, tipoCurrent) & ...
                          strcmp(Tstart.Color, colorCurrent), :);
        subEnd = Tend(strcmp(Tend.Tipo, tipoCurrent) & ...
                      strcmp(Tend.Color, colorCurrent), :);

        nMin = min(height(subStart), height(subEnd));
        if height(subStart) ~= height(subEnd)
            warning('Cantidad distinta para %s/%s: start=%d end=%d. Usando %d.', ...
                    tipoCurrent, colorCurrent, height(subStart), height(subEnd), nMin);
        end

        if nMin > 0
            subStart = sortrows(subStart, 'Area'); subEnd = sortrows(subEnd, 'Area');
            subStart = subStart(1:nMin, :); subEnd = subEnd(1:nMin, :);

            Tipos   = [Tipos; subStart.Tipo];
            Colores = [Colores; subStart.Color];
            Areas   = [Areas; subStart.Area];
            X0      = [X0; subStart.X0];   Y0 = [Y0; subStart.Y0];
            X1      = [X1; subEnd.X0];     Y1 = [Y1; subEnd.Y0];
        end
    end

    Taligned = table(Tipos, Colores, Areas, X0, Y0, X1, Y1, ...
                     'VariableNames', {'Tipo', 'Color', 'Area', 'X0', 'Y0', 'X1', 'Y1'});
    Taligned = Taligned(ismember(Taligned.Tipo, {'Bottle Cap','Lentil'}), :); 

end
