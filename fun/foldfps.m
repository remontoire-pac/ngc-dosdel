function out = foldfps(in,f)
% out = foldfps(in,f)
% Fold binary fingerprints f times.
% Last modified 2010/12/11 PAC
    
    % check for valid f
    if (nargin<2)
        f = 1;
    else
        assert(isindex(f),'Input f must be a positive integer.');
    end
    
    % check for fingerprint input
    assert(isbinary(in),'Input be binary fingerprints.');
    m = size(in,1);
    assert(m>0,'Input must have at least 1 row.');
    n = size(in,2);
    assert(n>2,'Input must have at least 3 columns.');
    
    in = logical(in');
    x = ceil(log2(n));
    assert(f<x,'f must result in final size at least 2.');
    
    extra = false(2^x-n,m);
    in = [in;extra];
    
    for i=1:f
        n = size(in,1);
        A = in(1:n/2,:);
        B = in(n/2+1:end,:);
        in = A|B;
    end
    
    out = in';
    
end
