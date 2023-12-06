function boundary = BoundaryCheck(bnd,Boundary,alp_view,D_z)

Xlim1_bnd = Boundary(1); Xlim2_bnd = Boundary(2);
Ylim1_bnd = Boundary(3); Ylim2_bnd = Boundary(4);


% bnd_nod1 = [Xlim1_bnd Ylim1_bnd]; bnd_nod2 = [Xlim2_bnd Ylim1_bnd];
% bnd_nod3 = [Xlim2_bnd Ylim2_bnd]; bnd_nod4 = [Xlim1_bnd Ylim2_bnd];
% bnd_vrtx =  [bnd_nod1;bnd_nod2;bnd_nod3;bnd_nod4];
% bnd_poly = polyshape(bnd_vrtx);

% if max(isinf(bnd),[],'all') < 1 
%   Xmin = max(min(bnd(:,1)),Boundary(1));
%   Xmax = min(max(bnd(:,1)),Boundary(2));
%   Ymin = max(min(bnd(:,2)),Boundary(3));
%   Ymax = min(max(bnd(:,2)),Boundary(4));
%   h_orb = ((area(polyshape(bnd))/pi)^0.5)/tan(alp_view);
%   Zmin = max(h_orb - D_z,Boundary(5));
%   Zmax = min(h_orb + D_z,Boundary(6));
% else
%   bnd_m = intersect(polyshape(bnd),bnd_poly)
%   Xmin = max(mean(bnd(:,1)) - h_orb * tan(alp_view),Boundary(1));
%   Xmax = min(mean(bnd(:,1)) + h_orb * tan(alp_view),Boundary(2));
%   Ymin = max(mean(bnd(:,2)) - h_orb * tan(alp_view),Boundary(3));
%   Ymax = min(mean(bnd(:,2)) + h_orb * tan(alp_view),Boundary(4));
%   Zmin = max(h_orb - D_z,Boundary(5));
%   Zmax = min(h_orb + D_z,Boundary(6));
% end

Xmin = max(min(bnd(:,1)),Boundary(1));
Xmax = min(max(bnd(:,1)),Boundary(2));
Ymin = max(min(bnd(:,2)),Boundary(3));
Ymax = min(max(bnd(:,2)),Boundary(4));
h_orb = ((area(polyshape(bnd))/pi)^0.5)/tan(alp_view);
Zmin = max(h_orb - D_z,Boundary(5));
Zmax = min(h_orb + D_z,Boundary(6));

if Xmin < Boundary(1)
    Xmin = Boundary(1);
elseif Xmin > Boundary(2)
    Xmin = Boundary(2);
end

if Xmax < Boundary(1)
    Xmax = Boundary(1);
elseif Xmax > Boundary(2)
    Xmax = Boundary(2);
end

if Ymin < Boundary(3)
    Ymin = Boundary(3);
elseif Ymin > Boundary(4)
    Ymin = Boundary(4);
end

if Ymax < Boundary(3)
    Ymax = Boundary(3);
elseif Ymax > Boundary(4)
    Ymax = Boundary(4);
end

if Zmin < Boundary(5)
    Zmin = Boundary(5);
elseif Zmin > Boundary(6)
    Zmin = Boundary(6);
end

if Zmax < Boundary(5)
    Zmax = Boundary(5);
elseif Zmax > Boundary(6)
    Zmax = Boundary(6);
end

boundary(1) = Xmin; boundary(2) = Xmax;
boundary(3) = Ymin; boundary(4) = Ymax;
boundary(5) = Zmin; boundary(6) = Zmax;
