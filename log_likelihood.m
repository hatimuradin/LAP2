function f = log_likelihood (SS, theta, clique, adj, n, logZ)
    if nargin < 9
        logZ = compute_logZ(theta, clique, adj, PF_main, PF_input);
    end
    f = theta*SS' - n*logZ;
end