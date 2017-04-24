close all
coverage = ObjFunc2(x);

%%%% Plotting for verification %%%%
FigHandle = figure();
% set(FigHandle, 'Position', [0, 0, 1920, 1080]);
worldmap('World'); load coastlines; plotm(coastlat, coastlon)
R = georasterref('RasterSize', size(coverage'), ...
                 'Latlim', [-90 90], 'Lonlim', [-180 180]);

coverage(coverage == 0) = NaN;
[c, h] = contourm(coverage', R, 'fill', 'on');
ch = get(h,'child');
alpha(ch, 0.5);