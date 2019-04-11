clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);
 
load data\foldedECFP6SimFusions.mat qsm qsx qst* st*;
load data\prctileECFP6GroupFusions.mat dpt v*;

% similarity fusions: intra-library comparisons
mc = [0.2 0.2 0.2; 0.85 0.75 0.25]; % colors
ms = ['s','s','s','s','o','o','o','o']; % shapes
mz = [256,64,256,64,256,64,256,64]; % sizes
st = [st111';st112';st121';st122';st211';st212';st221';st222'];
figure('Units','centimeters','Position',[1 1 32 16]);
for x1=1:8
    subplot(2,4,x1);
    scatter((qstm(st(x1,:),x1)),(qstx(st(x1,:),x1)),6,mc(1,:),'x','MarkerEdgeAlpha',0.5);
    xlim([1/3 2/3]); ylim([1/3 1]);
    hold on;
    for x2=1:8
        if (x2==x1)
            continue;
        else
            if (x2==1||x2==2||x2==5||x2==6)
                scatter(median(qstm(st(x1,:),x2)),median(qstx(st(x1,:),x2)),mz(x2),mc(2,:),ms(x2),'LineWidth',2);
            else
                scatter(median(qstm(st(x1,:),x2)),median(qstx(st(x1,:),x2)),mz(x2),mc(2,:),ms(x2),'filled');
            end
        end
    end
    hold off;
end
 
% similarity fusions: cross-library comparisons
mc = [0 0 0;1 0 1; 0 1 1; 1 0 0; 0 0 1; 0 1 0]; % colors
ms = ['s','s','s','s','o','o','o','o']; % shapes
mz = [256,64,256,64,256,64,256,64]; % sizes
figure('Units','centimeters','Position',[1 1 20 20]);
scatter(mean(qsm),mean(qsx),256,mc(1,:),'filled');
xlim([0.2 0.6]); ylim([0.6 1]); hold on;
me = errorbar(mean(qsm),mean(qsx),3*std(qsx),3*std(qsx),3*std(qsm),3*std(qsm));
me.Color = 'black';
me.CapSize = 18;
me.LineWidth = 2;
scatter(mean(qsm),mean(qsx),256,mc(1,:),'filled');
for x1=1:8
    for x2=1:5
        if (x1==1||x1==2||x1==5||x1==6)
            scatter(dpt(x1,51,x2),dpt(x1,101,x2),mz(x1),mc(x2+1,:),ms(x1),'LineWidth',2);
        else
            scatter(dpt(x1,51,x2),dpt(x1,101,x2),mz(x1),mc(x2+1,:),ms(x1),'filled');
        end
    end
end

toc;

