%%%% fmincon Optimisation %%%%

%%%% Decision Variables %%%%
sat1.Ra= 6378+500;
sat1.Rp = 6378+400;
sat1.INC = 98;
sat1.RAAN = 110;
sat1.AOP = 360;
sat1.TA = 0;

sat2.Ra= 6378+500;
sat2.Rp = 6378+400;
sat2.INC = 98;
sat2.RAAN = 200;
sat2.AOP = 360;
sat2.TA = 180;

sat3.Ra= 6378+500;
sat3.Rp = 6378+400;
sat3.INC = 98;
sat3.RAAN = 245;
sat3.AOP = 360;
sat3.TA = 180;

%%%% Optimisation %%%%

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

x0 = [sat1.Ra sat1.Rp sat1.INC sat1.RAAN sat1.AOP sat1.TA ...
      sat2.Ra sat2.Rp sat2.INC sat2.RAAN sat2.AOP sat2.TA ...
      sat3.Ra sat3.Rp sat3.INC sat3.RAAN sat3.AOP sat3.TA];
  
fun = @(x)ObjFunc(x);
x = fmincon(fun, x0, A, b, Aeq, beq, lb, ub);
coverage = ObjFunc(x)
