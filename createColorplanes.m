function createColorplanes(source_path, image_name, path_colorplanes, general)
    fprintf('source_path');
    fprintf(source_path);
    escape_char = general.escape_char;

    im = imread([source_path image_name]);
    im_info = imfinfo([source_path image_name]);
    
    dir_name = strtok(image_name, '.');

    if  strcmp(im_info.ColorType,'grayscale')

        mkdir([path_colorplanes dir_name]);
        imwrite(im,[path_colorplanes dir_name escape_char general.filename_gray]);

    else

        mkdir([path_colorplanes dir_name]);
        imwrite(rgb2gray(im(:,:,1:3)),[path_colorplanes dir_name escape_char general.filename_gray]);

        im_crack = im(:,:,1);
        imwrite(im_crack, [path_colorplanes dir_name escape_char general.filename_rgb_r]);

        im_crack = im(:,:,2);
        imwrite(im_crack, [path_colorplanes dir_name escape_char general.filename_rgb_g]);

        im_crack = im(:,:,3);
        imwrite(im_crack, [path_colorplanes dir_name escape_char general.filename_rgb_b]);

        im_hsv = rgb2hsv(im);

        im_crack = im_hsv(:,:,1);
        imwrite(im_crack, [path_colorplanes dir_name escape_char general.filename_hsv_h]);

        im_crack = im_hsv(:,:,2);
        imwrite(im_crack, [path_colorplanes dir_name escape_char general.filename_hsv_s]);

        im_crack = im_hsv(:,:,3);
        imwrite(im_crack, [path_colorplanes dir_name escape_char general.filename_hsv_v]);

    end
end