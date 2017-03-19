clear all
clc
close all

% tsteps = [0:0.0005:2*92.6*60/86400];
% [S_lat,S_lon,rmag]=OrbitProp(tsteps,6778,0,52,201,360,0);
tsteps = [0:0.001:1];
[S_lat, S_lon, rmag] = OrbitProp(tsteps, 26562, 0.74, 63.4, 0, 270, 0);

figure 
hold on
box on
load coast
plot(long, lat, 'k', 'LineWidth', 0.2) % Plot coastlines
plot(S_lon, S_lat,'b.')
axis equal
axis([-180 180 -90 90])
