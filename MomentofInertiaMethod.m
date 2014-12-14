function MomentofInertiaMethod(Image,Template)
tic;
disp('Running...'); % Message sent to command window.
workspace % Show panel with all the variables.

Image = imread(Image);
bImage = im2bw(Image,0.8);
bImage= imfill(bImage, 'holes');
Template = imread(Template);
bTemplate = im2bw(Template,0.8);%turn image to BW
bTemplate= imfill(bTemplate, 'holes');%fill any potential background holes

subplot(3,3,1);
imagesc(Image);

ImageProp=regionprops(bImage,'Centroid');
ImageCentroid=ImageProp(1).Centroid;
NumberofObjects=size(ImageProp);
boundaries = bwboundaries(bImage);	


nItemplate=MomentofInertia(Template);
nIImage=MomentofInertia(Image);

boundaries = bwboundaries(bTemplate);	
subplot(3,3,2); imshow(Template);

hold on
plot(boundaries{1}(:,2),boundaries{1}(:,1), 'g', 'LineWidth', 3);
hold off


toc;
return
function nMomentOfInertia=MomentofInertia(Template)

bTemplate = im2bw(Template,0.8);%turn image to BW
bTemplate= imfill(bTemplate, 'holes');%fill any potential background holes


TemplateProp=regionprops(bTemplate,'Centroid');
TemplateCentroid=TemplateProp(1).Centroid;

    
    length=size(bTemplate,1);
    width=size(bTemplate,2);
    MomentOfInertia=0;%I
    
    for i=1:length
        for j=1:width
            if bTemplate(i,j)
                MomentOfInertia=((i-TemplateCentroid(1))^2+(j-TemplateCentroid(2))^2)+MomentOfInertia;
            end
        end
    end
   
    NumberOfPixels=sum(sum(bTemplate));
    nMomentOfInertia=MomentOfInertia/(NumberOfPixels^2);%normalized I
                
return