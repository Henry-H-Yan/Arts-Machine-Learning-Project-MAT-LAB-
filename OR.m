
% Takes in two logical crack map and performs OR
% Then write the file

a=imread('good64.tif');
b=imread('mask.tif');
c=a|b;
name='good2'
imwrite(c,name);