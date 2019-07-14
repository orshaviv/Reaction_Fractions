close all; clear all; clc;

a = nSim;


if 1
    %Calculate SS values as a function of [Ca++] and activation parameters (by eventually changing k1)
    Ca = logspace(-10,5,100);
    alpha = [1 35 70 105];
    
    n = zeros(length(alpha),length(Ca),4);
    for i=1:length(alpha)
        for j=1:length(Ca)
            a.alpha = alpha(i);
            a.Ca = Ca(j);
            a.k1;
            a.nCalc;
            n(i,j,:) = a.SSValues;
        end
    end
    
    %semilogx(Ca,(n(1,:,3)+n(1,:,4))/max(n(1,:,3)+n(1,:,4)));
    plot(log(Ca)/log(10),(n(1,:,3)+n(1,:,4))/max(n(1,:,3)+n(1,:,4)));
    hold on;
    str(1,:) = '\alpha='; %'K_{CaCaM}=';
    str2(1,:) = ' '; ' (\muM)';
    for i=2:length(alpha)
        plot(log(Ca)/log(10),(n(i,:,3)+n(i,:,4))/max(n(i,:,3)+n(i,:,4)));
        str(i,:) = str(1,:);
        str2(i,:) = str2(1,:);
    end
    ylim([0 1.2]); xlim([-8 0]);
    
    xlabel('log(Ca^{2+}) (log(M))');
    ylabel('(n_{AMp}+n_{AM}) / {(n_{AMp}+n_{AM})_{max}}');
    
    legend([str num2str( alpha',3) str2]);
    hold off;
end

if 0
    k1 = [0.01, 0.1, 0.25, 0.4, 1];%linspace(0.01,1,5);
    a.nCalc; SamplePoints = length(a.time);
    n = zeros(length(k1),SamplePoints,4);
    for i=1:length(k1)
        a.k(1) = k1(i); a.k(6) = k1(i);
        a.nCalc;
        n(i,:,:) = a.n;
    end

    figure(); hold on;
    for i=1:length(k1)
        plot(a.time./60,n(i,:,3)+n(i,:,4));
        str(i,:) = 'k_1=';
        str2(i,:) = ' (s^{-1})';
    end
    ylim([0 1]); xlim([0 10]);

    xlabel('time (min)');
    ylabel('n_{AMp}+n_{AM}');


    legend([str num2str( k1',3) str2]);
    hold off;
end


if 0 
    CaCaM = linspace(0,4,100);
    k1 = @(CaCaM) (CaCaM.^2)./( (CaCaM.^2) + (0.178).^2 );
    plot(CaCaM,k1(CaCaM))
    ylabel('k1'); xlabel('CaCaM (\muM)'); 
    
    Ca = linspace(0,4,100);
    ED50 = 0.37; %uM
    h = 4;
    eta = 21.55; %min^-1
    k1 = @(Ca,ED50,eta,h) eta .* (Ca.^h) ./ ( (Ca.^h) + (ED50.^h) );
end


% figure(); hold on;
% for i=1:length(k1)
%     h(i) = plot(a.time./60,(n(i,:,3)+n(i,:,4))/max(n(i,:,3)+n(i,:,4)));
% end
% xlim([0 5]); ylim([0 1]);
% xlabel('time (min)'); ylabel('(n_{AMp}+n_{AM}) / {(n_{AMp}+n_{AM})_{max}}');
% 
% str = ['k1=';'k1=';'k1=';'k1=';'k1=';'k1=';'k1=';'k1=';'k1=';'k1='];
% legend([str num2str(k1',2)]);
% hold off;
 
% figure();
% plot(k1,n(:,3)+n(:,4));
% ylim([0 1]);
% ylabel('n_{AMp}+n_{AM}'); xlabel('k_1 (s^{-1})');

% legend('K_{CaCaM}= 1 \muM','K_{CaCaM}= 1.78 \muM','K_{CaCaM}= 3.56 \muM','K_{CaCaM}= 5.34 \muM');


