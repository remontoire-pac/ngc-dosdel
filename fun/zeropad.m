function [serial] = zeropad(i,n)
    
    if (nargin<2)
        n = 3;
    end

    L = numel(num2str(i));
    assert(isindex(i)&&i>=0,'Input i must be a non-negative integer.');
    assert(L<=n,'Input i must have length no more than n (default n=3).');
    if (L==n)
        serial = num2str(i);
    else
        z = '';
        for x=1:(n-L)
            z = [z '0'];
        end
        serial = [z num2str(i)];
    end
        
end
