imagenames = dir('../data/*.jpg');

for i = 1: length(imagenames)
   image_name = imagenames(i).name;    
   image_path = strcat(['../data/'],image_name);
   img = imread(image_path);
   blob_detection(img, 2, 1.3, .007, 10);   
end

%[image, r, c] = blob_detection(im, sigma, scale_factor, threshold, n)


