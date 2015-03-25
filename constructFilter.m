function filter = constructFilter(filtersize, filterlength, angle, sigma) 

    nx = filtersize(1);
    ny = filtersize(2);

    n = angle;

    sigma_x = sigma(1);
    sigma_y = sigma(2);

    G = zeros(nx,ny);
    for i=1:nx
        for j=1:ny
            G(i,j)=exp(-(((i-(nx+1)/2)^2)/(2*sigma_x^2)+((j-(ny+1)/2)^2)/(2*sigma_y^2)));
        end
    end

    % figure, imagesc(G);

    k = round(sigma_x/2);
    Gs1 = circshift(G,[0 k]);
    Gs2 = circshift(G,[0 -k]);
    Gx1 = 1/sigma_x*(Gs1-Gs2);

    % figure, imagesc(Gx1);

    Gs1 = circshift(G,[k 0]);
    Gs2 = circshift(G,[-k 0]);
    Gx2 = 1/sigma_x*(Gs1-Gs2);

    % figure, imagesc(Gx2);
    % figure, surf(Gx1);
    % figure, surf(Gx2);

    % n = [0.6 0.4];
%     n = [0.9 0.1];
    Gn = n(1)*Gx1 + n(2)*Gx2;
    % figure, imagesc(Gn);

    % create B kernels
    w = sigma_x;
    k = ceil(w*n);

    Gs1 = circshift(Gn,[k(2) k(1)]);
    Gs2 = circshift(Gn,[-k(2) -k(1)]);
    % Bn = Gs2-Gs1;
    Bn = Gs1-Gs2;
    % figure, imagesc(Bn);

    N = 1;
    l = 2*sigma_x;
    
    l = 10*sigma;
    if (n(1) == 0)
        t = [1 0];
    else
        if (n(2) == 0)
            t = [0 1];
        else
            t(1) = n(2)/sqrt(n(1)^2+n(2)^2);
            t(2) = -n(1)*t(1)/n(2);
        end        
    end
    % t(1) = 1/(sqrt(1+n(1)^2/n(2)^2));



    Bntilde = zeros(size(Bn));
%     for i=-filterlength*N:1:filterlength*N
%         Bntilde = Bntilde + circshift(Bn,[round(l*i/N*t(2)) round(l*i/N*t(1))]);
%     %     figure, surf(Bntilde);
%     end
%     
    for i=-l*N:1:l*N
    Bntilde = Bntilde + circshift(Bn,[round(i/N*t(2)) round(i/N*t(1))]);
%         figure, surf(Bntilde);
    end
    
%     for i=-N:1:N
%         Bntilde = Bntilde + circshift(Bn,[round(l*i/N*t(2)) round(l*i/N*t(1))]);
%     %     figure, surf(Bntilde);
%     end
    % figure, surf(Bntilde);
    filter = Bntilde;
    
end