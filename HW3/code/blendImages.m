function [finalImage] = blendImages(Im,B,col,row)
   row = abs(round(row(1)));
   col = abs(round(col(1)));
   fRow = size(Im,1)+ row;
   fCol = size(Im,2)+ col;
   
   newWarpedImage1= zeros(fRow,fCol);
   newWarpedImage2= zeros(fRow,fCol);
   
   %put unwarped image in 
   newWarpedImage1(1:size(B,1),1:size(B,2)) = B;     
   newWarpedImage2(row+1:fRow, col+1: fCol)= Im;
  
  newWarpedImage = newWarpedImage1 + newWarpedImage2;
  overlap = newWarpedImage1 & newWarpedImage2;
  newWarpedImage(overlap) = newWarpedImage(overlap)/2;
   
  finalImage = newWarpedImage;
   
end