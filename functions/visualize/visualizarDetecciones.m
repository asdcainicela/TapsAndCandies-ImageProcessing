function visualizarDetecciones(img, data, cmX, cmY)
    figure; imshow(img); hold on;
    for i = 1:length(data.Tipo)
        X_pix = data.X_cm(i)/cmX;
        Y_pix = data.Y_cm(i)/cmY;
        plot(X_pix, Y_pix, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
        text(X_pix+10, Y_pix, sprintf('%s (%s)', data.Tipo{i}, data.Color{i}), ...
             'Color','red','FontSize',10,'FontWeight','bold');
    end
    hold off;
end
