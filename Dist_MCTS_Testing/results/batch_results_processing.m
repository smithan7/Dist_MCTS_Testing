close all
clearvars
clc

tests = 0;
n_agents_desired = 3;
desired_time = 300;

d=dir('*.txt');
[~,dx]=sort([d.datenum]);
for file=1:length(d)
    test_file = d(file).name;
    [time,n_agents,agents,n_task_types,open_reward, task_selection_method] = results_reader(test_file);
    
    if n_agents ~= n_agents_desired;
        continue;
    end
    
    if abs(length(open_reward) - 2*desired_time) > 20
        continue;
    end
    
    flag = false;
    for i=1:desired_time
        if ~strcmp(task_selection_method{i}, 'greedy_completion_reward')
            flag = true;
            break;
        end
    end
    if flag
        continue;
    end
    
    
    flag = false;
    for i=desired_time + 1:length(task_selection_method(i))
        if ~strcmp(task_selection_method{i}, 'mcts_task_by_completion_reward') && ~strcmp(task_selection_method{i}, 'mcts_task_by_completion_reward_impact')
            flag = true;
            break;
        end
    end
    if flag
        continue;
    end
    
    tests = tests + 1;
    greedy_reward(:,tests) = open_reward(1:desired_time);
    
    mcts_reward(:,tests) = zeros(desired_time, 1);
    x=0.1:0.1:30;
    for i=1:300
        vx = x(i);
        if vx < 30
            vy = linterp(time(desired_time + 1:length(task_selection_method)),open_reward(desired_time + 1:length(task_selection_method)),vx);
            mcts_reward(i,tests) = vy;
        else
            mcts_reward(i,tests) = open_reward(end);
        end
    end

end

iter = 1;
for i=1:desired_time
    mg(iter) = mean(greedy_reward(i,:));
    sg(iter) = std(greedy_reward(i,:)) / tests;
    mm(iter) = mean(mcts_reward(i,:));
    sm(iter) = std(mcts_reward(i,:)) / tests;
    %i1m(iter) = mean(impact_reward_1(i,:));
    %i1s(iter) = std(impact_reward_1(i,:)) / tests;
    %i2m(iter) = mean(impact_reward_2(i,:));
    %i2s(iter) = std(impact_reward_2(i,:)) / tests;
    
    iter = iter + 1;
end
    
errorbar(1:desired_time/10, mg(1:10:desired_time), sg(1:10:desired_time), 'r');
hold on
errorbar(1:desired_time/10, mm(1:10:desired_time), sm(1:10:desired_time), 'g');
%errorbar(1:28, i1m(1:10:280), i1s(1:10:280), 'b');
%errorbar(1:28, i2m(1:10:280), i2s(1:10:280), 'k');
xlabel('Time (s)')
ylabel('Captured Reward');
ttl_str = sprintf('%i Iterations', tests);
title(ttl_str);
legend('Greedy', 'MCTS');
grid on;

for i=1:desired_time
    sd(i) = 100 * mean(mcts_reward(i,:) - greedy_reward(i,:)) / mean(greedy_reward(i,:));
    ss(i) = std((mcts_reward(i,:) - greedy_reward(i,:)) ./ mean(greedy_reward(i,:)));
    %sd(i) = 100 * mean(impact_reward_2(i,:) - greedy_reward(i,:)) / mean(greedy_reward(i,:));
    %ss(i) = std((impact_reward_2(i,:) - greedy_reward(i,:)) ./ mean(greedy_reward(i,:)));
end


figure
%errorbar(1:60, 100 * (mm - mg) ./ mg, ms - sg, 'k');
errorbar(1:desired_time/10, sd(1:10:desired_time), ss(1:10:desired_time), 'k');
xlabel('Time (s)')
ylabel('Gained Captured Reward (%)');
ttl_str = sprintf('%i Iterations, %i agents', tests, n_agents_desired);
title(ttl_str);
grid on;

a = sprintf( 'mcts m/v: %0.2f, %0.2f', mm(end), sm(end))
a = sprintf( 'greedy m/v: %0.2f, %0.2f', mg(end), sg(end))
a = sprintf( 'info gained m/v: %0.2f, %0.2f', sd(end), ss(end))

