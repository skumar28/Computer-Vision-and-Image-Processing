function [ inlier_matches , F, res] = ransac_inliers( matches )
%RANSAC_INLIERS

thresh = .25;
maxInl = 0;
totalResidual = 0;
for i = 1: 300
    randp = randsample(size(matches,1),8);    
    randMatches = matches(randp,:);
    
    f_norm = fundamental_normalized_cord(randMatches);
    inlier_match = [];
    inl_res = 0;
    inl = 0;
    for j = 1:size(matches,1)
        residual = residuals_for_givenF(matches(j,:), f_norm);
        residual = abs(residual);
        if residual < thresh
           inlier_match= [inlier_match; matches(j,:)];
           inl_res = inl_res + residual;
           inl = inl +1;
        end
    end    
    if maxInl < inl
        inlier_matches = inlier_match;
        F = f_norm;
        totalResidual = inl_res;
        maxInl = inl;
    end   
    
end
res = totalResidual;
end

