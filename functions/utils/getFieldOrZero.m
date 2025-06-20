function value = getFieldOrZero(S, fieldName)
    % Devuelve el valor del campo si existe; si no, retorna 0
    if isfield(S, fieldName)
        value = S.(fieldName);
    else
        value = 0;
    end
end
