function [Point,G] = RecPrmConnectionAddPointMultiObs_IMP(G1,G2,Point1,Point2,obs1,obs2,Nneig,ThDist)

% PointF(1,:) = S; PointF(2,:) = T;
Point = [Point1;Point2];
G0 = blkdiag(G1,G2);
obs = [obs1;obs2];
[K_obs,ss] = size(obs);
[l1,c1] = size(Point1);
[l2,c2] = size(Point2);
ISECXY =0;
ISECZ =0;
Safe_Dist = 10;
D2line = [];
ISECZ_k = [];
for i = 1:l1
    for j = 1:l2
        Gdist(i,j) = norm(Point1(i,:) - Point2(j,:));
        if Gdist(i,j) <= ThDist * 2
            line_Pi_Pj = [Point1(i,1) Point1(i,2);Point2(j,1) Point2(j,2)];
            ISECZ_k = [];
            for k = 1:K_obs
                D2line(k) = abs(obs(k,2) - Point1(i,2) - (Point2(j,2)-Point1(i,2))/(Point2(j,1)-Point1(i,1)) * (obs(k,1)-Point1(i,1)));
                if obs(k,3) >= min([Point1(i,3),Point2(j,3)])
                    if obs(k,3) >= max([Point1(i,3),Point2(j,3)])
                        ISECZ_k(k) = 1;
                    end
                end
            end

            if ~isempty(D2line)
                D2line_min = min(D2line);
                if D2line_min <= Safe_Dist
                    ISECXY = 1;
                else
                    ISECXY = 0;
                end
            else
                ISECXY = 0;
            end

            if ~isempty(ISECZ_k)
                ISECZ = any(ISECZ_k);
            else
                ISECZ = 0;
            end
            
            ISECT = (and(ISECXY,ISECZ));

            if sum(ISECT) > 0
                continue
            else
                if sum(G0(i,:) > 0) <= Nneig
                    G0(i,j+l1) = Gdist(i,j);
                    G0(j+l1,i) = Gdist(i,j);
                end
            end
        end
    end
end

G = G0;