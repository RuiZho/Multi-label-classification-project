function [recall, precision, accuracy] = calculate_base(ytest, ypredict)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    h = sum((ytest + ypredict == 2), 1);
    y = sum((ytest == 1), 1);
    p = sum((ypredict == 1), 1);
    recall = mean(h ./ y);
    precision = mean(h ./ p);
    accuracy = sum(h, 2) / max(sum(y, 2), sum(p, 2));
end

