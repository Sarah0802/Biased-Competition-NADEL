function data_fitting_large_library_200000_IE_prediction
clear all

[P0_codeA, P0_codeB, P0_count, P1_codeA, P1_codeB, P1_count, P2_codeA, P2_codeB, P2_count,P3_codeA, P3_codeB, P3_count] = data_200000_library;


P0_count_new = zeros(640*363, 1);
P1_count_new = zeros(640*363, 1);
P2_count_new = zeros(640*363, 1);
P3_count_new = zeros(640*363, 1);


for i =1:length(P0_codeA)
    codeA  = P0_codeA(i);
    codeB  = P0_codeB(i);

    idx = (codeA-1)*640 + codeB;
    P0_count_new(idx) = P0_count(i);
end



for i =1:length(P1_codeA)
    codeA  = P1_codeA(i);
    codeB  = P1_codeB(i);

    idx = (codeA-1)*640 + codeB;
    P1_count_new(idx) = P1_count(i);
end



for i =1:length(P2_codeA)
    codeA  = P2_codeA(i);
    codeB  = P2_codeB(i);

    idx = (codeA-1)*640 + codeB;
    P2_count_new(idx) = P2_count(i);
end


for i =1:length(P3_codeA)
    codeA  = P3_codeA(i);
    codeB  = P3_codeB(i);

    idx = (codeA-1)*640 + codeB;
    P3_count_new(idx) = P3_count(i);
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


alpha = 0.76;
data = P0_count_new./sum(P0_count_new);

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
ylim([15,16.5])

legend('Data', 'Model')
set(gca,'FontSize',20)
file_out2 = './library_20000_IE.png';
saveas(gcf,file_out2)


% 
% % write to a new file
% fid=fopen('Data_200000_library_raw_data_M1_true_data.txt','w');
% fprintf(fid,'%.15f\n', data1);
% fclose(fid);
% 
% fid=fopen('Model_200000_library_raw_data_M1_model.txt','w');
% fprintf(fid, '%.15f\n',new_data);
% fclose(fid);


end