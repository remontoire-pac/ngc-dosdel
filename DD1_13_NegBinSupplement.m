clear; clc; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary dataset D6
D6 = readtable('data\supplementaryDataset6.csv','TextType','string');

% input counts of sequencing reads and overall Poisson model
y0 = D6.ap1_baseline;
py = poissfit(y0);

% probabilities from Poisson models for each individual diversity element
for i=1:max(D6.scaffold)
    yy = y0(D6.scaffold==i);
    ls1(i,1) = poissfit(yy);
end
ls1 = ls1(D6.scaffold);
ls1 = poissrnd(ls1);
ls1 = ls1/sum(ls1);

for i=1:max(D6.BB1)
    yy = y0(D6.BB1==i);
    ls2(i,1) = poissfit(yy);
end
ls2 = ls2(D6.BB1);
ls2 = poissrnd(ls2);
ls2 = ls2/sum(ls2);

for i=1:max(D6.BB2)
    yy = y0(D6.BB2==i);
    ls3(i,1) = poissfit(yy);
end
ls3 = ls3(D6.BB2);
ls3 = poissrnd(ls3);
ls3 = ls3/sum(ls3);
clear i yy;

% model of counts from combinations of Poisson models for each individual diversity element
y1 = ls1.*ls2.*ls3;
y1 = sum(y0)*y1./sum(y1);

% model of counts from fitting negative-binomial distribution to all data
p0 = nbinfit(y0);
y2 = nbinrnd(p0(1),p0(2),[numel(y0) 1]);

% indicator variable to exclude problematic tagging steps
f = (D6.BB2 ~=80 & D6.BB2 ~= 102);

% figure comparing histograms without BB2: 80,102
figure('Units','inches','Position',[2 2 6.5 3.35]);
subplot(2,1,1); 
ty = y0(f);
bar(log2(1+histcounts(ty,0:700)),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',0.5);
xlim([0 700]);
ylabel('log2(count)');
subplot(2,1,2); 
ty = y2(f);
bar(log2(1+histcounts(ty,0:700)),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',0.5);
xlim([0 700]);
ylabel('log2(count)');
xlabel('sequencing reads');

% figure comparing histograms WITH BB2: 80,102
figure('Units','inches','Position',[2 2 6.5 3.35]);
for i=[0 1 2]
    subplot(3,1,i+1); 
    ty = eval(['y' num2str(i)]);
    bar(log2(1+histcounts(ty,0:600)),'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',0.5);
    xlim([0 600]);
    if (i<2)
%         xticks([])
        xticklabels({''});
    end
%     xticklabels('FontSize',8,'FontWeight','bold');
    ax = gca;
    ax.FontWeight = 'bold'; 
    ylabel('log_2(count)','FontSize',10,'FontWeight','bold');
end
xlabel('sequencing reads','FontSize',10,'FontWeight','bold');
toc;
