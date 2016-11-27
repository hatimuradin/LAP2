function [ESS, CovSS] = computeESS(theta, graph_nodes, adj, logZ,PF_main, PF_main_input)
    
    ESS = zeros(size(theta));
    CovSS = zeros(length(theta),length(theta));

    x = zeros(2^length(graph_nodes), size(adj, 1));
    for i=1:2^(length(graph_nodes))
       y = dec2bin(i-1,sum(graph_nodes)) - '0';
       x(clqNodes) = y;
       
       [gn, PF_aux, PF_inputs] = makeAux(graph_nodes, adj, PF_main, PF_main_input);
       SS_tmp = computeSS(PF_aux, PF_inputs, x);
    
       ESS = ESS + exp(theta*SS_tmp' - logZ) * SS_tmp;
       CovSS = CovSS + exp(theta*SS_tmp' - logZ) * (SS_tmp' * SS_tmp);
    end
    
    CovSS = CovSS - ESS'*ESS; 

end
