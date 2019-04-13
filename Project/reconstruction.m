function [mergedCloud] = reconstruction(PV, frames, numFrames, img)
    % Stitching: with affine Structure from Motion
    % Stitch every 3 images together to create a point cloud.
    Clouds = {};
    i = 1;
    n = size(PV, 1);

    for iBegin = 1:n-(numFrames - 1)
        iEnd = mod(iBegin + numFrames - 1, n);

        % Select frames from the PV matrix to form a block
        if iEnd > iBegin
            block = PV(iBegin:iEnd, :);
        else
            block = PV([iBegin:end,1:iEnd], :);
        end

        % Select columns from the block that do not have any zeros
        colInds = find(all(block ~= 0));

        % Check the number of visible points in all views
        numPoints = size(colInds, 2);
        fprintf('Found %d points for block %d\n', numPoints, iBegin);
        if numPoints < 8
            continue
        end


        % Create measurement matrix X with coordinates instead of indices using the block and the
        % Coordinates C
        block = block(:, colInds);
        X = zeros(2 * numFrames, numPoints);
        for f = 1:numFrames
            for p = 1:numPoints
                X(2 * f - 1, p) = frames{iBegin+f-1}(1,block(f,p));
                X(2 * f, p)     = frames{iBegin+f-1}(2,block(f,p));
            end
        end

        % Estimate 3D coordinates of each block following Lab 4 "Structure from Motion" to compute the M and S matrix.
        % Here, an additional output "p" is added to deal with the non-positive matrix error
        % Please check the chol function inside sfm.m for detail.
        [M, S, p] = sfm(X); % Your structure from motion implementation for the measurements X

        % Save the M matrix and Meanvalues for the first frame. In this example,the
        % first frame is the camera plane (view) where every point will be projected
        % Please do check if M is non-zero before selection. Otherwise, you
        % have to select another view
        if i==1 && ~p
            M1=M(1:2,:);
            MeanFrame1=sum(X,2)/numPoints;
        end

        if ~p
            % Compose Clouds in the form of (M,S,colInds)
            Clouds(i, :) = {M, S, colInds};
            i = i + 1;
        end
    end

    % By an iterative manner, stitch each 3D point set to the main view using the point correspondences i.e., finding optimal
    % transformation between shared points in your 3D point clouds.

    % Initialize the merged (aligned) cloud with the main view, in the first point set.
    mergedCloud                 = zeros(3, size(PV,2));
    mergedCloud(:, Clouds{1,3}) = Clouds{1, 2};
    mergedInds                  = Clouds{1,3};

    % Stitch each 3D point set to the main view using procrustes
    numClouds = size(Clouds,1);
    for i = 2:numClouds

        % Get the points that are in the merged cloud and the new cloud by using "intersect" over indexes
        [sharedInds, ~, iClouds] = intersect(mergedInds, Clouds{i,3});
        sharedPoints             = Clouds{i,2}(:, iClouds);

        % A certain number of shared points to do procrustes analysis.
        if size(sharedPoints, 2) < 15
            continue
        end

        % Find optimal transformation between shared points using procrustes. The inputs must be of the size [Nx3].
        [d, Z, T] = procrustes(mergedCloud(:,sharedInds)', sharedPoints');

        % Find the points that are not shared between the merged cloud and the Clouds{i,:} using "setdiff" over indexes
        [iNew, iCloudsNew] = setdiff(Clouds{1,3}, mergedInds);

        % T.c is a repeated 3D offset, so resample it to have the correct size
        c = T.c(ones(size(iCloudsNew,1),1),:);

        % Transform the new points using: Z = (T.b * Y' * T.T + c)'.
    % Note: We transposed the inputs to "procrustes" so we also have to transpose the input/output to the transformation.
        % And then we store them in the merged cloud, and add their indexes to mergedInds set.
        mergedCloud(:, iNew) = (T.b * (Clouds{i,2}(:, iCloudsNew))' * T.T + c)';
        mergedInds           = [mergedInds, iNew];
    end

    % Plot the full merged cloud
    % Helpful for debugging and visualizing your reconstruction
    % X = mergedCloud(1,:)';
    % Y = mergedCloud(2,:)';
    % Z = mergedCloud(3,:)';
    % scatter3(X, Y, Z, 20, [1 0 0], 'filled');
    % axis( [-500 500 -500 500 -500 500] )
    % daspect([1 1 1])
    % rotate3d


    % You are free to use other techniques like (Bundle Adjustment) to further
    % improve your reconstruction.


    % 3D Model Plotting (surfaceRender):
    % When you have the 3D point cloud of the moodel, use the built-in surf
    % function for the 3D surface plot. Then include RGB (texture) colour of
    % the related points on surf visualization (interpolate colour values for
    % the filled areas on the surface using the known points).
    % Students are supposed to implement this in a clever way (by using built-in
    % Matlab functions).
    surfaceRender(mergedCloud, M1, MeanFrame1, img);

end
