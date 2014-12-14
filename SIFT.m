%SIFT algorithm implementation - keypoint detection
%author Ethan Yuqiang Heng

%%%%%%%%
%load the image
filename = 'Image.jpg';
Image = imread(filename);
imshow(Image);
[x,y,dim] = size(Image);
if dim==3
        Image=rgb2gray(Image);
end
Image = im2double(Image);
Original = Image;

%Generate Octaves (sigma doubling in each octave)
%1st Octave
Octave1 = [];
ki=0;
Image(x:x+6,y:y+6)=0; %zero-pad
for kj=0:3
    kk=sqrt(2);
    sigma=(kk^(kj+(2*ki)))*1.6;
    %generating the gaussians
    for m=-3:3
        for n=-3:3
            gaussian1(m+4,n+4)= (1/((2*pi)*((kk*sigma)*(kk*sigma))))*exp(-((m*m)+(n*n))/(2*(kk*kk)*(sigma*sigma)));
        end
    end
    %convolve image with the gaussian filters generated above
    for i=1:x
        for j=1:y
            singlesum=Image(i:i+6,j:j+6)'.*gaussian1;
            conv1(i,j)=sum(sum(singlesum));
        end
    end
    
    Octave1=[Octave1 conv1];
end
%2nd Octave
Octave2 = [];
Image=imresize(Original,1/((ki+1)*2));
ki=1;
Image(x:x+6,y:y+6)=0; %zero-pad
for kj=0:3
    kk=sqrt(2);
    sigma=(kk^(kj+(2*ki)))*1.6;
    %generating the gaussians
    for m=-3:3
        for n=-3:3
            gaussian2(m+4,n+4)= (1/((2*pi)*((kk*sigma)*(kk*sigma))))*exp(-((m*m)+(n*n))/(2*(kk*kk)*(sigma*sigma)));
        end
    end
    %convolve image with the gaussian filters generated above
    for i=1:x
        for j=1:y
            singlesum=Image(i:i+6,j:j+6)'.*gaussian2;
            conv2(i,j)=sum(sum(singlesum));
        end
    end
    
    Octave2=[Octave2 conv2];
end
%3rd Octave
Octave3 = [];
Image=imresize(Original,1/((ki+1)*2));
ki=2;
Image(x:x+6,y:y+6)=0; %zero-pad
for kj=0:3
    kk=sqrt(2);
    sigma=(kk^(kj+(2*ki)))*1.6;
    %generating the gaussians
    for m=-3:3
        for n=-3:3
            gaussian3(m+4,n+4)= (1/((2*pi)*((kk*sigma)*(kk*sigma))))*exp(-((m*m)+(n*n))/(2*(kk*kk)*(sigma*sigma)));
        end
    end
    %convolve image with the gaussian filters generated above
    for i=1:x
        for j=1:y
            singlesum=Image(i:i+6,j:j+6)'.*gaussian3;
            conv3(i,j)=sum(sum(singlesum));
        end
    end
    
    Octave3=[Octave3 conv3];
end

%%Difference of Gaussian
% differnce of gaussian for octave1 
diff_11=Octave1(1:512,1:512)-Octave1(1:512,513:1024);      
diff_12=Octave1(1:512,513:1024)-Octave1(1:512,1025:1536);
diff_13=Octave1(1:512,1025:1536)-Octave1(1:512,1537:2048); 
 % difference of gaussian for octave2
diff_21=Octave2(1:256,1:256)-Octave2(1:256,257:512);       
diff_22=Octave2(1:256,257:512)-Octave2(1:256,513:768);
diff_23=Octave2(1:256,513:768)-Octave2(1:256,769:1024);
% difference of gaussian for octave3
diff_31=Octave3(1:128,1:128)-Octave3(1:128,129:256);        
diff_32=Octave3(1:128,129:256)-Octave3(1:128,257:384);
diff_33=Octave3(1:128,257:384)-Octave3(1:128,385:512);

key=[];                            

x1=0;                              
y1=0;
z1=0;
f=0;

for i=2:511
    for j=2:511


        
if (((diff_12(i,j)>diff_12(i-1,j))&&(diff_12(i,j)>diff_12(i+1,j))....
        &&(diff_12(i,j)>diff_12(i,j-1))&&(diff_12(i,j)>diff_12(i+1,j+1))....
        &&(diff_12(i,j)>diff_12(i-1,j-1))&&(diff_12(i,j)>diff_12(i-1,j+1))....
        &&(diff_12(i,j)>diff_12(i+1,j-1))&&(diff_12(i,j)>diff_12(i,j+1))))
    x1=x1+1;
else
    continue;
end

if x1>0
    if((diff_12(i,j)>diff_13(i,j))&&(diff_12(i,j)>diff_13(i-1,j))....
            &&(diff_12(i,j)>diff_13(i+1,j))&&(diff_12(i,j)>diff_13(i,j-1))....
            &&(diff_12(i,j)>diff_13(i+1,j+1))&&(diff_12(i,j)>diff_13(i-1,j-1))....
            &&(diff_12(i,j)>diff_13(i-1,j+1))&&(diff_12(i,j)>diff_13(i+1,j-1))&&(diff_12(i,j)>diff_13(i,j+1)))
        y1=y1+1;
    else
        continue;
        
    end 
end

  % store key point location if it is maximum in its neighbourhood on same scale and also on scale above and below
  key(i,j)=diff_12(i,j);                    
  f=1;
  

end
end
    
  
 
   if f==0
    x=0;
y=0;
z=0;

for i=2:511
    for j=2:511
        
if (((diff_12(i,j)<diff_12(i-1,j))&&(diff_12(i,j)<diff_12(i+1,j))....
        &&(diff_12(i,j)<diff_12(i,j-1))&&(diff_12(i,j)<diff_12(i+1,j+1))....
        &&(diff_12(i,j)<diff_12(i-1,j-1))&&(diff_12(i,j)<diff_12(i-1,j+1))....
        &&(diff_12(i,j)<diff_12(i+1,j-1))&&(diff_12(i,j)<diff_12(i,j+1))))
    x=x+1;
else
   continue;
end

if x>0
    if ((diff_12(i,j)<diff_13(i,j))&&(diff_12(i,j)<diff_13(i-1,j))....
            &&(diff_12(i,j)<diff_13(i+1,j))&&(diff_12(i,j)<diff_13(i,j-1))....
            &&(diff_12(i,j)<diff_13(i+1,j+1))&&(diff_12(i,j)<diff_13(i-1,j-1))....
            &&(diff_12(i,j)<diff_13(i-1,j+1))&&(diff_12(i,j)<diff_13(i+1,j-1))&&(diff_12(i,j)<diff_13(i,j+1)))
        y=y+1;
    else
        continue;
        
    end 
end
  if y>0
      
   if ((diff_12(i,j)<diff_11(i,j))&&(diff_12(i,j)<diff_11(i-1,j))....
           &&(diff_12(i,j)<diff_11(i+1,j))&&(diff_12(i,j)<diff_11(i,j-1))....
           &&(diff_12(i,j)<diff_11(i+1,j+1))&&(diff_12(i,j)<diff_11(i-1,j-1))....
           &&(diff_12(i,j)<diff_11(i-1,j+1))&&(diff_12(i,j)<diff_11(i+1,j-1))&&(diff_12(i,j)<diff_11(i,j+1)))
       z=z+1;
   else 
       continue;
   end
  end
  % store key point location if it is minimum in its neighbourhood on same scale and also on scale above and below
  key(i,j)=diff_12(i,j);               


end
    end
  
   end
  
 key1=key*255;
 figure,imshow(key1);   
 

    