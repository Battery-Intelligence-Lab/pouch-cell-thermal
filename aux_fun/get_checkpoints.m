function [out, files]= get_checkpoints(Crate, data)
% Read Checkpoint values for surrogate optimisation. 
% Author: Volkan Kumtepeli

files = dir(['Checkpoints/Checkpoint_Pulse_',num2str(Crate),'C_*.mat']); % make sure to run the right folder

threshold = 2e-3;

my_X = [];
my_Feval = [];
my_Ineq  = [];

my_cost1 = [];
my_cost2 = [];

% x_es = zeros(length(files),5);
%
% fprintf('Checkpoints are being cleaned.\n');
% for i=1:length(files)
% path = fullfile(files(i).folder, files(i).name);
%
% ld = load(path,'x');
%
% x_es(i,:) = ld.x;
%
% end

fprintf('Checkpoints are being loaded.\n');
deleted_files = 0;
for i=1:length(files)%1:10:100%1:length(files)
    path = fullfile(files(i).folder,files(i).name); %['Checkpoint_Pulse_',num2str(Crate),'C_',num2str(i),'.mat']

    ld = load(path);

    if(~isempty(my_X))
        if(any(vecnorm(my_X - ld.x,'inf',2) < threshold))
            fprintf('Removing %s\n', files(i).name);
            delete(path);
            deleted_files = deleted_files +1;
            continue;
        end
    end

    my_X = [my_X; ld.x];
    [cost, cost1, cost2]= calculate_costs(ld.SimT, ld.SimV, ld.Simt, data, ld.x);

    my_cost1 = [my_cost1; cost1];
    my_cost2 = [my_cost2; cost2];

    fprintf('Cost for checkpoint %d is: %4.4f, cost1: %4.3f, cost2: %4.3f.\n',i,cost, 100*cost1, 100*cost2);

    if(cost>1e6)
        Fval = 1;
        Ineq = 1;
    else
        Fval = cost;
        Ineq = -1;
    end

    my_Feval = [my_Feval; Fval];
    my_Ineq  = [my_Ineq; Ineq];

end

out.X = my_X;
out.Fval = my_Feval;
out.Ineq = my_Ineq;
out.cost1 = my_cost1;
out.cost2 = my_cost2;

fprintf('Deleted %d files.\n',deleted_files);
end