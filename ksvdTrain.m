function D = ksvd(im,params)

    blocksize = params.blocksize;
    
    x = im2double(im);
    p = ndims(x);
    ids = cell(p,1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [ids{:}] = reggrid(size(x)-params.blocksize+1, params.trainnum, 'eqdist');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    params.data = sampgrid(x,params.blocksize,ids{:});

    % remove dc in blocks to conserve memory %
    for i = 1:blocksize:size(params.data,2)
      blockids = i : min(i+blocksize-1,size(params.data,2));
      params.data(:,blockids) = remove_dc(params.data(:,blockids),'columns');
    end

    %%%% train dictionary %%%%
    [D,~,~] = ksvd(params,params.verbose);

end
