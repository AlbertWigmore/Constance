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

coverage_calc(sat_lat(10), sat_lon(10), sat_alt(10), fov, earth)