function [] = ObjFunc()

tsteps = [0:0.001:1];
[S_lat, S_lon, rmag] = OrbitProp(tsteps, 400+6371, 0.0, 53.0, 0, 90, 0);

earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 10; % FoV of sensor
coverage = CoverageCalc(S_lat, S_lon, rmag, fov, earth);

%% Plotting for verification
worldmap world; load coastlines; plotm(coastlat, coastlon);

e_lat = linspace(90, -90, e_lat_size + 2);
e_lat = e_lat(2:numel(e_lat)-1);
e_lon = linspace(-180, 180, e_lon_size + 2);
e_lon = e_lon(2:numel(e_lon)-1);

contourm(e_lat, e_lon, coverage, 'LineWidth', 5)

%%
h = waitbar(0, 'Calculating Earth Coverage');
for i = 1:numel(tsteps)
    coverage = coverage + CoverageCalc(S_lat(i), S_lon(i), rmag(i), fov, earth);
    waitbar(i / numel(tsteps))
end
close(h)

% Plotting for verification
worldmap world; load coastlines; plotm(coastlat, coastlon);

e_lat = linspace(90, -90, e_lat_size + 2);
e_lat = e_lat(2:numel(e_lat)-1);
e_lon = linspace(-180, 180, e_lon_size + 2);
e_lon = e_lon(2:numel(e_lon)-1);

contourm(e_lat, e_lon, coverage, 'LineWidth', 5)
