function cleaned_map = kmeansFiltering(path_data, selected_features,name)

if nargin < 3
    name = 'mask';
end


    
    im_splitted = imread([path_data 'splitted.tif']);
    load([path_data 'FeatArray.mat']);

%     featArray = featArray(:,selected_features);
    
    %%% classification with k-means
    CC_crack = bwconncomp(im_splitted);
    classified_map = zeros(size(im_splitted));
    do_kmeans = 'y';
    
    while do_kmeans == 'y'
        
    [IDX,C] = kmeans(featArray,5);
    for i=1:CC_crack.NumObjects
        pixelArray = CC_crack.PixelIdxList{i};
        classified_map(pixelArray) = IDX(i);
    end
    figure('name',name);map = imagesc(classified_map);colorbar;title('kmeans classification result')
    
%     %%% user input
%     stop_com = 'n';
%     cracks_to_remove = zeros(size(im_splitted)); 
%     while stop_com ~= 'y'
%         class_tbr = input('What class needs to be removed?: ');
%         if (class_tbr == 0)
%             break;
%         end
%         % cracks_to_remove(ismember(classified,class_tbr)) = 1;
%         cracks_to_remove(classified_map == class_tbr) = 1;
%         stop_com = input('Stop (y/n)?: ','s');
%     end

     %%% gui user input
     cracks_to_remove = zeros(size(im_splitted));
     do_kmeans = questdlg('Do kmeans again? ', 'Redo kmeans', 'y','n','n');
     if do_kmeans == 'n'
         x = inputdlg('Enter classes to be removed (e.g. 2 3 5):',...
             'Sample', [1 50]);
         class_tbr = str2num(x{:});
         cracks_to_remove(ismember(classified_map,class_tbr)) = 1;
         classified_map = classified_map.*(~ismember(classified_map,class_tbr));
     end
    end
    map = imshow(classified_map > 0,[]);title('selected crack classes');


%     figure, imshow(cracks_to_remove);title('cracks to remove');

    im_crack = imread([path_data name '.tif']);
    im_crosspoints = imread([path_data 'crosspoints.tif']);

    SE = strel('square',2);
    im_crosspoints = imdilate(im_crosspoints,SE);
    CC_to_remove = bwconncomp(cracks_to_remove);

    for i=1:CC_to_remove.NumObjects
        [r c] = ind2sub(size(cracks_to_remove), CC_to_remove.PixelIdxList{i});
        [map_connected,~] = bwselect(im_crosspoints,c,r,8);
        map_connected = imerode(map_connected,SE);
        cracks_to_remove = cracks_to_remove | map_connected;   
    end
%     figure, imshow(cracks_to_remove);title('cracks to remove dilated');

    SE = strel('square',3);
    cracks_to_remove = imdilate(cracks_to_remove,SE);

    final_map = (im_crack-cracks_to_remove);
    cleaned_map = (final_map > 0);

    CC_crack = bwconncomp(cleaned_map);
    CC_crack_stats = regionprops(CC_crack,'Eccentricity','Area');

    [idx] = find([CC_crack_stats.Area] < 40 & [CC_crack_stats.Eccentricity] < 0.95);
    for i=1:length(idx)
        cleaned_map(CC_crack.PixelIdxList{idx(i)}) = 0;
    end

end

