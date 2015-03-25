function saveSkeleton(path_im_crack, image_name, path_result, w, general) 

    escape_char = general.escape_char;

    fprintf('path_im_crack\n');
    fprintf(path_im_crack);
    
    %%%%%%%%%%%%%%%%%%%%%%
    %  path_im_crack  needs updating!!!
    fprintf('path_im_crack is: '); fprintf(path_im_crack);
  % path_im_crack='results/ksvd/01_enhanced/1_enhanced.tif'
     k= strtok(image_name,'_');  %% k is the number!!
     
     folder= strcat('results/ksvd/', k,'_enhanced/');
     
     if( strcmp(k(1),'0'))
        k=k(2);
     end
     
     
    path_im_crack=strcat(folder,k,'_enhanced.tif');
    im_crack = imread(path_im_crack);
    [im_h im_w] = size(im_crack);
    
    im_crack(1:im_h,1) = 0;
    im_crack(1:im_h,im_w) = 0;
    im_crack(1,1:im_w) = 0;
    im_crack(im_h,1:im_w) = 0;
    
    imwrite(im_crack, path_im_crack);
    
    image_name = strtok(image_name,'.');
    [im_h,im_w] = size(im_crack);
    [crack_split,crack_junctions] = createSkeleton(im_crack,[],w);
    
    crack_split(1:im_h,1) = 0;
    crack_split(1:im_h,im_w) = 0;
    crack_split(1,1:im_w) = 0;
    crack_split(im_h,1:im_w) = 0;

    imwrite(crack_split(1:im_h, 1:im_w),[path_result image_name escape_char 'splitted.tif']);
    imwrite(crack_junctions(1:im_h, 1:im_w),[path_result image_name escape_char 'crosspoints.tif']);

end
