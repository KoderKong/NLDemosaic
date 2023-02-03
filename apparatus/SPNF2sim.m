clc
clear
rng default
addpath ..\method -end
Ts = 1e-6; % Sampling period (s)
imraw = imread('..\data\kodim18.png');
[xin,cin,imref] = simin(imraw,'bggr',2,Ts);
imwrite(imref,'SPNF2output.png')
[rows,cols,~] = size(imraw);
sim SPNF2 % Call Simulink
L = 2*cols+8; % Model latency
imout = yout.Data(L+1:L+cols*rows,:);
imout = reshape(imout,cols,rows);
imout = permute(imout,[2 1]);
i = 3:rows-2;
j = 3:cols-2;
assert(isequal(imref(i,j),imout(i,j)))
beep

function [xin,cin,im] = simin(im,cfa,reps,Ts)
[rows,cols,~] = size(im);
im = mosaic(im,cfa);
im = imnoise(im,'salt & pepper',0.01);
imwrite(im,'SPNF2input.png')
im = im'; % Row-vs-column major
x = repmat(im(:),reps,1);
c = isRG(cfa,rows,cols);
c = repmat(c,reps,1);
t = (0:numel(x)-1)'*Ts;
xin = timeseries(x,t);
cin = timeseries(c,t);
if nargout > 2
    im = spnfilter(im',7,cfa);
end
end

function c = isRG(cfa,rows,cols)
cfa = upper(cfa);
M = ceil(rows/2);
N = ceil(cols/2);
cfa = reshape(cfa,2,2)';
isRr = any(cfa == 'R',2);
isGc = cfa == 'G';
isRr = repmat(isRr,M,cols);
isGc = repmat(isGc,M,N);
isRr = isRr(1:rows,:)';
isGc = isGc(1:rows,1:cols)';
c = [isRr(:) isGc(:)];
end
