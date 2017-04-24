% Does One-At-a-Time sensitivity analysis based on Soyuz launcher injection
% accuracies, for the 2-satellite optimum
clear all
close all
clc

% Load result
load 2SatSingleObjRun1;

% Limiting cases (min,opt,max)
err_R = [1-0.0146 1 1+0.0146];
err_INC = [-0.12 0 0.12];
err_AOP = [-0.6 0 0.6];
err_RAAN = [-0.6 0 0.6];

% Create array to be tested
% All the radii
x_array(1,:) = x(1)*err_R;
x_array(2,:) = x(2)*err_R;
x_array(7,:) = x(7)*err_R;
x_array(8,:) = x(8)*err_R;
% All the INCs
x_array(3,:) = x(3)+err_INC;
x_array(9,:) = x(9)+err_INC;
% All the RAANs
x_array(4,:) = x(4)+err_RAAN;
x_array(10,:) = x(10)+err_RAAN;
% All the AOPs
x_array(5,:) = x(5)+err_AOP;
x_array(11,:) = x(11)+err_AOP;
% All the TAs
x_array(6,:) = [x(6),x(6),x(6)];
x_array(12,:) = [x(12),x(12),x(12)];

% Populate coverage sensitivity matrix
indices = 2*ones(12,1);
COV = zeros(12,3);
for i = 1:12
    for j = [1 3 2]
        indices(i) = j;
        for k = 1:12
            x_current(k) = x_array(k,indices(k));
        end
        COV(i,j) = sensitivityFun(x_current);
        disp(['i,j = (',num2str(i),',',num2str(j),'); Area = ',...
            num2str(COV(i,j))]);
    end
end

COV_scaled = 100*COV/COV(1,2);
imagesc(COV_scaled)
colormap(gray)
colorbar
