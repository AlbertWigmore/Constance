clear all
clc
close all

sat1.SMA= 6878;
sat1.ECC = 0;
sat1.INC = 98;
sat1.RAAN = 201;
sat1.AOP = 360;
sat1.TA = 0;

sat2.SMA= 26562;
sat2.ECC = 0.74;
sat2.INC = 63.4;
sat2.RAAN = 0;
sat2.AOP = 270;
sat2.TA = 0;

tsteps = [0:0.001:1];


[nu1,S_lat1,S_lon1,rmag1]=OrbitProp(tsteps,sat1); % THIS IS FUNCTION CALL
[nu2,S_lat2,S_lon2,rmag2]=OrbitProp(tsteps,sat2);


figure 
hold on
box on
load coast
plot(long, lat, 'k', 'LineWidth',0.2) % Plot coastlines
plot(S_lon2,S_lat2,'b.')

axis equal
axis([-180 180 -90 90])

% figure
% earth = referenceEllipsoid('wgs84','km');
% figure('Renderer','opengl')
% ax = axesm('globe','Geoid',earth,'galtitude',1000);
% ax.Position = [0 0 1 1];
% axis equal off
% view(3)
% load topo
% geoshow(topo,topolegend,'DisplayType','texturemap')
% demcmap(topo)
% land = shaperead('landareas','UseGeoCoords',true);
% plotm([land.Lat],[land.Lon],'Color','black')
% 
% r1 = geocradius(S_lat1,'WGS84')/1000;
% r2 = geocradius(S_lat2,'WGS84')/1000;
% plotm(S_lat1,S_lon1,rmag1-r1,'Color','magenta');
% % plotm(S_lat2,S_lon2,rmag2-r2,'Color','red');