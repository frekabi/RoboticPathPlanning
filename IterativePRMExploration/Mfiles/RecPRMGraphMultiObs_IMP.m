function G = RecPRMGraphMultiObs_IMP(Point,obs,Nneig,ThDist)
K_obs = length(obs);
[m,n] = size(Point);

for j=1:m
    Nc(j) = {[]};
end
Nprm = m;
Safe_Dist = 1;
Adj = zeros(Nprm,Nprm);
D = zeros(Nprm,Nprm);
DistG = zeros(Nprm,Nprm);
ISECXY = 0;
ISECZ = 0;
Safe_Dist = 10;
D2line = [];
ISECZ_k = [];
for i=1:Nprm
    Dist = (diag((Point-Point(i,:))*(Point-Point(i,:))')).^0.5;
    D2 = sort(Dist);
    if length(D2) >= Nneig*2
        J0 = find(Dist<D2(Nneig*2) & Dist > 2 & Dist <= ThDist ,Nneig);
    else
        J0 = find(Dist<D2(Nneig) & Dist > 2 & Dist <= ThDist ,Nneig);
    end
    J1 = J0;
     
    for t = 1:length(J0)
        line = [Point(J0(t),1) Point(J0(t),2);Point(i,1) Point(i,2)];
        ISECZ_k = [];
        for k = 1:K_obs
            D2line(k) = abs(obs(k,2) - Point(J0(t),2) - (Point(J0(t),2)-Point(i,2))/(Point(J0(t),1)-Point(i,1)) * (obs(k,1)-Point(J0(t),1)));
           if obs(k,3) >= min([Point(J0(t),3),Point(i,3)])
               if obs(k,3) >= max([Point(J0(t),3),Point(i,3)])
                   ISECZ_k(k) = 1;
               end
           end
        end
        if ~isempty(D2line)
            D2line_min = min(D2line);
            if D2line_min <= Safe_Dist
                ISECXY = 1;
            else
                ISECXY = 0;
            end
        else
            ISECXY = 0;
        end
        if ~isempty(ISECZ_k)
            ISECZ = any(ISECZ_k);
        else
            ISECZ = 0;
        end
        
        ISECT = (and(ISECXY,ISECZ));
        if ISECT
           J1 = setdiff(J1,J0(t));
        else
            if isempty(intersect(cell2mat(Nc(J0(t))),i))
                if ~isempty(intersect(J1,cell2mat(Nc(J0(t)))))
                        J1 = setdiff(J1,J0(t));
                else
                        Nc(J0(t)) = {[cell2mat(Nc(J0(t)));i]};
                        Adj(i,J0(t)) = 1;
                        Adj(J0(t),i) = 1;
                        DistG(J0(t),i) = sqrt((Point(J0(t),:)-Point(i,:))*(Point(J0(t),:)-Point(i,:))');
                        DistG(i,J0(t)) = sqrt((Point(J0(t),:)-Point(i,:))*(Point(J0(t),:)-Point(i,:))');
                end
            end
        end 
    end
    if isempty(intersect(cell2mat(Nc(i)),J1))
        Nc(i) = {[cell2mat(Nc(i));J1]};
    else
        Nc(i) = {[cell2mat(Nc(i));setdiff(J1,cell2mat(Nc(i)))]};
    end
    D(i,i) = sum(Adj(i,:));
end
G = DistG;