f = fopen('ReportFile2.txt', 'r');
line = fgetl(f);
i = 1;
while ischar(line)
    try
        line = fgetl(f);
        val = strsplit(line, ' ');
        sat_lat(i) = str2double(val(1));
        sat_lon(i) = str2double(val(2));
        sat_alt(i) = str2double(val(3));
        i = i + 1;
    catch
    end
end
fclose('all');
clear line i f val


%%%% Setup %%%%

earth = wgs84Ellipsoid('km'); % Earth Ellipsoid based on WGS84 Model.
fov = 5;

%%%% Satellite View %%%%
az = linspace(0, 360, 100);
[gnd_lat, gnd_lon] = lookAtSpheroid(sat_lat(15), sat_lon(15), ...
                                    sat_alt(15), az, fov, earth);
worldmap world; load coastlines; plotm(coastlat, coastlon);
% plotm(gnd_lat, gnd_lon, 'r', 'LineWidth', 3);
% pcolorm(lat, lon, ones(1, numel(lat)));
% geoshow(lat, lon)
clear coastlat coastlon

tic

%%%% Set up Grid %%%%
e_lat_size = 90;
e_lon_size = 180;

e_lat = linspace(90, -90, e_lat_size + 2);
e_lat = e_lat(2:numel(e_lat)-1);
e_lon = linspace(-180, 180, e_lon_size + 2);
e_lon = e_lon(2:numel(e_lon)-1);
coverage = zeros(e_lat_size, e_lon_size); % Dunno what this does yet?
ncoverage = zeros(e_lat_size, e_lon_size);

plotm(gnd_lat, gnd_lon, 'r', 'LineWidth', 3);

%%%% Bounding Box %%%%

% Determine bounding box
max_gnd_lat = max(gnd_lat); min_gnd_lat = min(gnd_lat);
max_gnd_lon = max(gnd_lon); min_gnd_lon = min(gnd_lon);

% Check to see whether North/South or other
n = 0; % Default case
if max_gnd_lon - min_gnd_lon > 180.0 && mean(gnd_lat) > 0
    n = 'N';
elseif max_gnd_lon - min_gnd_lon > 180.0 && mean(gnd_lat) < 0
    n = 'S';
end

if n ~= 0
   % Rearrange longitudes to be in order -180 to 180 to fix North/South
    tmp = [gnd_lat; gnd_lon];
    [~, I] = sort(tmp(2,:));
    tmp = tmp(:, I);
    gnd_lat = tmp(1, :);
    gnd_lon = tmp(2, :);
    clear tmp Y I 
end

%%%% Determining points inside coverage %%%%
switch n
    case 'N'
        %%% North Pole %%%
        
        % Find valid Latitudes, Longitudes to search
        search_lat = e_lat(find(e_lat > min_gnd_lat));
        search_lon = e_lon;
        
        for i = 1:numel(search_lat)
            for j = 1:numel(search_lon)
                [xi, yi] = polyxpoly([search_lat(i), 90], ...
                                     [search_lon(j), search_lon(j)], [gnd_lat NaN], [gnd_lon NaN]);
                lati = find(e_lat == search_lat(i));
                loni = find(e_lon == search_lon(j));
                if xi
                    ncoverage(lati, loni) = ncoverage(lati, loni) + 1;
                else
                    coverage(lati, loni) = coverage(lati, loni) + 1;
                end
                
            end            
        end
    case 'S'
        %%% South Pole %%%
        
        % Find valid Latitudes, Longitudes to search
        search_lat = e_lat(find(e_lat < max_gnd_lat));
        search_lon = e_lon;
        
        for i = 1:numel(search_lat)
            for j = 1:numel(search_lon)
                [xi, yi] = polyxpoly([search_lat(i), -90], ...
                                     [search_lon(j), search_lon(j)], [gnd_lat NaN], [gnd_lon NaN]);
                lati = find(e_lat == search_lat(i));
                loni = find(e_lon == search_lon(j));
                if xi
                    ncoverage(lati, loni) = ncoverage(lati, loni) + 1;
                else
                    coverage(lati, loni) = coverage(lati, loni) + 1;
                end
                
            end            
        end
    otherwise
        %%% Standard Case %%%
        
        % Find valid latitudes to search
        search_lat = e_lat(find(e_lat < max_gnd_lat));
        search_lat = search_lat(find(search_lat > min_gnd_lat));

        % Find valid longitudes to search
        search_lon = e_lon(find(e_lon < max_gnd_lon));
        search_lon = search_lon(find(search_lon > min_gnd_lon));
        
        % Determine which points intersect
        for i = 1:numel(search_lat)
            for j = 1:numel(search_lon)
                [xi, yi] = polyxpoly([search_lat(i), 90], ...
                                     [search_lon(j), search_lon(j)], gnd_lat, gnd_lon);
                lati = find(e_lat == search_lat(i));
                loni = find(e_lon == search_lon(j));
                if numel(xi) == 1
                    coverage(lati, loni) = coverage(lati, loni) + 1;
                else
                    ncoverage(lati, loni) = ncoverage(lati, loni) + 1;
                end
                
            end            
        end
end

toc

for i = 1:numel(search_lat)
    plotm(search_lat(i) * ones(1, numel(search_lon)), search_lon, 'm.');
end

% contourm(e_lat, e_lon, coverage, 'LineWidth', 5)

