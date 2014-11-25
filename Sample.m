Template = imread('Template.jpg');   % Reads the images
Image = imread('Image.jpg');

% imshow(Image)         % Displays the images
% figure
% imshow(Template)

dimT = size(Template);
dimI = size(Image);

c = 0;
for i=1:dimI(1)-dimT(1) 
    for j=1:dimI(2)-dimT(2)
        dotproduct = Template.*Image(i:dimT(1)+i-1,j:dimT(2)+j-1,:);
    end
    
end

plot(dotproduct)