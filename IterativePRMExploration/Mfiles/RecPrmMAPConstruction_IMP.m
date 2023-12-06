function [Map,connectivity] = RecPrmMAPConstruction_IMP(Map0,nprm0,Nneig,ThsDist,bnd,curr_point)

Map = Map0;
tic
%Map.PRMPoints = [];
%Map.PRMGraph = [];
Board = Map.Boundary;
obs = Map.Obs;
risk_max = 0.5;
assignin("base","obs",obs)
assignin("base","Board",Board)
IsgoodMap = 0;
trymap = 0;
while IsgoodMap < 1 && trymap < 10
    clear k tcon tcounter Point G0 AddPoint count
    close all
    trymap = trymap + 1
    Point = RecPrmNodeMultiObs_IMP(Map,nprm0,risk_max,bnd,curr_point); % In this version Map should include Boundary and obs(the point cloude obtained from sensors)
    
    G0 = MPRMGraphMultiObs_IMP(Point,obs,Nneig,ThsDist);
    
    tcon = is_connected(G0);
    
    Map.PRMPoints = Point;
    Map.PRMGraph = G0;
    
    k = 1;
    count(1,1) = 1;
    tcounter(1,1) = tcon;
    [m,n] = size(Point);
    risk_max2 = 0.5;
    while tcon > 1 && k < 20
        [DefPoint,Distmean] = RecPrmFindDefectivePoint(Point,G0,2);
        %AddPoint = AddPrmNode(Board,DefPoint,obs,min(Distmean/2,ThsDist*0.75));
        AddPoint = RecPrmAddPoint_IMP(Map,DefPoint,ThsDist/2,2,risk_max2,bnd,curr_point);
        [r_a,c_a] = size(AddPoint);
        G1 = RecPRMGraphMultiObs_IMP(AddPoint,obs,min(r_a,Nneig),ThsDist);
        Nneig2 = Nneig;
        [Point,G0] = RecPrmConnectionAddPointMultiObs_IMP(G0,G1,Point,AddPoint,obs,[],Nneig2,ThsDist);
        
        [m,n] = size(Point);
        %G0 = MPRMGraphMultiObs(Point,obs,Nneig,ThsDist);
        tcon = is_connected(G0);
        k=k+1;
        count(k,1) = k;
        tcounter(k,1) = tcon;
        if length(count)>1
            figure(9) 
            plot(count,tcounter);grid on
        end
        if k >= 14 && tcon > 1
            break
            IsgoodMap = 0;
        end
        %PLOT2DMAP(Point,G0)
    end
    if k <= 14 && tcon <= 1
        IsgoodMap = 2;
    end
    
end
try
    Map.PRMPoints = Point;
    Map.PRMGraph = G0;
    Map.PointNum = length(Point);
    Map.LinkNum = length(find(G0>0))/2;
    tttmap=toc
    connectivity = [count tcounter];
    %PLOT3DMAP(Point,G0);
catch
    disp('Mapping was not successfull, try with different PRM parameters')
end