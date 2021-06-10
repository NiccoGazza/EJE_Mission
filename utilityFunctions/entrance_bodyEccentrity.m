function [delta_v, rp] = entrance_bodyEccentrity(body_id, vinf, varargin)

%funzione che calcola l'iperbole di avvicinamento di una sonda di massa
%1000kg in arrivo al pianeta identificato dal body_id e la fa rimanere in
%orbita attorno ad esso ad una distanza rp (distanza che ottimizza l'uso
%di carburante) 
%ATT. questa funzione non permette di scegliere il raggio al periasse
%dell'orbita di cattura.
%
%
%body_id = numero associato al pianeta al quale la sonda si sta
%		avvicinando (sonda giunta al confine della SOI del pianeta)
%    body_id - body identifier:
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
%	vinf = velocità di eccesso iperbolico in ingresso alla SOI del pianeta
%		target
%		vinf = delta-v2helio (secondo impulso a fine fase eliocentrica -es. pag.431 Curtis) 
%
%	ec = eccentricità desiderata dell'orbita di cattura 
%       	ec = 0 orbita circolare
%         		< 1 ellisse
%	varargin{1} :primo input per definire l'altezza dell'orbita di cattura
%			varargin = 'opt' la funzione fa i calcoli considerando il raggio al periasse che ottimizza le spese energetiche
%			Alternativamente, a varargin viene assegnato un valore numerico per specificare il raggio al periasse desiderato.
%			Qualunque sia la scelta dell'utente, la funzione riporta nuovamente il raggio al periasse (ci serve per richiamarla)
%	varargin{2} :secondo input, se viene scelto rp, questo ingresso non va inserito. Se si sceglie  'opt' , questo ingresso serve per specificare %			l'eccentricità desiderata dell'orbita di parcheggio.
%   
%% Definizione input
	parameters;
	validateattributes(vinf,{'double'},{'size',[1 3]})
	global pl_mu
	mu_p = pl_mu(body_id);
    
%%Computations
%traiettoria iperbolica:
    %calcolo del raggio al periasse dell'iperbole di ingresso che minimizza il delta-v:
    %(corrisponde al punto di manovra (rp della traiettoria iperbolica è uguale a rp dell'orbita di cattura -punto di manovra per rimanerci)
r_soi = soi_compute(body_id, 11); %da aggiustare!!!!
if (varargin{1} == 'opt')   
	ec = varargin{2}; 
	rp =  (2*mu_p/norm(vinf,2)^2)*((1-ec)/(1+ec)); %(Eq.8.67 Curtis)
elseif (isa(varargin{1}, 'float')) 
	if (varargin{1}> r_soi)
		disp('Too far away to be held by the celestial body');
	if(varargin{1}<radii(body_id))
		disp('Orbit too small') ;
	else
		rp = varargin{1};
    end
    end
end
	ei = 1 + rp*norm(vinf,2)^2/mu_p; %eccentricità iperbole(Eq.8.53 Curtis)
	%angolo di svolta /2 perchè la sonda compie metà della traiettoria iperbolica(quindi svolta a metà rispetto a un flyby)
	half_turn = asin(1/ei);
	%aiming radius 
	h =rp*sqrt(norm(vinf,2)^2+2*mu_p/rp);
	Delta = (h^2/mu_p)*(ei^2-1)^(-0.5);

    
    %raggio all'apoasse dell'orbita di cattura
    %ra = 2*mu_body/norm(vinf)^2;
    %velocity (scalare) della sonda nella traiettoria iperbolica nel
    %periasse
    vp_hyp = sqrt(norm(vinf,2)^2 + 2*mu_p/rp); 
    
    %velocity (scalare) dell'orbita di cattura nel periasse
    vp_cap = sqrt (mu_p*(1+ec)/rp);
    
 %Delta-v delle manovre di entrata
    delta_v = vp_hyp - vp_cap;  

end
