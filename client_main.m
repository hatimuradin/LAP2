function client_main ()

% Initialize MPI.
MPI_Init;

% Create communicator.
comm = MPI_COMM_WORLD;

comm_size = MPI_Comm_size(comm);
my_rank = MPI_Comm_rank(comm);

load('common.mat');

for i=my_rank:comm_size:size(cliques, 2)
    [graph_nodes, PF_aux, PFAux_inputs, PFAux_index] = makeAux(cliques(:,i), adj, PF_main, PF_main_inputs, allSamples);
    thetaAux = auxMRFLearn(graph_nodes, PF_aux, PFAux_inputs, PF_index);
    thetaAux
    %share_theta(PFAux_index(ind), thetaAux(ind));
end

MPI_Finalize;

end