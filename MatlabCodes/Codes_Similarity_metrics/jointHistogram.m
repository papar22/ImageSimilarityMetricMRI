%% Function to calculate the joint histogram of two images
% written by Thomas Küstner

% Input Parameters:     - pic_a: The first image (like the reference image)
%                       - pic_b: The second image (like the sensed image)
%                       - grayscale: the range of pixel intensities
%                       - ver: (here = 1)

% Output Parameter:     - n_ab: The joint histogram of two images

function n_ab = jointHistogram(pic_a, pic_b,grayscale,ver)
% calculate a joint histogram

if(ver == 1)
    xi = linspace(min(pic_a(:)),max(pic_a(:)),grayscale);
    yi = linspace(min(pic_b(:)),max(pic_b(:)),grayscale);

    xr = interp1(xi,1:numel(xi),pic_a(:),'nearest');
    yr = interp1(yi,1:numel(yi),pic_b(:),'nearest');

    n_ab = accumarray([xr yr], 1, [grayscale grayscale]);

else
    x=0:grayscale-1; 
    n_ab=zeros(grayscale); 
    for id=0:grayscale-1 
        n_ab(id+1,:) = histc(pic_b(pic_a==id),x,1); 
    end
end