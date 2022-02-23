function data_fitting_for_library_with_274_members
clear all

% upload data
[P0_count, P1_count, P2_count, P3_count] = data_200_library;
 
% calculate the probability from the raw data
data = P0_count./sum(P0_count);
data1 = P1_count./sum(P1_count);


error_array = zeros(100,1);
alpha_array = linspace(0,1,100);


for alpha_index = 1:100

alpha = alpha_array(alpha_index);
total = sum(data.^2) + (1-alpha) * sum(data.*(1-data));

new_data = (data.^2 + (1-alpha) * data.*(1-data))/total;
error_array(alpha_index ) = norm(new_data-data1,2);

end

figure(1)
plot(alpha_array, error_array, '-', 'LineWidth',3);
hold on
set(gca,'FontSize',20)
file_out2 = './fitting_error.png';
saveas(gcf,file_out2)

[val, idx] = min(error_array);

alpha = alpha_array(idx);
total = sum(data.^2) + alpha * sum(data.*(1-data));
new_data = (data.^2 + alpha*data.*(1-data))/total;

fprintf('The optimal value of alpha is: %f\n', alpha)

figure(2)

plot(data1, 'b-', 'LineWidth',2);
hold on
plot(new_data, 'r--', 'LineWidth',2);
hold on
legend('Data', 'Model')
set(gca,'FontSize',20)
file_out2 = './Data_Vs_Model.png';
saveas(gcf,file_out2)

end