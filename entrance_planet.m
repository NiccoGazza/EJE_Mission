function [delta_v] = entrance_planet(planet_id, v_inf, e)

%funzione che calcola l'iperbole di avvicinamento di una sonda di massa
%1000kg in arrivo al pianeta identificato dal planet_id e la fa rimanere in
%orbita attorno ad esso ad una distanza r_p (distanza che ottimizza l'uso
%di carburante) 
%ATT. questa funzione non permette di scegliere il raggio al periasse
%dell'orbita di cattura.
%
%
%planet_id = numero associato al pianeta al quale la sonda si sta
%avvicinando (sonda giunta al confine della SOI del pianeta)
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
%   v_inf = velocità di eccesso iperbolico in ingresso alla SOI del pianeta
%           target
%
%   e = eccentricità desiderata dell'orbita di cattura 
%       e = 0 orbita circolare
%         < 1 ellisse
%   
%% Constants

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

    G = 6.6742e-20; %[km^3/kg/s^2]
    mu_planet= G* masse (planet_id); %[km^3/s^2]
    
 %Computations
    %raggio al periasse dell'orbita di cattura che minimizza il delta-v:
    %(corrisponde al punto di manovra
    r_p =  (2*mu_planet/norm(v_inf,2)^2)*((1-e)/(1+e));
    
    %raggio all'apoasse dell'orbita di cattura
    %r_a = 2*mu_planet/norm(v_inf,2)^2;
    
    %velocity (scalare) della sonda nella traiettoria iperbolica nel
    %periasse
    vp_hyp = sqrt(norm(v_inf,2)^2 + 2*mu_planet/r_p);
    
    %velocity (scalare) dell'orbita di cattura nel periasse
    vp_cap = sqrt (mu_planet*(1+e)/r_p);
    
 %Delta-v delle manovre di entrata
    delta_v = vp_hyp - vp_cap;

