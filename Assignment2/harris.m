function [r, c, sigmas] = harris(im, loc)
    % inputs: 
    % im: double grayscale image
    % loc: list of interest points from the Laplacian approximation
    % outputs:
    % [r,c,sigmas]: The row and column of each point is returned in r and c
    %              and the sigmas 'scale' at which they were found
    
    % This function finds Harris corners at integration-scale sigma.
    gamma = 0.7; % The derivative-scale is gamma times the integration scale

    % Calculate Gaussian Derivatives at derivative-scale
    % Hint: use your previously implemented function in assignment 1 
    Ix =  ...
    Iy =  ...

    % Allocate an 3-channel image to hold the 3 parameters for each pixel
    M = zeros(size(Ix,1), size(Ix,2), 3);

    % Calculate M for each pixel
    M(:,:,1) = ...
    M(:,:,2) = ...
    M(:,:,3) = ...

    % Smooth M with a gaussian at the integration scale sigma.
    % Keep only points from the list 'loc' that are coreners. 
    for l = 1:size(loc,1)
        sigma = loc(l,3); % The sigma at which we found this point	
        M = imfilter(M, fspecial('gaussian', ceil(sigma*6+1), sigma), 'replicate', 'same');

        % Compute the cornerness R
        trace = ...
        det = ...
        R = ...

        % Set the threshold 
        threshold = ...

        % Find local maxima
        % Dilation will alter every pixel except local maxima in a 3x3 square area.
        % Also checks if R is above threshold

        R = ((R>threshold) & ((imdilate(R, strel('square', 3))==R))) ; 

        % Display corners
        figure
        imshow(R,[]);
    end
        
    % Return the coordinates and sigmas
    [r, c, sigmas] = ...
end
