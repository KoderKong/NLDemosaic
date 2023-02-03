clear
rng default
cfa = 'bggr';
no = input('Image number (1-24)? ');
file = sprintf('kodim%02d.png',no);
imref = imread(strcat('..\data\',file));
imraw = mosaic(imref,cfa);
imdemN = demosaic(imraw,cfa); % LD (0% SPN)
assert(isequal(imdemN,ldemosaic(imraw,cfa,@floor)))
imraw = imnoise(imraw,'salt & pepper',0.01);
imdemY = demosaic(imraw,cfa); % LD (1% SPN)
assert(isequal(imdemY,ldemosaic(imraw,cfa,@floor)))
imdem5 = spnfldmsck(imraw,5,cfa); % SPNF1+LD
imdem7 = spnfldmsck(imraw,7,cfa); % SPNF2+LD
imdem1 = nldemosaic1(imraw,cfa); % NLD1
imdem2 = nldemosaic2(imraw,cfa,'int16'); % NLD2
imdemH = nldhybrid(imraw,cfa,'int16'); % Hybrid
rmsY = getrms(imref,imdemY);
rms5 = getrms(imref,imdem5);
rms7 = getrms(imref,imdem7);
rms1 = getrms(imref,imdem1);
rms2 = getrms(imref,imdem2);
rmsH = getrms(imref,imdemH);
rms = [rmsY rms5 rms7 rms1 rms2 rmsH];
disp(['  LD (SPN)  SPNF1+LD  SPNF2+LD' ...
    '      NLD1      NLD2    Hybrid'])
disp(20*log10(255./rms))
[i,j] = selectroi(imdem7,imdem2);
imdem = {imdemY,imdem7,imdem2,imdemN}; % (b,c,d,e)
file = sprintf('fig9_kodak_%02d',no);
makepdf(file,imref,no,imdem,i,j)

function rms = getrms(im1,im2)
rms = zeros(3,1);
[m,n,~] = size(im1);
i = 3:m-2;
j = 3:n-2;
for k = 1:3
    err = double(im1(i,j,k))-double(im2(i,j,k));
    err = err(:);
    rms(k) = sqrt((err'*err)/numel(err));
end
end

function im3d = spnfldmsck(im2d,num,cfa)
im2d = spnfilter(im2d,num,cfa);
im3d = demosaic(im2d,cfa);
end

function [i,j] = selectroi(im1,im2)
imerr = abs(double(im2)-double(im1));
imerr = imerr/max(imerr(:));
imshow(imerr)
title('Click on one point!')
[j0,i0] = ginput(1);
close
zoom = input('Zoom (e.g., 4)? ');
[M,N,~] = size(imerr);
i = zoompan(zoom,i0,M);
j = zoompan(zoom,j0,N);
end

function k = zoompan(zoom,k0,kend)
k = k0+round([-0.5 0.5]*kend/zoom);
if min(k) < 1
    k = k-min(k)+1;
elseif max(k) > kend
    k = k-max(k)+kend;
end
end

function makepdf(file,imref,no,imdem,i,j)
cols = numel(imdem);
subplot(1,1+cols,1)
imshow(imref)
box = [j(1) i(1) diff(j)+1 diff(i)+1];
rectangle('Position',box)
xlabel('(a)')
ylabel(sprintf('No %d',no))
i = i(1):i(2);
j = j(1):j(2);
for k = 1:cols
    subplot(1,1+cols,1+k)
    imshow(imdem{k}(i,j,:))
    xlabel(sprintf('(%c)','a'+k))
end
width = (1+cols)*2;
set(gcf,'PaperPosition',[0 0 width 2])
set(gcf,'PaperSize',[width 2])
print('-dpdf',file)
close
end
