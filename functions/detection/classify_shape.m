function tipo = classify_shape(area_cm2)
    % Expected range for each type (in cm^2):
    minLentil = 0.1;
    maxLentil = 1.5;
    minBottleCap = 2.5;
    maxBottleCap = 10.0;

    if area_cm2 >= minBottleCap && area_cm2 <= maxBottleCap
        tipo = 'Bottle Cap';
    elseif area_cm2 >= minLentil && area_cm2 <= maxLentil
        tipo = 'Lentil';
    else
        tipo = 'Unknown';
    end

end
