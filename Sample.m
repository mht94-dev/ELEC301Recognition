clear 
clc

%Template = imread('Template.jpg');   % Reads the images
%Image = imread('Image.jpg');

Triangle = imread('Triangle.jpg');
Square = imread('Square.jpg');
Circle = imread('Circle.jpg');
TestImage = imread('TestImage.jpg');

Triangle = double(rgb2gray(Triangle));
Square = double(rgb2gray(Square));
Circle = double(rgb2gray(Circle));
TestImage = double(rgb2gray(TestImage));
figure;imagesc(conv2(TestImage,fliplr(flipud(Triangle))));
title('Triangle');
figure;imagesc(conv2(TestImage,fliplr(flipud(Circle))));
title('Circle');
figure;imagesc(conv2(TestImage,fliplr(flipud(Square))));
title('Square');
% imshow(Image)         % Displays the images
% figure
% imshow(Template)

% Image = rgb2gray(Image);
% Template = rgb2gray(Template);
% Image = double(Image);
% Template = double(Template);
% figure; imagesc(conv2(Image,fliplr(flipud(Template))))
%figure; imagesc(conv2(Image,fliplr(flipud(Template))))