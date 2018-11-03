clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary dataset D6
D6 = readtable('data\supplementaryDataset6.csv','TextType','string');

% extract counts and normalize to parts-per-million
Dt6 = D6{:,[6:11 17:22]};
Dt6 = Dt6.*repmat(10^6./sum(Dt6),size(Dt6,1),1);
xbca9 = Dt6(:,1:2); % 2 replicates of CA9 beads
xaca9 = Dt6(:,3:6); % 4 replicates of CA9 experimental
xbhrp = Dt6(:,7:10); % 4 replicates of HRP beads
xahrp = Dt6(:,11:12); % 2 replicates of HRP experimental

% fit Poisson distributions for each barcode combination
nbc = size(Dt6,1);
lhbca9 = nan(nbc,1); lhaca9 = lhbca9; lhbhrp = lhbca9; lhahrp = lhbca9;
lcbca9 = nan(nbc,2); lcaca9 = lcbca9; lcbhrp = lcbca9; lcahrp = lcbca9;
for u=1:nbc
    [lhbca9(u,1),lcbca9(u,1:2)] = poissfit(xbca9(u,:),0.05);
    [lhaca9(u,1),lcaca9(u,1:2)] = poissfit(xaca9(u,:),0.05);
    [lhbhrp(u,1),lcbhrp(u,1:2)] = poissfit(xbhrp(u,:),0.05);
    [lhahrp(u,1),lcahrp(u,1:2)] = poissfit(xahrp(u,:),0.05);
    sprintf('Fit distributions for barcode %i of %i.',u,nbc)
end

% WARNING: enabling replaces values from supplementary dataset D6
%           (confirmed precise to round-off error of 10^-12)
% D6.ca9_B = lhbca9;
% D6.ca9_A = lhaca9;
% D6.ca9_Bp = lcbca9(:,2);
% D6.ca9_Ap = lcaca9(:,1);
% D6.ca9_Fn = lcaca9(:,1)./lcbca9(:,2);
% D6.hrp_B = lhbhrp;
% D6.hrp_A = lhahrp;
% D6.hrp_Bp = lcbhrp(:,2);
% D6.hrp_Ap = lcahrp(:,1);
% D6.hrp_Fn = lcahrp(:,1)./lcbhrp(:,2);

toc;
