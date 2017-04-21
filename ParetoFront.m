%%%% PS Optimisation %%%%
nvars = 6;
lb = [6778 6778 0 0 0 0];
ub = [46378 46378 120 360 360 360]; % you can have inclinations of >90deg
  
options = optimoptions('particleswarm', 'UseParallel', 1, 'SwarmSize', 100, ...
                       'PlotFcn', {@pswplotbestf});


weights = 0;
for n = 5:5:15
    weights = [weights setdiff(linspace(0, 1, n + 1), weights)];
end

for w = 1:numel(weights)
    disp(['Commencing weight ',num2str(w),' of ',...
        num2str(numel(weights)),', a: ',num2str(weights(w))]);
    a = weights(w);
    fun = @(x)MultiObjFunc(x, a);
    [x{w}, fval{w}, exitflag{w}, output{w}] = particleswarm(fun, nvars, lb, ub, options);
end

%%

for i = 1:numel(weights)
    f{i} = MultiObjFunc(x{1}, a);
end