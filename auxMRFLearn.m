function [client_theta] = auxMRFLearn(graph_nodes, PF_aux, PF_inputs, PF_index, X)
    %  Computing SS = [sumf1(samples), sumf2(samples), ..., sumfn(samples)]
    client_theta = zeros(1, size(PF_aux, 2));
    SS = computeSS(PF_aux, PF_inputs, X);
    MaxIter = 1000;
    share_step = 200;
    update_factor = 0.5;
    
    for iter = 1:MaxIter
        %disp(['    iter #' num2str(iter)]);
        %fprintf('time of logZ:\n');
        %tic
        logZ = compute_logZ(client_theta, graph_nodes, PF_aux, PF_inputs);
        %toc
        
        %fprintf('time of computeESS:\n');
        %tic
        ESS = computeESS(client_theta, graph_nodes, logZ, PF_aux, PF_inputs);
        %toc
        grad = (SS - size(X,1)*ESS);
        delta_theta = grad;
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
        %%%% compute step size
        alpha = 0.49;
        beta = 0.7;

        etha = 1;
        
        %fprintf('time of line_search:\n');
        %tic 
        current_log_likelihood = log_likelihood(SS, client_theta, graph_nodes, size(X,1), PF_aux, PF_inputs, logZ); 
        while true
            if log_likelihood(SS, client_theta + etha*delta_theta, graph_nodes, size(X,1), PF_aux, PF_inputs, logZ) < current_log_likelihood + alpha*etha*grad*delta_theta'
                etha = beta*etha;
            else
                break;
            end
        end
        %toc 
        %%%%
        client_theta = client_theta + etha * delta_theta
        
        theta = [];
        if (mod(iter, share_step) == 0)
                shareind = PF_index > 0;
                load('theta.mat', 'theta');
                client_theta(shareind) = update_factor * theta(PF_index(shareind)) + (1 - update_factor) * client_theta(shareind);
                theta(PF_index(shareind)) = client_theta(shareind);
                save('theta.mat', 'theta');
        end
    end    
    %%

end