clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary datasets D3 and D5
D3 = readtable('data\supplementaryDataset3.csv','TextType','string');
D3 = sortrows(D3(~(D3.BB2==77),:)); % remove structure duplicates
D5 = readtable('data\supplementaryDataset5.csv','TextType','string');

% create sparse matrix from ecfp6 representation
FF = sparse(false(size(D5,1),512));
for i=1:size(D5,1)
    FF(i,eval(D5.ecfp6(i))) = true;
end

% set up subdivisions for analysis (8 AP1 X 5 comparison collections)
assert(isequal(D3.cpd_id(strcmp(D5.collection,'AP1')),D3.cpd_id),'Mismatched tables.');
[vi,~,pi] = unique(D3(:,{'ring','Ncap','Suzuki'}));
[vj,~,pj] = unique(D5(:,{'collection','type'}));

% WARNING: fully enabling loop creates 8*5=40 similarity matrices
for i=1 % 1:max(pi)
    for j=2 % 2:max(pj)
    d = 1-pdist2(FF(pi==i,:),FF(pj==j,:),'jaccard');
    save(['sim\compsim' zeropad(i,3) 'x' zeropad(j,3) 'out.mat'],'d');
    tt = toc;
    sprintf('Finished sublibrary %i, comparison %i, after %d seconds.',i,j,tt)
    end
end

toc;