function guardarResultados(Tfinal, Taligned, counts, outputDir)
    if ~exist(outputDir, 'dir')
        mkdir(outputDir); 
    end
    writetable(Tfinal, fullfile(outputDir, 'ResultadosDeteccionCrudo.csv'));
    writetable(Taligned, fullfile(outputDir, 'ResultadosEmparejados.csv'));
    save(fullfile(outputDir, 'counts.mat'), 'counts'); % también guardar en .mat si quieres
end
