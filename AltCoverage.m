close all
clear
clc
Re = earthRadius/1000;

earth = referenceEllipsoid('WGS84','km');

% figure('Color','white')
% axesm('globe','Geoid',earth,'frame','on','grid','on')
% axis off
% load coastlines
% geoshow(coastlat, coastlon)
% view(3)
% 
figure('Renderer','opengl')
ax = axesm('globe','Geoid',earth,'galtitude',1000);
ax.Position = [0 0 1 1];
axis equal off
view(3)
load topo
geoshow(topo,topolegend,'DisplayType','texturemap')
demcmap(topo)
land = shaperead('landareas','UseGeoCoords',true);
plotm([land.Lat],[land.Lon],'Color','black')
% 
% figure 
% axesm miller
% axis off; framem on; gridm on;
% load coast
% plotm(lat, long, 'k', 'LineWidth',0.2) % Plot coastlines

sat1.SMA = Re+400;
sat1.ECC = .0;
sat1.INC = 95;
sat1.RAAN = 180;
sat1.AOP = 180;
sat1.TA = 0;
tsteps = [0:0.001:.1];
[S_lat,S_lon,rmag]=OrbitProp(tsteps,sat1); % THIS IS FUNCTION CALL

plotm(S_lat,S_lon,'-','Color','black','linewidth',0.5);

fov = 50;
eps = acos(rmag./Re*sin(deg2rad(fov)));
phi = pi/2-deg2rad(fov)-eps;
arclen = (phi*Re);
try
    arclen(imag(arclen)~=0) = Re*(pi/2-asin(Re./rmag));
catch
    disp('No annoying viewing angles');
end

for i = 2:numel(S_lat)-1
    az(i) = azimuth(S_lat(i-1),S_lon(i-1),S_lat(i+1),S_lon(i+1));
end
az(1) = az(2);
az(numel(S_lat)) = az(numel(S_lat)-1);
[latout_left,lonout_left] = reckon(S_lat,S_lon,arclen,az-90,earth);
[latout_right,lonout_right] = reckon(S_lat,S_lon,arclen,az+90,earth);

plotm(latout_left,lonout_left,'o-','Color','red','linewidth',1);
plotm(latout_right,lonout_right,'o-','Color','green','linewidth',1);


gridlat = linspace(-90,90,400);
gridlon = linspace(-360,360,800);
[gridLAT,gridLON] = meshgrid(gridlat,gridlon);
IN = zeros(numel(gridlon),numel(gridlat));
for i = 1:numel(S_lat)-1
    latv = [latout_left(i),latout_left(i+1),latout_right(i+1),latout_right(i)];
       
    lonv = [lonout_left(i),lonout_left(i+1),lonout_right(i+1),lonout_right(i)];
    if min(lonv) < -90 || max(lonv) > 90
        b = [lonv-360;lonv;lonv+360];
        [~,ind]=sort((b>-360&b<360));
        lonv = b(sub2ind(size(b),ind(end,:),1:size(b,2)));
    end
    
    IN = IN + inpolygon(gridLAT,gridLON,latv,lonv);
end
s = size(IN, 1) / 2;
IN = IN(1:s,:)+IN(s + 1:end,:);
gridLON = gridLON(1:s,:);
gridLAT = gridLAT(1:s,:);

% plotm(gridLAT(IN==1),gridLON(IN==1),'y.');
% try
%     plotm(gridLAT(IN>1),gridLON(IN>1),'r.');
% catch
%     disp('No intersections')
% end