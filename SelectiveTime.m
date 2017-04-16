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

brk = find(abs(diff(nu))>.9*pi);

nu_target = 0:deg2rad(10):2*pi;
ind = 1;

for targetCount = 1:numel(nu_target)
    [val,index(ind)] = min(abs(nu(1:brk(1))-nu_target(targetCount)));
    ind = ind+1;
end

tsteps_new = tsteps(index); nu_new = nu(index); S_lat_new = S_lat(index);
S_lon_new = S_lon(index);


figure
plot(tsteps,rad2deg(nu),'.-')
 
% figure 
% hold on
% box on
% load coast
% plot(long, lat, 'k', 'LineWidth',0.2) % Plot coastlines
% plot(S_lon,S_lat,'b.')
% plot(S_lon_new,S_lat_new,'rs')
% axis([-180 180 -90 90])