function InitPopulation = MPrmGAInitPopulation(NPop,TaskSet)
% Input: Nagent, Ntask, Population Size
[r,c] = size(TaskSet.District{1});
%Nagent = r-1;
Ntask = max(TaskSet.NumDistrict);
for j = 1:NPop
    Popj = randperm(Ntask);
    Pop{j} = Popj;
end
InitPopulation = Pop;