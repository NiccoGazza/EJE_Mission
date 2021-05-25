function [deltaV_h, deltaT_h] = hohmann_transfer(dep_planet, arr_planet , varargin )
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
%		11 = Sun
%deltaV_h : km/s
%deltaT_h : s 
% planet : boolean input
%		true : trasferimento da un pianeta a un altro, durante una fase eliocentrica ( il Sole è il fuoco) - pertanto le due orbite di %			partenza e di arrivo coincidono con quelle dei pianeti
%		false : trasferimento da un pianeta a un suo satellite (il Sole non è il fuoco di tale trasferimento), pertanto l'orbita di % %			partenza ha raggio al periasse pari a quello dell'orbita di cattura
% varargin è un ulteriore input da dare se si effettua il trasferimento da un pianeta a un suo satellite, che serve a specificare il raggio 			dell'orbita di partenza attorno a dep_plantet

%validateattributes(dep_planet,{'double'})
%validateattributes(arr_planet,{'double'})
%validateattributes(planet,{'boolean'})
%validateattributes(varargin,{'float'})
%planet = true;

    global mu distances 
    parameters; 
    
    %prelevo i dati di interesse 
	if (arr_planet == 10 | dep_planet == 10)
		%planet= false;
		if (dep_planet == 5) 
			r_dep = varargin{1};
			r_arr= distances (arr_planet);
		elseif (dep_planet~=5 & arr_planet==10)
			disp('The two bodies do not refer to the same focus. Cannot compute a Hohmann transfer')
	else 
		%planet=true;
		r_dep = distances(dep_planet);
		r_arr = distances(arr_planet);
	end
		
    
    %mengali 7.4.1
    deltaV_1 = sqrt((2*(r_arr/r_dep))/(1 + r_arr/r_dep)) - 1; %normalizzata a v_c1
    deltaV_2 = sqrt(1/(r_arr/r_dep)) - sqrt(2/((r_arr/r_dep)*(1 + r_arr/r_dep))); %normalizzata a v_c1
    
    deltaV_h = deltaV_1 + deltaV_2; %normalizzata a v_c1
    deltaT_h = pi*sqrt((r_arr + r_dep)^3 / (8*mu));
                                                           
end
