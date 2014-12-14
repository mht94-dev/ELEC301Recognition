function MomentofInertiaMethod(Image,Template)
tic;
disp('Running...'); % Message sent to command window.
workspace % Show panel with all the variables.

Image = imread(Image);
bImage = im2bw(Image,0.01);
bImage=~bImage;
bImage= imfill(bImage, 'holes');
Template = imread(Template);
bTemplate = im2bw(Template,0.8);%turn image to BW
bTemplate= imfill(bTemplate, 'holes');%fill any potential background holes


ImageCentroid=regionprops(bImage,'Centroid');
TemplateCentroid=regionprops(bTemplate,'Centroid');
NumberofObjects=size(ImageCentroid,1);
boundaries = bwboundaries(bImage);

mimage=masking(bImage,NumberofObjects);%get masked images

nItemplate=MomentofInertia(bTemplate);

NumberofSquare=0;

figure
% subplot(2,1,1);
imagesc(Image);axis square;
hold on

for i=1:NumberofObjects
    nIImage{i}=MomentofInertia(mimage{i});
    if ((nIImage{i}-nItemplate)/nItemplate)<0.001
        NumberofSquare=NumberofSquare+1;
        plot(boundaries{i}(:,2),boundaries{i}(:,1), 'g', 'LineWidth', 3);
        name=sprintf('%d',NumberofSquare);
        text(ImageCentroid(i).Centroid(1),ImageCentroid(i).Centroid(2),name);
    end
end
name=sprintf('Number of Squares= %d', NumberofSquare);
% name=sprintf('Moment of Inertia= %d',nIImage{1});
title(name);
hold off

% Tboundaries = bwboundaries(bTemplate);	
% subplot(2,1,2); imshow(Template);
% 
% hold on
% plot(Tboundaries{1}(:,2),Tboundaries{1}(:,1), 'g', 'LineWidth', 3);
% hold off


toc;
return
function nMomentOfInertia=MomentofInertia(binaryimage)
  workspace
    length1=size(binaryimage,1);
    width1=size(binaryimage,2);
    MomentOfInertia=0;%MOI
    
    imCentroid=regionprops(binaryimage,'Centroid');
    
    for i=1:length1
        for j=1:width1
            if (binaryimage(i,j)==1)
                MomentOfInertia=((j-imCentroid.Centroid(1))^2+(i-imCentroid.Centroid(2))^2)+MomentOfInertia;
            end
        end
    end
    MomentOfInertia
    NumberOfPixels=sum(sum(binaryimage));
    nMomentOfInertia=MomentOfInertia/(NumberOfPixels^2);
    %normalized I with total number of pixels 
    
return
function  maskedimage=masking(binaryimage,NumberofObjects)
workspace
boundaries = bwboundaries(binaryimage);	%boundary indices
length=size(binaryimage,1);%size
width=size(binaryimage,2);
figure
for k=1:NumberofObjects
    maskedimage{k}=binaryimage;
    for i=1:length
        for j=1:width
            in = inpolygon(i,j,boundaries{k}(:,1),boundaries{k}(:,2));
            %detects if a point of interest is within the boundary
            %then mask all points within boundary to be 1 and everywhere
            %else to be 0.
                if (in)
                    maskedimage{k}(i,j)=1;
                else
                    maskedimage{k}(i,j)=0;
                end 
        end
    end
    subplot(5,5,k); imshow(maskedimage{k});
end

return