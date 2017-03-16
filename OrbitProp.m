function [lat,lon,r] = OrbitProp(timeseries,SMA,ECC,INC,RAAN,AOP,TA)
    %  Returns lat (deg), long (deg), earth radius
    %  magnitude given time series (s) and orbital elements SMA, ECC, INC,
    %  RAAN, AOP, TA. Inputs in km and deg.

    % Turn into rads
    INC = deg2rad(INC); % [rad]
    AOP0 = deg2rad(AOP);
    RAAN0 = deg2rad(RAAN);
    TA = deg2rad(TA);
    
    % Setup initial mean anomaly
    E0 = atan2(sqrt(1+ECC)*sin(TA),sqrt(1-ECC)*cos(TA));
    M0 = wrapTo2Pi(E0 - ECC*sin(E0));

    %EARTH DATA
    J2 = 0.00108263;
    pi = 3.14159265358979;
    mu = 398600; % [km3/s2]
    R_e = 6378.14; % [km]
    We_deg = 360.98564735; %deg/solar day
    We = deg2rad(We_deg);
    lamb_gw_deg_0 = 99.281;
    lamb_gw_0 = deg2rad(lamb_gw_deg_0);
    
    % Orbital period
    N = sqrt(mu/SMA^3)/(2*pi)*86400;

    
    % Loop over time series
    T_Ep = 0; % Epoch time is 0
    iii=1;
    for T_now = timeseries
        %Mean Anomaly
        M = M0 + 2*pi*N*(T_now-T_Ep);
        E(1) = M;

        diff = 1;
        ii = 1;
        while diff > 1e-6
            fE = E(ii)-ECC*sin(E(ii))-M;
            dfE = 1-ECC*cos(E(ii));

            E(ii+1)=E(ii)-fE/dfE;

            diff = abs(E(ii+1)-E(ii));
            ii = ii+1;
        end
        E=E(end);

    nu(iii) = 2*atan(sqrt(1+ECC)/sqrt(1-ECC)*tan(E/2));
    r(iii) = SMA*(1-ECC^2)/(1+ECC*cos(nu(iii)));

    lamb_gw(iii) = wrapTo2Pi(lamb_gw_0 + We*T_now);
    
    RAAN(iii) = wrapTo2Pi(RAAN0 - 3/2*J2*(R_e/SMA)^2*N*2*pi*...
        (1-ECC^2)^(-2)*cos(INC)*(T_now-T_Ep));

    AOP(iii) = wrapTo2Pi(AOP0 + 3/2*J2*(R_e/SMA)^2*N*2*pi*...
        (1-ECC^2)^(-2)*(2-5/2*sin(INC)^2)*(T_now-T_Ep));

    iii=iii+1;
    end

    %Calc Latitude
    lat = asin(sin(AOP+nu)*sin(INC));

    %Calc Longitude
    lambda_sin = tan(lat)/tan(INC);
    lambda_cos = cos(AOP+nu)./cos(lat);
    lon = atan2(lambda_sin,lambda_cos)+RAAN-lamb_gw;
    lon = wrapToPi(lon);

    lat=rad2deg(lat);
    lon=rad2deg(lon);    
end
