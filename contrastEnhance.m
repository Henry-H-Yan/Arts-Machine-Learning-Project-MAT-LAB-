function enhancedImage = contrastEnhance(im)    
    
    grayImage = im2double(im);
    grayMask = 1-grayImage;

    H = fspecial('gaussian',[45 45], 15); % book

    grayMask = imfilter(grayMask,H,'replicate');

    enhancedImage = adapthisteq(grayImage,'NumTiles', [48 48], 'nbins', 256,'distribution','uniform');
    enhancedImage = enhancedImage+0.1; 
    grayMask = histeq(grayMask);
    enhancedImage = grayMask.*enhancedImage+(1-grayMask).*grayImage;
    
end