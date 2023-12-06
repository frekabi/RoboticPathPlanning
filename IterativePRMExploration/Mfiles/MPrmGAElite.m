function Children = MPrmGAElite(Parents,J,NElite)


%Inputs: Parents
%% Choose two sets of random parents for crossover
[Jmin,IdJmin] = min(J);
Npop = length(Parents);
Jsorted = sort(setdiff(J,Jmin));
EliteId = find(J<Jsorted(NElite),NElite);
Children = [Parents(IdJmin) Parents(EliteId)];