function [client_theta] = auxMRFLearn(graph_nodes, PF_aux, PF_inputs, PF_index, X)
    %  Computing SS = [sumf1(samples), sumf2(samples), ..., sumfn(samples)]
    client_theta = zeros(1, size(PF_aux, 2));
    SS = computeSS(PF_aux, PF_inputs, X);
    MaxIter = 1000;
    etha = 0.001;
    share_step = 10;
    update_factor = 0.5;
    
    for iter = 1:MaxIter
        %disp(['    iter #' num2str(iter)]);
        logZ = compute_logZ(client_theta, graph_nodes, adj, PF_aux, PF_input);
        [ESS, CovSS] = computeESS(client_theta, graph_nodes, adj, logZ, PF_aux, PF_input);
        grad = (SS - size(X,1)*ESS)';
%         H = -n*CovSS;
%         H = vpa(H);
%         delta_theta = -grad'/H;
%         %%%% check stop criterion
% %         lambda2 = -grad'*H^(-1)*grad;
%         lambda2 = grad' * delta_theta';
% %         lambda2
% %         lambda2 = eval(lambda2);
%         epsilon = 0.001;
%         if (lambda2 <= epsilon * n) 
%             return;
%         end
%         %%%% compute step size
%         alpha = 0.49;
%         beta = 0.7;
% 
%         t = 1;
%         current_log_likelihood = log_likelihood(SS, theta, clique, clqAdj, d, n, logZ);
%         while true
%             if log_likelihood(SS, theta + t*delta_theta, clique, clqAdj, d, n) < current_log_likelihood + alpha*t*grad'*delta_theta'
%                 t = beta*t;
%             else
%                 break;
%             end
%         end
%         gamma = t;
%         %%%%
%         theta = theta + gamma * delta_theta;
        client_theta = client_theta + etha * grad;
        if (mod(iter, share_step) == 0)
                shareind = PF_index > 0;
                load('theta.m');
                client_theta(ind) = update_factor * theta(ind) + (1 - update_factor) * theta(ind);
        end
    end    
    %%

end