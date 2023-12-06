function [DefPoint,Distmean] = RecPrmFindDefectivePoint(Point,G0,Num)
LG0 = laplacian(G0);
DG0 = diag(LG0);
[r,c] = size(Point);
IDs = 1:r;
Gr = graph(G0);

bins = conncomp(Gr);
tcon = max(bins);
DefPoint = [];

for k = 1:tcon
    PointID = find(bins == k);
    l = length(PointID);
    if l > 1
        mPoint_k = mean(Point(PointID,:));
    else
        mPoint_k = Point(PointID,:);
    end
    %RPointID = setdiff(IDs,PointID);
    for i = 1:l
        Dist = (diag((mPoint_k-Point(PointID(i),:))*(mPoint_k-Point(PointID(i),:))')).^0.5;
        Distsorted = sort(Dist);
        if l > 1
            D(i) = Distsorted(end)+5/(DG0(PointID(i))+.1);
        else
            D(i) = 50/(DG0(PointID(i))+.1);
        end
    end
    Dsorted = -sort(-D);
    ss = min(Num,l);
    Count = find(D>=Dsorted(ss));
    DefPoint{k} = Point(PointID(Count),:);
    Dmean(k) = mean(Dsorted(1:ss));
    clear D Dsorted Dist
end
Distmean = mean(Dmean);