function crack_map = tophatTransform(path_data, name, params, general_settings)

    fileset = dir([path_data '*' name '*' ]);

    se_size = params.se_size;
    n_se = length(params.se_size);
    factor = 4;

    % -- filter operation on blocks -- %
    for i = 1:length(fileset)  

        im = imread([path_data fileset(i).name]);
        im = im2double(im);
        [im_h im_w] = size(im);
        im_bw = zeros(im_h, im_w, length(se_size));
        im_th = zeros(im_h, im_w, length(se_size));
        for j = 1:length(se_size)
            se = strel('square',se_size(j));  
            closeIm = imclose(im,se);
            im_th(:,:,j) = closeIm - im;
            
            % changed 09/10/2013
%             level = graythresh(im_th(:,:,j))*factor ;
%             im_bw(:,:,j) = im2bw(im_th(:,:,j),level);

            level = graythresh(im_th);
            im_bw(:,:,j) = hysthresh(im_th(:,:,j),level*factor,level*factor/2);
        end

        % construct base map
        base_map = constructBaseMap(im_th,3,factor,50);

        % propagation from base map
        crack_map = propagateCrackMap(im_bw, base_map, [10:20:10+(n_se-1)*20]);

    end

end