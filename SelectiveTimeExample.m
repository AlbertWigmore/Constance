%Selective Time Test function
close all
clear all
clc

sat.SMA= 27000;
sat.ECC = 0.7;
sat.INC = 60;
sat.RAAN = 0;
sat.AOP = 270;
sat.TA = 90;

tsteps = 0:0.001:1;

[nu,S_lat,S_lon,rmag]=OrbitProp(tsteps,sat);

[tsteps_new,nu_new,S_lat_new,S_lon_new,rmag_new] = SelectiveTime(tsteps,nu,S_lat,S_lon,rmag,10);


figure 
hold on
box on
load coast
plot(long, lat, 'k', 'LineWidth',0.2) % Plot coastlines
plot(S_lon,S_lat,'b.')
plot(S_lon_new,S_lat_new,'rs')
axis([-180 180 -90 90])
legend('Coast','Original points','Sampled points')