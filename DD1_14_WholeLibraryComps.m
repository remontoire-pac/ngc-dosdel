clear; clc; close all; tic;
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);
% customize wf to local environment

% read supplementary datasets D3 and D5
D3 = readtable('data\supplementaryDataset3.csv','TextType','string');
D3 = sortrows(D3(~(D3.BB2==77),:)); % remove structure duplicates
D5 = readtable('data\supplementaryDataset5.csv','TextType','string');

% set up divisions for analysis (8 AP1 X 5 comparison collections)
assert(isequal(D3.cpd_id(strcmp(D5.collection,'AP1')),D3.cpd_id),'Mismatched tables.');
vi = unique(D3(:,{'ring','Ncap','Suzuki'}));
vj = unique(D5(:,{'collection','type'}));
clear D*;

% load data for self-similarity cloud
load data\foldedECFP6SimFusions.mat qsm qsx;

% load data for cross-similarity summaries
load data\prctileECFP6GroupFusions.mat dpt;

% read in similarity tables and accumulate percentiles
up = 0:1:100;
dpw = nan(numel(up),5);

% WARNING: fully enabling loop expects 5 similarity matrices
% for j=2:size(vj,1)
%     dv = [];
%     for i=1:size(vi,1)
%         load(['sim\compsim' zeropad(i,3) 'x' zeropad(j,3) 'out.mat'],'d');
%         d = [mean(d,2) max(d,[],2)];
%         dv = [dv;d];
%     end
% 	sprintf('Finished comparison %i.',j)
%     save(['data\prctileECFP6WholeFus' zeropad(j,3) '.mat'],'dv');
% end

% create map with color ids to control order of plotting
cm = [0 0 0; 1 0 1; 0 1 1; 1 0 0; 0 0 1; 0 1 0];
cv = ones(size(qsm));
for j=2:6
    load(['data\prctileECFP6WholeFus' zeropad(j,3) '.mat'],'dv');
    qsm = [qsm;dv(:,1)];
    qsx = [qsx;dv(:,2)];
    cv = [cv;j*ones(size(dv(:,1)))];
end
rv = rand(size(qsx));
[~,sv] = sort(rv,'descend');
qsm = qsm(sv); qsx = qsx(sv); cv = cv(sv);
figure('Units','centimeters','Position',[1 1 20 20]);
scatter(qsm,qsx,4,cv,'.');
colormap(cm);
xlim([0.2 0.6]);
ylim([0.3 1.0]);
ax = gca;
ax.FontWeight = 'bold'; 
xlabel('mean similarity (Tanimoto)','FontSize',12,'FontWeight','bold');
ylabel('maximum similarity (Tanimoto)','FontSize',12,'FontWeight','bold');

% reset data for self-similarity summary
load data\foldedECFP6SimFusions.mat qsm qsx;

% similarity fusions: cross-library comparisons
ms = ['s','s','s','s','o','o','o','o']; % shapes
mz = [256,64,256,64,256,64,256,64]; % sizes
figure('Units','centimeters','Position',[1 1 20 20]);
scatter(mean(qsm),mean(qsx),256,cm(1,:),'filled');
ax = gca;
ax.FontWeight = 'bold'; 
xlabel('median similarity (Tanimoto)','FontSize',12,'FontWeight','bold');
ylabel('maximum similarity (Tanimoto)','FontSize',12,'FontWeight','bold');
xlim([0.2 0.6]); ylim([0.3 1.0]); hold on;
me = errorbar(mean(qsm),mean(qsx),3*std(qsx),3*std(qsx),3*std(qsm),3*std(qsm));
me.Color = 'black';
me.CapSize = 18;
me.LineWidth = 2;
scatter(mean(qsm),mean(qsx),256,cm(1,:),'filled');
for x1=1:8
    for x2=1:5
        if (x1==1||x1==2||x1==5||x1==6)
            scatter(dpt(x1,51,x2),dpt(x1,101,x2),mz(x1),cm(x2+1,:),ms(x1),'LineWidth',2);
        else
            scatter(dpt(x1,51,x2),dpt(x1,101,x2),mz(x1),cm(x2+1,:),ms(x1),'filled');
        end
    end
end


toc;