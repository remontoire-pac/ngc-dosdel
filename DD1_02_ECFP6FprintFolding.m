clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read MAT file of unfolded fingerprints (not provided)
load data\sparseECFP6Fingerprints.mat F;

% tune folding using sampling to optimize similarity distribution
ss = 47; sn = 23;
f = F(:,sum(F,1)>1);
for i=1:(ceil(log2(size(f,2)))-1)
    [~,fs] = sort(abs(mean(f,1)-0.5),'ascend');
    f = f(:,fs);
    frm = [];
    for k=1:sn
        frs = f(randsample(size(f,1),ss),:);
        frd = 1-pdist(frs,'jaccard');
        frm = [frm frd];
        sprintf('Sample %i before fold %i.',k,i)
    end
    bpd(i,:) = prctile(frm,1:99);
    bpm(i,:) = nanmean(frm);
    bpv(i,:) = nanstd(frm);
    [~,~,~,~,bps] = regress((bpd(i,:))',[ones(99,1) (1:99)']);
    bpr(i,:) = bps(1);
    clear k fr*;
    f = foldfps(f,1);
    sprintf('Folded %i time(s).',i)
end
clear ans f* i s*;
fi = find(bpr==max(bpr),1,'first')-1;
f = F(:,sum(F,1)>1);
for i=1:fi
    [~,fs] = sort(abs(mean(f,1)-0.5),'ascend');
    f = f(:,fs);
    f = foldfps(f,1);
    sprintf('Folded %i time(s).',i)
end
[~,fs] = sort(abs(mean(f,1)-0.5),'ascend');
f = f(:,fs);
FF = f;
clear ans b* f* i;

% write MAT file of folded fingerprints (included in supplementary dataset D5)
save data\foldedECFP6Fingerprints.mat FF;

toc;