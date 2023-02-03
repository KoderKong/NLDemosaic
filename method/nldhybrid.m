function im3d = nldhybrid(im2d,cfa,mode)
if nargin < 3
    mode = 'double';
end
saveG = spnf2ld(im2d,cfa);
type = class(im2d);
im2d = cast(im2d,mode);
im3d = nldemosaic1(im2d,cfa);
pageG = im3d(:,:,2);
im3d = nldemosaic1(im2d-pageG,cfa);
pageR = cast(im3d(:,:,1)+pageG,type);
pageB = cast(im3d(:,:,3)+pageG,type);
im3d = cat(3,pageR,saveG,pageB);

function im2d = spnf2ld(im2d,cfa)
im2d = spnfilter(im2d,7,cfa);
im3d = demosaic(im2d,cfa);
im2d = im3d(:,:,2); % pageG
