I = imread('res/ColoredStarsBlackBGDigital.png');
I = rgb2gray(I);
C = corner(I);

%Display the corners when the maximum number of desired corners is the default setting of 200.

subplot(1,2,1);
imshow(I);
hold on
plot(C(:,1), C(:,2), '.', 'Color', 'g')
title('Maximum Corners = 200')
hold off

%Display the corners when the maximum number of desired corners is 3.

corners_max_specified = corner(I,40);
subplot(1,2,2);
imshow(I);
hold on
plot(corners_max_specified(:,1), corners_max_specified(:,2), ...
   '.', 'Color', 'g')
title('Maximum Corners = 20')
hold off 
