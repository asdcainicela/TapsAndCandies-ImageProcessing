function Tformateada = formatearDecimales(T, numDecimales)
    Tformateada = T;  % Copia la estructura de columnas que tenga T
    formato = sprintf('%%.%df', numDecimales);  % e.g. "%.2f"
    numCols = {'X0','Y0','X1','Y1'};  % Columnas numéricas que quieres formatear
    for col = numCols
        if ismember(col, T.Properties.VariableNames)
            vals = T.(col{:});  % obtiene vector numérico
            Tformateada.(col{:}) = string(num2str(vals, formato)); % convierte a string con formato
        end
    end
end
