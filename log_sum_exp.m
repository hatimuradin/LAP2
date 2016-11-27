function [ s ] = log_sum_exp( a , d )
    mx = max(a,[],d);
    rp = ones(1,length(size(a)));
    rp(d) = size(a,d);
    s = mx + log(sum( exp(a-repmat(mx,rp)), d));
    s = double(s);
end

