function Point = RecPrmNodeMultiObs_IMP(Map,Nprm,risk_max,bnd,curr_point)
% This function using the RiskAssementMultiObs function, to evaluate the
% collision risks with the obstacles
Bound = Map.Boundary;
Xmin = Bound(1); Xmax = Bound(2);
Ymin = Bound(3); Ymax = Bound(4);
Zmin = Bound(5); Zmax = Bound(6);


obs = Map.Obs; % In this version obs is the point set obtained from the drone 


if length(bnd)>2
    Ply_bnd = polyshape(bnd);
else
    bnd = [Xmin Ymin;Xmax Ymin;Xmax Ymax;Xmin Ymax];
    Ply_bnd = polyshape(bnd);
end

k = 0;
Xprm = [];
Yprm = [];
Zprm = [];
ss = 0;
while k <= Nprm || ss <= Nprm * 2
     ss = ss + 1;
     X0 = Xmin+(Xmax-Xmin)*rand;
     Y0 = Ymin+(Ymax-Ymin)*rand;
     Z0 = Zmin+(Zmax-Zmin)*rand;
     %risk = RiskAssessMultiObs(obs,X0,Y0,Z0);
     risk = Simple_RiskAssessMultiObs_IMP(obs,[X0,Y0,Z0],curr_point);
     if risk <= risk_max 
         if isinterior(Ply_bnd,X0,Y0)
             k = k+1;
             Xprm(k) = X0;
             Yprm(k) = Y0;
             Zprm(k) = Z0;
             rr(k) = risk;
         end
     end
end
Point = [Xprm' Yprm' Zprm'];
%histogram(rr)