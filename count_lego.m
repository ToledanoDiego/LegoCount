function [numA,numB]=count_lego(I)
%function [numA,numB]=count_lego(I)
%
% This function count the number of 2x4 blue Lego and 2x2 red Lego 
%
% Parameter:
% I the image containing some Lego
%

[centers, radii, metric] = imfindcircles(I,[15 30]);
centersStrong = centers(1:1,:); 
radiiStrong = radii(1:1);
metricStrong = metric(1:1);
viscircles(centersStrong, radiiStrong,'EdgeColor','b');
legoSize =  ((radiiStrong) * 2 * 3.16)^2;

Ig = rgb2gray(I);
Ir = I(:,:,1);
Ib = I(:,:,3);

red = imsubtract(Ir,Ig);
blue = imsubtract(Ib,Ig);

for i = 1:height(red)
    for j = 1:width(red)
        if red(i,j)> 30
            red(i,j) = 255;
        else
            red(i,j) = 0;
        end
    end
end

for i = 1:height(blue)
    for j = 1:width(blue)
        if blue(i,j)> 30
            blue(i,j) = 255;
        else
            blue(i,j) = 0;
        end
    end
end

filledRed = regionprops(red,'FilledImage');
se = strel('line',11,90);
filledRed = imerode(filledRed(255).FilledImage,se);

legoSize = legoSize - mod(legoSize,1);
legoSizeMax = legoSize * 1.5;
legoSizeMax = legoSizeMax - mod(legoSizeMax,1);

FinalRed = xor(bwareaopen(filledRed,legoSize),  bwareaopen(filledRed,legoSizeMax));

areaRed = regionprops(FinalRed,'Area');

filledBlue = regionprops(blue,'FilledImage');
se = strel('line',11,90);
filledBlue = imerode(filledBlue(255).FilledImage,se);

FinalBlue = xor(bwareaopen(filledBlue,legoSize*2),  bwareaopen(filledBlue,legoSizeMax*20));

areaBlue = regionprops(FinalBlue,'Area');

numA = height(areaBlue);
numB = height(areaRed);


