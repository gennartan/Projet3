function [] = Amo()
% PRODUCTION_AMONIAC calcule le bilan de masse (et d'energie) de la
% production d'amoniac dans un procede continu

% CONSTANTE DONNEES (transformees en SI si necessaire)
RapO2CH4 = 0.6; %  []
RapH2OCH4 = 1.5; % []
Tref_ATR = 1200; % [K]
P_ATR = 50*10^5; % [Pa]
c_pg = 2.500; % [J/g/K]

DH0_CH4 = -803000; %[J/mol]
DH0_SMR = 222000; %[J/mol]
DH0_WGS = -37300; %[J/mol]

CH4 = 800 *10^6/(3600*24); %[g/s]

% Definition des masses molaire [g/mol]
M_O2 = 32;
M_H2O = 18;
M_CH4 = 16;
M_CO2 = 44;
M_H2 = 2;
M_CO = 28;
M_N2 = 28;
M_NH3 = 17;
M_Air = 28.84;

% Calcul du debit de O2 [g/s]  et de H2O [g/s] qui rentre dans la zone de combustion de l'ATR
N_CH4 = CH4 / M_CH4; %[mol/s]
N_O2 = RapO2CH4 * N_CH4; % [mol/s] 
N_H2O = RapH2OCH4 * N_CH4; % [mol/s]

N_O2_Need = N_O2; % Pour le caclul dans Air separation unit

[N_CH4, N_H2O, N_CO2, N_CO, N_H2, Ti, Tf] = ATR(N_O2, N_CH4, N_H2O); % Probleme d'erection dans l'ATR

[N_CH4, N_H2O, N_CO2, N_H2] = WGS(N_CH4, N_H2O, N_CO2, N_CO, N_H2); % Calcul des reaction dans le WGS

[N_CH4, N_H2, N_H2O, N_CO2] = CondAbs(N_CH4, N_H2O, N_CO2, N_H2);

N_N2_Need = N_H2 /3; % Maintenant on sait de combien de moles d'azote on a besoin (Air separation unit)
N_N2 = N_N2_Need;

[N_CH4 ,NH3] = SyntheseAmoniac(N_CH4, N_H2, N_N2);

[N_Air_Need] = AirSeparationUnit(N_O2_Need, N_N2_Need);

% fin du processus

% Debut des sous fonctions

    function [N_CH4, N_H2O, N_CO2, N_CO, N_H2, Ti, Tf] = ATR(N_O2, N_CH4, N_H2O)
    % ATR calcule le bilan de masse et d'energie dans l'ATR (autothermal
    % reformer)
    % --- INPUT ---
    % N_O2 (oxygen) [mol/s]
    % N_CH4 (methan) [mol/s]
    % N_H2O (water) [mol/s]
    % --- OUTPUT ---
    % N_CH4 [mol/s]
    % N_H20 [mol/s]
    % N_CO2 [mol/s]
    % N_CO [mol/s]
    % N_H2 [mol/s]
    
    M_entrant = N_O2*M_O2 + N_CH4*M_CH4 + N_H2O*M_H2O; %[g/s]
    
    % [][][][][][] Premiere reaction : COMBUSTION (reaction complete) [][][][][][][]
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
    
    % Energie
    DH_comb = N_reac*DH0_CH4; %[J/s]
    
    % [][][][][][][] Deuxieme reactio1n : Reformage (reaction incomplete)[][][][][][][]
    % degre d'avancement : K1
    %          |  CH4         +      H2O      <-->     3* H2      +    CO
    % ----------------------------------------------------------------------
    %  n(reac) |
    %  n(eq)   | N_CH4-x(1)    N_H2O-x(1)-x(2)    3*x(1)+x(2)    x(1)-x(2)
    % |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    % degre d'avancement : K2
    %          |   CO     +      2* H2O    <-->    H2       +     CO2
    % ----------------------------------------------------------------------
    %  n(eq)   | x(1)-x(2)   N_H2O-x(1)-x(2)    3*x(1)-x(2)    x(1)-x(2)
    
    K1 = 10^((-11650/Tref_ATR)+13.076); % [bar^2]
    K2 = 10^((1910/Tref_ATR)-1.764); % []
    
    % Resolution du systeme : 2 equations 2 inconnues
    function F = myfun(x)
        % X(1) : degre d'avancement de la premiere reaction [mol/s]
        % X(2) : degre d'avancement de la seconde reaction [mol/s]
        F(1) = (((x(1)-x(2))*(3*x(1)+x(2))^3 * (P_ATR/10^5)^2) / ((N_CH4+N_H2O+2*x(1)+N_CO2)^2 * (N_H2O-x(1)-x(2))*(N_CH4-x(1)))) - K1;
        F(2) = ( ((N_CO2+x(2))*(3*x(1)+x(2))) / ((x(1)-x(2))*(N_H2O-x(1)-x(2))) ) -K2;
    end
    % Choix du X0(1) et X0(2)
    % X0(1) est plus petit et proche de N_CH4
    % X0(2) est assez petit par rapport a la valeur de N_CH4
    X0(1) = 0.8*N_CH4;
    X0(2) = 0.05*N_CH4;
    OPTIONS = optimoptions('fsolve', 'MaxFunEvals', 1000);
    X=fsolve(@myfun, X0, OPTIONS);
    
    N_CH4 = (N_CH4-X(1));
    N_H2O = (N_H2O-X(1)-X(2));
    N_H2 = (3*X(1)+X(2));
    N_CO = (X(1)-X(2));
    N_CO2 = (N_CO2+X(2));
    
    % Energie
    DH_SMR = DH0_SMR * X(1); %[J/s]
    DH_WGS = DH0_WGS * X(2); %[J/s]
    
    DH_tot = DH_comb + DH_SMR + DH_WGS; %[J/s]
    
    Ti = (DH_tot+c_pg*M_entrant*Tref_ATR) / (c_pg*M_entrant);
    Tf = (-DH_comb+c_pg*M_entrant*Tref_ATR) / (c_pg*M_entrant);
    
    % Masse
    M_sortant = N_CH4*M_CH4 + N_H2O*M_H2O + N_CO2*M_CO2 + N_CO*M_CO + N_H2*M_H2; %[g/s]
    
    % verification de la conservation de la masse
    if abs(M_entrant-M_sortant)>10^(-6)
        disp(sprintf('ERREUR A ATR conservation de la masse'));
        abs(M_entrant-M_sortant)
    end
    
    end % ATR

    function [N_CH4, N_H2O, N_CO2, N_H2] = WGS(N_CH4, N_H2O, N_CO2, N_CO, N_H2)
    % WGS Water Gas Shift
    % --- INPUT ---
    % N_CH4, N_H2O, N_CO2, N_CO, N_H2 [mol/s]
    % --- OUTPUT ---
    % N_CH4, N_H2O, N_CO2, N_H2 [mol/s]
    
    M_entrant = N_CH4*M_CH4 + N_H2O*M_H2O + N_CO2*M_CO2 + N_CO*M_CO + N_H2*M_H2; %[g/s]
    
    % [][][][][][][][] Reaction WGS (complete) [][][][][][][][]
    %          |   CO     +     H2O    <-->    H2     +   CO2
    % ----------------------------------------------------------------------
    %  n(eq)   |    N_CO        N_H2O            N_H2      N_CO2
    N_reac=min(N_CO, N_H2O);
    
    N_H2O = N_H2O-N_reac;
    N_CO = N_CO-N_reac;
    N_H2 = N_H2+N_reac;
    N_CO2 = N_CO2+N_reac;
    
    % conservation de la masse
    M_sortant = N_CH4*M_CH4 + N_H2O*M_H2O + N_CO2*M_CO2 + N_H2*M_H2; %[g/s]
    if abs(M_entrant-M_sortant)>10^(-6)
        disp(sprintf('ERREUR A WGS conservation de la masse'));
        abs(M_entrant-M_sortant)
    end
    end % WGS

    function [N_CH4, N_H2, N_H2O, N_CO2] = CondAbs(N_CH4, N_H2O, N_CO2, N_H2)
    % CONDABS bloc de condensation de l'H2O et absorption du CO2
    % Toute l'eau et le CO2 rentrant sont evacues.
    % les Input/Output sont en [mol/s]
    
    N_H2O = 0;
    N_CO2 = 0;
    N_CH4 = N_CH4;
    N_H2 = N_H2;
    
    %Conservation de la masse
    % pas d'erreur possible pour le moment pour cette etape
    end % CondAbs

    function [N_CH4,N_NH3] = SyntheseAmoniac(N_CH4, N_H2, N_N2)
    % SYNTHESEAMONIAC tache finale de la synthese
    
    % [][][][][][][][] Reaction complete [][][][][][][][]
    %        |   3* H2     +     N2     -->    2* NH3   
    % -------|------------------------------------------------
    %   n(i) |     N_H2         N_N2           0
    
    N_reac=min(N_N2, N_H2/3);
    
    N_H2 = N_H2-3*N_reac; % =0
    N_N2 = N_N2-N_reac; % =0
        if abs(N_H2)>10^-6 || abs(N_N2)>10^-6
            disp(sprintf('ERREUR A SyntheseAmoniac'));
        end
    N_NH3 = 2*N_reac;
    end% SyntheseAmoniac

    function [N_Air_Need] = AirSeparationUnit(N_O2_Need, N_N2_Need)
    % AIRSEPARATIONUNIT Separation de l'air
    % l'air est compose de 21% d'oxygene, et de 79% d'azote.
    
    % On a besoin de O2_Need mole d'oxygene par seconde, donc au minimum
    % N_O2_need /21 * 100 mole d'air par seconde.
    N1 = N_O2_Need /21 * 100;
    % On a besoin de N2_Need mole d'oxygene par seconde, donc au minimum
    % N_N2_Nedd /79 * 100 mole d'air par seconde.
    N2 = N_N2_Need /79 * 100;
    
    N_Air_Need = max(N1,N2);
    end% AirSeparationUnit
end

