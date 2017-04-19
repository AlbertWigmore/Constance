% Test of the SatCost function
close all
clear

inc = linspace(0,120,50);
sma = linspace(earthRadius()/1000+450,earthRadius()/1000+50000,80);

for i = 1:numel(inc)
    for j = 1:numel(sma)
        TestSat.INC = inc(i);
        TestSat.SMA = sma(j);
        cost(i,j) = SatCost(TestSat);
    end
end

 surf(sma,inc,cost)
 zlim([0 2.5e8])
 box on
 xlabel('SMA')
 ylabel('INC')
 zlabel('Cost')