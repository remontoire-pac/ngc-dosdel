clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary dataset D3
D3 = readtable('data\supplementaryDataset3.csv','TextType','string');
D3 = sortrows(D3(~(D3.BB2==77),:)); % remove structure duplicates

% individual decisions
s11 = strcmp(D3.ring,'az'); s12 = ~s11;
s21 = strcmp(D3.Ncap,'ald'); s22 = ~s21;
s31 = strcmp(D3.Suzuki,'Suz'); s32 = ~s31;

% 8 groups
st111 = s11&s21&s31; % az, ald, Suz
st112 = s11&s21&s32; % az, ald, no Suz
st121 = s11&s22&s31; % az, sc, Suz
st122 = s11&s22&s32; % az, sc, no Suz
st211 = s12&s21&s31; % pyr, ald, Suz
st212 = s12&s21&s32; % pyr, ald, no Suz
st221 = s12&s22&s31; % pyr, sc, Suz
st222 = s12&s22&s32; % pyr, sc, no Suz

% matrices for sim fusion data
qsm = nan(0,1);
qsx = nan(0,1);
qsgm = nan(0,6);
qstm = nan(0,8);
qsgx = nan(0,6);
qstx = nan(0,8);

% WARNING: fully enabling loop expects 59*59=3481 similarity tiles
for i=1:2 %1:59
    q = [];
    for j=1:59
        load(['sim\selfsim' zeropad(j,3) 'x' zeropad(i,3) 'out.mat']);
        if (exist('d','var'))
            q = [q d];
        else
            q = [q dt];
        end
        tt = toc;
        clear d dt;
        sprintf('Finished %i x %i after %d seconds.',i,j,tt) 
    end
    tsi = (1:1824);
    tsj = 1824*(i-1)+(1:1824);
    q(tsi,tsj) = NaN;
    qsm = [qsm; nanmedian(q,2)];
    qsx = [qsx; max(q,[],2)];
    qsgm = [qsgm; nanmedian(q(:,s11),2) nanmedian(q(:,s12),2) nanmedian(q(:,s21),2) nanmedian(q(:,s22),2) nanmedian(q(:,s31),2) nanmedian(q(:,s32),2)];
    qstm = [qstm; nanmedian(q(:,st111),2) nanmedian(q(:,st112),2) nanmedian(q(:,st121),2) nanmedian(q(:,st122),2) nanmedian(q(:,st211),2) nanmedian(q(:,st212),2) nanmedian(q(:,st221),2) nanmedian(q(:,st222),2)];
    qsgx = [qsgx; max(q(:,s11),[],2) max(q(:,s12),[],2) max(q(:,s21),[],2) max(q(:,s22),[],2) max(q(:,s31),[],2) max(q(:,s32),[],2)];
    qstx = [qstx; max(q(:,st111),[],2) max(q(:,st112),[],2) max(q(:,st121),[],2) max(q(:,st122),[],2) max(q(:,st211),[],2) max(q(:,st212),[],2) max(q(:,st221),[],2) max(q(:,st222),[],2)];
end
save data\foldedECFP6SimFusions.mat qs* s*;

toc;