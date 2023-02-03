function im3d = ldemosaic(im2d,cfa,fun)
if nargin < 3
    fun = @round;
end
[m,n] = size(im2d);
im3d = cat(3,im2d,im2d,im2d);
im2d = impad(im2d,2);
row = [1 1 2 2];
col = [1 2 1 2];
for pos = 1:4
    i = row(pos):2:m;
    j = col(pos):2:n;
    masks = pattern(cfa,pos);
    for k = 1:3
        mask = masks{k};
        assert(sum(mask(:)) == 1)
        if ~isscalar(mask)
            page = conv2(im2d,mask,'valid');
            im3d(i,j,k) = fun(page(i,j));
        end
    end
end

function mask = pattern(cfa,pos)
switch cfa(pos)
    case {'r','b'}
        mask = {
            1; % R/B at R/B
            [
            +0  0 -1  0  0
            +0  0  2  0  0
            -1  2  4  2 -1
            +0  0  2  0  0
            +0  0 -1  0  0
            ]/8; % G at R/B
            [
            +0  0 -3  0  0
            +0  4  0  4  0
            -3  0 12  0 -3
            +0  4  0  4  0
            +0  0 -3  0  0
            ]/16; % B/R at R/B
            };
        flipRB = cfa(pos) == 'b';
    case 'g'
        mask = {
            [
            +0  0  1  0  0
            +0 -2  0 -2  0
            -2  8 10  8 -2
            +0 -2  0 -2  0
            +0  0  1  0  0
            ]/16; % R/B at G
            1; % G at G
            [
            +0  0 -2  0  0
            +0 -2  8 -2  0
            +1  0 10  0  1
            +0 -2  8 -2  0
            +0  0 -2  0  0
            ]/16; % B/R at G
            };
        pos = pos+2*mod(pos,2)-1;
        flipRB = cfa(pos) == 'b';
end
if flipRB
    mask = flip(mask); % {B,G,R} to {R,G,B}
end
