function [forward_matches, backward_matches] = sift_match(descs, MATCH_THRESH)
	forward_matches = {};
	backward_matches = {};
	for i = 1:length(descs)
		j = i + 1;
		if j > length(descs)
			j = 1;
		end
		matches = vl_ubcmatch(descs{i}, descs{j}, MATCH_THRESH);
		% Take indices
		forward_matches{i} = matches(1,:);
		backward_matches{j} = matches(2,:);
		fprintf('Found %d matches for image %d of %d\n', length(forward_matches{i}), i, length(descs));
	end
end
