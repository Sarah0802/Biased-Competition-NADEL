function data_prediction_for_input_data_and_calculated_alpha
clear all

% input your data
data = [5,5,1,1,1,1,1,1,1,1];
data = data./sum(data);


% data = ones(5562,1) * (1-0.2)/5561;
% data(1) = 0.2;

% data = ones(901,1);
% data(1) = 100;
% total_count = zeros(3,1);
% total_category = zeros(3,1);
% total_count(1) = sum(data);
% total_category(1)=nnz(data);
% N_num = 1000;
% [P0_count, P1_count, P2_count, P3_count] = data_274_library;
% data = P0_count./sum(P0_count);
% N_num = length(P0_count);

% data = data./sum(data);
% N_num = 10;
% sum(data)

% number of NADEL cycles
num_loops = 10;

% alpha values fitted from other data
alpha = 0.76;


top_p = zeros(num_loops,1);
Eff_loops = zeros(num_loops, 1);

[val, target_index1]  = max(data);

top_p(1) = data(target_index1);


temp = nonzeros(data);
Efficiency = - temp.*log2(temp); 
Eff_loops(1)  = sum(Efficiency);

for loops = 2:num_loops
total = sum(data.^2) + (1-alpha) * sum(data.*(1-data));
new_data = (data.^2 + (1-alpha) * data.*(1-data))/total;

top_p(loops) = new_data(target_index1);

temp = nonzeros(new_data);
Efficiency = - temp.*log2(temp);
Eff_loops(loops)  = sum(Efficiency);

data = new_data;
end

figure(1)
plot(Eff_loops, '-', 'LineWidth',3);
hold on
xlim([1,num_loops])
ylabel('IE')
xlabel('Cycles')
set(gca,'FontSize',20)
file_out2 = './IE_prediction.png';
saveas(gcf,file_out2)


figure(2)
% legend('alpha = 1', 'alpha = 0.8', 'alpha = 0.6', 'alpha = 0.4', 'alpha = 0.2', 'alpha = 0','Location','northeast')
plot(top_p, '-', 'LineWidth',3);
hold on
ylabel('Sequence probability [%]')
xlabel('Cycles')
xlim([1,num_loops])
set(gca,'FontSize',20)
file_out2 = './Top_probability_prediction.png';
saveas(gcf,file_out2)


end
