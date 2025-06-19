function hsv = manual_rgb2hsv(rgb)
    rgb = im2double(rgb);
    R = rgb(:, :, 1); G = rgb(:, :, 2); B = rgb(:, :, 3);
    Cmax = max(rgb, [], 3); Cmin = min(rgb, [], 3); delta = Cmax - Cmin;
    H = zeros(size(R));
    mask = delta ~= 0;
    idx = mask & (Cmax == R); H(idx) = mod((G(idx) - B(idx)) ./ delta(idx), 6);
    idx = mask & (Cmax == G); H(idx) = ((B(idx) - R(idx)) ./ delta(idx)) + 2;
    idx = mask & (Cmax == B); H(idx) = ((R(idx) - G(idx)) ./ delta(idx)) + 4;
    H = H / 6; H(H < 0) = H(H < 0) + 1;
    S = zeros(size(R)); S(Cmax ~= 0) = delta(Cmax ~= 0) ./ Cmax(Cmax ~= 0);
    V = Cmax;
    hsv = cat(3, H, S, V);
end
