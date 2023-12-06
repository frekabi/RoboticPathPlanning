function [F_risk] = Simple_RiskAssessMultiObs_IMP(obs_point,point,curr_point)

l = length(obs_point);
% if l>= 1 
%     for k = 1:l
%         Distc(k) = norm(obs_point(k,:) - curr_point);
%     end
%     [Dclose_cuur_pos,id] = min(Distc);
% else
%     Dclose_cuur_pos = 100;
% end

D_p2p = norm(curr_point - point);
if l >= 3
    %if D_p2p <= Dclose_cuur_pos
        for k = 1:l
        Dist_xy(k) = norm(obs_point(k,1:2) - point(1,1:2));
        Dist_z(k) = norm(obs_point(k,3) - point(1,3));
        end
        [Dclose_xy,id] = min(Dist_xy);
        Dclose_z = Dist_z(id);
        Dclose = 0.5 * Dclose_z + 0.5 * Dclose_xy;
    %else
     %   Dclose = 0;
    %end
    P0 = curr_point';
    P1 = obs_point(id,:);
    P2 = point;
    dP12 = P2 - P1;
    dP10 = P0 - P1;
    calpha = dot(dP12,dP10) / (norm(dP10) * norm(dP12));
    if calpha < 0
        Dclose = 0;
    end
else
Dclose = 100;
end
F_risk = 0.3/(Dclose+0.01);
if F_risk >= 1
    F_risk = 1;
end

