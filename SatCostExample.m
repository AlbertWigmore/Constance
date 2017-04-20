% Test of the SatCost function
close all
clear

inc = linspace(0,120,50);
Ra = linspace(6378+450,6378+100000,80);
TestSat.Rp = 6378+450;
sma = (Ra+TestSat.Rp)/2;

for i = 1:numel(inc)
    for j = 1:numel(sma)
        TestSat.INC = inc(i);
        TestSat.Ra = Ra(j);
        cost(i,j) = SatCost(TestSat);
    end
end

 surf(sma,inc,cost)
 zlim([0 2.5e8])
 box on
 xlabel('SMA')
 ylabel('INC')
 zlabel('Cost')