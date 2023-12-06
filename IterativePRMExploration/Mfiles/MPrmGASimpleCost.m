function J = MPrmGASimpleCost(Population,Map,TaskSet,Sag)



Npop = length(Population);
[r,c] = size(TaskSet.District{1});
Nagent = 1; %r-1;
for i = 1:Npop
    Pop = Population{i};
    DistId = Pop;  
    Ndist = length(DistId);
    if Nagent>1
        AgPos = Pop(:,2:Nagent+1);
        AgPri = Pop(:,Nagent+2:2*Nagent+1);
    else
        AgPos = 1*ones(Ndist,1);
        AgPri = 1*ones(Ndist,1);
    end
    
    for j = 1:Ndist
        if j<2
            DistStPoint = Sag;
            DistFi = TaskSet.District{DistId(j)};
            DistFiPoint = [DistFi TaskSet.hDistrict(DistId(j))*ones(Nagent,1)];
        else
            DistSt = TaskSet.District{DistId(j-1)};
            DistStPoint = [DistSt TaskSet.hDistrict(DistId(j-1))*ones(Nagent,1)];
            DistFi = TaskSet.District{DistId(j)};
            DistFiPoint = [DistFi TaskSet.hDistrict(DistId(j))*ones(Nagent,1)];
        end
        %for k = 1:Nagent
            %if j<2
             %   AgId = k;
              %  StartId = k;
           % else
            %    AgId = AgPri(j-1,k);
             %   StartId = find(AgPos(j-1,:) == AgId);
           % end
           % FinalId = find(AgPos(j,:) == AgId);
            %GG2 = ConnectionSTMultiObs(Map,DistStPoint(StartId,:),DistFiPoint(FinalId,:));
            %GG12 = sparse(GG2);
            %[dist,Path] = FindPathPRM(GG12,1,2);
            %L0(k) = P2Pdist(DistStPoint(StartId,:),DistFiPoint(FinalId,:));
            try
                L0 = P2Pdist(DistStPoint,DistFiPoint);
            catch
                disp(TaskSet.District)
                disp(DistFiPoint)
                disp(DistStPoint)
                pause 
            end
         %end
            %L0(k) = dist;
            %L1(j) = sum(L0);
            L1(j) = L0;
    end
    J(i) = sum(L1);
end