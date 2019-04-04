function [frames, descs] = sift_feat(imgs, PEAK_THRESH)
	frames = {};
	descs = {};
	for i = 1:length(imgs)
		img = imgs{i};
		[frames{i}, descs{i}] = vl_sift(img, 'PeakThresh', PEAK_THRESH);
		fprintf('Found %d descriptors for image %d of %d\n', length(descs{i}), i, length(imgs));
	end
end
