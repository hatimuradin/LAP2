function [graph_nodes, PF_aux, PF_inputs, PF_index] = makeAux(clique, adj, PF_main, PF_main_input)
    % Pairwise 
    graph_nodes = clique;
    PF_aux = PF_main;
    PF_inputs = PF_main_input;
    PF_index = 1:size(PF_main);
    
    k=1;

%     v = find(clique');
%     for i=1:length(v)
%         PF_aux{k} = @(x) x;
%         PF_inputs{k} = X(:, v(i));
%         k = k+1;
%         for j=i+1:length(v)
%             PF_aux{k} = @(x) x(1)*x(2);
%             PF_inputs{k} = X(:,[v(i) v(j)]); 
%             
%             %set value equal to one for indices of a clique and 1
%             %additional zero for theta
%             k = k+1;
%         end
%     end
    
    v = find(clique');
    for i=1:length(v)
        for ii=1:size(adj,1)
            if (   (adj(ii, v(i)) == 1) && isempty(find(find(clique) == ii , 1)) )
                % add 1-neighbours to graph_nodes of aux graph 
                graph_nodes(ii) = 1;
                
            end
        end
    end
    
    % making auxulary over 1-neighbourhood (q') not (qq')
    qp = graph_nodes - cliques;
    qp (ap == -1) = [];
    [row, col, gn] = find(qp);
    for ii=1:length(col)
        for jj=ii+1:length(col)
            PF_aux{k} = @(x) x(1)*x(2);
            PF_index = [PF_index 0];
            PF_inputs{k} = [col(ii), col(jj)];
            k = k+1;
        end
    end  % finding 1-neighbour of each node of clique
           
       
    % Dense
    
    
    % Exact

end