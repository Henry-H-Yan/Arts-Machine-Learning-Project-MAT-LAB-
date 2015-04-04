function [y,dc] = remove_dc(x,columns)


if (nargin==2 && strcmpi(columns,'columns')), columns = 1;
else columns = 0;
end

if (columns)
  dc = mean(x);
  y = addtocols(x,-dc);
else
  if (ndims(x)==2)  % temporary, will remove in future
    warning('Treating 2D matrix X as a single signal and not each column individually');
  end
  dc = mean(x(:));
  y = x-dc;
end