function [phi] = ObjFunc(x)

sat1.Ra= x(1);
sat1.Rp = x(2);
sat1.INC = x(3);
sat1.RAAN = x(4);
sat1.AOP = x(5);
sat1.TA = x(6);

sat2.Ra= x(7);
sat2.Rp = x(8);
sat2.INC = x(9);
sat2.RAAN = x(10);
sat2.AOP = x(11);
sat2.TA = x(12);

sat3.Ra= x(13);
sat3.Rp = x(14);
sat3.INC = x(15);
sat3.RAAN = x(16);
sat3.AOP = x(17);
sat3.TA = x(18);

sat = [sat1, sat2, sat3];
% Decision variables x

%%%% Setup Coverage Parameters  %%%%
e_lat_size = 300;
e_lon_size = 300;
e_lat = linspace(-90, 90, e_lat_size + 2);
e_lon = linspace(-180, 180, e_lon_size + 2);
[grid_lat, grid_lon] = meshgrid(e_lat, e_lon);
coverage = zeros(e_lon_size + 2, e_lat_size + 2);
earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 65; % FoV of sensor

tsteps = [0:0.0005:0.5];
for i = 1:numel(sat)
    [nu, S_lat, S_lon, rmag] = OrbitProp(tsteps, sat(i));
    [tsteps_new, ~, S_lat_new, S_lon_new, rmag_new] = SelectiveTime(tsteps, nu, S_lat, S_lon, rmag, 2.5);

    out = CoverageCalc(S_lat_new, S_lon_new, rmag_new, sat(i), grid_lat, grid_lon, ...
                       tsteps_new, fov, earth);
    coverage = coverage + out.coverage;
end

 phi = coverage; % This is required for plotting
