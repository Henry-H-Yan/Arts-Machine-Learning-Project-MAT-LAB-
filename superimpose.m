
%% Superimpose two crack logical maps
%% Suitable when one has large cracks and the other has finer details
function ret= superimpose(im1, im2);


[Row,Col] = size(im1);
ret=zeros(Row,Col);


for r= 1:Row
  for c= 1:Col
    ret(r,c)= im1(r,c) || im2(r,c);
  
   
  end
  
end

