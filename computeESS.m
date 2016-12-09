function ESS = computeESS(theta, graph_nodes, logZ, PF_aux, PF_inputs)
    
    ESS = zeros(size(theta));
    %CovSS = zeros(length(theta),length(theta));

    for i=1:2^(sum(graph_nodes))
       y = dec2bin(i-1,sum(graph_nodes)) - '0';
       x = zeros(1, length(graph_nodes));
       x(find(graph_nodes')) = y;
       
       %[gn, PF_aux, PF_inputs] = makeAux(graph_nodes, adj, PF_main, PF_main_input);
       SS_tmp = computeSS(PF_aux, PF_inputs, x);
    
       ESS = ESS + exp(theta*SS_tmp' - logZ) * SS_tmp;
       %CovSS = CovSS + exp(theta*SS_tmp' - logZ) * (SS_tmp' * SS_tmp);
    end
    
    %CovSS = CovSS - ESS'*ESS; 

end
