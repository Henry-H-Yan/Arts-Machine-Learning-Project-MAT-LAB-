function featureArray = gatherFeatures(im_crack, im_splitted, selectedfeat, path_colorplanes,image_name)

    featureArray = [];
    
    %%% Create objects
    CC_crack = bwconncomp(im_splitted);

    %%% extract crack properties
    % determine crack density
    if (~isempty(find(selectedfeat==1)))
        border_size = [5 5];
        block_size = [30 30];

        myfun = @(block_struct) ...
            sum(sum(block_struct.data))*...
            ones(size(block_struct.data));

        block_edges = blockproc(im_crack,block_size,myfun,'BorderSize',border_size);

%     figure
%     imagesc(block_edges);
%     title('Block Processing - Density');

        densityArray = zeros(CC_crack.NumObjects,1);

        for i=1:CC_crack.NumObjects
            pixelArray = CC_crack.PixelIdxList{i};

            sArray = block_edges(pixelArray);
            densityArray(i) = mean(sArray);
        end
        % normalize
        densityArray = densityArray/max(max(densityArray));
        featureArray = [featureArray densityArray];
    end
    
    % crack color properties
    c = 1;
    
    if (~isempty(find(selectedfeat==2)))
        fileset(c).name = 'rgb_r.tif';
        c = c+1;
    end
    
    if (~isempty(find(selectedfeat==3)))
        fileset(c).name = 'rgb_g.tif';
        c = c+1;
    end
    
    if (~isempty(find(selectedfeat==4)))
        fileset(c).name = 'rgb_b.tif';
        c = c+1;
    end
    
    if (~isempty(find(selectedfeat==5)))
        fileset(c).name = 'hsv_h.tif';
        c = c+1;
    end
    
    if (~isempty(find(selectedfeat==6)))
        fileset(c).name = 'hsv_s.tif';
        c = c+1;
    end
    
    if (~isempty(find(selectedfeat==7)))
        fileset(c).name = 'hsv_v.tif';
        c = c+1;
    end
    
    if (~isempty(find(selectedfeat==8)))
        fileset(c).name = 'gray.tif';
    end
    
    n_planes = length(fileset);
    delete([path_colorplanes '.DS_Store']);
    colorArray = zeros(CC_crack.NumObjects,n_planes);

    for j = 1:n_planes


        path_colorplanes=strcat('data_colorplanes/',image_name,'/');
        plane = imread([path_colorplanes fileset(j).name]);
        plane = im2double(plane);

        for i=1:CC_crack.NumObjects

            pixelArray = CC_crack.PixelIdxList{i};
            sArray = plane(pixelArray);
            colorArray(i,j) = mean(sArray);

        end

    end
    
    featureArray = [featureArray colorArray];
    
    
    % crack border color properties
    if (~isempty(find(selectedfeat==13)))
  
    
        SE = strel('square',4);
        im_splitted_temp = imdilate(im_splitted,SE);
        final_map_border = im_splitted_temp-im_splitted;

        SE = strel('square',2);
        final_map_border = imdilate(final_map_border, SE);
    %     figure, imshow(final_map_border);
        L = bwlabel(final_map_border, 8);

        CC_crack_border = bwconncomp(final_map_border);
%         classified_bordermap = zeros(size(final_map_border));
        featborderArray = zeros(CC_crack_border.NumObjects,n_planes);

        for j = 1:n_planes

            plane = imread([path_colorplanes fileset(j).name]);
            plane = im2double(plane);

            for i=1:CC_crack_border.NumObjects

                pixelArray = CC_crack_border.PixelIdxList{i};
                sArray = plane(pixelArray);
                featborderArray(i,j) = mean(sArray);
            end

        end

        selected_crack = zeros(size(im_splitted));
        borderArray = zeros(CC_crack.NumObjects,n_planes);

        for i=1:CC_crack.NumObjects
            [r c] = ind2sub(size(im_splitted), CC_crack.PixelIdxList{i});
            selected_crack(CC_crack.PixelIdxList{i}) = 1;

            [~,idx] = bwselect(final_map_border,c,r,8);
            object_no = L(idx);
            object_no = object_no(1);

            borderArray(i,1:n_planes) = featborderArray(object_no,:);
        end
        
        featureArray = [featureArray borderArray];
        
    end

    
    % physical properties such as length, width, orientation, etc.
    
    CC_crack_stats = regionprops(CC_crack, 'MajorAxisLength','Orientation','Eccentricity','ConvexArea');
    geometryArray = zeros(CC_crack.NumObjects,4);
    
    c = 1;
    if (~isempty(find(selectedfeat==9)))
        for i=1:length(CC_crack_stats)
            geometryArray(i,c) = CC_crack_stats(i).Orientation;
        end
        
        geometryArray(:,1) = abs(geometryArray(:,1));
%         for i=1:length(tempArray(:,1))
%             if abs(tempArray(i,1) > 45) 
%                 tempArray(i,1) = abs((tempArray(i,1))-90); 
%             end
%         end
        geometryArray(:,c) = geometryArray(:,c)/max(geometryArray(:,c));
        
        c = c + 1;      
    end
    
    if (~isempty(find(selectedfeat==10)))
        for i=1:length(CC_crack_stats)
            geometryArray(i,c) = CC_crack_stats(i).MajorAxisLength;
        end
        geometryArray(:,c) = (geometryArray(:,c))/max(geometryArray(:,c));
        c = c + 1;      
    end
    
    if (~isempty(find(selectedfeat==11)))
        for i=1:length(CC_crack_stats)
            geometryArray(i,c) = CC_crack_stats(i).Eccentricity;
        end
        c = c + 1;      
    end
    
    if (~isempty(find(selectedfeat==12)))
        for i=1:length(CC_crack_stats)
            geometryArray(i,c) = CC_crack_stats(i).ConvexArea;
        end
        geometryArray(:,c) = (geometryArray(:,c))/max(geometryArray(:,c));
    end
    
    featureArray = [featureArray geometryArray];

end