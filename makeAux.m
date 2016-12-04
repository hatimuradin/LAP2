function [graph_nodes, PF_aux, PF_aux_inputs, PF_index] = makeAux(clique, adj, PF_main, PF_main_inputs)
    % Pairwise 
    graph_nodes = clique;
    PF_aux = {};
    PF_aux_inputs = {};
    PF_index = [];

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
    
    % importing q and qq' from main potential functions
    counter = 1;
    for k=1:size(PF_main_inputs, 2)
       for kk=1:size(PF_main_inputs{k}, 2)
          if (clique(PF_main_inputs{k}(kk))==1)
              PF_aux_inputs{counter} = PF_main_inputs{k};
              PF_aux{counter} = PF_main{k};
              PF_index(counter) = k;
              counter = counter + 1;
              break;
          end
       end
    end

    
    % making auxulary over 1-neighbourhood (q') not (qq') not {q}
    qp = graph_nodes - clique;
    qp (qp == -1) = [];
    [row, col, gn] = find(qp');
    for ii=1:length(col)
        PF_aux{counter} = @(x) x;
        PF_index = [PF_index 0];
        PF_aux_inputs{counter} = col(ii);
        counter = counter + 1;
        for jj=ii+1:length(col)
            PF_aux{counter} = @(x) x(1)*x(2);
            PF_index = [PF_index 0];
            PF_aux_inputs{counter} = [col(ii), col(jj)];
            counter = counter+1;
        end
    end  % finding 1-neighbour of each node of clique
           
       
    % Dense
    
    
    % Exact

end