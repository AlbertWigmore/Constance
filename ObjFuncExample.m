
sat1.SMA= 6878;
sat1.ECC = 0;
sat1.INC = 98;
sat1.RAAN = 110;
sat1.AOP = 360;
sat1.TA = 0;

sat2.SMA= 6878;
sat2.ECC = 0;
sat2.INC = 98;
sat2.RAAN = 200;
sat2.AOP = 360;
sat2.TA = 180;

sat3.SMA= 6878;
sat3.ECC = 0;
sat3.INC = 98;
sat3.RAAN = 245;
sat3.AOP = 360;
sat3.TA = 180;

x = [sat1.SMA sat1.ECC sat1.INC sat1.RAAN sat1.AOP sat1.TA ...
     sat2.SMA sat2.ECC sat2.INC sat2.RAAN sat2.AOP sat2.TA ...
     sat3.SMA sat3.ECC sat3.INC sat3.RAAN sat3.AOP sat3.TA];

coverage = ObjFunc(x);

%%%% Plotting for verification %%%%
axesm ('globe','Grid', 'on');
view(60,60)
axis off
load coastlines; plotm(coastlat, coastlon);

%base = zeros(180,360); baseref = [1 90 0];
%hs = meshm(base,baseref,size(base));
%colormap white;
% plotm(grid_lat(coverage == 1), grid_lon(coverage == 1),'m+');

R = georasterref('RasterSize', size(coverage'), ...
  'Latlim', [-90 90], 'Lonlim', [-180 180]);
meshm(coverage', R);
