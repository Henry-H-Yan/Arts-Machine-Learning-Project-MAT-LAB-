function gaussian = makeGaussian(sigma, filtersize)

    nx = filtersize(1);
    ny = filtersize(2);

    sigma_x = sigma(1);
    sigma_y = sigma(2);

    gaussian = zeros(nx,ny);
    for i=1:nx
        for j=1:ny
            gaussian(i,j)=exp(-(((i-(nx+1)/2)^2)/(2*sigma_x^2)+((j-(ny+1)/2)^2)/(2*sigma_y^2)));
        end
    end

    

end