function [im,enhancedImage] = prepareData(im, image_name, path_gray, path_enh, sw_enh)

    [~, ~, n] = size(im);
    sw_color = true;
    
    if  n == 1
        sw_color = false;
    end
    
    % -- convert to grayscale --
    if  sw_color
        im = rgb2gray(im(:,:,1:3));
    end
    
    im = im2double(im);
    
    % -- contrast enhancement --
    if sw_enh
        mkdir([path_enh image_name]);
        enhancedImage = contrastEnhance(im);
        imwrite(enhancedImage,[path_enh image_name '/enhanced.tif']);
    end
    
    mkdir([path_gray image_name]);
    imwrite(im,[path_gray image_name '/gray.tif']);
    
end
