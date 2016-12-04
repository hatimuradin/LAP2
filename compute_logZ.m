function logZ = compute_logZ (theta, graph_nodes, PF_aux, PF_inputs)

    x = zeros(1, length(graph_nodes));
    log_sum_tmp = zeros(1, 2^sum(graph_nodes));
    for i=1:2^(sum(graph_nodes))
       y = dec2bin(i-1,sum(graph_nodes)) - '0';
       x(i, find(graph_nodes')) = y;
       
       %[gn, PF_aux, PF_inputs] = makeAux(clique, adj, PF_main, PF_input);
       SS_tmp = computeSS(PF_aux, PF_inputs, x);
       log_sum_tmp(i) = theta*SS_tmp';
    end
    logZ = log_sum_exp(log_sum_tmp, 2);
end