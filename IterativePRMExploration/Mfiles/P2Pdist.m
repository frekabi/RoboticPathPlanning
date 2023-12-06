function d = P2Pdist(Point1,Point2)
dpx = Point2(:,1) - Point1(:,1);
dpy = Point2(:,2) - Point1(:,2);
dpz = Point2(:,3) - Point1(:,3);
dp = [dpx dpy dpz];
d = sqrt(diag(dp*dp'));