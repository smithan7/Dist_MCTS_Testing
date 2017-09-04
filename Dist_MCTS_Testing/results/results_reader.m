function [time,n_agents,agents,n_task_types,open_reward, task_selection_method] = results_reader(filename)

dataArray = importdata(filename,',');

task_selection_method = dataArray.textdata(:);
%task_claim_method = dataArray{1, cntr};
%task_claim_time = dataArray{1, cntr};

%% Allocate imported array to column variable names
time = dataArray.data(:, 1);
n_agents = dataArray.data(1, 2);
n_task_types = dataArray.data(1, 3);
cntr = 4;

agents(n_agents) = struct();
for i=1:n_agents
   agents(i).work = dataArray.data(:,cntr); 
   cntr = cntr+1;
end

for i=1:n_agents
   agents(i).travel = dataArray.data(:,cntr); 
   cntr = cntr+1;
end

for i=1:n_agents
   agents(i).type = dataArray.data(1,cntr); 
   cntr = cntr+1;
end

open_reward = dataArray.data(:, cntr);

