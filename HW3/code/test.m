%I = imread('../data/part1/hill/1.JPG');
%tform = maketform('affine',[1 0 0; .5 1 0; 0 0 1]);
%J = imtransform(I,tform); imshow(I), figure, imshow(J)
canvas1 = uint8(zeros(10));
canvas2 = canvas1;
image1=uint8(magic(3));
canvas1(2:4,2:4)=image1;
image2=uint8(magic(3));
canvas2(3:5,3:5)=image2;
canvas = canvas1 + canvas2;
overlap = canvas1 & canvas2;
canvas(overlap) = canvas(overlap)/2;