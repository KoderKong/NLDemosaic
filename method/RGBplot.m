clc
clear
close all
load RGBtest
density = vertcat(mse{:,1});
i = round(density,3) == 0.01;
[psnr,dpsnr] = getpsnr(mse);
psnrfig('fig6_abs_psnr',density,psnr,'o^v<>s')
dpsnr = dpsnr(:,1:end-1,:); % Suppress Hybrid
dpsnrfig('fig7_delta_psnr_g',density,dpsnr(:,:,2),'o^v<>','Green')
dpsnrfig('fig8a_delta_psnr_r',density,dpsnr(:,:,1),'o^v<>','Red')
dpsnrfig('fig8b_delta_psnr_b',density,dpsnr(:,:,3),'o^v<>','Blue')

function [psnr,dpsnr] = getpsnr(mse)
rows = size(mse,1);
cols = size(mse{1,2},1);
psnr = zeros(rows,cols);
dpsnr = zeros(rows,cols,3);
for i = 1:rows
    data = permute(mse{i,2},[3 1 2]);
    rmms = sqrt(median(mean(data,3),1));
    psnr(i,:) = 20*log10(255./rmms);
    temp = 20*log10(255./sqrt(data));
    temp = temp-temp(:,1,:);
    dpsnr(i,:,:) = median(temp,1);
end
end

function psnrfig(file,density,psnr,style)
p = plot(100*density,psnr,'.-',[1 1],[15 40],'k--');
for k = 1:numel(style)
    p(k).Marker = style(k);
    p(k).MarkerSize = p(k).MarkerSize/2;
end
legend('LD (demosaic)','SPNF1+LD','SPNF2+LD',...
    'NLD1','NLD2','Hybrid','Location','NE')
xlabel('SPN density (%)')
ylabel('Median PSNR (dB)')
set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'PaperSize',[6 4])
print('-dpdf',file)
close
end

function dpsnrfig(file,density,dpsnr,style,label)
p = plot(100*density,dpsnr,'.-',[1 1],[-10 15],'k--');
for k = 1:numel(style)
    p(k).Marker = style(k);
    p(k).MarkerSize = p(k).MarkerSize/2;
end
lims = [xlim ylim];
label = sprintf(' %s',label);
text(lims(1),lims(4),label,'VerticalAlignment','top')
legend('LD (demosaic)','SPNF1+LD','SPNF2+LD',...
    'NLD1','NLD2','Location','SE')
xlabel('SPN density (%)')
ylabel('Delta PSNR (dB)')
set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'PaperSize',[6 4])
print('-dpdf',file)
close
end
