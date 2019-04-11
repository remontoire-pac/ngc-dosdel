clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary dataset D5
D5 = readtable('data\supplementaryDataset5.csv','TextType','string');

% create sparse matrix from ecfp6 representation
FF = sparse(false(size(D5,1),512));
for i=1:size(D5,1)
    FF(i,eval(D5.ecfp6(i))) = true;
end

% restrict to AP1 for self-similarity calculations
FFd = FF(strcmp(D5.collection,'AP1'),:);

% WARNING: fully enabling loop creates 59*59=3481 similarity tiles
for i=1%:2 % 1:59
    ti = (1:1824)+(i-1)*1824;
    for j=i%:59
        tj = (1:1824)+(j-1)*1824;
        if (i==j)
            d = single((1-squareform(pdist(FFd(ti,:),'jaccard'))));
            save(['sim\selfsim' zeropad(i,3) 'x' zeropad(j,3) 'out.mat'],'d');
        else
            d = single((1-pdist2(FFd(ti,:),FFd(tj,:),'jaccard')));
            save(['sim\selfsim' zeropad(i,3) 'x' zeropad(j,3) 'out.mat'],'d');
            dt = d';
            save(['sim\selfsim' zeropad(j,3) 'x' zeropad(i,3) 'out.mat'],'dt');
        end
        tt = toc;
        sprintf('Finished %i x %i after %d seconds.',i,j,tt) 
    end
end

toc;