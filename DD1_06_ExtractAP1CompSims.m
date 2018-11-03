clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary datasets D3 and D5
D3 = readtable('data\supplementaryDataset3.csv','TextType','string');
D3 = sortrows(D3(~(D3.BB2==77),:)); % remove structure duplicates
D5 = readtable('data\supplementaryDataset5.csv','TextType','string');

% set up subdivisions for analysis (8 AP1 X 5 comparison collections)
assert(isequal(D3.cpd_id(strcmp(D5.collection,'AP1')),D3.cpd_id),'Mismatched tables.');
vi = unique(D3(:,{'ring','Ncap','Suzuki'}));
vj = unique(D5(:,{'collection','type'}));
clear D*;

% read in similarity tables and accumulate percentiles
up = 0:1:100;
dpt = nan(8,numel(up),5);

% WARNING: fully enabling loop expects 8*5=40 similarity matrices
for i=1 % 1:size(vi,1)
    for j=2 % 2:size(vj,1)
        load(['sim\compsim' zeropad(i,3) 'x' zeropad(j,3) 'out.mat'],'d');
        dpt(i,:,j-1) = prctile(single(d(:)),up);
        clear d;
        sprintf('Finished sublibrary %i, comparison %i.',i,j)
    end
end
save data\prctileECFP6GroupFusions.mat dpt v*;

toc;