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

fun = @(x)MultiObjFunc(x, a);

weights = [0, 0.25, 0.5, 0.75, 1];

for w = 1:numel(weights)
    a = weights(w);
    [x{w}, fval{w}, exitflag{w}, output{w}] = particleswarm(fun, nvars, lb, ub, options);
end
