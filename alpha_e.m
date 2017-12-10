function accuracy = alpha_e(ytest, ypredict, alpha, beta, gamma)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    n = size(ytest, 1);
    union = sum((ypredict + ytest >= 0), 2);

    Mx = sum((ypredict - ytest == -2), 2);
    Fx = sum((ypredict - ytest == 2), 2);

    score = (ones(n, 1) - ((beta*Mx+gamma*Fx)./union));
    if alpha == 0
        score = (score > 0)*1;
    else
        score = score.^alpha;
    end
    accuracy = mean(score);
end

