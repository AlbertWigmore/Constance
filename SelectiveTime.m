close all
clear all
clc


sat.SMA= 26562;
sat.ECC = 0.74;
sat.INC = 63.4;
sat.RAAN = 0;
sat.AOP = 270;
sat.TA = 90;

tsteps = 0:0.001:0.8;

[nu,S_lat,S_lon,rmag]=OrbitProp(tsteps,sat);

Brk = find(abs(diff(nu))>.9*pi);
Brk = [1,Brk,numel(tsteps)];

nu_target = 0:deg2rad(10):2*pi;

ind = 1;

% for BrkNo = 1:numel(Brk)
    for targetCount = 1:numel(nu_target)
        [val,index(ind)] = min(abs(nu(Brk(1):Brk(2))-nu_target(targetCount)));
        ind = ind+1;  
    end
    for targetCount = 1:numel(nu_target)
        [val,index(ind)] = min(abs(nu(Brk(2):Brk(3))-nu_target(targetCount)));
        index(ind)= index(ind)+Brk(2)-1;
        ind = ind+1;
    end
% end

index = unique(index);

tsteps_new = tsteps(index); nu_new = nu(index); S_lat_new = S_lat(index);
S_lon_new = S_lon(index);


figure
plot(tsteps,rad2deg(nu),'.-')
hold on
plot(tsteps_new,rad2deg(nu_new),'rs')

figure 
hold on
box on
load coast
plot(long, lat, 'k', 'LineWidth',0.2) % Plot coastlines
plot(S_lon,S_lat,'b.')
plot(S_lon_new,S_lat_new,'rs')
axis([-180 180 -90 90])