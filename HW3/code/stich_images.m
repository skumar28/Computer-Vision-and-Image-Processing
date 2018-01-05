function [ output_image ] = stich_images( Img1, Img2, homography )
%STICH_IMAGES 
T = maketform('projective',homography');
%apply imtransform for and get the x and y direction offset
[B,xdata,ydata]=imtransform(Img1,T, 'nearest');
 xdataout=[min(1,xdata(1)) max(size(Img2,2),xdata(2))];
 ydataout=[min(1,ydata(1)) max(size(Img2,1),ydata(2))];
    
 B=imtransform(Img1,T,'nearest','XData',xdataout,'YData',ydataout);
 C=imtransform(Img2,maketform('affine',eye(3)),'nearest','XData',xdataout,'YData',ydataout);

 [finalRow, finalHieght, dim] = size(B);
  finalImage = B;

 %take the first and second image and avg for overlapping areas.
for i = 1:finalRow*finalHieght*dim
            if(finalImage(i) == 0)
                finalImage(i) = C(i);
            elseif(finalImage(i) ~= 0 && C(i) ~= 0)
                finalImage(i) = B(i)/2 + C(i)/2;
            end
end

output_image = finalImage;
end

