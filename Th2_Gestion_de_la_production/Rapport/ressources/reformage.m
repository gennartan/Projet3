function [ X ] = reformage(Tref_ATR, P_ATR, N_CH4, N_H2O, N_CO2)
    % Tref_ATR : Temperature de l'ATR [K]
    % P_ATR    : Pression dans l'ATR  [Pa]
    % N_CH4    : debit molaire de CH4 [mol/s]
    % N_H2O    : debit molaire de CH4 [mol/s]
    % N_CO2    : debit molaire de CH4 [mol/s]
    
	KSMR = 10^((-11650/Tref_ATR)+13.076);
	KWGS = 10^((1910/Tref_ATR)-1.764);

	function F = myfun(x)
		F(1) = (((x(1)-x(2))*(3*x(1)+x(2))^3 * (P_ATR/10^5)^2) / ... 
		       ((N_CH4+N_H2O+2*x(1)+N_CO2)^2 * (N_H2O-x(1)-x(2))*(N_CH4-x(1))))-KSMR;
		F(2) = (((N_CO2+x(2))*(3*x(1)+x(2))) / ((x(1)-x(2))*(N_H2O-x(1)-x(2))))-KWGS;
	end

	% Choix du X0(1) et X0(2)
	% X0(1) est plus petit et proche de N_CH4
	% X0(2) est assez petit par rapport a la valeur de N_CH4
	X0(1) = 0.7*N_CH4;
	X0(2) = 0.01*N_CH4;

	OPTIONS = optimoptions('fsolve', 'MaxFunEvals', 1000);
	X = fsolve(@myfun, X0, OPTIONS);
	% X(1) : degre d'avancement de la premiere reaction [mol/s]
	% X(2) : degre d'avancement de la seconde reaction [mol/s]
end
