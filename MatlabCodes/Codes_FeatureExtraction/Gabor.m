%% Function to calculate the gabor filters

% The function generates different gabor filters with different scales and
% different orientations.
% It creates a (scale x orientation) cell whose elements are Gabor filter.
% Reference paper : "Gabor Features in Image Analysis"


% Input Parameters:     - scale: Number of scales to create the filters
%                       - orientation: Number of scales to create the filters
%                       - I: A 2D image to be convolved
%                       - FlagShow : A flag to show tne Images.
%                       It should set to 1 to show the results.




% Output Parameter:     - GaborResult: A (scale x orientation) cell
%                           so that each element includes a matrix of 40x40
%                           representing the corresponding filter




function GaborResult = Gabor(scale,orientation,I, FlagShow)


% Create scale*orientation gabor filters

GaborFilter = cell(scale,orientation);

for i = 1:scale
    
    f_max = (0.25)/((sqrt(2))^(i-1));
    alpha = f_max/(sqrt(2));
    beta = f_max/sqrt(2);
    
    for j = 1:orientation
        theta = ((j-1)/orientation)*(2*pi);
        filter = zeros(39,39);
        for x = 1:39
            for y = 1:39
                xprime = (x-20)*cos(theta)+(y-20)*sin(theta);
                yprime = -(x-20)*sin(theta)+(y-20)*cos(theta);
                filter(x,y) = ((f_max)^2/(pi*(sqrt(2))*(sqrt(2))))*exp(-((alpha^2)*(xprime^2)+(beta^2)*(yprime^2)))*exp(1i*2*pi*f_max*xprime);
            end
        end
        GaborFilter{i,j} = filter;
    end
end

if FlagShow
    %% Show Gabor filters
    
    % Show magnitudes of Gabor filters:
    figure('Name','Magnitudes of Gabor filters');
    for i = 1:scale
        for j = 1:orientation
            subplot(scale,orientation,(i-1)*orientation+j);
            imshow(abs(GaborFilter{i,j}),[]);
        end
    end
    
    % Show real parts of Gabor filters:
    figure('Name','Real parts of Gabor filters');
    for i = 1:scale
        for j = 1:orientation
            subplot(scale,orientation,(i-1)*orientation+j);
            imshow(real(GaborFilter{i,j}),[]);
        end
    end
end


% Convalve the GaborFilters with Given Image
GaborResult = cell(scale,orientation);
for i = 1:scale
    for j = 1:orientation
        GaborResult{i,j} = conv2(I,GaborFilter{i,j},'same');
    end
end

