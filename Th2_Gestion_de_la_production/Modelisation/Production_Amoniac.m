function [] = Production_Amoniac()
% PRODUCTION_AMONIAC calcule le bilan de masse (et d'energie) de la
% production d'amoniac dans un procede continu

% --- ENTREE -----------------------------------------------------------
% CH4 (methan) [t/j]
% RapO2CH4 (rapport molaire entre O2 et CH4)
% RapH20CH4 (rapport molaire entre H20 et CH4)
% Tref_ATR (temperature dans la zone de reforming de l'ATR
% P_ATR (pression dans l'ATR)

RapO2CH4 = 0.6; %  []
RapH20CH4 = 1.5; % []
Tref_ATR = 1200; % [K]
P_ATR = 50*10^5; % [Pa]

CH4 = 800; % [t/j]

% Definition des masses molaire [t/j]
M_O2 = 32*10^(-6);
M_H20 = 18*10^(-6);
M_CH4 = 16*10^(-6);
M_CO2 = 44*10^(-6);

% Calcul du debit de O2 [t/j]  et de H20 [t/j] qui rentre dans la zone de combustion de l'ATR
N_CH4 = CH4 / M_CH4; % [mol/j]

N_O2 = RapO2CH4 * N_CH4; % [mol/j] 
O2 = M_O2 * N_O2; % [t/j]

N_H20 = RapH20CH4 * N_CH4; % [mol/j]
H20 = M_H20 * N_H20;


[CH4, H20, CO2, CO, H2] = ATR(N_O2, N_CH4, N_H20); % Calcul d'erections dans l'ATR


function [CH4, H20, CO2, CO, H2] = ATR(N_O2, N_CH4, N_H20)
% ATR calcule le bilan de masse et d'energie dans l'ATR (autothermal
% reformer)
% O2 (oxygen) [kg/j]
% CH4 (methan) [kg/j]
% H20 (water) [kg/j]

% Premiere reaction : COMBUSTION (complete)
%                |    CH4     +    2* O2     -->   CO2     +     2* H20
% ------------------------------------------------------------------------
%   m(i) [t/j]   |    CH4           O2              0             H20(i)
%   M    [t/mol] |
%   n(i) [mol]   |

N_reac = min(N_CH4, N_O2/2); % [mol] nombre de mol reagissant (par unité de mole de CO2 produite)

N_O2 = N_O2 - 2*N_reac;
N_CH4 = N_CH4 - N_reac;
N_H20 = N_H20 + 2*N_reac;
N_CO2 = N_reac

O2 = M_O2 * N_O2;
CH4 = M_CH4 * N_CH4;
H20 = M_H20 * N_H20;
CO2 = M_CO2 * N_CO2;

% Deuxieme reactio1n : Reformage
%          |  CH4      +    H20      <-->   3* H2    +    CO
% ----------------------------------------------------------------------
%  n(reac) |
K1 = 10^((-11650/Tref_ATR)+13.076); % [bar^2]

%          |   CO     +    2* H20    <-->    H2     +     CO2
% ----------------------------------------------------------------------
%          |
K2 = 10^((1910/Tref_ATR)-1.764);

syms x y
S = solve([K1==((x-y) * (3*x+y)^3 * (P_ATR/10^5)^2)  /  ((N_CH4+N_H20+2*x-y) * (N_H20-x-y)*(N_CH4-y)),  K2 == ((N_CO2+y)*(3*x+y))  /  ((x-y)*(N_H20-x-y))], [x, y], 'ReturnConditions', true);
S.x
S.y

H2 =2;

end % ATR
end % Production_Amoniac

