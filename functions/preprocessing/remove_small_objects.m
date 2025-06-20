function BW_clean = remove_small_objects(BW, min_area)
    [L, num] = my_bwlabel(BW); % Usamos nuestro etiquetado
    BW_clean = false(size(BW));

    for i = 1:num
        area = sum(L(:) == i);

        if area >= min_area
            BW_clean(L == i) = true;
        end

    end

end
