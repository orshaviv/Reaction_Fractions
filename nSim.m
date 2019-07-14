classdef nSim < handle
    properties
        TotalTime = 20; %min
        dt = 1; %sec
        n0 = [1 0 0 0];
        timeDep = 0; %1 - k1=k1(t) or 0-k1 const.
        
        time
        n
        
        hadv = 51e-3; %mm
        DKCL = 0.1e-4; %mm^2/s
        k1ss = 0.1926; %s^-1
        
        KCaCaM = 1.78e-3; %1.78e-7; %M
        alpha = 35e-6;
        Ca = 2.5e-3; %mM to M
        
        k = [0.1926, 0.5, 0.4, 0.1, 0.5, 0.1926, 0.01];
    end
    
    methods
        
        function obj = k1(obj)
            obj.k1ss = ((obj.alpha*obj.Ca)^2)/ ( (obj.alpha*obj.Ca)^2 + obj.KCaCaM^2 );
            obj.k(6) = obj.k1ss;
            obj.k(1) = obj.k1ss;
        end
       
        function k1t = k1t(obj,t)
            k1t = obj.k1ss*erfc(obj.hadv./(2*sqrt(obj.DKCL*t)));
        end
        
        function obj = nCalc(obj)
            function dydt = myode(t,y)
                if obj.timeDep
                    obj.k(1) = obj.k1t(t);
                end
                kM = [-obj.k(1), obj.k(2), 0, obj.k(7)
                    obj.k(1), -obj.k(2)-obj.k(3), obj.k(4), 0
                    0, obj.k(3), -obj.k(4)-obj.k(5), obj.k(6)
                    0, 0, obj.k(5), -obj.k(6)-obj.k(7)];
                dydt = kM*y;
            end
            [obj.time, obj.n] = ode15s(@(t,y) myode(t,y),0:obj.dt:obj.TotalTime*60,obj.n0);
        end
        
        function [SSn] = SSValues(obj)
            SSn = obj.n(length(obj.n),:);
        end
        
        function plotStress(obj)
            figure();
            plot(obj.time./60,[obj.n(:,3)+obj.n(:,4),obj.n(:,2)+obj.n(:,3)]);
            xlabel('time (min)'); ylabel('Fractions');
            legend('n3+n4','n2+n3');
            ylim([0 1]); xlim([0 obj.TotalTime]);
            grid on;
        end
        function plotFractions(obj)
            figure();
            plot(obj.time./60,obj.n);
            xlabel('time (min)'); ylabel('Fractions');
            legend('n1','n2','n3','n4');
            ylim([0 1]); xlim([0 obj.TotalTime]);
            grid on;
        end
    end
end

