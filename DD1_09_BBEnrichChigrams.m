clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary dataset D6
D6 = readtable('data\supplementaryDataset6.csv','TextType','string');

% set up design space of scaffold X BB1 X BB2
aa = D6.scaffold; ab = D6.BB1; ac = D6.BB2; ai = D6.ap1_baseline;
ta = max(aa); tb = max(ab); tc = max(ac);
tt = [tc tb ta]; 
tp = [prod(tt([1 2])) prod(tt([1 3])) prod(tt([2 3]))];
tt = tt./sum(tt);
tp = 0.5*([tp./sum(tp) tt]);

% TOGGLE these two lines for ca9 versus hrp protein
cb = D6.ca9_B; ca = D6.ca9_A; c = D6.ca9_Fn;
% cb = D6.hrp_B; ca = D6.hrp_A; c = D6.hrp_Fn;

Fct = nnz(c>1);
cr1 = accumarray([aa ab ac],tiedrank(-c));
cr0 = accumarray([aa ab ac],tiedrank(-cb));
cbas = accumarray([aa ab ac],ai);
cexp = accumarray([aa ab ac],cb);
cobs = accumarray([aa ab ac],ca);
ts = 1:Fct;
tsn = numel(ts);
for tj=1:numel(tt)
    for ti=tj:numel(tt)
        tx = shiftdim(squeeze(sum(sum(cbas,ti),tj)));
        tx = tx./sum(sum(tx));
        ty = shiftdim(squeeze(sum(sum(cexp,ti),tj)));
        ty = ty./sum(sum(ty));
        if (ti==tj)
            En(1,ti).bas = tx;
            En(1,ti).con = ty;
        else
            En(1,1+ti+tj).bas = tx;
            En(1,1+ti+tj).con = ty;
        end
    end
end
for tk=1:tsn
    ttk = tk/power(10,6);
    for tj=1:numel(tt)
        for ti=tj:numel(tt)
            tz0 = 1+shiftdim(squeeze(sum(sum(cexp&(cr0<=ts(tk)),ti),tj)));
            tz1 = 1+shiftdim(squeeze(sum(sum(cobs&(cr1<=ts(tk)),ti),tj)));
            if (ti==tj)
                tsf = ttk*tp(ti)*En(ti).bas.*En(ti).con;
                E(tk,ti).obs = tsf.*tz1;
                E(tk,ti).exp = sum(sum(tsf.*tz1)).*((tsf.*tz0)./sum(sum(tsf.*tz0)));
                E(tk,ti).res = (E(tk,ti).obs-E(tk,ti).exp);
                E(tk,ti).chi = (E(tk,ti).obs-E(tk,ti).exp)./E(tk,ti).exp;
                E(tk,ti).sum = sum(sum(power(E(tk,ti).chi,2)));
                E(tk,ti).deg = prod(size(tz1)-1);
            else
                tsf = ttk*tp(1+ti+tj)*En(1+ti+tj).bas.*En(1+ti+tj).con;
                E(tk,1+ti+tj).obs = tsf.*tz1;
                E(tk,1+ti+tj).exp = sum(sum(tsf.*tz1)).*((tsf.*tz0)./sum(sum(tsf.*tz0)));
                E(tk,1+ti+tj).res = (E(tk,1+ti+tj).obs-E(tk,1+ti+tj).exp);
                E(tk,1+ti+tj).chi = (E(tk,1+ti+tj).obs-E(tk,1+ti+tj).exp)./E(tk,1+ti+tj).exp;
                E(tk,1+ti+tj).sum = sum(sum(power(E(tk,1+ti+tj).chi,2)));
                E(tk,1+ti+tj).deg = numel(tz1)-1;
            end
        end
    end
    sprintf('Finished cut %i of %i.',tk,tsn)
end

% TOGGLE these two blocks for ca9 versus hrp protein
Fsum = [[E(:,1).sum]' [E(:,2).sum]' [E(:,3).sum]' [E(:,4).sum]' [E(:,5).sum]' [E(:,6).sum]'];
Fdeg = [E(1,:).deg];
% figure(); plot(sum(Fsum,2));
Ffin = find(sum(Fsum,2)==max(sum(Fsum,2)));
% figure(); bar(E(Ffin,4).chi)
F = E(Ffin,:);
% save data\chigramHitListDepthCA9.mat F*;

% Fsum = [[E(:,1).sum]' [E(:,2).sum]' [E(:,3).sum]' [E(:,4).sum]' [E(:,5).sum]' [E(:,6).sum]'];
% Fdeg = [E(1,:).deg];
% figure(); plot(sum(Fsum,2));
% Ffin = find(sum(Fsum,2)==max(sum(Fsum,2)));
% figure(); bar(E(Ffin,5).chi)
% F = E(Ffin,:);
% save data\chigramHitListDepthHRP.mat F*;

toc;