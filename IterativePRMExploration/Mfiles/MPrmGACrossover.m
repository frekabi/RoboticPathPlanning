function Children = MPrmGACrossover(Parents,Nbr)


%Inputs: Parents
%% Choose two sets of random parents for crossover
Npop = length(Parents);
IdPr  = 1:Npop;
IdPr1 = randperm(Npop,Npop/2);
IdPr20 = setdiff(IdPr,IdPr1);
IdPr2 = IdPr20(randperm(Npop/2));

Parent1 = Parents(IdPr1);
Parent2 = Parents(IdPr2);
%Nagent = (length(Parent1{1})-1)/2;
Nagent = 1;
%% Create Children from Parents
for i = 1:Npop/2
    Par1 = Parent1{i};  Par2 = Parent2{i};
    Par1Dist = Par1; Par2Dist = Par2;
    Ndist = length(Par1Dist);
%     Nbr = 3;%round(Ndist/3)+1;
%     ChangDist = randperm(Ndist,Nbr);
%     ChangDist2 = ChangDist(randperm(Nbr));
%     Child1 = Par1; Child2 = Par2;
%     for j = 1:Nbr
%         Child1(find(Par1Dist == ChangDist(j)),:) = Par2(find(Par2Dist == ChangDist2(j)),:);
%         Child2(find(Par2Dist == ChangDist(j)),:) = Par1(find(Par1Dist == ChangDist2(j)),:);
%     end
    ChangPoint = randperm(Ndist,2);
    ChildId1 = 1:Ndist; 
    ChildId1(ChangPoint(1):ChangPoint(2))=fliplr(ChildId1(ChangPoint(1):ChangPoint(2)));
    Child1 = Par1(ChildId1);    
    ChangPoint = randperm(Ndist,2);
    ChildId2 = 1:Ndist; ChildId2(ChangPoint(1):ChangPoint(2))=fliplr(ChildId2(ChangPoint(1):ChangPoint(2)));
    Child2 = Par2(ChildId2);
    if Nagent>=3 
        Id1 = randperm(Ndist,Nbr);
        Id2 = randperm(Ndist,Nbr);
        for k=1:Nbr
            b1 = randperm(Nagent);b2 = randperm(Nagent);
            v = randperm(2);
            if v == 1
                Ch1 = Child1(Id1(k),2:end);
                Ch1(b1:b2) = fliplr(Ch1(b1:b2));
                Child1(Id1(k),2:end) = Ch1;
                b1 = randperm(Nagent);b2 = randperm(Nagent);
                Ch2 = Child2(Id2(k),2:end);
                Ch2(b1:b2) = fliplr(Ch2(b1:b2));
                Child2(Id2(k),2:end) = Ch2;
            else
                Ch1 = Child1(Id1(k),2:end);
                Ch1(b1+Nagent:b2+Nagent) = fliplr(Ch1(b1+Nagent:b2+Nagent));
                Child1(Id1(k),2:end) = Ch1;
                b1 = randperm(Nagent);b2 = randperm(Nagent);
                Ch2 = Child2(Id2(k),2:end);
                Ch2(b1+Nagent:b2+Nagent) = fliplr(Ch2(b1+Nagent:b2+Nagent));
                Child2(Id2(k),2:end) = Ch2;
            end
        end
    end
    Children{i} = Child1;
    Children{i+Npop/2} = Child2;
end
            
    