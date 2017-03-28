function [phi] = ObjFunc(x)

sat1.SMA= x(1);
sat1.ECC = x(2);
sat1.INC = x(3);
sat1.RAAN = x(4);
sat1.AOP = x(5);
sat1.TA = x(6);

sat2.SMA= x(7);
sat2.ECC = x(8);
sat2.INC = x(9);
sat2.RAAN = x(10);
sat2.AOP = x(11);
sat2.TA = x(12);

sat3.SMA= x(13);
sat3.ECC = x(14);
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
fov = 10; % FoV of sensor

tsteps = [0:0.001:0.1];
for i = 1:numel(sat)
    try
        [S_lat, S_lon, rmag] = OrbitProp(tsteps, sat(i));
    catch OrbitPropError
        disp(OrbitPropError)
        phi = 100; % Maximum value that can exist
        return 
    end
    out = CoverageCalc(S_lat, S_lon, rmag, sat(i), grid_lat, grid_lon, ...
                       tsteps, fov, earth);
    coverage = coverage + out.coverage;
end
R = georasterref('RasterSize', size(coverage'), ...
  'Latlim', [-90 90], 'Lonlim', [-180 180]);

area = 100 * (areamat(coverage >= 1, R, earth) / 510.1E6);
overlap = 100 * (areamat(coverage > 1, R, earth) / 510.1E6);

f = -area; % Cost function
p = overlap; % Penalty function

phi = f + p;

% phi = coverage;
