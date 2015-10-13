function [ F ] = reformage()
    xi = fsolve(@system,[0,0])
end

function F = system(xi)
    
    n1 = 35 ; %nombre initial de mole de CH4
    n2 = 105; %                          H20 
    n3 = 15; %                          CO2
    ptot = 50; %en bar
    T = 1200; %en K
    K1 = 10^( (-11650/T) + 13.076 );
    K2 = 10^( (1910/T) - 1.764 );
    
    F(1) = ptot^2 * ( xi(1) - xi(2) ) * ( 3*xi(1) + xi(2) )^3 - K1 * ( n1 - xi(1) ) *( n2 - xi(1) - xi(2) ) * ( n1 + n2 + n3 + 2*xi(1) )^2;
    F(2) = ( 3*xi(1) + xi(2) ) * ( n3 + xi(2) ) - K2 * ( xi(1) - xi(2) ) * ( n2 - xi(1) - xi(2) );

end