function [] = ObjFunc()

%%%% Orbit Propagation %%%%
sat1.SMA= 6878;
sat1.ECC = 0;
sat1.INC = 98;
sat1.RAAN = 110;
sat1.AOP = 360;
sat1.TA = 0;
tsteps = [0:0.001:0.1];
[S_lat, S_lon, rmag] = OrbitProp(tsteps, sat1);

%%%% Setup Coverage Parameters  %%%%
e_lat_size = 300;
e_lon_size = 300;
e_lat = linspace(-90, 90, e_lat_size + 2);
e_lon = linspace(-180, 180, e_lon_size + 2);
[grid_lat, grid_lon] = meshgrid(e_lat, e_lon);
coverage = zeros(e_lon_size + 2, e_lat_size + 2);
earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 10; % FoV of sensor

coverage = CoverageCalc(S_lat, S_lon, rmag, grid_lat, grid_lon, ...
                        coverage, fov, earth);

%%%% Plotting for verification %%%%
axesm ('globe','Grid', 'on');
view(60,60)
axis off
load coastlines; plotm(coastlat, coastlon);

base = zeros(180,360); baseref = [1 90 0];
hs = meshm(base,baseref,size(base));
colormap white;

% plotm(gnd_lat, gnd_lon, 'r', 'LineWidth', 3); 
plotm(grid_lat(coverage == 1), grid_lon(coverage == 1),'m.');
plotm(grid_lat(coverage >= 1), grid_lon(coverage >= 1),'b.');
