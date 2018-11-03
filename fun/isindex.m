function flagTest = isindex(inMat)
%flagTest = isindex(inMat)
%Test matrix for containing only positive integers (indices)
%Last modified 2009/05/13 PAC
%
%----------------------------------------------------------------
%workflow
%----------------------------------------------------------------
%Input any matrix.
%Check for integer data type or de facto integers.
%Ensure all integers are positive.
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

    %test for positive integers
    if ((isinteger(inMat)==true)&&(min(inMat(:))>=1)) %actual integer data type
        flagTest = true;
    elseif (isnumeric(inMat)&&(isequal(inMat,fix(inMat)))&&(min(inMat(:))>=1)) %de-facto integers
        flagTest = true;
    else
        flagTest = false;
    end
    
end
