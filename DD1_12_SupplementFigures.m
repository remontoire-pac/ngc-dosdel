clear; clc; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary dataset D6
D6 = readtable('data\supplementaryDataset6.csv','TextType','string');

x = D6.ap1_baseline;

% SF33
xe = 0:5:max(x);
[hc,il] = histcounts(x,xe);
figure('Units','inches','Position',[2 2 6.5 3.35]);
bar(hc,'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',0.5);
bc = numel(il);
bcf = ceil(bc/8);
bci = 1:bcf:bc;
set(gca,'XTick',bci,'XTickLabel',il(bci));
xlabel('sequencing reads');
ylabel('count');

% SF34-36
ct = crosstab(x,D6.scaffold);
ct = sum(ct.*repmat((1:size(ct,1))',1,max(D6.scaffold)));
ct = sort(numel(ct).*ct./sum(ct),'descend');
figure('Units','inches','Position',[2 2 6.5 3.35]);
bar(ct,'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',0.5);
xlabel('scaffold rank');
ylabel('relative abundance');

ct = crosstab(x,D6.BB1);
ct = sum(ct.*repmat((1:size(ct,1))',1,max(D6.BB1)));
ct = sort(numel(ct).*ct./sum(ct),'descend');
figure('Units','inches','Position',[2 2 6.5 3.35]);
bar(ct,'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',0.5);
xlabel('BB1 rank');
ylabel('relative abundance');

ct = crosstab(x,D6.BB2);
ct = sum(ct.*repmat((1:size(ct,1))',1,max(D6.BB2)));
ct = sort(numel(ct).*ct./sum(ct),'descend');
figure('Units','inches','Position',[2 2 6.5 3.35]);
bar(ct,'FaceColor',[0 0 1],'EdgeColor',[0 0 1],'LineWidth',0.5);
xlabel('BB2 rank');
ylabel('relative abundance');

% SF37-38 (BB2: 70 & 77)
load data\chigramHitListDepthCA9.mat F*;
cF5a = 1*ones(119,3);
cF5a(70,:) = [0 0 1];
cF5a(77,:) = [0 0 1];
[schi,sBBC] = sort(F(4).chi,'descend'); % sort order for BB_C
cF5a = cF5a(sBBC,:);
figure('Units','inches','Position',[2 2 6.5 3.35]);
cF5b = bar(log2(schi.*schi),'EdgeColor',[0 0 1],'LineWidth',0.25);
cF5b.FaceColor = 'flat';
cF5b.CData(:,:) = cF5a;
xlabel('BB2 rank');
ylabel('enrichment, log_2(\chi^2)');
clear F*;

load data\chigramHitListDepthHRP.mat F*;
cF5a = 1*ones(119,3);
cF5a(70,:) = [0 0 1];
cF5a(77,:) = [0 0 1];
[schi,sBBC] = sort(F(4).chi,'descend'); % sort order for BB2
cF5a = cF5a(sBBC,:);
figure('Units','inches','Position',[2 2 6.5 3.35]);
cF5b = bar(log2(schi.*schi),'EdgeColor',[0 0 1],'LineWidth',0.25);
cF5b.FaceColor = 'flat';
cF5b.CData(:,:) = cF5a;
xlabel('BB2 rank');
ylabel('enrichment, log_2(\chi^2)');

% % SF39 (BB1: 88)
cF5a = 1*ones(119,3);
cF5a(88,:) = [0 0 1];
[schi,sBBC] = sort(F(5).chi,'descend'); % sort order for BB1
cF5a = cF5a(sBBC,:);
figure('Units','inches','Position',[2 2 6.5 3.35]);
cF5b = bar(log2(schi.*schi),'EdgeColor',[0 0 1],'LineWidth',0.25);
cF5b.FaceColor = 'flat';
cF5b.CData(:,:) = cF5a;
xlabel('BB1 rank');
ylabel('enrichment, log_2(\chi^2)');

% % SF40 (BB2: 98)
cF5a = 1*ones(119,3);
cF5a(98,:) = [0 0 1];
[schi,sBBC] = sort(F(4).chi,'descend'); % sort order for BB2
cF5a = cF5a(sBBC,:);
figure('Units','inches','Position',[2 2 6.5 3.35]);
cF5b = bar(log2(schi.*schi),'EdgeColor',[0 0 1],'LineWidth',0.25);
cF5b.FaceColor = 'flat';
cF5b.CData(:,:) = cF5a;
xlabel('BB2 rank');
ylabel('enrichment, log_2(\chi^2)');

toc;
