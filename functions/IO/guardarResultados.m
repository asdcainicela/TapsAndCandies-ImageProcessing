function guardarResultados(Tfinal, Taligned, counts, outputDir)
    if ~exist(outputDir, 'dir')
        mkdir(outputDir); 
    end
    writetable(Tfinal, fullfile(outputDir, 'Raw_Detections.csv'));
    writetable(Taligned, fullfile(outputDir, 'Matched_Detections.csv'));

    save(fullfile(outputDir, 'counts.mat'), 'counts'); % también guardar en .mat si quieres
end
