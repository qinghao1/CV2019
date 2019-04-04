% IN4393-16 Project
% Chu Qinghao 4988612

clc; clear;

% Make sure vl_feat is setup
run('../vlfeat-0.9.21/toolbox/vl_setup')

% Constants
PEAK_THRESH = 8; % SIFT peak threshold, default 0.
MATCH_THRESH = 1.5; % SIFT matching threshold, default 1.5
RANSAC_ITERATIONS = 100;
SAMPSON_THRESHOLD = 25; % Default 50

% Load images
% imgs = load_images('model_castle');
% save('imgs', 'imgs')
load('imgs')

% 1) Use vl_feat to find interest points and correspondences
% [frames, descs] = sift_feat(imgs, PEAK_THRESH);
% save('sift_feat', 'frames', 'descs')
load('sift_feat')
[forward_matches, backward_matches] = sift_match(descs, MATCH_THRESH);
save('sift_match', 'forward_matches', 'backward_matches')
load('sift_match')

% Plotting
% figure; imshow([imgs{i}, imgs{j}], []);
% hold on;
% scatter(frames{i}(1,:), frames{i}(2,:), frames{i}(3,:), [1,1,0]);
% scatter(size(imgs{i},2)+frames{j}(1,:), frames{j}(2,:), frames{j}(3,:), [1,1,0]);
% match1 = frames{i}(:,matches(1,:));
% match2 = frames{j}(:,matches(2,:));
% line([match1(1,:);size(imgs{i},2)+match2(1,:)],[match1(2,:);match2(2,:)]);

% 2) Apply normalized 8-point RANSAC to find best matches
[best_forward_matches, best_backward_matches] = ransac(frames, descs, forward_matches, backward_matches, RANSAC_ITERATIONS, SAMPSON_THRESHOLD);
save('ransac', 'best_forward_matches', 'best_backward_matches')
load('ransac')

% 3) Create point-view matrix for point correspondences
% PV = chainimages(best_forward_matches);
