% Sandeep Kumar, 50258881, skumar28@buffalo.edu%
function rgbResult = alignChannels(red, green, blue)
% alignChannels - Given 3 images corresponding to different channels of a
%       color image, compute the best aligned result with minimum
%       aberrations
% Args:
%   red, green, blue - each is a matrix with H rows x W columns
%       corresponding to an H x W image
% Returns:
%   rgb_output - H x W x 3 color image output, aligned as desired

%% Write code here
red = red.red;
green = green.green;
blue = blue.blue;

% Take one image as reference image say red in this case and caculate SSD 
% Green and Blue with respect to red image and concatanate the RGB cahnnels
% to fine the compelete image.

ssdMinGreen = 0;
ssdMinBlue = 0;

for i = -30:30
    tempGreen = circshift (green, i);
    tempBlue = circshift(blue, i);
    G = red - tempGreen;
    B = red - tempBlue;
    ssdG = sum(G(:).^2);
    ssdB = sum(B(:).^2);
    if(ssdMinGreen == 0 && ssdMinBlue == 0)
        ssdMinGreen = ssdG;
        ssdMinBlue = ssdB;
    end
    
    if(ssdMinGreen > ssdG)
        ssdMinGreen = ssdG;
        counterG = i;
    end
    if(ssdMinBlue > ssdB)
        ssdMinBlue = ssdB;
        counterB = i;
    end
end
newGreen = circshift(green, counterG);
newBlue = circshift(blue, counterB);

rgbResult = cat (3, red, newGreen, newBlue);

end
