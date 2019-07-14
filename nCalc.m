function [time,n] = nCalc(k,TotalTime,dt,n0,k1t)
    function dydt = myode(t,y)
        if exist('k1t','var')
            k(1) = k1t(t);
        end
        kM = [-k(1), k(2), 0, k(7)
            k(1), -k(2)-k(3), k(4), 0
            0, k(3), -k(4)-k(5), k(6)
            0, 0, k(5), -k(6)-k(7)];
        dydt = kM*y;
    end
    [time, n] = ode15s(@(t,y) myode(t,y),0:dt:TotalTime*60,n0);
end