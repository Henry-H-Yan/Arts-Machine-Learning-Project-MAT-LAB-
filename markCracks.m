function [im_rgb] = markCracks(im,final_map,rgb_color)

    im = im2double(im);
    [im_h, im_w, n] = size(im);
    
    if (n >= 3)
        im = rgb2gray(im);
    end
    
    im_rgb = zeros(im_h,im_w,3);
    im_rgb(:,:,1) = im;
    im_rgb(:,:,2) = im;
    im_rgb(:,:,3) = im;

    [col, row] = find(final_map == 1);

    for i=1:length(col)
        im_rgb(col(i),row(i),1) = rgb_color(1);
        im_rgb(col(i),row(i),2) = rgb_color(2);
        im_rgb(col(i),row(i),3) = rgb_color(3);
    end

end