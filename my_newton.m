function theta = my_newton(theta_0, SS, n, clique, clqAdj, d)
    
    MaxIter = 100;
    theta = theta_0;
    
    for iter = 1:MaxIter
        disp(['    iter #' num2str(iter)]);
        logZ = compute_logZ(theta, clique, clqAdj, d);
        [ESS, CovSS] = computeESS(theta, clique, clqAdj, d, logZ);
        grad = (SS - n*ESS)';
        H = -n*CovSS;
        H = vpa(H);
        delta_theta = -grad'/H;
        %%%% check stop criterion
%         lambda2 = -grad'*H^(-1)*grad;
        lambda2 = grad' * delta_theta';
%         lambda2
%         lambda2 = eval(lambda2);
        epsilon = 0.001;
        if (lambda2 <= epsilon * n) 
            return;
        end
        %%%% compute step size
        alpha = 0.49;
        beta = 0.7;

        t = 1;
        current_log_likelihood = log_likelihood(SS, theta, clique, clqAdj, d, n, logZ);
        while true
            if log_likelihood(SS, theta + t*delta_theta, clique, clqAdj, d, n) < current_log_likelihood + alpha*t*grad'*delta_theta'
                t = beta*t;
            else
                break;
            end
        end
        gamma = t;
        %%%%
        theta = theta + gamma * delta_theta;
    end    
end