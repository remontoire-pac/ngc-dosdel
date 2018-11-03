clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);
% read supplementary dataset D6 and HRP chigram results
D6 = readtable('data\supplementaryDataset6.csv','TextType','string');
load data\chigramHitListDepthHRP.mat F*;

% create and annotate Figure 5a
[~,sHRP] = sort(D6.hrp_B); % sort order for products
[schi,sBBB] = sort(F(5).chi,'descend'); % sort order for BB_B
cF5d = 0.75*ones(114,3);
cF5d(sBBB(1),:) = [0 0 138]/255;
cF5d(sBBB(2),:) = [68 141 0]/255;
cF5d(sBBB(5),:) = [202 171 2]/255;

figure('Units','centimeters','Position',[2 2 32 4]);
scatter(1:numel(D6.hrp_Fn),D6.hrp_Fn(sHRP),1+2*D6.hrp_Fn(sHRP),D6.BB1(sHRP),'o','LineWidth',1.5,'MarkerEdgeAlpha',0.75);
colormap(cF5d);
xlim([0 numel(sHRP)]); ylim([0 9]);
xticks(''); xticklabels('');

% create and annotate Figure 5b
figure('Units','centimeters','Position',[2 2 16 8]);
cF5e = bar(F(5).chi);
cF5e.FaceColor = 'flat';
cF5e.CData(:,:) = cF5d;

% create and annotate Figure 5c
ttt = zeros(0,3);
ttc = zeros(0,1);
for xi=1:3
    tn = zeros(numel(F(xi).chi),3);
    t = true(1,3);
    t(xi) = false;
    ttf = F(xi).chi(:);
    ttf(ttf<-norminv(0.0005)) = 0.1;
    ttc = [ttc; ttf];
    [tchx,tchy] = find(F(xi).chi);
    tn(:,t) = [tchx tchy];
    ttt = [ttt; tn];
end
cF5f = 0.75*ones(15430,3);
cF5f(ttt(:,2)==sBBB(1),:) = repmat([0 0 138]/255,nnz(ttt(:,2)==sBBB(1)),1);
cF5f(ttt(:,2)==sBBB(2),:) = repmat([68 141 0]/255,nnz(ttt(:,2)==sBBB(2)),1);
cF5f(ttt(:,2)==sBBB(5),:) = repmat([202 171 2]/255,nnz(ttt(:,2)==sBBB(5)),1);
figure('Units','centimeters','Position',[2 2 16 8]);
scatter3(ttt(:,1),ttt(:,2),ttt(:,3),ttc,cF5f,'filled');
toc;
