# TapsAndCandies-ImageProcessing (v1.0.5)

A MATLAB App Designer application for detecting, measuring, and matching plastic caps and candies (e.g. lentils) in images.
This version is fully automated and requires the MATLAB Image Processing Toolbox.
All the custom image-processing functions from earlier versions have been removed in favor of the Toolbox.
The graphical user interface is in Spanish.

## ✨ Features
- Graphical user interface built in MATLAB App Designer (now only in Spanish).
- Capture or load images directly from file or webcam.
- Automatic scale calculation using detected A4 paper as reference.
- Color segmentation and object classification (bottle caps and lentils) using Image Processing Toolbox.
- Compute object areas and centroid positions.
- Match corresponding objects between start and end images.
- Display results in tables and preview axes.
- Export raw and matched detection results as CSV.
- Summaries of object counts per color and type.

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
TapsAndCandies-ImageProcessing/
├── App.mlapp
├── app_exported.m
├── config/
│   └── boton_config.csv
├── functions/
│   ├── detection/
│   │   ├── calcularEscalaDesdeHoja.m
│   │   ├── classify_shape.m
│   │   ├── detectarEnImagenes.m
│   │   ├── detectarObjetos.m
│   │   ├── detectarObjetosEnMascaras.m
│   │   ├── generarMascarasColor.m
│   ├── matching/
│   │   ├── calcularConteos.m
│   │   ├── convertirDeteccionATabla.m
│   │   ├── emparejarDetecciones.m
│   ├── preprocessing/
│   │   ├── remove_nonborder_objects.m
│   ├── round-button/
│   │   ├── round_button.m
│   │   ├── round_button.html
│   │   ├── test_button.m
│   ├── utils/
│   │   ├── cargarEscalarImagen.m
│   │   ├── formatearDecimales.m
│   │   ├── getFieldOrZero.m
│   │   ├── guardarDeteccionesImagenes.m
│   │   ├── guardarResultados.m
│   │   ├── visualizarDetecciones.m
├── listTree.mlx
├── media/
├── result/
├── ss/
├── utils/
│   └── usbwebcams.mlpkginstall

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
