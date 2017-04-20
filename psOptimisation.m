%%%% PS Optimisation %%%%
nvars = 18;
lb = [6778 6778 0 0 0 0 ...
      6778 6778 0 0 0 0 ...
      6778 6778 0 0 0 0];
ub = [46378 46378 120 360 360 360 ...
      46378 46378 120 360 360 360 ...
      46378 46378 120 360 360 360]; % you can have inclinations of >90deg
  
options = optimoptions('particleswarm', 'UseParallel', 1, 'SwarmSize', 100, ...
                       'PlotFcn', {@pswplotbestf});

fun = @(x)ObjFunc(x);
[x, fval, exitflag, output] = particleswarm(fun, nvars, lb, ub, options);
