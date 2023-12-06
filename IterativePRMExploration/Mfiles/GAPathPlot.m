function []=GAPathPlot(TaskSet,Pop)

[r,c] = size(TaskSet.District{1});
Nagent = r-1;
DistId = Pop(:,1);  
Ndist = length(DistId);
if Nagent>1
    AgPos = Pop(:,2:Nagent+1);
    AgPri = Pop(:,Nagent+2:2*Nagent+1);
else
    AgPos = 1*ones(Ndist,1);
    AgPri = 1*ones(Ndist,1);
end
for j = 1:Ndist-1
    DistSt = TaskSet.District{DistId(j)};
    DistStPoint = [DistSt(2:end,:) TaskSet.hDistrict(DistId(j))*ones(Nagent,1)];
    DistFi = TaskSet.District{DistId(j+1)};
    DistFiPoint = [DistFi(2:end,:) TaskSet.hDistrict(DistId(j+1))*ones(Nagent,1)];
    for k = 1:Nagent
        AgId = AgPri(j,k);
        StartId = find(AgPos(j,:) == AgId);
        FinalId = find(AgPos(j+1,:) == AgId);
        plot3([DistStPoint(StartId,1);DistFiPoint(FinalId,1)],[DistStPoint(StartId,2);DistFiPoint(FinalId,2)],[DistStPoint(StartId,3);DistFiPoint(FinalId,3)],'--*','LineWidt',2,'Color',[0.75*AgId/Nagent,0.5*AgId/Nagent+0.2,0.25*AgId/Nagent+0.5]);
        hold on;grid on
    end
end