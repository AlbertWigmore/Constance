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
e_lat_size = 150;
e_lon_size = 150;
e_lat = linspace(-90, 90, e_lat_size + 2);
e_lon = linspace(-180, 180, e_lon_size + 2);
[grid_lat, grid_lon] = meshgrid(e_lat, e_lon);
coverage = zeros(e_lon_size + 2, e_lat_size + 2);
earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 10; % FoV of sensor

tsteps = [0:0.001:0.1];
for i = 1:numel(sat)
    try
        [nu, S_lat, S_lon, rmag] = OrbitProp(tsteps, sat(i));
        [tsteps_new, ~, S_lat_new, S_lon_new, rmag_new] = SelectiveTime(tsteps, nu, S_lat, S_lon, rmag, 5);
    catch OrbitPropError
        disp(OrbitPropError)
        phi = 400; % It is not known whether this is high enough
        return 
    end
    out = CoverageCalc(S_lat_new, S_lon_new, rmag_new, sat(i), grid_lat, grid_lon, ...
                       tsteps_new, fov, earth);
    coverage = coverage + out.coverage;
    cost(i) = SatCost(sat(i));
%     rper(i) = sat(i).SMA * ((1 - sat(i).ECC^2) / (1 + sat(i).ECC));
end

% Coverage and overlap calculation
R = georasterref('RasterSize', size(coverage'), ...
  'Latlim', [-90 90], 'Lonlim', [-180 180]);

area = 100 * (areamat(coverage >= 1, R, earth) / 510.1E6);
overlap = 100 * (areamat(coverage > 1, R, earth) / 510.1E6);

p = 0;

% Inequality constraints
g = cost ./ 100E6; % Cost of each satellite must be less then 100 million
g = [g, (95 - area)/100]; % Coverage greater than 95% 
% g = [g, (500 - rper)/500]; % No radius of perigee less then 500 km

for j = 1:numel(g)
    p = p + (max(0, g(j)))^2;
end

% Equality constraints
h = 0;
for k = 1:numel(h)
    p = p + h(k)^2;
end

f(1) = overlap; % Objective 1: Minimise overlap
f(2) = sum(cost) / 1E6; % Objective 2: Minimise cost
a = [1., 1.]; % Weighting coefficients

% Pseudo Objective Function
phi = f(1) + f(2) + p;

phi = coverage; % This is required for plotting
