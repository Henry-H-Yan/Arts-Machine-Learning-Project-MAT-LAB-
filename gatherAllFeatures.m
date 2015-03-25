function [featArray, feature_vector] = gatherAllFeatures(path_result, image_name, general, post_proc,  path_data)

    im = imread([path_data.source image_name '.tif']);
    [~, ~, n] = size(im);
    sw_color = true;
    
    if  n == 1
        sw_color = false;
    end
    
    image_name = strtok(image_name,'.');
    escape_char = general.escape_char;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('\n');
   
    %% im_crack = imread([path_result image_name escape_char 'mask.tif']);

    im_crack = imread([path_result image_name escape_char 'mask.tif']);
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [im_h,im_w] = size(im_crack);
    
    im_splitted = imread([path_result image_name escape_char 'splitted.tif']);


    if sw_color == true
        feature_vector = 1:13;
    else
        feature_vector = [1 8:12];
    end
    
    % added on 10/10/2013
    feature_vector = post_proc.selectedFeatures;
    
    path_colors = [path_data.planes image_name escape_char];
    %featArray = gatherFeatures(im_crack, im_splitted, feature_vector, path_colors);
    featArray = gatherFeatures(im_crack, im_splitted, feature_vector, path_colors,image_name);
end