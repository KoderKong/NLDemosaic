function im3d = nldemosaic2(im2d,cfa,mode)
if nargin < 3
    mode = 'double';
end
type = class(im2d);
im2d = cast(im2d,mode);
im3d = nldemosaic1(im2d,cfa);
pageG = im3d(:,:,2);
im3d = nldemosaic1(im2d-pageG,cfa);
pageR = cast(im3d(:,:,1)+pageG,type);
pageB = cast(im3d(:,:,3)+pageG,type);
pageG = cast(pageG,type);
im3d = cat(3,pageR,pageG,pageB);
