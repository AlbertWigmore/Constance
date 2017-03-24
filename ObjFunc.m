function [phi] = ObjFunc(sat)

% Decision variables x

%%%% Setup Coverage Parameters  %%%%
e_lat_size = 300;
e_lon_size = 300;
e_lat = linspace(-90, 90, e_lat_size + 2);
e_lon = linspace(-180, 180, e_lon_size + 2);
[grid_lat, grid_lon] = meshgrid(e_lat, e_lon);
coverage = zeros(e_lon_size + 2, e_lat_size + 2);
earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 10; % FoV of sensor

tsteps = [0:0.001:0.1];
for i = 1:numel(sat)
    [S_lat, S_lon, rmag] = OrbitProp(tsteps, sat(i));
    out = CoverageCalc(S_lat, S_lon, rmag, sat(i), grid_lat, grid_lon, ...
                       tsteps, fov, earth);
    coverage = coverage + out.coverage;
end

f = 0; % Cost function
p = 0; % Penalty function
phi = f + p;

phi = coverage;