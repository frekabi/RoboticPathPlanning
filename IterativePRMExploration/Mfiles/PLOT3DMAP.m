function [] = PLOT3DMAP(Point,G)
obs = evalin('base','obs');
board = evalin('base','Board');
 for i = 1:length(obs)
    node = cell2mat(obs(i));
    x_n = node(:,1); y_n = node(:,2); H_E = node(1,3);
    for j=1:length(x_n)
        if j+1<=length(x_n)
            X(j,:) = [x_n(j) x_n(j) x_n(j+1) x_n(j+1)];
            Y(j,:) = [y_n(j) y_n(j) y_n(j+1) y_n(j+1)];
            Z(j,:) = [0 H_E 0 H_E];
        else
            X(j,:) = [x_n(j) x_n(j) x_n(1) x_n(1)];
            Y(j,:) = [y_n(j) y_n(j) y_n(1) y_n(1)];
            Z(j,:) = [0 H_E 0 H_E];
        end
    end
    figure(10)
    surf(X,Y,Z);grid on;hold on    
    axis tight
    clear X Y Z
 end
    plot3(Point(:,1),Point(:,2),Point(:,3),'*'); 
    [m,n] = size(G);
    for i=1:m
        for j= 1:n
            if G(i,j)>0
                plot3([Point(i,1);Point(j,1)],[Point(i,2);Point(j,2)],[Point(i,3);Point(j,3)],'Color',[0.65 0.35 0]);
            end
        end
    end
   