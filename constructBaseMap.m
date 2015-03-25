% created: 12/10/2010
% last edited: 14/07/2011
% author: Bruno Cornelis

function base_map = constructBaseMap(maps, nmaps, factor, npixels)

[im_h im_w n] = size(maps);
base_map = zeros(im_h, im_w);

for i = 1:nmaps
    
    im = maps(:,:,i);
    im = im2double(im);
    
    % changed on 9/10/2013
%     level = graythresh(im)*factor ;
%     im_bw = im2bw(im,level);

    level = graythresh(im);
    im_bw = hysthresh(im,level*factor,level*factor/2);
    
    
    
    im_bw = bwmorph(im_bw,'bridge');
    im_bw = bwmorph(im_bw,'clean');
    im_bw = bwmorph(im_bw,'fill');
        
    im_bw(1:im_h,1:3) = 0;
    im_bw(1:im_h,im_w-2:im_w) = 0;
    im_bw(1:3,1:im_w) = 0;
    im_bw(im_h-2:im_h,1:im_w) = 0;
    
    CC_crack = bwconncomp(im_bw);
    CC_crack_stats = regionprops(CC_crack,'Area');

    [idx] = find([CC_crack_stats.Area] < npixels);
    for j=1:length(idx)
        im_bw(CC_crack.PixelIdxList{idx(j)}) = 0;
    end
    
    base_map = base_map | im_bw;
    
end

end