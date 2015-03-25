
function [im_crack_splitted,im_crosspoints] = createSkeleton(im_crack, len, w)

    [im_h,im_w] = size(im_crack);
    [mb nb] = bestblk([im_h im_w],512);
    
    n_x = round(im_w/nb);
    n_y = round(im_h/mb);
    
    pad_x = mod(n_x*nb,im_w);
    pad_y = mod(n_y*mb,im_h);
    
    im_crack = padarray(im_crack, [pad_y,pad_x],'post');
    
    im_crack_block = zeros(mb,nb);
    im_crack_block_padded = zeros(size(im_crack_block)+[2*w,2*w]);
    
    zero_mat = zeros(2*w+1);
    one_mat = ones(2*w+1);

    im_crosspoints = zeros(size(im_crack));
    im_crack_splitted = zeros(size(im_crack));
    im_crosspoints_block = zeros(size(im_crack_block_padded));
    
    for j=1:n_y,
        for i=1:n_x,
            
            im_crack_block = im_crack((j-1)*mb+1:j*mb,(i-1)*nb+1:(i)*nb,:);
            CC_crack = bwconncomp(im_crack_block);
            if (CC_crack.NumObjects ~= 0)
                [edgelist, ] = edgelink(im_crack_block,len);
            
                if (length(edgelist) > 30)
                    edgelist = cleanedgelist(edgelist,10);
                end
            
            im_crack_block_padded(w+1:mb+w,w+1:nb+w) = im_crack_block;
            else
                edgelist = [];
            end
            
            for k=1:length(edgelist)
                
                edge = edgelist{k};
                startpt = edge(1,:)+[w,w];
                endpt = edge(size(edge,1),:)+[w,w];
                
                im_crack_block_padded(startpt(1)-w:startpt(1)+w, startpt(2)-w:startpt(2)+w) = zero_mat;
                im_crack_block_padded(endpt(1)-w:endpt(1)+w, endpt(2)-w:endpt(2)+w) = zero_mat;
                
                im_crosspoints_block(startpt(1)-w:startpt(1)+w, startpt(2)-w:startpt(2)+w) = one_mat;
                im_crosspoints_block(endpt(1)-w:endpt(1)+w, endpt(2)-w:endpt(2)+w) = one_mat;
                
            end
        

        im_crack_splitted((j-1)*mb+1:j*mb,(i-1)*nb+1:(i)*nb) = im_crack_block_padded(w+1:mb+w,w+1:nb+w);
        im_crosspoints((j-1)*mb+1:j*mb,(i-1)*nb+1:(i)*nb) = im_crosspoints_block(w+1:mb+w,w+1:nb+w);

        im_crack_block_padded = zeros(size(im_crack_block_padded));
        im_crosspoints_block = zeros(size(im_crosspoints_block));
        end
    end
end
