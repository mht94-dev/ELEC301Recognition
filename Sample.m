tic; % Start timer.
clc; 
clear all; 
disp('Running...'); % Message sent to command window.
workspace; % Show panel with all the variables.

Triangle = imread('Triangle.jpg');
Square = imread('Square.jpg');
Circle = imread('Circle.jpg');
TestImage = imread('TestImage.jpg');

Triangle = double(rgb2gray(Triangle));
Square = double(rgb2gray(Square));
Circle = double(rgb2gray(Circle));
TestImage = double(rgb2gray(TestImage));% why is it red after passing through rgb2gray?


thresholdValue = 200;
bTestImage = TestImage > thresholdValue; 
bTriangle = Triangle > thresholdValue; 
bCircle = Circle > thresholdValue; 
bSquare = Square > thresholdValue; 

%find the centroids of templates for reference
%TriangleCentroid=regionprops(bTriangle,'Centroid');
TriangleArea=regionprops(bTriangle,'Area');
%CircleCentroid=regionprops(bCircle,'Centroid');
CircleArea=regionprops(bCircle,'Area');
%SquareCentroid=regionprops(bSquare,'Centroid');
SquareArea=regionprops(bSquare,'Area');



subplot(3,3,1);
imagesc(TestImage);


subplot(3,3,2);imagesc(conv2(TestImage,rot90(Triangle,2)));
title('Triangle');
subplot(3,3,3);imagesc(conv2(TestImage,rot90(Circle,2)));
title('Circle');
subplot(3,3,4);imagesc(conv2(TestImage,rot90(Square,2)));
title('Square');

subplot(3,3,5); imagesc(bTestImage); title('Binary Image');

labeledImage = bwlabel(bTestImage, 8);     % Label each blob so we can make measurements of it

ImageProperties = regionprops(bTestImage, TestImage, 'all');   
numberOfObjects = size(ImageProperties, 1);%find number of objects


subplot(3, 3, 7); imagesc(TestImage);
title('Outlines, from bwboundaries()');
hold on;
boundaries = bwboundaries(bTestImage);	
numberOfBoundaries = size(boundaries);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;


fontSize = 14;	% Used to control size of "blob number" labels put atop the image.
labelShiftX = -20;	% Used to align the labels in the centers of the coins.
blobECD = zeros(1, numberOfObjects);
% Print header line in the command window.
fprintf(1,'Blob #      Mean Intensity  Area   Perimeter    Centroid       Diameter\n');
% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfObjects           % Loop through all blobs.
	% Find the mean of each blob.  (R2008a has a better way where you can pass the original image
	% directly into regionprops.  The way below works for all versions including earlier versions.)
    thisBlobsPixels = ImageProperties(k).PixelIdxList;  % Get list of pixels in current blob.
    meanGL = mean(TestImage(thisBlobsPixels)); % Find mean intensity (in original image!)
	meanGL2008a = ImageProperties(k).MeanIntensity; % Mean again, but only for version >= R2008a
	
	blobArea = ImageProperties(k).Area;		% Get area.
	blobPerimeter = ImageProperties(k).Perimeter;		% Get perimeter.
	blobCentroid = ImageProperties(k).Centroid;		% Get centroid.
	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
    fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
	% Put the "blob number" labels on the "boundaries" grayscale image.
	text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', fontSize, 'FontWeight', 'Bold');
end


% Put the labels on the rgb labeled image also.
subplot(3, 3, 7);
for k = 1 : numberOfObjects           % Loop through all blobs.
	blobCentroid = ImageProperties(k).Centroid;		% Get centroid.
	text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', fontSize, 'FontWeight', 'Bold');
end

%%%%%%%%%%%%%%%%%%%%find the number of objects in testimage usnig area%%
numberofSquare=0;
subplot(3, 3, 8); imagesc(TestImage);
hold on;
boundaries = bwboundaries(bTestImage);	
for k = 1 : numberOfObjects
    blobArea = ImageProperties(k).Area;
	thisBoundary = boundaries{k};
    if blobArea(1,1)==SquareArea(1).Area
        plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
        numberofSquare=numberofSquare+1;
    end
end
title(sprintf('Number of Square=%d',numberofSquare));
hold off;

%how to find centroid of object relative to its boundaries