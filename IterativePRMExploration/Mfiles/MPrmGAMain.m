function [BestPop,Jmin] = MPrmGAMain(Map,TaskSet,StartPoint)

%% Define Genetic Parameters
Npop = 100;  NpopF = 100;    Ngen = 5000;     Ncross = Npop*0.8;      NElite = Npop*0.1;
NMut = Npop - Ncross - NElite;
NMig = 10;
%load Map20.mat
obs = Map.Obs;
Sag = StartPoint;
%load TaskSet15
%load Sag06
% Sag = [-10 0 5];
%% 
Boundary = Map.Boundary;
% Board = Boundary;
Xmin = Boundary(1);     Xmax = Boundary(2);     Ymin = Boundary(3);
Ymax = Boundary(4);     Zmin = Boundary(5);     Zmax = Boundary(6);
Board.Xmin = Xmin; Board.Xmax = Xmax; Board.Ymin = Ymin; Board.Ymax = Ymax; Board.Zmin = Zmin; Board.Zmax = Zmax;
InitPopulation = MPrmGAInitPopulation(Npop,TaskSet);
i = 0;
Population = InitPopulation;
Nbr = 3;
StopCriteria = 2;


while i<Ngen && StopCriteria>0.001
    i = i+1;
%     kk = i
    J = MPrmGASimpleCost(Population,Map,TaskSet,Sag);
    Lpop = length(Population);
    ElitChild = MPrmGAElite(Population,J,NElite);
%     if Lpop>NpopF
%         [Population,J] = GAMigration(Population,J,NMig);
%         Npop = length(Population);
%         Ncross = 2*round(0.5*Npop*0.8);
%         NElite = round(Npop*0.05);
%         NMut = Npop - Ncross - NElite;
%     end
    
%     CrossParent = GARoullSelection(Population,J,Ncross);
    CrossParent = MPrmGAStocSelection(Population,Ncross);
    CrossChild = MPrmGACrossover(CrossParent,Nbr);
    MutParent = MPrmGAStocSelection(Population,NMut);
    MutChild = MPrmGAMutation(MutParent);
    [Jmin(i),Idmin] = min(J);
    BestPop = Population{Idmin};
    Population = [ElitChild CrossChild MutChild];
    figure(1)
    subplot(2,1,1)
    plot(i,Jmin(i),'r*'); hold on; title(['min cost is ',num2str(Jmin(i)),' and average cost is: ',num2str(mean(J))]);
    subplot(2,1,2)
    bar(BestPop); title('Best is: ');
    if i>201
        StopCriteria = mean(Jmin(i-200:i))/Jmin(i)-1;
    end

end
figure
GAPathPlot(TaskSet,BestPop)
%PLOT3DObsTGWP(TaskSet,Map.Obs)
    