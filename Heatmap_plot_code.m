function Heatmap_plot_code
clear all

num_loops = 1000; %50;
alpha = 0.76; %0.9994;

temp_indexy = linspace(0,1000,101);

temp_indexy(1) = 1;

% temp_indexy(2)
% 
% temp_indexy(26)
% 
% temp_indexy(51)


N_array = int32(linspace(100,300000,100)); 
top_p = zeros(length(N_array),num_loops);
Eff_loops = zeros(length(N_array), num_loops);

for index = 1:length(N_array)
    
N_num = int32(N_array(index));

N1 = int32(N_num * 0.01);
N2 = int32(N_num * 0.05);
N3 = int32(N_num * 0.1);
N4 = int32(N_num * 0.2);
N5 = N_num - N1 - N2 - N3 - N4;
data = zeros(N_num,1);

data(1:N1,1) = int32(rand(N1,1)*(10000-1000) + 1000);
data(N1+1:N1 + N2,1) = int32(rand(N2,1)*(1000-100) + 100);

data((N1 + N2 + 1): (N1 + N2 + N3),1) = int32(rand(N3,1)*(100-50) + 50);
data((N1 + N2 + N3 + 1):(N1 + N2 + N3 + N4),1) = int32(rand(N4,1)*(50-10) + 10);
data(N1 + N2 + N3 + N4 + 1:N_num,1) = int32(rand(N5,1)*(10-1) + 1);

data = data./sum(data);
% First 1% random integers between (1000, 10000)
% Second 5% random integers between (100, 1000)
% Third 10% random integers between (50, 100)
% Fourth 20% random integers between (10, 50)
% All the rest random integers between (1, 10)

[val, target_index1] = max(data);

top_p(index, 1) = data(target_index1);

temp = nonzeros(data);
Efficiency = - temp.*log2(temp);
Eff_loops(index, 1)  = sum(Efficiency);


for loops = 2:num_loops

total = sum(data.^2) + (1-alpha) * sum(data.*(1-data));
new_data = (data.^2 + (1-alpha) * data.*(1-data))/total;

top_p(index, loops) = new_data(target_index1);

temp = nonzeros(new_data);
Efficiency = - temp.*log2(temp); 
Eff_loops(index, loops)  = sum(Efficiency);


data = new_data;
end


end

figure(3)
top_p(1:100,1000)


figure(1)

h = pcolor(top_p(1:100,temp_indexy(1:101)));
set(h, 'EdgeColor', 'none');

xticks([1 25 50 75 100])
xticklabels({'1', '250', '500', '750', '1000'})

yticks([1 25 50 75 100])
yticklabels({'100', '72803', '148535', '224268', '300000'})


ylabel('Library size')
xlabel('Cycles')
set(gca,'FontSize',20)
colorbar
file_out2 = './Heatmap_top_p.png';
saveas(gcf,file_out2)

figure(2)

h = pcolor(Eff_loops(1:100,temp_indexy(1:101)));
set(h, 'EdgeColor', 'none');
ylabel('Library size')
xlabel('Cycles')
xticks([1 25 50 75 100])
xticklabels({'1', '250', '500', '750', '1000'})

yticks([1 25 50 75 100])
yticklabels({'100', '72803', '148535', '224268', '300000'})

% N_array(1)
% N_array(25)
% N_array(50)
% N_array(75)
% N_array(100)

set(gca,'FontSize',20)
colorbar
file_out2 = './Heatmap_IE.png';
saveas(gcf,file_out2)

end


