function BW = remove_nonborder_objects(BW)
    % Encuentra etiquetas
    [L, num] = my_bwlabel(BW);
    BW = false(size(BW));

    for label = 1:num
        objMask = (L == label);
        % Revisa si el objeto toca el borde
        if any(objMask(1, :)) || any(objMask(end, :)) || any(objMask(:, 1)) || any(objMask(:, end))
            BW = BW | objMask;
        end

    end

end
