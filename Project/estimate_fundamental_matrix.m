% Function [bestF bestinliers] = estimateFundamentalMatrix(match1, match2)
% Estimate the fundamental matrix (F)
%
% Input:
%           - match1: matched points from the first images
%           - match2: matched points from the second images
%           - ransac_iterations: minimum number of ransac iterations
% Output:
%           - bestF: estimated F
%           - bestinliers: inliers found

function [bestF bestinliers] = estimate_fundamental_matrix(match1, match2, ransac_iterations, threshold)

    % Set in homogenous coordinates
    match1 = [match1;ones(1,size(match1,2))];
    match2 = [match2;ones(1,size(match2,2))];

    % Initialize parameters
    bestcount = 0;
    bestinliers = [];

    % Minimum of iterations
    iterations = ransac_iterations;
    miniter = ransac_iterations / 2;

    % How many points are needed for the Fundamental matrix?
    p = 8;

    % Start iterations
    i=0;
    while i<iterations

        % Randomly select P points from two sets of matched points.
        % Keep only the first two dimensions: x, y.
        perm = randperm(size(match1, 2), p);

        % Normalization
        [X1,T1] = normalize(match1(1:2, perm));
        [X2,T2] = normalize(match2(1:2, perm));

        % Compose matrix A, given matched points (X1,X2) from two images
        A = composeA(X1, X2);

        % Compute F given A, T1 and T2
        F = computeF(A,T1,T2);

        % Find inliers by computing perpendicular errors between the points
        % and the epipolar lines in each image
        inliers = computeInliers(F,match1,match2,threshold);

        % Check if the number of inliers is larger than 8
        % If yes, use those inliners to re-estimate (re-fine) F.
        if size(inliers,2)>=8
            % Normalize previously found inliers
            [X1,T1] = normalize(match1(1:2, inliers));
            [X2,T2] = normalize(match2(1:2, inliers));

            % Use inliers to re-estimate F
            A = composeA(X1, X2);
            F = computeF(A,T1,T2);

            % Find the final set of inliers
            inliers = computeInliers(F,match1,match2,threshold);

            % Note: The number of inliers is assumed to be written as [1 x #good_matches].
            % if number of inlier > the best so-far, use new F
            if size(inliers,2)>bestcount
                bestcount   = length(inliers);
                bestF       = F;
                bestinliers = inliers;
            end

            % Calculate how many iterations we need by computing:
            % i=log(eps)/log(1-q^p),
            % where p=8 (the number of matches)
            % q= #inliers/#total_pairs (the proportion of inliers over total pairs)
            eps = 0.001;
            q   = bestcount / size(match1, 2);
            N   = log(eps)/log(1-q^p);
            % To prevent special cases, always run at least a couple of times
            iterations = max(miniter, ceil(N));

        end
        i = i+1;

    end

    disp(strcat(int2str(iterations), ' iterations used to estimate F'));
    pause(0.001);
    disp(strcat(int2str(size(bestinliers,2)), ' inliers found'));
end





