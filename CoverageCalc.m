function coverage = CoverageCalc(sat_lat, sat_lon, sat_alt, grid_lat, grid_lon, coverage, fov, earth);
%%%% Satellite View %%%%
az = linspace(0, 360, 36);
[gnd_lat, gnd_lon] = lookAtSpheroid(sat_lat, sat_lon, sat_alt, ...
                                    (ones(numel(sat_lat), 1) * az)', ... 
                                    fov, earth);
                                
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
            coverage = coverage + inpolygon(grid_lat, grid_lon, tmp1, tmp2);
        elseif mean(gnd_lat(:, i)) < 0 
            % South Pole
            [gnd_lon(:, i), sortindex] = sort(gnd_lon(:, i));
            gnd_lat(:, i) = gnd_lat(sortindex, i);            
            tmp1 = [gnd_lat(:, i); gnd_lat(end, i); -90; -90; gnd_lat(1, i)];
            tmp2 = [gnd_lon(:, i); 180; 180; -180; -180];
            coverage = coverage + inpolygon(grid_lat, grid_lon, tmp1, tmp2);     
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
        coverage = coverage + inpolygon(grid_lat, grid_lon, tmp3, tmp4);
        
        % Western Hemisphere
        tmp3 = tmp7(sign(tmp8) < 0);
        tmp4 = tmp8(sign(tmp8) < 0);
        coverage = coverage + inpolygon(grid_lat, grid_lon, tmp3, tmp4);
    else
        coverage = coverage + inpolygon(grid_lat, grid_lon, gnd_lat(:, i), gnd_lon(:, i));
    end
   
end
%%%% Plotting %%%%
% axesm ('globe','Grid', 'on');
% view(60,60)
% axis off
% load coastlines; plotm(coastlat, coastlon);
% 
% base = zeros(180,360); baseref = [1 90 0];
% hs = meshm(base,baseref,size(base));
% colormap white;
% 
% plotm(gnd_lat, gnd_lon, 'r', 'LineWidth', 3);
% plotm(grid_lat(coverage == 1), grid_lon(coverage == 1),'m.');
% plotm(grid_lat(coverage >= 1), grid_lon(coverage >= 1),'b.');
