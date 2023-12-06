function PopSelect = MPrmGAStocSelection(Population,Nsel)

Npop = length(Population);
SelId = randperm(Npop,Nsel);

PopSelect = Population(SelId);