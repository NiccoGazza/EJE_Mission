%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [deltaV_h, deltaT_h] = hohmann_transfer(dep_body, arr_body , varargin )
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%hohmann_transfer restituisce il deltaV (NORMALIZZATO alla velocità di 
%percorrimento dell'orbita circolare di partenza) e il deltaT necessario
%ad effettuare una manovra di Hohmann tra i pianeti 
%dep_body e arr_body, assumendo che essi compiano un'orbita 
%circolare attorno al Sole. Non tiene conto del phasing necessario.
%   dep_body, arr_body- body identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto
%               10= Europe
%               11 = Sun
%deltaV_h : km/s
%deltaT_h : s 
% varargin è un ulteriore input da dare se si effettua il trasferimento da un pianeta a un suo satellite, che serve a specificare il raggio 			dell'orbita di partenza attorno a dep_plantet. Di default infatti, il fuoco della (semi)ellisse di trasferimento è il Sole.


    global mu distances     
    %prelevo i dati di interesse 
	if (arr_body == 10 || dep_body == 10)
		%body= false;
		if (dep_body == 5) 
			r_dep = varargin{1};
			r_arr = distances(arr_body);
		elseif (dep_body~=5 && arr_body==10)

			disp('The two bodies do not refer to the same focus. Cannot compute a Hohmann transfer')
        end
	else 
		r_dep = distances(dep_body);
		r_arr = distances(arr_body);
	end
		
    
    %mengali 7.4.1: utilizza l'approx. di orbite circolari
    deltaV_1 = sqrt((2*(r_arr/r_dep))/(1 + r_arr/r_dep)) - 1; %normalizzata a v_c1
    deltaV_2 = sqrt(1/(r_arr/r_dep)) - sqrt(2/((r_arr/r_dep)*(1 + r_arr/r_dep))); %normalizzata a v_c1
    
    deltaV_h = deltaV_1 + deltaV_2; %normalizzata a v_c1
    deltaT_h = pi*sqrt((r_arr + r_dep)^3 / (8*mu));
                                                           
end
