close all
clearvars
clc

d=dir('*.txt');
[~,dx]=sort([d.datenum]);
newest_file = d(dx(end-1)).name


[time,n_agents,agents,n_task_types,open_reward, task_selection_method] = results_reader(newest_file);
%[time,n_agents,agents,n_task_types,open_reward] = results_reader('results_for_params_13435.txt');

for i=1:n_agents
    subplot(2,1,1)
    hold on;
    color = get_agent_color(agents(i).type);
    plot(1:length(time),agents(i).work, color);
    ylabel('Work done by each agent')
    subplot(2,1,2);
    hold on;
    plot(1:length(time),agents(i).travel, color);
    ylabel('Travel done by each agent')
    xlabel('Time')
end

figure
hold on
legend_list = {};
time_steps = 600;
for i=1:length(time)/time_steps
    start = (i-1)*time_steps+1;
    finish = i*time_steps;
    color = get_agent_color(i);
    plot(time(start:finish), open_reward(start:finish),color);
    mean(open_reward(start+400:finish));
    ylabel('Collected Reward')
    xlabel('Time')
    
    legend_list{i} = char(strrep(task_selection_method(start), '_',' '));
end

legend(legend_list);
    

figure
plot(open_reward);
 ylabel('Collected Reward')
 grid on
    