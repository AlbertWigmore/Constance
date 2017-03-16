function coverage = CoverageCalc2(sat_lat, sat_lon, sat_alt, fov, earth)

tic
%%%% Satellite View %%%%
az = linspace(0, 360, 36);
[gnd_lat, gnd_lon] = lookAtSpheroid(sat_lat, sat_lon, sat_alt, ...
                                    (ones(numel(sat_lat), 1) * az)', fov, earth);
gnd_lat = gnd_lat';
gnd_lon = gnd_lon';
tmp1 = [NaN];
tmp2 = [NaN];
for i = 1:numel(sat_lat)
   tmp1 = [tmp1, gnd_lat(i, :), NaN];
   tmp2 = [tmp2, gnd_lon(i, :), NaN];
end

axesm ('globe','Grid', 'on');
view(60,60)
axis off
load coastlines; plotm(coastlat, coastlon);

% base = zeros(180,360); baseref = [1 90 0];
% hs = meshm(base,baseref,size(base));
% colormap white;

plotm(tmp1, tmp2, 'r', 'LineWidth', 3);

%%%% Set up Grid %%%%
e_lat_size = 45;
e_lon_size = 90;

e_lat = linspace(-90, 90, e_lat_size + 2);
e_lat = e_lat(2:numel(e_lat)-1);
e_lon = linspace(-180, 180, e_lon_size + 2);
e_lon = e_lon(2:numel(e_lon)-1);
coverage = zeros(e_lat_size, e_lon_size);

% Convert 2D grid into two single vectors with each combination.
k = 1;
for i = 1:numel(e_lat)
   for j = 1:numel(e_lon)
       tmp3(k) = e_lat(i);
       tmp4(k) = e_lon(j);
       k = k + 1;
   end
end

gnd_lat = gnd_lat';
gnd_lon = gnd_lon';
in = inpolygon(tmp3, tmp4, tmp1, tmp2);

% Convert back
k = 1;
for i = 1:numel(e_lat)
   for j = 1:numel(e_lon)
       coverage(i, j) = in(k);
       k = k + 1;
   end
end
toc

Z = coverage;
R = georasterref('RasterSize', size(Z), ...
  'Latlim', [-90 90], 'Lonlim', [-180 180]);
meshm(Z, R)

% area = 100 * areaint(gnd_lat, gnd_lon);
% area_grid = 100 * (areamat(coverage, [0.5 90, -180], earth) / 510.1E6);
