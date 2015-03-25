% created: 12/10/2010
% last edited: 22/10/2010
% author: Bruno Cornelis

function crackmap = propagateCrackMap(maps, map_base, npixels)

    [im_h im_w n] = size(maps);
    crackmap  = zeros(im_h,im_w);
    
    % connected components base crack map
    CC(n+1) = bwconncomp(map_base);
    nobjects = floor(CC(n+1).NumObjects);

    for j = 1:n

        map_SE = maps(:,:,j);

        map_SE = bwmorph(map_SE,'bridge');
        map_SE = bwmorph(map_SE,'clean');
        map_SE = bwmorph(map_SE,'fill');

        CC(j) = bwconncomp(map_SE);
        numPixels = cellfun(@numel,CC(j).PixelIdxList);

        [ind] = find(numPixels < npixels(j));
        for i=1:length(ind)
            map_SE(CC(j).PixelIdxList{ind(i)}) = 0;
        end

        maps(:,:,j) = map_SE;

    end

    numPixels = cellfun(@numel,CC(n+1).PixelIdxList);
    [~,idx] = sort(numPixels,'descend');
    for j = 1:n
        for i=1:nobjects
            [r c] = ind2sub(size(map_base), CC(n+1).PixelIdxList{idx(i)});
            crackmap = crackmap | bwselect(maps(:,:,j),c,r,8);
        end
    end
    
    
end

