close all
clearvars
clc

d=dir('*.txt');
[~,dx]=sort([d.datenum]);
for file=1:length(d)
    test_file = d(file).name;
    [time,n_agents,agents,n_task_types,open_reward, task_selection_method] = results_reader(test_file);
    
    if length(open_reward) ~= 1200
        continue;
    end
    
    if n_agents ~= 3
        continue;
    end
    if task_selection_method{1} == 'greedy_completion_reward'
        greedy_reward(1:600,file) = open_reward(1:600);
    end
    if task_selection_method{601} == 'mcts_task_by_completion_reward'
        mcts_reward(1:600,file) = open_reward(601:1200);
    end

end

iter = 1;
for i=1:600
    mg(iter) = mean(greedy_reward(i,:));
    sg(iter) = std(greedy_reward(i,:)) / length(d);
    mm(iter) = mean(mcts_reward(i,:));
    ms(iter) = std(mcts_reward(i,:)) / length(d);
    iter = iter + 1;
end
    
errorbar(1:60, mg(1:10:600), sg(1:10:600), 'r');
hold on
errorbar(1:60, mm(1:10:600), ms(1:10:600), 'g');
xlabel('Time (s)')
ylabel('Captured Reward');
ttl_str = sprintf('%i Iterations', length(d));
title(ttl_str);
legend('Greedy', 'MCTS');
grid on;

for i=1:600
    sd(i) = 100 * mean(mcts_reward(i,:) - greedy_reward(i,:)) / mean(greedy_reward(i,:));
    ss(i) = std((mcts_reward(i,:) - greedy_reward(i,:)) ./ mean(greedy_reward(i,:)));
end


figure
%errorbar(1:60, 100 * (mm - mg) ./ mg, ms - sg, 'k');
errorbar(1:60, sd(1:10:600), ss(1:10:600), 'k');
xlabel('Time (s)')
ylabel('Gained Captured Reward (%)');
ttl_str = sprintf('%i Iterations, %i agents', length(d), n_agents);
title(ttl_str);
grid on;


