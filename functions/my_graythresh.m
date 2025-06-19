function level = my_graythresh(I)
    % Asegurar que la imagen sea uint8
    if isa(I, 'double')
        minI = min(I(:));
        maxI = max(I(:));

        if maxI <= 1
            I = uint8(I * 255); % Escala de 0-1 a 0-255
        else
            I = uint8(I); % Ya está entre 0-255
        end

    elseif isa(I, 'single')
        minI = min(I(:));
        maxI = max(I(:));

        if maxI <= 1
            I = uint8(I * 255); % Escala de 0-1 a 0-255
        else
            I = uint8(I);
        end

    elseif ~isa(I, 'uint8')
        I = uint8(I); % Por si es uint16 u otro tipo entero
    end

    % Histograma y Otsu
    counts = zeros(256, 1);

    for pix = 0:255
        counts(pix + 1) = sum(I(:) == pix);
    end

    p = counts / sum(counts); % Probabilidades
    omega = cumsum(p);
    mu = cumsum((0:255)' .* p);
    muT = mu(end);
    sigma_b_sq = (muT * omega - mu) .^ 2 ./ (omega .* (1 - omega) + eps);
    [~, idx] = max(sigma_b_sq);
    level = (idx - 1) / 255;
end
