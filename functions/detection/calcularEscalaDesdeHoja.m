function [cmX, cmY, bbox_hoja, area_px_hoja] = calcularEscalaDesdeHoja(img)
    gray = rgb2gray(img);
    level = my_graythresh(gray);
    BW_hoja = my_imbinarize(gray, level);
    BW_hoja = my_imcomplement(BW_hoja);
    BW_hoja = remove_small_objects(BW_hoja, 5000);
    BW_hoja = remove_nonborder_objects(BW_hoja);
    stats_hoja = get_object_properties(BW_hoja);

    if isempty(stats_hoja)
        warning('No hoja detectada. Usando A4 completa.');
        bbox_hoja = [1, 1, size(img,2), size(img,1)];
    else
        [~, idxMax] = max([stats_hoja.Area]);
        bbox_hoja = stats_hoja(idxMax).BoundingBox;
    end
    area_px_hoja = prod(bbox_hoja(3:4));
    cmX = 21 / bbox_hoja(3); cmY = 29.7 / bbox_hoja(4);
end
