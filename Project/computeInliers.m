% function inliers = computeInliers(F,match1,match2,threshold)
% Find inliers by computing perpendicular errors between the points and the epipolar lines in each image
% To be brief, we compute the Sampson distance mentioned in the lab file.
% Input:
%   -matrix F, matched points from image1 and image 2, and a threshold (e.g. threshold=50)
% Output:
%   -inliers: indices of inliers
function inliers = computeInliers(F,match1,match2,threshold)

    % Calculate Sampson distance for each point
    % Compute numerator and denominator at first
    numer = zeros(1,length(match1));
    denom = zeros(size(numer));
    for i = 1 : size(match1, 2)
    	numer(i) = (match2(:, i)' * F * match1(:, i)).^2;
    	Fx = F * match1(:, i);
    	FTx = F' * match2(:, i);
    	denom(i) = Fx(1).^2 + Fx(2).^2 + FTx(1).^2 + FTx(2).^2;
    end
    sd    = numer./denom;

    % Return inliers for which sd is smaller than threshold
    inliers = find(sd<threshold);

end
