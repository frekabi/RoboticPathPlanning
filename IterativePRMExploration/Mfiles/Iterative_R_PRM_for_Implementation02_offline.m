clear
clc
close all


% load('MapForExp01.mat')
load('Map21.mat')
k = length(Map.Obs);
OBSVt = [];
for i = 1:k
    bound_k = cell2mat(Map.Obs(i));
    OBSVt = [OBSVt;bound_k(:,1:2)];
    OBSVt = [OBSVt;nan nan];
    h_obs(i) = bound_k(1,3);
    clear bound_k
end
Map_Polyin = polyshape(OBSVt);
Map_reg = regions(Map_Polyin);
[Map_C_x,Map_C_y] = centroid(Map_reg);
Map_C = [Map_C_x Map_C_y];

%% Initialize the robot position
robotinfo.x0 = 0;%-27.5;
robotinfo.y0 = 0;%-12.4;
robotinfo.z0 = 0;
misinfo.R_s = 25;
misinfo.D_z = 100;
misinfo.nprm0 = 50;
misinfo.Nneig = 10;
misinfo.ThsDist = 25;
robotinfo.Spos = [robotinfo.x0;robotinfo.y0;robotinfo.z0];
Tdist(1).C = robotinfo.Spos;
Map_new.Obs = Map.Obs;
%EnvironmentData(Map_reg,robotinfo.Spos(1:2)',h_obs);
Map_new.Boundary(1) = max((Tdist(1).C(1) - misinfo.R_s),Map.Boundary(1));
Map_new.Boundary(2) = min((Tdist(1).C(1) + misinfo.R_s),Map.Boundary(2));
Map_new.Boundary(3) = max((Tdist(1).C(2) - misinfo.R_s),Map.Boundary(3));
Map_new.Boundary(4) = min((Tdist(1).C(2) + misinfo.R_s),Map.Boundary(4));
Map_new.Boundary(5) = max(Tdist(1).C(3) - misinfo.D_z,Map.Boundary(5));
Map_new.Boundary(6) = min(Tdist(1).C(3) + misinfo.D_z,Map.Boundary(6));
Dist_Centers = [];
NDist = 6;%round((Map.Boundary(2)-Map.Boundary(1))*(Map.Boundary(4)-Map.Boundary(3)))/misinfo.R_s^2;

%%********Set the next district center************%
t = 1;
while t <= NDist
    temp_Centers_X = Map.Boundary(1) + (Map.Boundary(2) - Map.Boundary(1)) * rand(1,1);% randi([Map.Boundary(1)*10 Map.Boundary(2)*10],NDist,1)/10;
    temp_Centers_Y = Map.Boundary(3) + (Map.Boundary(4) - Map.Boundary(3)) * rand(1,1);%randi([Map.Boundary(3)*10 Map.Boundary(4)*10],NDist,1)/10;
    temp_Centers_Z = Map.Boundary(5) + (Map.Boundary(6) - Map.Boundary(5)) * rand(1,1);%randi([Map.Boundary(5)*10 Map.Boundary(6)*10],NDist,1)/10;
    pnt = [temp_Centers_X temp_Centers_Y];
    if t > 1
        ddist = diag((temp_Centers(:,1:2) - pnt)*(temp_Centers(:,1:2) - pnt)').^0.5;
        if min(ddist) >= misinfo.R_s
            temp_Centers(t,:) = [temp_Centers_X temp_Centers_Y temp_Centers_Z];
            t = t + 1;
        end
    else
        temp_Centers(t,:) = [temp_Centers_X temp_Centers_Y temp_Centers_Z];
        t = t + 1;
    end
    
end
TaskSet.NumDistrict = 1:NDist;
for i =1:NDist
    TaskSet.District{i} = temp_Centers(i,1:2);
    TaskSet.hDistrict(i) = temp_Centers(i,3);
end

%% find the optimal path to pass between the center points
[BestPop,Jmin] = MPrmGAMain(Map,TaskSet,robotinfo.Spos');
temp_Centers = temp_Centers(BestPop,:);
[Vn_vertex,Vn_bnd,Vn_XY] = VoronoiLimit(temp_Centers(:,1),temp_Centers(:,2));
% The VoronoiLimit function doesnt return the district as the order we made
% in the temp_Centers, so we need to reorder the districts in the following
% loop
if length(temp_Centers) > 2
    for i = 1:length(temp_Centers)
        [rowc,colc] = find(Vn_XY == temp_Centers(i,1:2));
        id_s(i) = rowc(1);
    end
end

Vn_bnd = Vn_bnd(id_s,:);
Vn_XY = Vn_XY(id_s,:);

beta = 0;
beta = 0;

should_cont = 1;
Dcount = 1;
tt = 0;
count = 0;
FMap.PRMPoints = [];
FMap.Obs = [];
FMap.PRMGraph = [];
FMap.Boundary = Map.Boundary;
alp_view = 45 * pi/180;
FMap.CoverPoly = [];
PathPoint = [];
FMap0 = FMap;
obs = [];
for i = 1:NDist
    disp(['District number: ',num2str(i)])
    is_not_new_C = 1;
    count = 0;

    Tdist(i).C = temp_Centers(i,:);
    
    clear Map_new %sp2c_dist
    bnd_vrtx = cell2mat(Vn_bnd(i));
    bnd = Vn_vertex(bnd_vrtx,:);

    %%%###################Here We should get the points from ROS###########################
    %Map_new.Obs = []; %In this version obs should be the point cloud collected from sensor
    %Map_new.Obs = Rec_PRM_Env_Sim(Vn_vertex(bnd_vrtx,:));
    %%% we need a command to initialize data collection and it should come
    %%% from python state-machine
%     mission_state = Rec_PRM_Rec_state();
%     while mission_state ~= 'Data_collection'
%         mission_state = Rec_PRM_Rec_state();
%         pause(0.1)
%     end
%     da_time = 6;
%     da_freq = 0.5;
%     Map_new.Obs = RecPRM_RecPoints_IMP(da_time,da_freq);
%     obs = [obs;Map_new.Obs];
    Map_new.Obs = Rec_PRM_Env_Sim(Map,Vn_vertex(bnd_vrtx,:),robotinfo.Spos);
    obs = [obs;Map_new.Obs];
    %%%####################################################################################

    
    %bnd_center = mean(bnd)

    Map_new.Boundary = BoundaryCheck(bnd,Map.Boundary,alp_view,misinfo.D_z);
    [Tdist(i).Map,Tdist(i).connectivity] = RecPrmMAPConstruction_IMP(Map_new,misinfo.nprm0,misinfo.Nneig,misinfo.ThsDist,bnd,robotinfo.Spos);%RecPrmMAPConstruction_IMP(Map_new,misinfo.nprm0,misinfo.Nneig,misinfo.ThsDist,bnd);

    if i <= 1
        FMap.PRMPoints = Tdist(i).Map.PRMPoints;
        FMap.PRMGraph = Tdist(i).Map.PRMGraph;
        FMap.Obs = obs;
    else
        [FMap.PRMPoints,FMap.PRMGraph] = RecPrmConnectionAddPointMultiObs_IMP(FMap.PRMGraph,Tdist(i).Map.PRMGraph,FMap.PRMPoints,Tdist(i).Map.PRMPoints,Map_new.Obs,FMap.Obs,misinfo.Nneig,misinfo.ThsDist);
        FMap.Obs = obs;
    end

    if i <= 1
        FMap0.PRMPoints = Tdist(i).Map.PRMPoints;
        FMap0.PRMGraph = Tdist(i).Map.PRMGraph;
        FMap0.Obs = Map_new.Obs;
    else
        [FMap0.PRMPoints,FMap0.PRMGraph] = RecPrmConnectionAddPointMultiObs_IMP(Tdist(i-1).Map.PRMGraph,Tdist(i).Map.PRMGraph,Tdist(i-1).Map.PRMPoints,Tdist(i).Map.PRMPoints,Map_new.Obs,Map_old.Obs,misinfo.Nneig,misinfo.ThsDist);
        FMap0.Obs = [Map_new.Obs;Map_old.Obs];
    end

    for j = 1:length(Tdist(i).Map.PRMPoints)
        g_point = Tdist(i).Map.PRMPoints(j,:);
        Targetdist(j) = norm(g_point - Tdist(i).C);
    end
    [dmin,id_dmin] = min(Targetdist);

    Tdist(i).TargetPoint = Tdist(i).Map.PRMPoints(id_dmin,:); 
    Tdist(i).StartPoint = robotinfo.Spos;   

    if i >= 2
        G2 = RecPrmConnectionSTMultiObs_IMP(FMap0,Tdist(i).StartPoint,Tdist(i).TargetPoint,misinfo.ThsDist);
    else
        G2 = RecPrmConnectionSTMultiObs_IMP(FMap0,Tdist(i).StartPoint,Tdist(i).TargetPoint,100);
    end
    GG12 = sparse(G2);
    [Tdist(i).PathDistance,Tdist(i).Path] = FindPathPRM(GG12,1,2);
    Tdist(i).Path(2:end-1) = Tdist(i).Path(2:end-1) - 2;

    if i > 1
        New_PathPoint = [FMap0.PRMPoints(Tdist(i).Path(2:end-1),:);Tdist(i).TargetPoint];
        PathPoint = [PathPoint;FMap0.PRMPoints(Tdist(i).Path(2:end-1),:);Tdist(i).TargetPoint];
    else
        if length(Tdist(i).Path) > 2
            New_PathPoint = [Tdist(i).StartPoint';FMap0.PRMPoints(Tdist(i).Path(2:end-1),:);Tdist(i).TargetPoint];
            PathPoint = [Tdist(i).StartPoint';FMap0.PRMPoints(Tdist(i).Path(2:end-1),:);Tdist(i).TargetPoint];
        else
            New_PathPoint = [Tdist(i).StartPoint';Tdist(i).TargetPoint];
            PathPoint = [Tdist(i).StartPoint';Tdist(i).TargetPoint];
        end
    end

   

    beta = atan2(Tdist(i).TargetPoint(2)-Tdist(i).StartPoint(2),Tdist(i).TargetPoint(1)-Tdist(i).StartPoint(1));
    %temp_Centers = setdiff(temp_Centers,temp_Centers(Id_next_c,:),'rows');
    robotinfo.Spos = Tdist(i).TargetPoint';
    
    Tdist_xmin = min(Tdist(i).Map.PRMPoints(:,1));
    Tdist_xmax = max(Tdist(i).Map.PRMPoints(:,1));
    Tdist_ymin = min(Tdist(i).Map.PRMPoints(:,2));
    Tdist_ymax = max(Tdist(i).Map.PRMPoints(:,2));
    node_cover_1 = [Tdist_xmin Tdist_ymin];
    node_cover_2 = [Tdist_xmax Tdist_ymin];
    node_cover_3 = [Tdist_xmax Tdist_ymax];
    node_cover_4 = [Tdist_xmin Tdist_ymax];
    
    if length(bnd)>2
        Poly_temp = subtract(intersect(polyshape(bnd),polyshape([node_cover_1;node_cover_2;node_cover_3;node_cover_4])),Map_Polyin);
        FMap.CoverPoly = [FMap.CoverPoly,Poly_temp];
    else
        Poly_temp = polyshape([node_cover_1;node_cover_2;node_cover_3;node_cover_4]);
        FMap.CoverPoly = [FMap.CoverPoly,Poly_temp];
    end
    Dcount = Dcount + 1;
    Map_old = Map_new;
    %%%%###############################################################################
    %########################Her We should send New_PathPoint#########################
%     if i < NDist
%         Rec_PRM_Com_Send_IMP(New_PathPoint,0)
%     else
%         Rec_PRM_Com_Send_IMP(New_PathPoint,1)
%     end


    %%%%###############################################################################
    clear g_point Targetdist
     
end
    
k = length(Tdist);

tcon_final = is_connected(FMap.PRMGraph)
Point = FMap.PRMPoints;
G0 = FMap.PRMGraph;
obs0 = obs;
clear obs 
obs = Map.Obs;

Scover_t = sum(area(FMap.CoverPoly));
FPolyin_Intersect = intersect(FMap.CoverPoly);
Scover_rep = Scover_t - area(union(FMap.CoverPoly));
Scover_effective = area(union(FMap.CoverPoly));
Bx_min = min(Vn_vertex(:,1));
Bx_max = max(Vn_vertex(:,1));
By_min = min(Vn_vertex(:,2));
By_max = max(Vn_vertex(:,2));
%Stotal = (Map.Boundary(2)-Map.Boundary(1)) * (Map.Boundary(4)-Map.Boundary(3)) - area(Map_Polyin) - area(Map_Polyin);
Stotal = (Bx_max - Bx_min) * (By_max - By_min) - area(Map_Polyin);% - area(Map_Polyin);

Rcover_ef = Scover_effective / Stotal
Rcover_rep = Scover_rep / Stotal
PLOT3DMAP(Point,G0);hold on
ll = 0;
for i = 1:length(Tdist)
    ll = ll + length(Tdist(i).Map.PRMPoints);
    STPoints(i,:) = Tdist(i).StartPoint;
    plot3(Tdist(i).C(1),Tdist(i).C(2),Tdist(i).C(3),'r d','MarkerSize',10,'MarkerFaceColor',[1 0 0])
end
plot3(PathPoint(:,1),PathPoint(:,2),PathPoint(:,3),'y','LineWidth',3,'Marker','s','MarkerSize',10,'MarkerFaceColor',[1 1 0])
plot(union(FMap.CoverPoly))


