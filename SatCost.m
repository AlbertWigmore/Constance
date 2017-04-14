function [Cost] = SatCost(SatelliteStruct)
% Costing function of a satellite given its orbital parameters (in struct)

    % Set up estimate SMAs and masses for LEO and GEO for reference
    % COSTING IS REALLY SENSITIVE TO THIS
    m_LEO = 5000; % kg; mass of a typical LEO satellite
    m_GEO = 9000; % kg; mass of a typical GEO satellite
    SMA_LEO = 6771; % km; semi-major axis of LEO satellite
    SMA_GEO = 42164; % km; semi-major axis of GEO satellite
    
    %% Evaluate mass of sat by linear best fit
    SatelliteStruct.p = polyfit([SMA_LEO,SMA_GEO],[m_LEO,m_GEO],1);
    SatelliteStruct.m = polyval(SatelliteStruct.p,SatelliteStruct.SMA);
    
    %% Estimate launch cost of Soyuz
    Soyuz.masstoLEO = 9000;
    Soyuz.masstoGEO = 3250;
    Soyuz.p = polyfit([SMA_LEO,SMA_GEO],[Soyuz.masstoLEO,Soyuz.masstoGEO],1);
               % (assuming linear variation of launchable mass with SMA...)
    Soyuz.masstoChosenOrbit = polyval(Soyuz.p,SatelliteStruct.SMA);
    % Allow a reduction if more than 3/5 of capacity is left unused
    if SatelliteStruct.m < 3/5*Soyuz.masstoChosenOrbit
        Soyuz.cost = SatelliteStruct.m/Soyuz.masstoChosenOrbit...
            *70e6;
    elseif SatelliteStruct.m <= Soyuz.masstoChosenOrbit
        Soyuz.cost = 70e6;
    else
        Soyuz.cost = 1e100; % Cannot be launched
    end
    
    %% Estimate launch cost of Ariane 5
    A5.masstoLEO = 21000;
    A5.masstoGEO = 10730;
    A5.p = polyfit([SMA_LEO,SMA_GEO],[A5.masstoLEO,A5.masstoGEO],1);
               % (assuming linear variation of launchable mass with SMA...)
    A5.masstoChosenOrbit = polyval(A5.p,SatelliteStruct.SMA);
    A5.masstoChosenOrbit = polyval(A5.p,SatelliteStruct.SMA);
    % Allow a reduction if more than 3/5 of capacity is left unused
    if SatelliteStruct.m < 3/5*A5.masstoChosenOrbit
        A5.cost = SatelliteStruct.m/A5.masstoChosenOrbit...
            *120e6;
    elseif SatelliteStruct.m <= A5.masstoChosenOrbit
        A5.cost = 120e6;
    else
        A5.cost = 1e20; % Cannot be launched
    end
    
    %% Take best launch cost of two rockets
    SatelliteStruct.cost.launch = min(A5.cost,Soyuz.cost);
    
    %% Add a penalty for launching into an inclined orbit
    penalty = SatelliteStruct.INC/180/5;
    SatelliteStruct.cost.inclinationPenalty = SatelliteStruct.cost.launch*penalty;
    
    %% Estimate the cost of the imaging payload
    if SatelliteStruct.SMA < 7371   
        % LEO payloads less intense optics = cheaper yay
        SatelliteStruct.cost.payload = 5e6;
    elseif SatelliteStruct.SMA < 26371
        % MEO payloads reasonable optics = meh
        SatelliteStruct.cost.payload = 7e6;
    elseif SatelliteStruct.SMA < SMA_GEO
        % GEO dorra dorra
        SatelliteStruct.cost.payload = 12e6;
    else
        % #getrekt
        SatelliteStruct.cost.payload = 20e6;
    end
    
    %% Sum all satellite costs
    Cost = sum(structfun(@sum,SatelliteStruct.cost));
       
end