clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);
% read supplementary dataset D6 and CA9 chigram results
D6 = readtable('data\supplementaryDataset6.csv','TextType','string');
load data\chigramHitListDepthCA9.mat F*;

% create and annotate Figure 5d
[~,sCA9] = sort(D6.ca9_B); % sort order for products
[schi,sBBC] = sort(F(4).chi,'descend'); % sort order for BB_C
cF5a = 0.75*ones(119,3);
cF5a(sBBC(1),:) = [0 0.60 0.60];
cF5a(sBBC(2),:) = [0.75 0 0.75];

figure('Units','centimeters','Position',[2 2 32 4]);
scatter(1:numel(D6.ca9_Fn),D6.ca9_Fn(sCA9),1+2*D6.ca9_Fn(sCA9),D6.BB2(sCA9),'o','LineWidth',1.5,'MarkerEdgeAlpha',0.75);
colormap(cF5a);
xlim([0 numel(sCA9)]); ylim([0 18]);
xticks(''); xticklabels('');

% create and annotate Figure 5e
figure('Units','centimeters','Position',[2 2 16 8]);
cF5b = bar(F(4).chi);
cF5b.FaceColor = 'flat';
cF5b.CData(:,:) = cF5a;

% create and annotate Figure 5f
ttt = zeros(0,3);
ttc = zeros(0,1);
for xi=1:3
    tn = zeros(numel(F(xi).chi),3);
    t = true(1,3);
    t(xi) = false;
    ttf = F(xi).chi(:);
     ttf(ttf<-norminv(0.025)) = 0.1;
    ttc = [ttc; ttf];
    [tchx,tchy] = find(F(xi).chi);
    tn(:,t) = [tchx tchy];
    ttt = [ttt; tn];
end
cF5c = 0.75*ones(15430,3);
cF5c(ttt(:,3)==sBBC(1),:) = repmat([0 0.60 0.60],nnz(ttt(:,3)==sBBC(1)),1);
cF5c(ttt(:,3)==sBBC(2),:) = repmat([0.75 0 0.75],nnz(ttt(:,3)==sBBC(2)),1);
figure('Units','centimeters','Position',[2 2 16 8]);
scatter3(ttt(:,1),ttt(:,2),ttt(:,3),ttc,cF5c,'filled');
toc;
