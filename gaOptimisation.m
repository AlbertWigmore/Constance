%%%% GA Optimisation %%%%
nvars = 18;
A = [];
b = [];
Aeq = [];
beq = [];
lb = [6778 6778 0 0 0 0 ...
      6778 6778 0 0 0 0 ...
      6778 6778 0 0 0 0];
ub = [46378 46378 120 360 360 360 ...
      46378 46378 120 360 360 360 ...
      46378 46378 120 360 360 360]; % you can have inclinations of >90deg
nonlcon = [];
 
fun = @(x)ObjFunc(x);

options = gaoptimset('UseParallel', 1, 'PopulationSize', 20, ...
                     'PlotFcn', {@gaplotdistance, @gaplotbestindiv, ...
                                 @gaplotscores, @gaplotgenealogy});
[x, fval, exitflag, output, population, scores] = ...
ga(fun, nvars, A, b, Aeq, beq, lb, ub, nonlcon, options);
