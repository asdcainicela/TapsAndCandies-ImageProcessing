function data = detectarObjetosEnMascaras(masks, colorNames, cmX, cmY)
    Tipo = {}; Color = {}; Area_cm2 = []; X_cm = []; Y_cm = [];

    for k = 1:length(masks)
        BW = remove_small_objects(masks{k}, 100);
        stats = get_object_properties(BW);
        for i = 1:length(stats)
            a = stats(i).Area * cmX * cmY;
            tipo = classify_shape(a); % SRP
            Tipo{end+1,1} = tipo;
            Color{end+1,1} = colorNames{k};
            Area_cm2(end+1,1) = a;
            X_cm(end+1,1) = stats(i).Centroid(1) * cmX;
            Y_cm(end+1,1) = stats(i).Centroid(2) * cmY;
        end
    end

    data.Tipo = Tipo;
    data.Color = Color;
    data.Area_cm2 = Area_cm2;
    data.X_cm = X_cm;
    data.Y_cm = Y_cm;
end
