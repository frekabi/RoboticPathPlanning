function [dist,Path] = FindPathPRM(G,S,T)

h = (graph(G));
[Path,dist] = shortestpath(h,S,T);
% set(h.Nodes(Path),'Color',[1 0.4 0.4])
% edges = getedgesbynodeid(h,get(h.Nodes(Path),'ID'));
% set(edges,'LineColor',[1 0 0])
% set(edges,'LineWidth',1.5)