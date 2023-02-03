function im2d = spnfilter(im2d,num,cfa)
if nargin < 3
    cfa = [];
end
if ismatrix(im2d)
    im3d = make3d(im2d,num,cfa);
    im2d = make2d(im3d);
else
    for k = 1:size(im2d,3)
        im3d = make3d(im2d(:,:,k),num,cfa);
        im2d(:,:,k) = make2d(im3d);
    end
end

function im3d = make3d(im2d,num,cfa)
[m,n] = size(im2d);
im3d = zeros(m,n,num,class(im2d));
if isempty(cfa)
    init = [1 1];
    step = 1;
else
    init = [1 1; 1 2; 2 1; 2 2];
    step = 2;
end
im2d = impad(im2d,step);
for pos = 1:size(init,1)
    i = init(pos,1):step:m;
    j = init(pos,2):step:n;
    delta = pattern(num,cfa,pos);
    for k = 1:num
        ii = i+delta(k,1);
        jj = j+delta(k,2);
        im3d(i,j,k) = im2d(ii,jj);
    end
end

function delta = pattern(num,cfa,pos)
if isempty(cfa)
    mode = '0'+num;
else
    mode = [cfa(pos) '0'+num];
end
switch mode
    case '5'
        delta = [0 1; 1 0; 1 1; 1 2; 2 1];
    case {'r5','b5'}
        delta = [0 2; 2 0; 2 2; 2 4; 4 2];
    case 'g5'
        delta = [1 1; 1 3; 2 2; 3 1; 3 3];
    case '7'
        delta = [0 1; 1 0; 1 1; 1 1; 1 1; 1 2; 2 1];
    case {'r7','b7'}
        delta = [0 2; 2 0; 2 2; 2 2; 2 2; 2 4; 4 2];
    case 'g7'
        delta = [1 1; 1 3; 2 2; 2 2; 2 2; 3 1; 3 3];
end

function im2d = make2d(im3d)
p = size(im3d,3);
im3d = sort(im3d,3);
k = (p+1)/2;
im2d = im3d(:,:,k);
