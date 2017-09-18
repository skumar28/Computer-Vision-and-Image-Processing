% Sandeep Kumar, 50258881, skumar28@buffalo.edu%
% Problem 1: Image Alignment

%% 1. Load images (all 3 channels)
red = load('../data/red.mat');  % Red channel
green = load('../data/green.mat');  % Green channel
blue = load('../data/blue.mat');  % Blue channel

%% 2. Find best alignment
% Hint: Lookup the 'circshift' function
rgbResult = alignChannels(red, green, blue);

%% 3. Save result to rgb_output.jpg (IN THE "results" folder)
imshow(rgbResult);
%set(gcf, 'Color', [1 1 1]);
%set(gcf, 'PaperPositionMode', 'auto');
outname = fullfile('../results', 'rgb_output.jpg');
saveas(gcf, outname);