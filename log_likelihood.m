function f = log_likelihood (SS, theta, graph_nodes, n, PF_aux, PF_inputs, logZ)
    if nargin < 9
        logZ = compute_logZ(theta, graph_nodes, PF_aux, PF_inputs);
    end
    f = theta*SS' - n*logZ;
end