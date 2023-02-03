function im2d = impad(im2d,num)
[m,n] = size(im2d);
delta = 1:num;
i = m-delta;
j = n-delta;
k = 1+flip(delta);
im2d = [...
    im2d(k,k) im2d(k,:) im2d(k,j);
    im2d(:,k) im2d      im2d(:,j);
    im2d(i,k) im2d(i,:) im2d(i,j)
    ];
