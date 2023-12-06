function [ L ] = laplacian( A )
    B = A>0;
    L = indegree(B) - B;
end

