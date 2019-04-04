function [best_forward_matches, best_backward_matches] = ransac(frames, descs, forward_matches, backward_matches, min_iter, threshold)
	best_forward_matches = {};
	best_backward_matches = {};
	for i = 1:length(forward_matches)
		j = i + 1;
		if j > length(forward_matches)
			j = 1;
		end
		match1 = frames{i}(1:2, forward_matches{i});
		match2 = frames{j}(1:2, backward_matches{j});
		[~, best_inliers] = estimate_fundamental_matrix(match1, match2, min_iter, threshold);
		best_forward_matches{i} = forward_matches{i}(best_inliers);
		best_backward_matches{j} = backward_matches{j}(best_inliers);
	end
end
