clear all;

digits(100);

%Grid-like graph
graphHeight = 4;
graphWidth = 4;

numSamples = 5;

totalFeatures = graphHeight * graphWidth;

% making adjacency for grid MRF
adj = zeros(totalFeatures);
for i=1:totalFeatures
    for j=1:totalFeatures
       if (i+1==j && rem(i,graphWidth)~=0)
           adj(i,j)=1;
       end
       if (i-1==j && rem(j,graphWidth)~=0)
           adj(i,j)=1;
       end
       if i==j+graphHeight || i==j-graphHeight
           adj(i,j)=1;
       end
    end
end

%Temporary vector of size graph to generate all samples
x = zeros(1,totalFeatures);

%Probability of each possible value for binary model
P = zeros(1,2^totalFeatures);


allOutcomes = zeros(2^totalFeatures,totalFeatures);


w2 = triu(rand(totalFeatures,totalFeatures),1);
w2 = w2 .* adj;

w1 = rand(1,totalFeatures);

%making all outcomes
for t=1:2^totalFeatures
    if ~any(x == 0)
        x = zeros(1,totalFeatures);
        allOutcomes(t,:) = x;
    else
        i = find(x == 0, 1);
        x(1:i-1) = 0;
        x(i) = 1;
        allOutcomes(t,:) = x;
    end 
    P(t) = exp( sum(w1.*x) + sum(sum(w2 .* (x' * x))) );
    
end

%Normalize probabilities
P = P./sum(P);

%Making cumulative
C = cumsum(P);

allSamples = zeros(numSamples, totalFeatures);

for i=1:numSamples
    s = rand;
    allSamples(i,:) = allOutcomes(find(C >= s, 1),:);
end

est_w2 = zeros(totalFeatures, totalFeatures);
est_w2_num = zeros(totalFeatures, totalFeatures);
est_w1 = zeros(1,totalFeatures);
est_w1_num = zeros(1,totalFeatures);

%%%% Finding maximal cliques using adjacency matrix
% for i=1:totalFeatures
%     for j=i:totalFeatures
%        if adj(i,j) == 1
%           cliques = [cliques, [i,j]];
%        end
%     end
% end
cliques = maximalCliques(adj, 'v2');

% Generating main potential functions
PF_main = {};
PF_main_inputs = {};

for i=1:length(cliques')
    [row, col, val] = find(cliques(:, i)');
    PF_main{end+1} = @(x) x;
    PF_main_inputs{end+1} = col(1);
    
    PF_main{end+1} = @(x) x;
    PF_main_inputs{end+1} = col(2);
    
    PF_main{end+1} = @(x) x(1)*x(2);
    PF_main_inputs{end+1} = col;
end

save('common.mat', 'cliques', 'adj', 'PF_main', 'PF_main_inputs');
theta = zeros(size(PF_main));
save('theta.m', 'theta');

machines = {};
eval(MPI_Run('client_main',1 , machines));
%%
% 
% for c=1:length(cliques)
% 
%     
%     disp(['clique #' num2str(c)]);
%    
%     [gn, pf_aux, pf_inputs] = makeAux(c, adj);
%     SS = computeSS(pf_aux, pf_inputs);
%     
%     theta_0 = zeros(size(SS));
%     theta = my_newton(theta_0, SS, size(allSamples, 1), cliques{c}, clqAdj, size(allSamples,2));
%     est_w2(v,u) = est_w2(v,u) + theta(1);
%     est_w2_num(v,u) = est_w2_num(v,u)+1;
%     est_w1(v) = est_w1(v) + theta(2);
%     est_w1_num(v) = est_w1_num(v)+1;
%     est_w1(u) = est_w1(u) + theta(3);
%     est_w1_num(u) = est_w1_num(u) + 1;
%     %%%%
% end
%%%%
%%%% parameter averaging
% est_w2_num(est_w2_num == 0) = 1;
% est_w1_num(est_w1_num == 0) = 1;
% est_w2 = est_w2 ./ est_w2_num;
% est_w1 = est_w1 ./ est_w1_num;
% 
% w1
% est_w1
% 
% w2
% est_w2
% 
% figure(1);
% bar([w1' , est_w1']);
% 
% figure(2);
% bar([w2(w2 ~= 0) , est_w2(est_w2 ~= 0)]);