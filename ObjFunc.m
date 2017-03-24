function [] = ObjFunc()

%%%% Setup Coverage Parameters  %%%%
e_lat_size = 300;
e_lon_size = 300;
e_lat = linspace(-90, 90, e_lat_size);
e_lon = linspace(-180, 180, e_lon_size);
[grid_lat, grid_lon] = meshgrid(e_lat, e_lon);
coverage = zeros(e_lon_size, e_lat_size);

earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 10; % FoV of sensor

%%%% Orbit Propagation %%%%
sat.SMA= 6878;
sat.ECC = 0;
sat.INC = 90.0;
sat.RAAN = 110;
sat.AOP = 360;
sat.TA = 0;

tsteps = [0:0.001:1];
[S_lat, S_lon, rmag] = OrbitProp(tsteps, sat);

out = CoverageCalc(S_lat, S_lon, rmag, sat, grid_lat, grid_lon, ...
                        coverage, tsteps, fov, earth);

%%%% Plotting for verification %%%%
axesm ('globe','Grid', 'on');
view(60,60)
axis off
load coastlines; plotm(coastlat, coastlon);

%base = zeros(180,360); baseref = [1 90 0];
%hs = meshm(base,baseref,size(base));
%colormap white;
% plotm(grid_lat(out.coverage > 1), grid_lon(out.coverage > 1),'m+');

R = georasterref('RasterSize', size(out.coverage'), ...
  'Latlim', [-90 90], 'Lonlim', [-180 180]);
meshm(out.coverage', R); colorbar;

