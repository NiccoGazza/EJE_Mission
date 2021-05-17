function [delta_v] = entrance_planetPeriod(planet_id, vinf, T)

%funzione che calcola l'iperbole di avvicinamento di una sonda di massa
%1000kg in arrivo al pianeta identificato dal planet_id e la fa rimanere in
%orbita attorno ad esso ad una distanza rp (distanza che ottimizza l'uso
%di carburante) 
%ATT. questa funzione non permette di scegliere il raggio al periasse
%dell'orbita di cattura.
%
%
%planet_id = numero associato al pianeta al quale la sonda si sta
%		avvicinando (sonda giunta al confine della SOI del pianeta)
%    planet_id - planet identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                6 = Saturn
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto
%               10 = Europe
%               11 = Sun
%
%	vinf [m/s] = velocità di eccesso iperbolico in ingresso alla SOI del pianeta
%		target
%		vinf = delta-v2helio (secondo impulso a fine fase eliocentrica -es. pag.431 Curtis) 
%
%	T [s] = periodo dell'orbita di cattura 
%       	
%% Definizione input
    validateattributes(vinf,{'double'},{'size',[1 3]})


%% Costanti
    masse = 10^24 * [0.330104 %mercurio
                      4.86732 %venere
                      5.97219 %terra
                      0.641693 %marte
                      1898.13 %giove
                      568.319 %saturno
                      86.8100 %urano
                      102.410  %nettuno
                      0.01309 %plutone 
                      0.04800 %europa 
                      1989100];%sole %[kg]

    G = 6.6742e-20; %[km^2/kg/s^2]
    mu_planet= G* masse (planet_id); %[km^3/s^2]
    
 %%Computations
  %parametri orbita di cattura
    a = (T/2*pi)*(mu_planet)^(1/3); %semiasse maggiore
	ec = (2*mu_planet/(a*vinf^2))-1; %eccentricità
    
    %raggio all'apoasse dell'orbita di cattura
     %ra = 2*mu_planet/norm(vinf)^2;

    %beta angolo tra il periasse e velocità del pianeta
        % beta= acos(1/(1+rp*vinf^2/mu_planet));

  %parametri traiettoria iperbolica:
    %raggio al periasse dell'iperbole di ingresso che minimizza il delta-v:
    %(corrisponde al punto di manovra (rp della traiettoria iperbolica è uguale a rp dell'orbita di cattura -punto di manovra per rimanerci)
    rp =  (2*mu_planet/norm(vinf)^2)*((1-ec)/(1+ec)); %(Eq.8.67 Curtis)
	%eccentricità iperbole
	ei = 1 + rp*vinf^2/mu_planet; %(Eq.8.53 Curtis)
	%angolo di svolta /2 perchè la sonda compie metà della traiettoria iperbolica(quindi svolta a metà rispetto a un flyby)
	half_turn = asin(1/ei);
	%aiming radius 
	h =rp*sqrt(vinf^2+2*mu_planet/rp);
	Delta = (h^2/mu_planet)*(ei^2-1)^(-0.5);
    
 %Minimo Delta-v per il piazzamento della sonda sull'orbita
    delta_v = vp_hyp - vp_cap;
    

