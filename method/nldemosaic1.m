function im3d = nldemosaic1(im2d,cfa)
im4d = make4d(im2d,cfa);
im3d = make3d(im4d,class(im2d));

function im4d = make4d(im2d,cfa)
[m,n] = size(im2d);
im4d = nan(m,n,3,8);
im2d = impad(im2d,2);
row = [1 1 2 2];
col = [1 2 1 2];
for pos = 1:4
    i = row(pos):2:m;
    j = col(pos):2:n;
    delta = pattern(cfa,pos);
    for k = 1:3
        d = delta{k};
        for l = 1:size(d,1)
            ii = i+d(l,1);
            jj = j+d(l,2);
            im4d(i,j,k,l) = im2d(ii,jj);
        end
    end
end

function delta = pattern(cfa,pos)
switch cfa(pos)
    case {'r','b'}
        delta = {
            [0 2; 2 0; 2 2; 2 2; 2 2; 2 4; 4 2]; % R/B at R/B
            [1 2; 2 1; 2 3; 3 2]; % G at R/B
            [1 1; 1 3; 3 1; 3 3]; % B/R at R/B
            };
        flipRB = cfa(pos) == 'b';
    case 'g'
        delta = {
            [0 1; 0 3; 2 1; 2 1; 2 3; 2 3; 4 1; 4 3]; % R/B at G
            [1 1; 1 3; 2 2; 2 2; 2 2; 3 1; 3 3]; % G at G
            [1 0; 1 2; 1 2; 1 4; 3 0; 3 2; 3 2; 3 4]; % B/R at G
            };
        pos = pos+2*mod(pos,2)-1;
        flipRB = cfa(pos) == 'b';
end
if flipRB
    delta = flip(delta); % {B,G,R} to {R,G,B}
end

function im3d = make3d(im4d,type)
[m,n,~,~] = size(im4d);
im3d = zeros(m,n,3,type);
im4d = sort(im4d,4);
row = [1 1 2 2];
col = [1 2 1 2];
for pos = 1:4
    i = row(pos):2:m;
    j = col(pos):2:n;
    for k = 1:3
        sample = im4d(i(1),j(1),k,:);
        notnan = sum(~isnan(sample));
        if mod(notnan,2) ~= 0
            l = (notnan+1)/2;
            im3d(i,j,k) = im4d(i,j,k,l);
        else
            l = notnan/2;
            im3d(i,j,k) = (im4d(i,j,k,l)+im4d(i,j,k,l+1))/2;
        end
    end
end
