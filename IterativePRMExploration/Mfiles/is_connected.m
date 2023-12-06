function num = is_connected( G )

% Get eigenvalues of laplacian
L = laplacian(G);
lambda = eig(L);

% Get number of zero eigenvalues
num=sum(lambda<=0.00001);

% Display
if (num>1)
   disp(['Graph is not connected. ' num2str(num) ' connected subgraphs.']);   
else
   disp('Graph is connected!'); 
end
end

