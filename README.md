# TapsAndCandies-ImageProcessing

A **MATLAB App Designer** application for detecting, measuring, and matching plastic caps and candies (e.g. lentils) in images.  
This version (v2.0.0) features a fully localized user interface (English and Spanish) with a language dropdown allowing you to switch between languages dynamically.

## ✨ Features
- Load images directly from file or capture with a webcam.
- Interactive GUI built in **MATLAB App Designer** with multi-language support.
- Automatic scale calibration using detected A4 paper as reference.
- Color segmentation and object classification (**bottle caps** or **lentils**) powered by the **MATLAB Image Processing Toolbox**.
- Compute object areas and centroid positions.
- Match corresponding objects between `start` and `end` images.
- Export raw and matched detection results as CSV files.
- Display a summary of object counts per color and type.


## 📦 Requirements
- MATLAB R2025a or later
- Image Processing Toolbox installed

## 🏗️ Installation
1. Clone the repository:
   git clone https://github.com/asdcainicela/TapsAndCandies-ImageProcessing.git
2. Open MATLAB.
3. Navigate to the project folder.
4. Run `App.mlapp` in App Designer.

## 📂 Project Structure

```
TapsAndCandies-ImageProcessing/
├── app.mlapp               # Main App Designer file.
├── app_exported.m          # Auto-generated exported version of the app.
├── listTree.mlx            # Utility for listing file structure.
├── logic.m                 # Standalone logic script without GUI.
├── config/                 # CSV files for UI layout, styles, and translations.
├── functions/
│   ├── detection/          # Image-processing and detection scripts.
│   │   ├── calcularEscalaDesdeHoja.m
│   │   ├── classify_shape.m
│   │   ├── detectarEnImagenes.m
│   │   ├── detectarObjetos.m
│   │   ├── detectarObjetosEnMascaras.m
│   │   └── generarMascarasColor.m
│   ├── matching/           # Matching and counting detected objects.
│   │   ├── calcularConteos.m
│   │   ├── convertirDeteccionATabla.m
│   │   └── emparejarDetecciones.m
│   ├── preprocessing/      # Preprocessing utilities.
│   │   └── remove_nonborder_objects.m
│   ├── round-button/       # Custom UI round button component.
│   │   ├── round_button.html
│   │   ├── round_button.m
│   │   └── test_button.m
│   ├── utils/              # General utility scripts.
│       ├── cargarEscalarImagen.m
│       ├── formatearDecimales.m
│       ├── getFieldOrZero.m
│       ├── guardarDeteccionesImagenes.m
│       ├── guardarResultados.m
│       └── visualizarDetecciones.m
├── media/                  # Images and UI backgrounds.
├── result/                 # Generated output files and CSVs.
├── ss/                     # Screenshots of the app (English and Spanish).
├── utils/                  # Support packages or other utility files.
```

## 📜 Releases
v2.0.0 — Added Image Processing Toolbox support, multilingual interface (EN/ES), new project structure, automatic layout/styling from CSV.

v1.0.5 — Automated object matching and scale calibration, still in Spanish only, using custom image-processing functions.

v1.0.0 — Initial version without any external packages. Pure custom image-processing and English interface.

### 📄 Release Description (v2.0.0)
This version integrates the MATLAB Image Processing Toolbox, allowing for more robust image segmentation and detection routines. It simplifies the codebase by removing custom thresholding and labeling functions, and enhances the UI with a language selector. All labels and table contents switch dynamically between English and Spanish. The structure is better organized into logical folders for detection, matching, preprocessing, utilities, and UI components.

## 📝 Usage
1. Run `App.mlapp`.
2. Capture or load two images (start and end).
3. Click **Process** to detect and match objects.
4. View results in the app and check CSV files in `result/`.

## 📄 Notes
- Implemented using MATLAB App Designer and Image Processing Toolbox.
- Fully automated object detection and analysis.
- Interface is Spanish only.

## Extending the Project

If you want to control the app via smartphone or add new features like remote capture or cloud sync, check out:

[Descarga la aplicación](https://play.google.com/store/apps/details?id=com.pas.webcam&hl=en)  
See also the example video:  
[HEBI Robotics demo](https://www.youtube.com/watch?v=zaPtxre4tFc)

## Contributing

Contributions are welcome! Feel free to fork this repo and submit pull requests.

## License

This project is distributed **without a restrictive license** — you can use, modify, and distribute it as you wish.
