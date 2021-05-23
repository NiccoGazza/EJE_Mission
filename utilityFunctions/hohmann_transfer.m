%hohmann_transfer restituisce il deltaV (NORMALIZZATO alla velocità di 
%percorrimento dell'orbita circolare di partenza) e il deltaT necessario
%ad effettuare una manovra di Hohmann tra i pianeti 
%dep_planet e arr_planet, assumendo che essi compiano un'orbita 
%circolare attorno al Sole. Non tiene conto del phasing necessario.
%   dep_planet, arr_planet- planet identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto
%		10= Europe
%deltaV_h : km/s
%deltaT_h : s 

function [deltaV_h, deltaT_h] = hohmann_transfer(dep_planet, arr_planet)
    global mu r 
    parameters; 
    
    %prelevo i dati di interesse 
    r_dep = r(dep_planet);
    r_arr = r(arr_planet);
    
    %mengali 7.4.1
    deltaV_1 = sqrt((2*(r_arr/r_dep))/(1 + r_arr/r_dep)) - 1; %normalizzata a v_c1
    deltaV_2 = sqrt(1/(r_arr/r_dep)) - sqrt(2/((r_arr/r_dep)*(1 + r_arr/r_dep))); %normalizzata a v_c1
    
    deltaV_h = deltaV_1 + deltaV_2; %normalizzata a v_c1
    deltaT_h = pi*sqrt((r_arr + r_dep)^3 / (8*mu));
                                                           
end
