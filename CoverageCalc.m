function ret = CoverageCalc(sat_lat, sat_lon, sat_alt, sat, grid_lat, grid_lon, tsteps, fov, earth);
%%%% Satellite View %%%%
az = linspace(0, 360, 36);

%%%% Calculated FoV that miss Earth %%%%
fov = fov * ones(1, numel(sat_lat));
max_fov = atand(6353./(sat_alt+6353));
try
   fov(fov > max_fov) = max_fov;
catch exception
   % Ignore the warning, just means no FoV's where altered
end

%%%% Calculate Latitude and Longitude Points on Ground
[gnd_lat, gnd_lon] = lookAtSpheroid(sat_lat, sat_lon, sat_alt, ...
                                    (ones(numel(sat_lat), 1) * az)', ... 
                                    fov, earth);
coverage = zeros(numel(grid_lon(:, 1)), numel(grid_lat(1, :)));
time = NaN(numel(grid_lon(:, 1)), numel(grid_lat(1, :)), numel(tsteps));

%%%% Determine points inside satellite FoV %%%% 
for i = 1:numel(sat_lat)
    A = gnd_lon(:, i); A(A > 0) = 1; A(A < 0) = 0;
    x = find(diff(A) ~= 0);
    y = abs(diff(gnd_lon(:, i)));
    y = y(y > 180);
    
    if numel(x) == 2 && numel(y) == 1
        if mean(gnd_lat(:, i)) > 0 
            % North Pole
            [gnd_lon(:, i), sortindex] = sort(gnd_lon(:, i));
            gnd_lat(:, i) = gnd_lat(sortindex, i);
            tmp1 = [gnd_lat(:, i); gnd_lat(end, i); 90; 90; gnd_lat(1, i)];
            tmp2 = [gnd_lon(:, i); 180; 180; -180; -180];
            tmp_coverage = inpolygon(grid_lat, grid_lon, tmp1, tmp2);
        elseif mean(gnd_lat(:, i)) < 0 
            % South Pole
            [gnd_lon(:, i), sortindex] = sort(gnd_lon(:, i));
            gnd_lat(:, i) = gnd_lat(sortindex, i);            
            tmp1 = [gnd_lat(:, i); gnd_lat(end, i); -90; -90; gnd_lat(1, i)];
            tmp2 = [gnd_lon(:, i); 180; 180; -180; -180];
            tmp_coverage = inpolygon(grid_lat, grid_lon, tmp1, tmp2);     
        end
    elseif numel(x) == 2 && numel(y) == 2 
        % Add geometry points to fix the overlap
        tmp7 = [gnd_lat(1:x(1), i); gnd_lat(x(1), i); ...
                gnd_lat(x(1) + 1, i); gnd_lat(x(1) + 1:x(2), i); ...
                gnd_lat(x(2), i); gnd_lat(x(2)+1, i); ...
                gnd_lat(x(2) + 1:end, i)];
        tmp8 = [gnd_lon(1:x(1), i); 180; -180; gnd_lon(x(1) + 1:x(2), i); ...
                -180; 180; gnd_lon(x(2) + 1:end, i)];
            
        % Eastern Hemisphere
        tmp3 = tmp7(sign(tmp8) > 0);
        tmp4 = tmp8(sign(tmp8) > 0);
        tmp_coverage = inpolygon(grid_lat, grid_lon, tmp3, tmp4);
        
        % Western Hemisphere
        tmp3 = tmp7(sign(tmp8) < 0);
        tmp4 = tmp8(sign(tmp8) < 0);
        tmp_coverage = tmp_coverage + inpolygon(grid_lat, grid_lon, tmp3, tmp4);
    else
        tmp_coverage = inpolygon(grid_lat, grid_lon, gnd_lat(:, i), gnd_lon(:, i));
    end
    coverage = coverage + tmp_coverage;
    test = time(:, :, i);
    test(tmp_coverage == 1) = tsteps(i);
    time(:, :, i) = test;
end
% Calulated all points seen and set to one
coverage(coverage > 1) = 1;

% Calculate orbit period in same units as time input
orbit = 2*pi*sqrt((sat.SMA*1000)^3/3.986E14)/60/60/24;

% Calculate all points that are visited multiple times
time = sort(time, 3);
time_diff = (time(:, :, 2:end) - time(:, :, 1:end-1)) > 0.9 * orbit;
coverage = coverage + sum(time_diff(:, :, :), 3);

ret.coverage = coverage;
ret.time = time;
