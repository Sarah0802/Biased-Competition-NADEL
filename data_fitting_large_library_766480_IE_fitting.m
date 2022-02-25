function data_fitting_large_library_766480_IE_fitting
clear all

[M0_codeA] = data_766480_library_M0_codeA;
[M0_codeB] = data_766480_library_M0_codeB;
[M0_count] = data_766480_library_M0_count;

[M1_codeA] = data_766480_library_M1_codeA;
[M1_codeB] = data_766480_library_M1_codeB;
[M1_count] = data_766480_library_M1_count;

[M2_codeA] = data_766480_library_M2_codeA;
[M2_codeB] = data_766480_library_M2_codeB;
[M2_count] = data_766480_library_M2_count;

[M3_codeA] = data_766480_library_M3_codeA;
[M3_codeB] = data_766480_library_M3_codeB;
[M3_count] = data_766480_library_M3_count;

NA = max(M0_codeA);
NB = max(M0_codeB);

P0_count_new = zeros(NA*NB, 1);
P1_count_new = zeros(NA*NB, 1);
P2_count_new = zeros(NA*NB, 1);
P3_count_new = zeros(NA*NB, 1);



for i =1:length(M0_codeA)
    codeA  = M0_codeA(i);
    codeB  = M0_codeB(i);

    idx = (codeA-1)*NB + codeB;
    P0_count_new(idx) = M0_count(i);
end

for i =1:length(M1_codeA)
    codeA  = M1_codeA(i);
    codeB  = M1_codeB(i);

    idx = (codeA-1)*NB + codeB;
    P1_count_new(idx) = M1_count(i);
end

for i =1:length(M2_codeA)
    codeA  = M2_codeA(i);
    codeB  = M2_codeB(i);

    idx = (codeA-1)*NB + codeB;
    P2_count_new(idx) = M2_count(i);
end

for i =1:length(M3_codeA)
    codeA  = M3_codeA(i);
    codeB  = M3_codeB(i);

    idx = (codeA-1)*NB + codeB;
    P3_count_new(idx) = M3_count(i);
end

data = P0_count_new./sum(P0_count_new);
data1 = P1_count_new./sum(P1_count_new);
data2 = P2_count_new./sum(P2_count_new);
data3 = P3_count_new./sum(P3_count_new);


Eff_loops = zeros(4,1);
Eff_loops_true = zeros(4,1);

temp = nonzeros(data);
Efficiency = - temp.*log2(temp); 
Eff_loops_true(1)  = sum(Efficiency);
Eff_loops(1)  = sum(Efficiency);


temp = nonzeros(data1);
Efficiency = - temp.*log2(temp); 
Eff_loops_true(2)  = sum(Efficiency);

temp = nonzeros(data2);
Efficiency = - temp.*log2(temp); 
Eff_loops_true(3)  = sum(Efficiency);

temp = nonzeros(data3);
Efficiency = - temp.*log2(temp); 
Eff_loops_true(4)  = sum(Efficiency);


error_array = zeros(100,1);
alpha_array = linspace(0,1,10000);


for alpha_index = 1:length(alpha_array)
    alpha = alpha_array(alpha_index);
    data = P0_count_new./sum(P0_count_new);

    for cycle =2:4
        total = sum(data.^2) + (1-alpha) * sum(data.*(1-data));
        
        new_data = (data.^2 + (1-alpha) * data.*(1-data))/total;
        temp = nonzeros(new_data);
        Efficiency = - temp.*log2(temp); 
        Eff_loops(cycle)  = sum(Efficiency);
        data = new_data;
    end

error_array(alpha_index ) = norm(Eff_loops-Eff_loops_true,2); 
end

figure(1)
plot(alpha_array, error_array, 'o-', 'LineWidth',2);
hold on

[val, idx] = min(error_array);

alpha = alpha_array(idx);
data = P0_count_new./sum(P0_count_new);

fprintf('The optimal value of alpha is: %f\n', alpha)


for cycle =2:4
    total = sum(data.^2) + (1-alpha) * sum(data.*(1-data));
    
    new_data = (data.^2 + (1-alpha) * data.*(1-data))/total;
    temp = nonzeros(new_data);
    Efficiency = - temp.*log2(temp); 
    Eff_loops(cycle)  = sum(Efficiency);
    data = new_data;
end

figure(2)

plot(Eff_loops_true(1:4), 'b-', 'LineWidth',3);
hold on
plot(Eff_loops_true(1:4), 'bo', 'LineWidth',3);
hold on
plot(Eff_loops(1:4), 'r--', 'LineWidth',3);
hold on
plot(Eff_loops(1:4), 'ro', 'LineWidth',3);
hold on

ylabel('IE')
xlabel('Cycle')

legend('Data', 'Model')
set(gca,'FontSize',20)
file_out2 = './library_with_766480_IE .png';
saveas(gcf,file_out2)



% 
% % write to a new file
% fid=fopen('Data_766480_library_raw_data_M1_true_data.txt','w');
% fprintf(fid,'%.15f\n', data1);
% fclose(fid);
% 
% fid=fopen('Model_766480_library_raw_data_M1_model.txt','w');
% fprintf(fid, '%.15f\n',new_data);
% fclose(fid);


end
