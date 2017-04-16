function [tsteps_new,nu_new,S_lat_new,S_lon_new,rmag_new] = SelectiveTime(tsteps,nu,S_lat,S_lon,rmag,howclose)
Brk = find(abs(diff(nu))>.9*pi);
Brk = [1,Brk,numel(tsteps)];

nu_target = 0:deg2rad(howclose):2*pi;
ind = 1;

for BrkNo = 1:numel(Brk)-1
    for targetCount = 1:numel(nu_target)
        [~,index(ind)] = min(abs(nu(Brk(BrkNo):Brk(BrkNo+1))-nu_target(targetCount)));
        index(ind)= index(ind)+Brk(BrkNo)-1;
        ind = ind+1;
    end
end

index = unique(index);

tsteps_new = tsteps(index); nu_new = nu(index); S_lat_new = S_lat(index);
S_lon_new = S_lon(index); rmag_new = rmag(index);

end