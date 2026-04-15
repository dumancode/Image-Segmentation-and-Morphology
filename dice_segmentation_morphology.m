function dice_segmentation_morphology(inputImagePath)
   % Load the image
    inputImage = imread(inputImagePath);
    
    % Convert from rgb to grayscale
    grayImage = double(rgb2gray(inputImage)) / 255;
    

    % Run the segmentation pipeline and keep intermediate masks for inspection.
    [diceImage1, diceImage2, binaryMask, imcloseOperation] = segmentation(grayImage);
   
    
    % Detect dice pips and return both counts and intermediate dot masks.
    [number_of_dot1,number_of_dot2,notOperation,dotMask1,dotMask2] = findNumbers(diceImage1,diceImage2,grayImage);

    %  steps of the segmentation algorithm
    figure(1);
    subplot(3, 3, 1), imshow(inputImage), title('Original Image');
    subplot(3, 3, 2), imshow(grayImage), title('Grayscale Image');
    subplot(3, 3, 3), imshow(binaryMask), title('Binary Mask');
    subplot(3, 3, 4), imshow(imcloseOperation), title('Morphological closing');
    subplot(3, 3, 5), imshow(notOperation), title('Inverted grayscale image');
    subplot(3, 3, 6), imshow(dotMask1), title('Dice 1');
    subplot(3, 3, 7), imshow(dotMask2), title('Dice 2');
   
    figure(2);
    subplot(1, 2, 1), imshow(diceImage1), title(['Segmented Dice 1 with ', num2str(number_of_dot1), ' dots']);
    subplot(1, 2, 2), imshow(diceImage2), title(['Segmented Dice 2 with ', num2str(number_of_dot2), ' dots']);

end

function [diceImage1, diceImage2, binaryMask, morphologicalImage] = segmentation(grayImage)

 

    % Use graythresh to find an optimal threshold for BINARIZATION
    % This step simplifies the image, making it easier to isolate the dice.
    diceLevel = graythresh(grayImage);
    % Convert the grayscale image to binary using the threshold
    binaryMask = imbinarize(grayImage, diceLevel); %  binary mask

    % Apply morphological closing to fill in gaps and smooth the shapes.
    % This is particularly useful for enhancing the appearance of the dice
    % dots and make them more distinct
    x = strel('disk', 2);
    morphologicalImage = imclose(binaryMask, x); 

    % Label connected components in the binary image for identifying individual dice.
    [labeledDice, numDice] = bwlabel(morphologicalImage);
   

   % Extract the first dice image
    % Create a mask for the first object (dice) and apply it to the gray image
    diceMask1 = (labeledDice == 1);
    diceImage1 = grayImage .* diceMask1;

    % Extract the second dice image
    % Create a mask for the second object (dice) and apply it to the gray image
    diceMask2 = (labeledDice == 2);
    diceImage2 = grayImage .* diceMask2;
end

function [number_of_dot1,number_of_dot2,invertedDieImage,dotMask1,dotMask2] = findNumbers(dieImage1,dieImage2, grayImage)
   % Invert the image for dot detection
    invertedDieImage = imcomplement(grayImage); % I want to make the dark dots on the dice appear bright against a dark background

    % Use graythresh to find an optimal threshold for the dots
    dotLevel = graythresh(invertedDieImage(dieImage1 > 0));
    % Estimate the dot threshold only inside the current die region.

    % Binarize the inverted image with the computed threshold
    dotMask = imbinarize(invertedDieImage, dotLevel);
    
    % Clean up the binary mask to isolate dots on the first die
    dotMask1 = imopen(dotMask & (dieImage1 > 0), strel('disk', 1));
    
    % Label and count the dots
    [labeledDots, numDots1] = bwlabel(dotMask1 & (dieImage1 > 0));
  
    number_of_dot1 = numDots1 ;

    % Label the isolated dots on the first die and count them and
    % Store the count of dots for the first die
    dotLevel = graythresh(invertedDieImage(dieImage2 > 0));
    dotMask = imbinarize(invertedDieImage, dotLevel);

    % Repeated processes for second die. 
    dotMask2 = imopen(dotMask & (dieImage2 > 0), strel('disk', 1));
       
    % Label and count the dots
    [labeledDots, numDots2] = bwlabel(dotMask2 & (dieImage2 > 0));
    number_of_dot2 = numDots2;
end

