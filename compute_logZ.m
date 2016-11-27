function logZ = compute_logZ (theta, graph_nodes, adj, PF_main, PF_input)

    x = zeros(2^length(graph_nodes), size(adj, 1));
    for i=1:2^(length(graph_nodes))
       y = dec2bin(i-1,size(graph_nodes, 2)) - '0';
       x(clqNodes) = y;
       
       [gn, PF_aux, PF_inputs] = makeAux(clique, adj, PF_main, PF_input);
       SS_tmp = computeSS(PF_aux, PF_inputs, x);
       log_sum_tmp(i) = theta*SS_tmp';
    end
    logZ = log_sum_exp(log_sum_tmp, 2);

end