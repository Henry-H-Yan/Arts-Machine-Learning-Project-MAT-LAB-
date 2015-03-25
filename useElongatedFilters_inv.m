function crack_map = useElongatedFilters_inv(im, filterset, filter_params)

    filtersize = filter_params.filtersize;
    filterlength = filter_params.filterlength;
    sigma = filter_params.sigma; 
    nsteps = filter_params.nsteps; 
    halfcrackwidth = filter_params.halfcrackwidth; 
    
    th1 = filter_params.th1;
    th2 = filter_params.th2;
    
    map = zeros(size(im));
    map2 = zeros(size(im));
    
    G = makeGaussian(sigma, filtersize);
    blurred = filter2(G,im);

    c = 0;
    for i=1:2:length(nsteps) - 2

        c = c + 1;
        angle = [nsteps(i) 1-nsteps(i)];
        filter = filterset(:,:,i);
        imfiltered = filter2(filter,im);
        imfiltered = validateFilter_inv(imfiltered, blurred, angle, halfcrackwidth);
        imfiltered_bw  = hysthresh(imfiltered,th1,th2);

        map = map | imfiltered_bw;

        filterrotated = filterset(:,:,i+1);
        imfiltered2 = filter2(filterrotated,im);

        if (angle(1) == 0)
            t = [1 0];
        else
            if (angle(2) == 0)
                t = [0 1];
            else
                t(1) = angle(2)/sqrt(angle(1)^2+angle(2)^2);
                t(2) = -angle(1)*t(1)/angle(2);
            end        
        end

        imfiltered2 = validateFilter(imfiltered2, blurred, t, halfcrackwidth);
        imfiltered2_bw  = hysthresh(imfiltered2,th1,th2);

        map2 = map2 | imfiltered2_bw;

    end

    crack_map = map | map2;
    
end