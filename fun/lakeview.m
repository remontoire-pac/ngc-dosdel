function [] = lakeview(y1,y2,c,rf,fc,ec,lw)
% function [] = lakeview(y1,y2,c,rf,fc,ec,lw)
%  create lakeview histogram plot with two distributions y1, y2
%  color-change cutoff c, face color fc, edge color ec, line width lw
%  created PAC/CJG 2018-04-25
%  last modified PAC/CJG 2018-05-29
%

    if (nargin<7||isequal(lw,[]))
        lw = 1;
    end
    assert(isscalar(lw)&lw>0,'Input lw must be a positive scalar.');
    if (nargin<6||isequal(ec,[]))
        ec = [0 0 0;...
              0 0 0;...
              0 0 0;...
              0 0 0];
    end
    if (nargin<5||isequal(fc,[]))
        fc = [0 0 1;...
              1 0 0;...
              0.6 0.6 1;...
              1 0.6 0.6];
    end
    if (nargin<4||isequal(rf,[]))
        rf = false;
    end
    assert(isscalar(rf)&isbinary(rf),'Input rf must be a binary scalar.');
    if (nargin<3||isequal(c,[]))
        c = 0;
    end
    assert(isscalar(c),'Input c must be a scalar real number.');
    assert(size(y2,1)==1|size(y2,2)==1,'Input y2 must be a vector.');
    assert(size(y1,1)==1|size(y1,2)==1,'Input y1 must be a vector.');

    [~,il] = histcounts([y1;y2]);
    
    jtl = histcounts(y1(y1<=c),il);
    jtr = histcounts(y1(y1>c),il);
    ct = (sum([jtl jtr]));
    jtl = jtl/ct;
    jtr = jtr/ct;
    jbl = -histcounts(y2(y2<=c),il);
    jbr = -histcounts(y2(y2>c),il);
    cb = abs((sum([jbl jbr])));
    jbl = jbl/cb;
    jbr = jbr/cb;
    
    figure();
    hold on;
    bar(jtl,'FaceColor',fc(1,:),'EdgeColor',ec(1,:),'LineWidth',lw);
    bar(jtr,'FaceColor',fc(2,:),'EdgeColor',ec(2,:),'LineWidth',lw);
    bar(jbl,'FaceColor',fc(3,:),'EdgeColor',ec(3,:),'LineWidth',lw);
    bar(jbr,'FaceColor',fc(4,:),'EdgeColor',ec(4,:),'LineWidth',lw);
    bc = numel(il);
    bcf = ceil(bc/6);
    bci = 1:bcf:bc;
    if (rf)
        set(gca,'XTick',bci,'XTickLabel',ceil(il(bci)));
    else
        set(gca,'XTick',bci,'XTickLabel',il(bci));
    end

end