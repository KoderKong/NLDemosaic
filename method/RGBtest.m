clc
clear
cfa = 'bggr';
for k = 50:-1:0
    density = k/1000;
    mse{k+1,1} = density;
    mse{k+1,2} = mse3D(cfa,density);
end
save RGBtest cfa mse

function mse = mse3D(cfa,density)
dotdot(num2str(density),24)
for k = 24:-1:1
    dotdot(true)
    file = sprintf('..\\data\\kodim%02d.png',k);
    imref = imread(file);
    imraw = mosaic(imref,cfa);
    rng default
    imraw = imnoise(imraw,'salt & pepper',density);
    mse(:,:,k) = mse2D(imraw,cfa,imref);
end
dotdot(false)
end

function mse = mse2D(imraw,cfa,imref)
mse = zeros(6,3);
imdem = demosaic(imraw,cfa);
mse(1,:) = mse1D(imref,imdem); % LD
imdem = spnfldmsck(imraw,5,cfa);
mse(2,:) = mse1D(imref,imdem); % SPNF1+LD
imdem = spnfldmsck(imraw,7,cfa);
mse(3,:) = mse1D(imref,imdem); % SPNF2+LD
imdem = nldemosaic1(imraw,cfa);
mse(4,:) = mse1D(imref,imdem); % NLD1
imdem = nldemosaic2(imraw,cfa,'int16');
mse(5,:) = mse1D(imref,imdem); % NLD2
imdem = nldhybrid(imraw,cfa,'int16');
mse(6,:) = mse1D(imref,imdem); % Hybrid
end

function im3d = spnfldmsck(im2d,num,cfa)
im2d = spnfilter(im2d,num,cfa);
im3d = demosaic(im2d,cfa);
end

function mse = mse1D(im1,im2)
mse = zeros(3,1);
[m,n,~] = size(im1);
i = 3:m-2;
j = 3:n-2;
for k = 1:3
    err = double(im1(i,j,k))-double(im2(i,j,k));
    err = err(:);
    mse(k) = (err'*err)/numel(err);
end
end
