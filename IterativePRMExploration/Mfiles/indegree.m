function [ delta ] = indegree( A )
    B = A>0;
    delta=diag(sum(B,2));
end

