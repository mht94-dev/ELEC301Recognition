function nMomentOfInertia=TemplateMomentofInertia(Template)
    workspace;
    Template = imread(Template);
    subplot(2,1,1);imshow(Template);
    
    bTemplate = im2bw(Template,0.8);%turn image to BW
    bTemplate= imfill(bTemplate, 'holes');%fill any potential background holes
    
    TemplateProp=regionprops(bTemplate,'Centroid');
    TemplateCentroid=TemplateProp(1).Centroid;
    boundaries = bwboundaries(bTemplate);	
    
    subplot(2,1,2); imshow(Template);
  
    hold on
	plot(boundaries{1}(:,2),boundaries{1}(:,1), 'g', 'LineWidth', 3);
    hold off
    
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