clear all
close all

Template = imread('Template.jpg');

Image = imread('Image.jpg');


gTemplate = rgb2gray(Template);
gImage = rgb2gray(Image);

gTemplate = double(gTemplate);
gImage = double(gImage);

imshow(gTemplate)
imshow(gImage)

% thresholdValue = 200;
% bImage = gImage > thresholdValue; 
% bTemplate = gTemplate > thresholdValue;

