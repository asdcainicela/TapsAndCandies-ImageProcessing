function stats = get_object_properties(BW)
    [L, num] = my_bwlabel(BW);
    stats = struct('Area', {}, 'Centroid', {}, 'BoundingBox', {});

    for k = 1:num
        [r, c] = find(L == k); area = length(r); cx = mean(c); cy = mean(r);
        x = min(c); y = min(r); w = max(c) - x + 1; h = max(r) - y + 1;
        stats(k).Area = area;
        stats(k).Centroid = [cx, cy];
        stats(k).BoundingBox = [x, y, w, h];
    end

end
