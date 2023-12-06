function Point = RecPrmAddPoint_IMP(Map,DefPoint,radius,Nneigh,risk_max,bnd,curr_point)

%[m,n] = size(DefPoint);

Map1 = Map;
b1 = Map1.Boundary(1); b2 = Map1.Boundary(2);
b3 = Map1.Boundary(3); b4 = Map1.Boundary(4);
b5 = Map1.Boundary(5); b6 = Map1.Boundary(6);
obs = Map.Obs;
k = length(obs);
OBSVt = [];

%risk_max = 0.7;
Point = [];
tcon = length(DefPoint);
ID = 1:tcon;
for k = 1:tcon
    DDefPoint = DefPoint{k};
    RDPoints = [];
    for t = 1:tcon
        if t ~= k
            RDPoints = [RDPoints;DefPoint{t}];
        end
    end
    [m1,n1] = size(DDefPoint);
    [m2,n2] = size(RDPoints);
    for i = 1:m1
        DPoint = DDefPoint(i,:);
        for j = 1:m2
            dist(j) = P2Pdist(DPoint,RDPoints(j,:));
            
        end
        [mdist(i),idmin] = min(dist);
        MidPoint{i} = (1.4 * DPoint + 0.6 * RDPoints(idmin,:))/2;
    end
    distSorted = sort(mdist);
    Bound1 = []; 
    for j = 1:min(i,4)    
        id_dist = find(mdist == distSorted(j));
        MidPoint_k = MidPoint{id_dist};
        mdist_k = mdist(id_dist);
        %risk = RiskAssessMultiObs(Map.Obs,MidPoint_k(1),MidPoint_k(2),MidPoint_k(3));
        risk = Simple_RiskAssessMultiObs_IMP(obs,MidPoint_k,curr_point);
        if risk <= risk_max
            Bound1 = MidPoint_k(1) - min(2*radius,mdist_k)/2;  Bound2 = MidPoint_k(1) + min(2*radius,mdist_k)/2;
            Bound3 = MidPoint_k(2) - min(2*radius,mdist_k)/2;  Bound4 = MidPoint_k(2) + min(2*radius,mdist_k)/2;
            Bound5 = MidPoint_k(3) - min(2*radius,mdist_k)/2;  Bound6 = MidPoint_k(3) + min(2*radius,mdist_k)/2;
            break
        end
    end
    
    if isempty(Bound1)
        Bound1 = 0.9 * b1; Bound2 = 0.9 * b2; Bound3 = 0.9 * b3;
        Bound4 = 0.9 * b4; Bound5 = 0.9 * b5; Bound6 = 0.9 * b6;
    end       
        

    if abs(Bound1) <= abs(b1)
        Bound(1) = Bound1;
    else
        Bound(1) = b1;
    end

    if abs(Bound2) <= abs(b2)
        Bound(2) = Bound2;
    else
        Bound(2) = b2;
    end

    if abs(Bound3) <= abs(b3)
        Bound(3) = Bound3;
    else
        Bound(3) = b3;
    end

    if abs(Bound4) <= abs(b4)
        Bound(4) = Bound4;
    else
        Bound(4) = b4;
    end

    if abs(Bound5) <= abs(b5)
        Bound(5) = Bound5;
    else
        Bound(5) = b5;
    end

    if abs(Bound6) <= abs(b6)
        Bound(6) = Bound6;
    else
        Bound(6) = b6;
    end

    Map1.Boundary = Bound;
    %disp('go for PRMNode')
    Point = [RecPrmNodeMultiObs_IMP(Map1,Nneigh,risk_max*0.9,bnd,curr_point);Point];
    clear MidPoint dist mdist
end

