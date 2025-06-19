function [data] = detectarObjetos(imgPath, scaleFactor)
    % DETECTAROBJETOS Detects caps and lentils in an image and returns a simple struct
    img = imread(imgPath);
    img = imresize(img, scaleFactor);

    %% 1) Leaf detection
    gray = rgb2gray(img);
    level = my_graythresh(gray);
    BW_hoja = my_imbinarize(gray, level);
    BW_hoja = my_imcomplement(BW_hoja);
    BW_hoja = remove_small_objects(BW_hoja, 5000);
    BW_hoja = remove_nonborder_objects(BW_hoja);

    stats_hoja = get_object_properties(BW_hoja);

    if isempty(stats_hoja)
        warning('No leaf detected. Using default scale assuming full A4 size.');
        bbox_hoja = [1, 1, size(img, 2), size(img, 1)];
        area_px_hoja = prod(bbox_hoja(3:4));
        cmX = 21 / bbox_hoja(3);
        cmY = 29.7 / bbox_hoja(4);
    else
        [~, idxMax] = max([stats_hoja.Area]);
        area_px_hoja = stats_hoja(idxMax).Area;
        bbox_hoja = stats_hoja(idxMax).BoundingBox;
        cmX = 21 / bbox_hoja(3);
        cmY = 29.7 / bbox_hoja(4);
    end

    %% 2) Color masks
    hsv = manual_rgb2hsv(img);
    greenMask = (hsv(:, :, 1) > 0.25 & hsv(:, :, 1) < 0.4) & hsv(:, :, 2) > 0.3;
    blueMask = (hsv(:, :, 1) > 0.55 & hsv(:, :, 1) < 0.7) & hsv(:, :, 2) > 0.4;
    yellowMask = (hsv(:, :, 1) > 0.1 & hsv(:, :, 1) < 0.2) & hsv(:, :, 2) > 0.4;
    purpleMask = (hsv(:, :, 1) > 0.75 & hsv(:, :, 1) < 0.9) & hsv(:, :, 2) > 0.3;

    masks = {greenMask, blueMask, yellowMask, purpleMask};
    colorNames = {'Green', 'Blue', 'Yellow', 'Purple'};

    %% 3) Detection
    Tipo = {}; Color = {}; Area_cm2 = []; X_cm = []; Y_cm = [];

    for k = 1:length(masks)
        BW = remove_small_objects(masks{k}, 100);
        stats = get_object_properties(BW);

        for i = 1:length(stats)
            a = stats(i).Area * cmX * cmY;
            tipo = classify_shape(a);
            Tipo{end + 1, 1} = tipo;
            Color{end + 1, 1} = colorNames{k};
            Area_cm2(end + 1, 1) = a;
            X_cm(end + 1, 1) = stats(i).Centroid(1) * cmX;
            Y_cm(end + 1, 1) = stats(i).Centroid(2) * cmY;
        end

    end

    %% 4) Pack into struct
    data.Tipo = Tipo;
    data.Color = Color;
    data.Area_cm2 = Area_cm2;
    data.X_cm = X_cm;
    data.Y_cm = Y_cm;
    data.cmX = cmX;
    data.cmY = cmY;
    data.BBox_Hoja = bbox_hoja;
    data.area_px_hoja = area_px_hoja;
end
