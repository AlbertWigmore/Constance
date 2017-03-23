function [] = ObjFunc()

%%%% Setup Coverage Parameters  %%%%
e_lat_size = 300;
e_lon_size = 150;
e_lat = linspace(-90, 90, e_lat_size);
e_lon = linspace(-180, 180, e_lon_size);
[grid_lat, grid_lon] = meshgrid(e_lat, e_lon);
coverage = zeros(e_lon_size, e_lat_size);
size(coverage)
earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 10; % FoV of sensor

%%%% Orbit Propagation %%%%
sat.SMA= 6878;
sat.ECC = 0;
sat.INC = 98;
sat.RAAN = 110;
sat.AOP = 360;
sat.TA = 0;

tsteps = [0:0.001:0.1];
[S_lat, S_lon, rmag] = OrbitProp(tsteps, sat);
c = CoverageCalc(S_lat, S_lon, rmag, grid_lat, grid_lon, ...
                        coverage, tsteps, fov, earth);

%%%% Plotting for verification %%%%
axesm ('globe','Grid', 'on');
view(60,60)
axis off
load coastlines; plotm(coastlat, coastlon);

%base = zeros(180,360); baseref = [1 90 0];
%hs = meshm(base,baseref,size(base));
%colormap white;
plotm(grid_lat(c.coverage == 1), grid_lon(c.coverage == 1),'m+');

R = georasterref('RasterSize', size(c.coverage'), ...
  'Latlim', [-90 90], 'Lonlim', [-180 180]);
% meshm(coverage', R);

