%function final_map = votingTest(paths)


%     image_name = strtok([fileset(k).name],'.');

%  crack_ksvd = logical(imread([paths{1} 'cleaned_mask.tif']));
%     crack_matched = logical(imread([paths{2} 'cleaned_mask.tif']));
%     crack_mscale = logical(imread([paths{3} 'cleaned_mask.tif']));
%  
     f1= 'good2.tif';
     crack1 = logical(imread(f1));
     figure(10);imshow(crack1,[0,1]);title(f1)
    
     f2= 'mask.tif';
     crack2 = logical(imread(f2));
      figure(11);imshow(crack2,[0,1]);title(f2)
      
%     maps_added = crack_ksvd + crack_matched + crack_mscale;
%     binary_map = (crack_ksvd | crack_matched) | crack_mscale;
%     
    maps_added = crack1+crack2;
    binary_map = crack1|crack2;
    
    
    CC_crack = bwconncomp(binary_map);
    factor = zeros(CC_crack.NumObjects,1);

    for i=1:CC_crack.NumObjects;

        pixelArray = CC_crack.PixelIdxList{i};
        CC_crack_stats = regionprops(CC_crack, 'Area');
        total_nop = CC_crack_stats(i).Area;

        valArray = maps_added(pixelArray);
        nop = length(valArray(valArray > 1));
        factor(i) = nop/total_nop;

    end

    [idx] = find(factor == 0);
    for i=1:length(idx)
        binary_map(CC_crack.PixelIdxList{idx(i)}) = 0;
    end
    
    [im_crack_splitted,im_crosspoints] = createSkeleton(binary_map,[],3);
    im_crack_splitted = im_crack_splitted(size(binary_map));
    im_crosspoints = im_crosspoints(size(binary_map));
    
    
    CC_crack = bwconncomp(im_crack_splitted);
    factor_map = zeros(size(binary_map));
    factor = zeros(CC_crack.NumObjects,1);

    for i=1:CC_crack.NumObjects;

        pixelArray = CC_crack.PixelIdxList{i};
        CC_crack_stats = regionprops(CC_crack, 'Area');
        total_nop = CC_crack_stats(i).Area;

        valArray = maps_added(pixelArray);
        nop = length(valArray(valArray > 1));
        factor(i) = nop/total_nop;

        factor_map(pixelArray) = factor(i);

    end

    cracks_to_remove = zeros(size(binary_map));
    [idx] = find(factor < 0.3);
    for i=1:length(idx)
        cracks_to_remove(CC_crack.PixelIdxList{idx(i)}) = 1;
    end


    CC_crack = bwconncomp(cracks_to_remove);
    CC_crack_stats = regionprops(CC_crack, 'Area');

    [idx] = find([CC_crack_stats.Area] < 40);
    for i=1:length(idx)
        cracks_to_remove(CC_crack.PixelIdxList{idx(i)}) = 0;
    end


    SE = strel('square',2);
    im_crosspoints = imdilate(im_crosspoints,SE);

    CC_to_remove = bwconncomp(cracks_to_remove);
    for i=1:CC_to_remove.NumObjects
        [r c] = ind2sub(size(cracks_to_remove), CC_to_remove.PixelIdxList{i});
        [map_connected,idx] = bwselect(im_crosspoints,c,r,8);
        map_connected = imerode(map_connected,SE);
        cracks_to_remove = cracks_to_remove | map_connected;   
    end
    
    final_map = (binary_map - cracks_to_remove);
    final_map = (final_map > 0);
    
    


figure(200); imshow(final_map,[0,1]);title('finalmap');