function [SS] = computeSS(PF, PF_inputs, X)
    SS = zeros(1, size(PF, 2));
    for i=1:size(find(~cellfun(@isempty, PF)), 2)
        for j=1:size(X,1)
             SS(i) = SS(i) + PF{i}(X(j, PF_inputs{i}));
        end
    end
end