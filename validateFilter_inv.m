function validated = validateFilter_inv(filtered, S, angle, distance)

v = distance;
n = angle;
[im_h im_w] = size(filtered);

validated = zeros(size(filtered));
for j=v+1:im_h-(v+1)
    for i=v+1:im_w-(v+1)
        
        if ((S(round(j+v*n(2)),round(i+v*n(1))) < S(j,i)) && (S(round(j-v*n(2)),round(i-v*n(1))) < S(j,i)))
            validated(j,i) = filtered(j,i);    
        end
        
    end
end



end