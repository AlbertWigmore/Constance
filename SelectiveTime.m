close all
clear all
clc


sat.SMA= 26562;
sat.ECC = 0.74;
sat.INC = 63.4;
sat.RAAN = 0;
sat.AOP = 270;
sat.TA = 0;

tsteps = [0:0.001:1];

[nu,S_lat,S_lon,rmag]=OrbitProp(tsteps,sat);

tsteps(249:end)=[]; nu(249:end)=[]; S_lat(249:end)=[]; S_lon(249:end)=[];

nu_target = linspace(0,pi,20);

for ii = 1:numel(nu_target)
    [val index(ii)] = min(abs(nu-nu_target(ii)));    
end

tsteps_new = tsteps(index); nu_new = nu(index); S_lat_new = S_lat(index);
S_lon_new = S_lon(index);

 
figure 
hold on
box on
load coast
plot(long, lat, 'k', 'LineWidth',0.2) % Plot coastlines
plot(S_lon,S_lat,'b.')
plot(S_lon_new,S_lat_new,'rs')
axis([-180 180 -90 90])