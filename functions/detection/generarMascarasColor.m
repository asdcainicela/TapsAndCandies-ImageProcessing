function [masks, colorNames] = generarMascarasColor(img)
    hsv = manual_rgb2hsv(img);
    greenMask  = (hsv(:,:,1) > 0.25 & hsv(:,:,1) < 0.4) & hsv(:,:,2) > 0.3;
    blueMask   = (hsv(:,:,1) > 0.55 & hsv(:,:,1) < 0.7) & hsv(:,:,2) > 0.4;
    yellowMask = (hsv(:,:,1) > 0.1 & hsv(:,:,1) < 0.2) & hsv(:,:,2) > 0.4;
    purpleMask = (hsv(:,:,1) > 0.75 & hsv(:,:,1) < 0.9) & hsv(:,:,2) > 0.3;

    masks = {greenMask, blueMask, yellowMask, purpleMask};
    colorNames = {'Green','Blue','Yellow','Purple'};
end
