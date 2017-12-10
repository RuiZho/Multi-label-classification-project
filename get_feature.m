function features = get_feature(filename)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    RGB = imread(filename);
    m = size(RGB,1);
    n = size(RGB,2);
    XYZ = rgb2xyz(RGB,'WhitePoint','d50');

    x = XYZ(:,:,1);
    y = XYZ(:,:,2);
    z = XYZ(:,:,3);

    x = reshape(x,[],1);
    y = reshape(y,[],1);
    z = reshape(z,[],1);

    xyz = [x y z];

    white=[96.720 100.00 81.427];
    luv = zeros(size(xyz,1),size(xyz,2));
    % compute u' v' for sample
    up = 4*xyz(:,1)./(xyz(:,1) + 15*xyz(:,2) + 3*xyz(:,3) + 1e-12);
    vp = 9*xyz(:,2)./(xyz(:,1) + 15*xyz(:,2) + 3*xyz(:,3) + 1e-12);
    % compute u' v' for white
    upw = 4*white(1)/(white(1) + 15*white(2) + 3*white(3));
    vpw = 9*white(2)/(white(1) + 15*white(2) + 3*white(3));

    index = (xyz(:,2)/white(2) > 0.008856);
    luv(:,1) = luv(:,1) + index.*(116*(xyz(:,2)/white(2)).^(1/3) - 16);  
    luv(:,1) = luv(:,1) + (1-index).*(903.3*(xyz(:,2)/white(2)));  

    luv(:,2) = 13*luv(:,1).*(up - upw);
    luv(:,3) = 13*luv(:,1).*(vp - vpw);

    L = reshape(luv(:,1),m,n);
    U = reshape(luv(:,2),m,n);
    V = reshape(luv(:,3),m,n);

    first = zeros(1,17);
    second = zeros(1,17);

    for i = 1:16
        first(1,i+1) = idivide(m*i, int32(16), 'round');
        second(1,i+1) = idivide(n*i, int32(16), 'round');
    end

    features = zeros(256*2*3, 1);
    for i = 1:16
        for j = 1:16
            l = L(first(1,i)+1:first(1,i+1), second(1,j)+1:second(1,j+1));
            u = U(first(1,i)+1:first(1,i+1), second(1,j)+1:second(1,j+1));
            v = V(first(1,i)+1:first(1,i+1), second(1,j)+1:second(1,j+1));
            l = reshape(l,[],1);
            u = reshape(u,[],1);
            v = reshape(v,[],1);
            mean_l = mean(l);
            mean_u = mean(u);
            mean_v = mean(v);
            var_l = (l - mean_l)'*(l - mean_l)/size(l,1);
            var_u = (u - mean_u)'*(u - mean_u)/size(u,1);
            var_v = (v - mean_v)'*(v - mean_v)/size(v,1);
        
            index = ((i-1)*16+j-1)*6;
            features(index+1:index+6, 1) = [mean_l mean_u mean_v var_l var_u var_v]';
        end
    end
end

