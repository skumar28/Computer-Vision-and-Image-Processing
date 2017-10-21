function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../data/traintest.mat');

	% TODO Implement your code here
    % crating a zeros matrix for confusion matrix
    C = zeros(8);
    interval= 1;
    % itererating over all the test images and guessing the image and
    % saving the result in confusion matrix accordingly 
	test_imagenames = test_imagenames(1:interval:end);
    temp = [];
    for i = 1: length(test_imagenames)
       name = test_imagenames{i};
       imagename = strcat(['../data/'],name);
       guessedImage = guessImage( imagename );
       for j = 1:8
          if(strcmp(mapping{j}, guessedImage))
              index = j;
              break;
          end
       end
       C(test_labels(i),index) = C(test_labels(i), index) + 1;
    end
    conf = C;
    %success percent of the Recognition system
    successPercent = trace(conf)*100/sum(conf(:));
    fprintf('[percent of correctly classied images]:%f\n',successPercent);
end