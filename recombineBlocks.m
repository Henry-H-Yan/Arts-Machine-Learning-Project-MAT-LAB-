% Author: Bruno Cornelis
% Edited: 13/07/2011
% Description: recombine splitted images

function crack_map = recombineBlocks(path_data,  typename, general_settings)

    fileset = dir([path_data '*' typename '*' ]);
    
    block_overlap = general_settings.block_overlap;
    escape_char = general_settings.escape_char;
   

    c = 0;
    
    load([path_data 'block_dim.mat']);
    
    im_crack_temp = zeros(n_y*mb+block_overlap,n_x*nb+block_overlap);

    for j=1:n_y,
        for i=1:n_x,
            
            c = c + 1;
            
            
            
            num = strtok(fileset(c).name, '_');
            
            im_crack_block = imread([path_data num typename '.tif']);
%             im_crack_block = logical(im_crack_block);
              
            im_crack_temp((j-1)*mb+1:j*mb+block_overlap,(i-1)*nb+1:(i)*nb+block_overlap) = im_crack_block(1:mb+block_overlap,1:nb+block_overlap);
%             crack_map = crack_map | im_crack_temp;
            
        end
    end
    
%     crack_map = crack_map(1:im_h,1:im_w);
    crack_map = im_crack_temp(1:im_h,1:im_w);
end

