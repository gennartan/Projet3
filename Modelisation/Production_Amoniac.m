function [] = Production_Amoniac()
% PRODUCTION_AMONIAC calcule le bilan de masse (et d'energie) de la
% production d'amoniac dans un procede continu

% --- ENTREE -----------------------------------------------------------
% CH4 (methan) [t/j]
% RapO2CH4 (rapport molaire entre O2 et CH4)
% RapH2OCH4 (rapport molaire entre H2O et CH4)
% Tref_ATR (temperature dans la zone de reforming de l'ATR
% P_ATR (pression dans l'ATR)

RapO2CH4 = 0.6; %  []
RapH2OCH4 = 1.5; % []
Tref_ATR = 1200; % [K]
P_ATR = 50*10^5; % [Pa]

CH4 = 800; % [t/j]

% Definition des masses molaire [t/mol]
M_O2 = 32*10^(-6);
M_H2O = 18*10^(-6);
M_CH4 = 16*10^(-6);
M_CO2 = 44*10^(-6);
M_H2 = 2*10^(-6);
M_CO = 28*10^(-6);
M_N2 = 28*10^(-6);
M_NH3 = 17*10^(-6);

% Calcul du debit de O2 [t/j]  et de H2O [t/j] qui rentre dans la zone de combustion de l'ATR
N_CH4 = CH4 / M_CH4; % [mol/j]

N_O2 = RapO2CH4 * N_CH4; % [mol/j] 
O2 = M_O2 * N_O2; % [t/j]
O2_Need = O2; % Pour AirSeparationUnit

N_H2O = RapH2OCH4 * N_CH4; % [mol/j]
H2O = M_H2O * N_H2O; % [t/j]

N2_Need = -1;


[CH4, H2O, CO2, CO, H2] = ATR(N_O2, N_CH4, N_H2O); % Problème d'erections dans l'ATR

[CH4, H2O, CO2, H2] = WGS(CH4, H2O, CO2, CO, H2); % Calcul des reactions dans le WGS

[CH4, H2, H20, CO2] = CondAbs(CH4, H2O, CO2, H2);

[CH4 NH3] = SyntheseAmoniac(CH4, H2)
 
%[N2_Exces, O2_Exces] = AirSeparationUnit(O2_Need, N2_Need);



% fin du processus


% debut des sous-fonctions
    function [CH4, H2O, CO2, CO, H2] = ATR(N_O2, N_CH4, N_H2O)
    % ATR calcule le bilan de masse et d'energie dans l'ATR (autothermal
    % reformer)
    % --- INPUT ---
    % N_O2 (oxygen) [mol/j]
    % N_CH4 (methan) [mol/j]
    % N_H2O (water) [mol/j]
    % --- OUTPUT ---
    % CH4 [t/j]
    % H20 [t/j]
    % CO2 [t/j]
    % CO [t/j]
    % H2 [t/j]
    
    % Conversion en SI
    N_O2 = N_O2 / (24 * 3600); % [mol/s]
    N_CH4 = N_CH4 / (24 * 3600);
    N_H2O = N_H2O / (24 * 3600);
    
    % Premiere reaction : COMBUSTION (complete)
    %                |    CH4     +    2* O2     -->   CO2     +     2* H2O
    % ------------------------------------------------------------------------
    %   m(i) [t/j]   |    CH4           O2              0             H2O(i)
    %   M    [t/mol] |
    %   n(i) [mol]   |
    
    N_reac = min(N_CH4, N_O2/2); % [mol/s] nombre de mol reagissant (par unité de mole de CO2 produite)
    
    N_O2 = N_O2 - 2*N_reac; % [mol/s]
    N_CH4 = N_CH4 - N_reac;
    N_H2O = N_H2O + 2*N_reac;
    N_CO2 = N_reac;
    
    O2 = M_O2 * N_O2; % [t/s]
    CH4 = M_CH4 * N_CH4;
    H2O = M_H2O * N_H2O;
    CO2 = M_CO2 * N_CO2;
    
    % Deuxieme reactio1n : Reformage
    
    %          |  CH4         +      H2O      <-->     3* H2      +    CO
    % ----------------------------------------------------------------------
    %  n(reac) |
    %  n(eq)   | N_CH4-x(1)    N_H2O-x(1)-x(2)    3*x(1)+x(2)    x(1)-x(2)
    K1 = 10^((-11650/Tref_ATR)+13.076); % [bar^2]
    
    %          |   CO     +      2* H2O    <-->    H2       +     CO2
    % ----------------------------------------------------------------------
    %  n(eq)   | x(1)-x(2)   N_H2O-x(1)-x(2)    3*x(1)-x(2)    x(1)-x(2)
    K2 = 10^((1910/Tref_ATR)-1.764);
        function F = myfun(x)
            % X(1) : degre d'avancement de la premiere reaction [mol/s]
%           % X(2) : degre d'avancement de la seconde reaction [mol/s]
            F(1) = (((x(1)-x(2))*(3*x(1)+x(2))^3 * (P_ATR/10^5)^2) / ((N_CH4+N_H2O+2*x(1)+N_CO2)^2 * (N_H2O-x(1)-x(2))*(N_CH4-x(1)))) - K1;
            F(2) = ( ((N_CO2+x(2))*(3*x(1)+x(2))) / ((x(1)-x(2))*(N_H2O-x(1)-x(2))) ) -K2;
        end
    
    % Choix du X0(1) et X0(2)
    % X0(1) est plus petit et proche de N_CH4
    % X0(2) est assez petit par rapport a la valeur de N_CH4
    X0(1) = 0.7*N_CH4;
    X0(2) = 0.01*N_CH4;
    OPTIONS = optimoptions('fsolve', 'MaxFunEvals', 1000);
    X=fsolve(@myfun, X0, OPTIONS);
    
    % Nbre mol sortant de l'atr [mol/j]
    NbreSecParJour = 3600*24;
    
    N_CH4 = (N_CH4-X(1)) * NbreSecParJour;
    N_H2O = (N_H2O-X(1)-X(2)) * NbreSecParJour;
    N_H2 = (3*X(1)+X(2)) * NbreSecParJour;
    N_CO = (X(1)-X(2)) * NbreSecParJour;
    N_CO2 = (N_CO2+X(2)) * NbreSecParJour;
    
    % OUTPUT
    CH4 = N_CH4 * M_CH4; %[t/j]
    H2O = N_H2O * M_H2O;
    H2 = N_H2 * M_H2;
    CO = N_CO * M_CO;
    N_CO2 = N_CO2 * M_CO2;
    
    
    end % ATR

    function [CH4, H2O, CO2, H2] = WGS(CH4, H2O, CO2, CO, H2)
    % WGS Water Gas Shift
    % --- INPUT ---
    % CH4, H2O, CO2, CO, H2 [t/j]
    % --- OUTPUT ---
    % CH4, H2O, CO2, H2 [t/j]
    
    N_H2O = H2O / M_H2O; % [mol/j]
    N_CO2 = CO2 / M_CO2;
    N_CO = CO / M_CO;
    N_H2 = H2 / M_H2;
    
    N_Reac= min(N_CO,N_H2O);
    
    % On considere cette reaction complete
    %          |   CO     +     H2O    <-->    H2     +   CO2
    % ----------------------------------------------------------------------
    %  n(eq)   |    N_CO        N_H2O            N_H2      N_CO2
    
    N_H2O = N_H2O-N_Reac;
    N_CO = N_CO-N_Reac;
    N_H2 = N_H2+N_Reac;
    N_CO2 = N_CO2+N_Reac;
    
    
    % OUTPUT
    CH4 = CH4;
    H2O = N_H2O*M_H2O;
    CO2 = N_CO2*M_CO2;
    CO = N_CO*M_CO;
    H2 = N_H2*M_H2;
    end % WGS

    function [CH4, H2, H2O, CO2] = CondAbs(CH4, H2O, CO2, H2)
    % CONDABS bloc de condensation de l'eau et absorption du CO2
    % Toute l'eau et le CO2 rentrant sont evacues.
    
    H2O = H2O;
    CO2 = CO2;
    CH4 = CH4;
    H2 = H2;
    end % CondAbs

    function [CH4 NH3] = SyntheseAmoniac(CH4, H2)
    % SYNTHESEAMONIAC tache finale de la synthese
    
    %        |   3* H2     +     N2     -->    2* NH3   
    % -------|------------------------------------------------
    %   n(i) |     N_H2         N_N2           0
    
    N_H2 = H2 / M_H2;
    %N_N2 = N2 / M_N2;
    N_N2 = N_H2 /3;
    N2 = N_N2*M_N2;
    N2_Need = N2; % utile pour AirSeparationUnit
    
    N_Reac=min(N_N2, N_H2);
    
    N_H2 = N_H2-3*N_Reac;
    N_N2 = N_N2-N_Reac;
    N_NH3 = 2*N_Reac;
    
    H2 = N_H2 * M_H2;
    N2 = N_N2 * M_N2;
    
    % OUTPUT
    NH3 = N_NH3 * M_NH3;
    CH4 = CH4;
    
    end

    function [N2_Exces, O2_Exces] = AirSeparationUnit(O2_Need, N2_Need)
    % AIRSEPARATIONUNIT Separation de l'air
    % l'air est compose de 21% d'oxygene, et de 79% d'azote.
    
    % Il faut au minimum O2 t d'oxygene par jour
    N_O2 = O2_Need / M_O2;
    N_N2 = N2_Need / M_N2;

    
%     N_produced = max(N_O2, N_N2);
%     N2_Exces = N_produced - N_N2;
%     O2_Exces = N_produced - N_O2;
    end
        
end % Production_Amoniac

