%%%% SA Optimisation %%%%

%%%% Decision Variables %%%%
sat1.SMA= 6878;
sat1.ECC = 0;
sat1.INC = 98;
sat1.RAAN = 110;
sat1.AOP = 360;
sat1.TA = 0;

sat2.SMA= 6678;
sat2.ECC = 0;
sat2.INC = 98;
sat2.RAAN = 200;
sat2.AOP = 360;
sat2.TA = 180;

sat3.SMA= 7278;
sat3.ECC = 0;
sat3.INC = 98;
sat3.RAAN = 245;
sat3.AOP = 360;
sat3.TA = 180;

%%%% Optimisation %%%%
lb = [6378 0 0 0 0 0 ...
      6378 0 0 0 0 0 ...
      6378 0 0 0 0 0];
ub = [43000 0.01 90 360 360 360 ...
      43000 0.01 90 360 360 360 ...
      43000 0.01 90 360 360 360];

x0 = [sat1.SMA sat1.ECC sat1.INC sat1.RAAN sat1.AOP sat1.TA ...
      sat2.SMA sat2.ECC sat2.INC sat2.RAAN sat2.AOP sat2.TA ...
      sat3.SMA sat3.ECC sat3.INC sat3.RAAN sat3.AOP sat3.TA];
  
fun = @(x)ObjFunc(x);

options = optimoptions(@simulannealbnd, 'InitialTemperature', 100, ...
                       'TemperatureFcn', @temperatureboltz, ...
                       'PlotFcn',{@saplotbestf, @saplottemperature, ...
                                  @saplotf, @saplotstopping});
x = simulannealbnd(fun, x0, lb, ub, options);

coverage = ObjFunc(x)
