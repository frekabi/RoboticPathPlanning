function Children = MPrmGAMutation(Parents)


%Inputs: Parents
%% Choose two sets of random parents for crossover
Npop = length(Parents);

for i = 1:Npop
    Par = Parents{i};
    Ndist = length(Par);
    Nmut = 2;%round(Ndist/4)+1;
    Nagent = 1;%(lchr-1)/2;
    ChangChrom = randperm(Ndist,Nmut);
    ChangOrderDist = ChangChrom(randperm(Nmut));
    Child = Par;
%     for j = 1:Nmut
%         Child(ChangChrom(j),:) = [Par(ChangOrderDist(j),1) randperm(Nagent) randperm(Nagent)];
%     end
    Child(ChangChrom) = Par(ChangOrderDist);
    Children{i} = Child;
end