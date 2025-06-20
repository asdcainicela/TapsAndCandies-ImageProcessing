function counts = calcularConteos(Taligned)
    uniquePairs = unique(table(Taligned.Tipo, Taligned.Color, ...
        'VariableNames', {'Tipo', 'Color'}), 'rows');

    counts = struct();
    for iPair = 1:height(uniquePairs)
        tipoCurrent = uniquePairs.Tipo{iPair};
        colorCurrent = uniquePairs.Color{iPair};
        num = sum(strcmp(Taligned.Tipo, tipoCurrent) & ...
                  strcmp(Taligned.Color, colorCurrent));
        tipoField  = regexprep(tipoCurrent, '\s+', '_'); 
        colorField = regexprep(colorCurrent, '\s+', '_'); 

        if ~isfield(counts, tipoField)
            counts.(tipoField) = struct();
        end
        counts.(tipoField).(colorField) = num;
    end

    tipoUnique = unique(Taligned.Tipo); 
    for iTipo = 1:length(tipoUnique)
        tipoCurrent = tipoUnique{iTipo};
        tipoField = regexprep(tipoCurrent, '\s+', '_');
        counts.(tipoField).Total = sum(strcmp(Taligned.Tipo, tipoCurrent));
    end
end
