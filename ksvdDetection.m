function crack_map = ksvdDetection(im, params, bw_flag)

  %  fprintf(num2str( params)  );
    train_path = params.path_training;
    
    D = ksvdTrain(im, params);
    
    
  %  params_train
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- take in all training graphs and combine  --
    % fileset = dir([path_data '*' name '*' ]);

    im_train = imread(train_path);
    
    
    

    
    info = imfinfo(train_path);
    if (info.SamplesPerPixel >= 3)
        im_train = rgb2gray(im_train(:,:,1:3));
    end

    if (info.BitDepth/info.SamplesPerPixel == 16)
        im_train = double(im_train/255);
    end

    im_train = im2double(im_train);
     
    figure(2); imshow(im_train);title('im_Train');
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    im_rec = ksvdAlterD(im, im_train, D, params);
    
    
    
    
    if bw_flag 
        im_rec = -im_rec;
    end
    im_rec(im_rec < 0) = 0;
    im_rec = im_rec/max(max(im_rec));
    crack_map = hysthresh(im_rec,params.th1,params.th2);
    

end

