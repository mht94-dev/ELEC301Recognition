clear 
clc

Template = imread('Template.jpg');   % Reads the images
Image = imread('Image.jpg');

% imshow(Image)         % Displays the images
% figure
% imshow(Template)
Image = rgb2gray(Image);
Template = rgb2gray(Template);
Image = double(Image);
Template = double(Template);
figure; imagesc(conv2(Image,fliplr(flipud(Template))))
figure; imagesc(conv2(Image,fliplr(flipud(Template))))