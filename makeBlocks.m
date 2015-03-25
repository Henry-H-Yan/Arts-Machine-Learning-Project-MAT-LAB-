% Author: Bruno Cornelis
% Edited: 30/06/2011
% Description: split up images that get too large

function makeBlocks(im, image_name, path_blocks, name, general_settings)

    block_overlap = general_settings.block_overlap;
    max_block_size = general_settings.max_block_size;
    escape_char = general_settings.escape_char;
    
	[im_h, im_w] = size(im(:,:,1));
    nc = size(im,3);
    
    mb = im_h;
    nb = im_w;
    
    while (mb > max_block_size*1.2)
        mb = ceil(mb/2);
    end
    
    while (nb > max_block_size*1.2)
        nb = ceil(nb/2);
    end
    
    n_x = round(im_w/nb);
    n_y = round(im_h/mb);
    
    pad_x = mod(n_x*nb,im_w);
    pad_y = mod(n_y*mb,im_h);
        
    im = mat2cell(im,size(im,1),size(im,2),ones(1,nc));
    im = cellfun(@(x)padarray(x,[pad_y+block_overlap,pad_x+block_overlap],'post'),im,'UniformOutput',0);
    im = cat(3,im{:});
%     im = padarray(im, [pad_y+block_overlap,pad_x+block_overlap],'post');
    
    mkdir([path_blocks,image_name,escape_char]);
%     rmdir([path_blocks,image_name,escape_char],'s');
    
    c = 0;
    for j=1:n_y,
        for i=1:n_x,
            c = c + 1;
            
            if c < 10
                num_str = ['0' num2str(c)];
            else
                num_str = num2str(c);
            end
                            
            mkdir(path_blocks,[image_name,escape_char]);
            
            im2 = im((j-1)*mb+1:j*mb+block_overlap,(i-1)*nb+1:(i)*nb+block_overlap,:);

            imwrite(im2,[path_blocks image_name escape_char num_str '_' name '.tif']);
        end
    end
    
    save([path_blocks image_name escape_char 'block_dim.mat'],'mb','nb','n_y','n_x','im_h','im_w');

end
