% IN4393-16 Project
% Chu Qinghao 4988612

clc; clear;

% Make sure vl_feat is setup
run('../vlfeat-0.9.21/toolbox/vl_setup')

% Constants
PEAK_THRESH = 5; % SIFT peak threshold, default 0.
MATCH_THRESH = 1.5; % SIFT matching threshold, default 1.5
RANSAC_ITERATIONS = 100;
SAMPSON_THRESHOLD = 25; % Default 50
NUM_FRAMES = 3; % Chained points must be in >= NUM_FRAMES

% Load images
% imgs = load_images('model_castle');
% save('imgs', 'imgs')
load('imgs')

% 1) Use vl_feat to find interest points and correspondences
% [frames, descs] = sift_feat(imgs, PEAK_THRESH);
% save('sift_feat', 'frames', 'descs')
load('sift_feat')
% [forward_matches, backward_matches] = sift_match(descs, MATCH_THRESH);
% save('sift_match', 'forward_matches', 'backward_matches')
load('sift_match')

% Plotting
% for i = 1:length(imgs)
% 	j = i + 1;
% 	if j > length(imgs)
% 		j = 1;
% 	end
% 	figure; imshow([imgs{i}, imgs{j}], []);
% 	hold on;
% 	scatter(frames{i}(1,:), frames{i}(2,:), frames{i}(3,:), [1,1,0]);
% 	scatter(size(imgs{i},2)+frames{j}(1,:), frames{j}(2,:), frames{j}(3,:), [1,1,0]);
% 	match1 = frames{i}(:,matches(1,:));
% 	match2 = frames{j}(:,matches(2,:));
% 	line([match1(1,:);size(imgs{i},2)+match2(1,:)],[match1(2,:);match2(2,:)]);
% end

% 2) Apply normalized 8-point RANSAC to find best matches
% [best_forward_matches, best_backward_matches] = ransac(frames, descs, forward_matches, backward_matches, RANSAC_ITERATIONS, SAMPSON_THRESHOLD);
% save('ransac', 'best_forward_matches', 'best_backward_matches')
load('ransac')

% Plotting
% for i = 1:length(imgs)
% 	j = i + 1;
% 	if j > length(imgs)
% 		j = 1;
% 	end
% 	figure; imshow([imgs{i}, imgs{j}], []);
% 	hold on;
% 	scatter(frames{i}(1,best_forward_matches{i}), frames{i}(2, best_forward_matches{i}), frames{i}(3,best_forward_matches{i}), [1,1,0]);
% 	scatter(size(imgs{i},2)+frames{j}(1,best_backward_matches{j}), frames{j}(2,best_backward_matches{j}), frames{j}(3,best_backward_matches{j}), [1,1,0]);
% 	match1 = frames{i}(:,best_forward_matches{i});
% 	match2 = frames{j}(:,best_backward_matches{j});
% 	line([match1(1,:);size(imgs{i},2)+match2(1,:)],[match1(2,:);match2(2,:)]);
% end

% 3) Create point-view matrix for point correspondences
PV = chainimages(best_forward_matches, best_backward_matches);

% 4) Create measurement matrix from PV matrix
merged_cloud = reconstruction(PV, frames, NUM_FRAMES, imgs);
