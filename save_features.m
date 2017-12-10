X = zeros(2000, 1536);
for i=1:2000
    s = strcat(int2str(i),'.jpg');
    X(i,:)=get_feature(s);
end
save('features', 'X');