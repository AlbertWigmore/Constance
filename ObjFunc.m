function [] = ObjFunc()

tsteps = [0:0.01:1];
tsteps = 0.2
[S_lat, S_lon, rmag] = OrbitProp(tsteps, 20659+6371, 0.5, 63.4, 0, 90, 0);

earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 7; % FoV of sensor
e_lat_size = 45; % Currently hardcoded in CoverageCalc
e_lon_size = 90; % Currently hardcoded in CoverageCalc
coverage = zeros(e_lat_size, e_lon_size); 

coverage = CoverageCalc2(S_lat, S_lon, rmag, fov, earth);

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
