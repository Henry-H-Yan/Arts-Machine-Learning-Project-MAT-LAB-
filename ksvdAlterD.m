function im_rec = ksvdAlterD(im, im_train, D, params)

x_orig = im;
%%%%%%%%%%%%%%%
x = im_train;

dictsize = params.dictsize;
params.Tdata = 1;
blocksize = params.blocksize;

stepsize = 1;
stepsize = ones(1,2)*stepsize;

% blocksize %
if (numel(params.blocksize)==1)
    blocksize = ones(1,2)*blocksize;
end

G = D'*D;

n_dictel_used = zeros(1,dictsize);

%     for idx = 1:ntrainimg

for j = 1:stepsize(2):size(x,2)-blocksize(2)+1
    
    % the current batch of blocks
    blocks = im2colstep(x(:,j:j+blocksize(2)-1),blocksize,stepsize);
    
    % remove DC
    [blocks, ~] = remove_dc(blocks,'columns');
    gamma = omp(D'*blocks,G,params.Tdata);
    
    [a,~,~] = find(gamma);
    n_dictel_used = n_dictel_used + hist(a,dictsize);
    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_n = max(n_dictel_used);
% n_dict_th = find(n_dictel_used >= floor(max_n*0.5));


fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

 n_dict_th = find(n_dictel_used >= floor(max_n* params.thresh));  %% change threshold
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10);
hist(n_dictel_used); title('n_dictel_used');



%     combine n_dict_th
%

% max_n = max(n_dictel_used);
%  n_dict_th{idx} = find(n_dictel_used >= floor(max_n*0.5));
% n_dict_th{idx} = find(n_dictel_used >= floor(max_n*0.5));


y = zeros(size(x_orig));
for j = 1:stepsize(2):size(y,2)-blocksize(2)+1
    
    % the current batch of blocks
    blocks = im2colstep(x_orig(:,j:j+blocksize(2)-1),blocksize,stepsize);
    
    % remove DC
    [blocks, dc] = remove_dc(blocks,'columns');
    gamma = omp(D'*blocks,G,params.Tdata);
    gamma_new = zeros(size(gamma));
    gamma_new(n_dict_th,:) = gamma(n_dict_th,:);
    
    % add DC
    %     cleanblocks = add_dc(D*gamma_new, dc, 'columns');
    cleanblocks = D*gamma_new;
    %     n_dictel_used = nonzeros(g);
    cleanim = col2imstep(cleanblocks,[size(y,1) blocksize(2)],blocksize,stepsize);
    
    y(:,j:j+blocksize(2)-1) = y(:,j:j+blocksize(2)-1) + cleanim;
    
end

cnt = countcover(size(x_orig),blocksize,stepsize);
im_rec = (y./cnt);

end