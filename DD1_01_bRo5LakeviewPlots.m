clear; close all; tic;
% customize wf to local environment
wf = 'd:\job\del\ms'; addpath(genpath(wf)); cd(wf);

% read supplementary datasets D3 and D4
D3 = readtable('data\supplementaryDataset3.csv','TextType','string');
D3 = sortrows(D3(~(D3.BB2==77),:)); % remove structure duplicates
D4 = readtable('data\supplementaryDataset4.csv','TextType','string');
assert(isequal(D3.cpd_id,D4.cpd_id),'Mismatched tables.');

x = D4{:,2:7}; % descriptor vectors
ro5 = [500,5,5,10,10,140]; % bRo5 cutoffs

% az or pyr
[v1,~,p1] = unique(D3.ring);
x11 = x(p1==1,:);
x12 = x(p1==2,:);

% WARNING: fully enabling loop creates 6 figures
for i=1 % 1:size(x,2)
    yl1 = sprintf("descriptor %s",string(D4.Properties.VariableNames(i+1)));
    yl2 = sprintf("top %s",string(v1(1)));
    yl3 = sprintf("bottom %s ",string(v1(2)));
    y1 = x11(:,i); % distribution for top
    y2 = x12(:,i); % distribution for bottom
    if (i>=3&&i<=5)
        lakeview(y1,y2,ro5(i),true);
    else
        lakeview(y1,y2,ro5(i),false);
    end
    title([char(yl1) ': ' char(yl2) ' / ' char(yl3)])
end

% ald or sc
[v2,~,p2] = unique(D3.Ncap);
x21 = x(p2==1,:);
x22 = x(p2==2,:);

% WARNING: fully enabling loop creates 6 figures
for i=1 % 1:size(x,2)
    yl1 = sprintf("descriptor %s",string(D4.Properties.VariableNames(i+1)));
    yl2 = sprintf("top %s",string(v2(1)));
    yl3 = sprintf("bottom %s ",string(v2(2)));
    y1 = x21(:,i); % distribution for top
    y2 = x22(:,i); % distribution for bottom
    if (i>=3&&i<=5)
        lakeview(y1,y2,ro5(i),true);
    else
        lakeview(y1,y2,ro5(i),false);
    end
    title([char(yl1) ': ' char(yl2) ' / ' char(yl3)])
end

% Suz or no Suz
[v3,~,p3] = unique(D3.Suzuki);
x31 = x(p3==1,:);
x32 = x(p3==2,:);

% WARNING: fully enabling loop creates 6 figures
for i=1 % 1:size(x,2)
    yl1 = sprintf("descriptor %s",string(D4.Properties.VariableNames(i+1)));
    yl2 = sprintf("top %s",string(v3(1)));
    yl3 = sprintf("bottom %s ",string(v3(2)));
    y1 = x31(:,i); % distribution for top
    y2 = x32(:,i); % distribution for bottom
    if (i>=3&&i<=5)
        lakeview(y1,y2,ro5(i),true);
    else
        lakeview(y1,y2,ro5(i),false);
    end
    title([char(yl1) ': ' char(yl2) ' / ' char(yl3)])
end

% 8 combinations
[v0,~,p0] = unique(D3(:,5:7));
x01 = x(p0==1,:); % az, ald, Suz
x02 = x(p0==2,:); % az, ald, no Suz
x03 = x(p0==3,:); % az, sc, Suz
x04 = x(p0==4,:); % az, sc, no Suz
x05 = x(p0==5,:); % pyr, ald, Suz
x06 = x(p0==6,:); % pyr, ald, no Suz
x07 = x(p0==7,:); % pyr, sc, Suz
x08 = x(p0==8,:); % pyr, sc, no Suz

% WARNING: fully enabling loop creates 6x8x8=384 figures
for i=1 % 1:size(x,2)
    for j=5 % 1:8
        for k=7 % 1:8
            yl1 = sprintf("descriptor %s",string(D4.Properties.VariableNames(i+1)));
            yl2 = sprintf("top %s %s %s",string(v0.ring(j)),string(v0.Ncap(j)),string(v0.Suzuki(j)));
            yl3 = sprintf("bottom %s %s %s",string(v0.ring(k)),string(v0.Ncap(k)),string(v0.Suzuki(k)));
            y1 = eval(['x0' num2str(j) '(:,i)']); % distribution for top
            y2 = eval(['x0' num2str(k) '(:,i)']); % distribution for bottom
            if (i>=3&&i<=5)
                lakeview(y1,y2,ro5(i),true);
            else
                lakeview(y1,y2,ro5(i),false);
            end
            title([char(yl1) ': ' char(yl2) ' / ' char(yl3)])
        end
    end
end

toc;