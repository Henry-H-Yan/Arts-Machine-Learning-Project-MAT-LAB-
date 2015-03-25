function filterset = createElongatedFilters(filter_params)

filtersize = filter_params.filtersize;
filterlength = filter_params.filterlength;
sigma = filter_params.sigma; 
nsteps = filter_params.nsteps; 

filterset = zeros(filtersize(1),filtersize(2),length(nsteps)-2);

c = 0;  

for i=1:2:length(nsteps)-2
    
    c = c + 1;
    angle = [nsteps(i) 1-nsteps(i)];
    filter = constructFilter(filtersize, filterlength, angle, sigma);
    filterset(:,:,i) = filter;
    filterset(:,:,i+1) = imrotate(filter,90,'crop');
    
end

end
