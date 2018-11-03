function flagTest = isbinary(inMat)
%flagTest = isbinary(inMat)
%Test matrix for containing only binary data (bits)
%Last modified 2009/05/13 PAC
%
%----------------------------------------------------------------
%workflow
%----------------------------------------------------------------
%Input any matrix.
%Check for logical data type or de facto binary data.
%Report test results as scalar logical.
%
%----------------------------------------------------------------
%parameters
%----------------------------------------------------------------
%"inMat" - any matrix
%
%----------------------------------------------------------------
%output
%----------------------------------------------------------------
%"flagTest" - logical reporting whether matrix passes test
%
%----------------------------------------------------------------

    %test for binary data
    if (islogical(inMat)==true) %actual logical data type
        flagTest = true;
    elseif ((isnumeric(inMat))&&(isequal(nnz(inMat),nnz(inMat==1)))) %de-facto binary
        flagTest = true;
    else
        flagTest = false;
    end
    
end
