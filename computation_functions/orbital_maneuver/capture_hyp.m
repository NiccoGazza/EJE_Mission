function [delta_v, r_p] = capture_hyp(body_id, V2, arr_time, varargin)
%Questa funzione calcola l'iperbole di avvicinamento della sonda 
%in arrivo al pianeta identificato dal body_id e la fa rimanere in
%orbita attorno ad esso ad una distanza rp (distanza che ottimizza l'uso
%di carburante) - presa dal centro del pianeta.
%ATT. questa funzione non permette di scegliere il raggio al periasse
%dell'orbita di cattura.
%
% Dati in ingresso:
%	body_id : numero associato al pianeta al quale la sonda si sta
%		avvicinando (sonda giunta al confine della SOI del pianeta)
%   		body identifier:
%                	1 = Mercury
%                	2 = Venus
%                	3 = Earth
%                	4 = Mars
%                	5 = Jupiter
%                	6 = Saturn
%                	7 = Uranus
%                	8 = Neptune
%                	9 = Pluto
%               	10 = Europe
%               	11 = Sun
%
%	V2 : velocita' eliocentrica della sonda, in arrivo alla SOI del pianeta target
%
%	e : eccentricita'  desiderata dell'orbita di cattura 
%   			e = 0 orbita circolare
%       		< 1 orbita ellittica

%	arr_time : data di arrivo alla SOI del body_id. Formato datetime
%
%	varargin : campo sostituibile con uno o due ingressi.
%		varargin{1}: primo input per definire l'altezza dell'orbita di cattura
%       		varargin = 'opt' la funzione calcola il raggio al periasse che ottimizza il deltaV
%			Alternativamente, a varargin viene assegnato un valore numerico per specificare il raggio al periasse desiderato.
%			Qualunque sia la scelta dell'utente, la funzione riporta nuovamente il raggio al periasse (ci serve per richiamarla)
%		varargin{2}: secondo input; se viene scelto rp, questo ingresso non va inserito. 
%                	Se si sceglie 'opt', questo ingresso serve per specificare l'eccentricita'  desiderata dell'orbita di parcheggio.
%   
    %% Definizione input
    validateattributes(V2,{'double'},{'size',[1 3]})
    close all;
    global pl_mu radii  %Costanti globali (contenuti in initializeEJE.m) 
    global R mu_p       %Parametri che dipendono da costanti globali
    
    global r_p v_park v_hyp  %Variabili necessarie per il plot
    
    R = radii(body_id);
    mu_p = pl_mu(body_id);
    
    % calcolo velocita' di eccesso iperbolico in entrata alla SOI
    y = year(arr_time);
    m = month(arr_time);
    d = day(arr_time);
    
    [~, ~, v, ~] = body_elements_and_sv (body_id, y, m, d, 0, 0, 0); 
       
    v_inf = norm((V2 - v)); 
 
    %traiettoria iperbolica:
    %calcolo del raggio al periasse dell'iperbole di ingresso che minimizza il delta-v:
    %(corrisponde al punto di manovra (rp della traiettoria iperbolica e'
    %uguale a rp dell'orbita di cattura -punto di manovra per rimanerci)
    
    r_soi = compute_soi(body_id, 11); 
    
    if (varargin{1} == 'opt')   
        e_park = varargin{2}; 
        r_p =  (2*mu_p / v_inf^2)*( (1 - e_park) / (1 + e_park) ); %(Eq.8.67 Curtis)
        e_hyp = 1 + (r_p * v_inf^2) / mu_p;
        %da aggiungere: check sul risultato, potrebbe venire troppo piccolo
        % (o troppo grande!)
    elseif (isa(varargin{1}, 'float')) 
        if (varargin{1} > r_soi)
            disp('Too far away to be held by the celestial body');
            return
        elseif(varargin{1} < R)
            disp('Orbit too small') ;
            return
        else
            %IN QUESTO CASO E' NECESSARIO SPECIFICARE ANCHE
            %L'ECCENTRICITA'!!
            r_p = varargin{1};
            e_park = 0.4;
            
            %NOTA: se viene fissato r_p, l'eccentricità risulta fissata
            e_hyp = 1 + (r_p * v_inf^2) / mu_p;
        end
    end
   
%     %angolo di svolta /2 perche' la sonda compie meta' della traiettoria iperbolica
%     half_turn = asin(1/ei);
%     %aiming radius 
%     h =r_p * sqrt(v_inf^2 + 2*mu_p / r_p);
%     Delta = (h^2 /mu_p) * (ei^2 - 1)^(-0.5);

    %raggio all'apoasse dell'orbita di cattura
    %ra = 2*mu_body/norm(vinf)^2;
    %velocita' (scalare) della sonda nella traiettoria iperbolica nel
    %periasse
    v_hyp = sqrt(v_inf^2 + 2*mu_p / r_p); 

    %velocita' (scalare) dell'orbita di cattura nel periasse
    v_park = sqrt(mu_p * (1 + e_park) / r_p);

    %Delta-v delle manovre di entrata
    delta_v = abs(v_hyp - v_park);  
    
    %% HYPERBOLA PLOT
    %capture_hyp_plot(body_id);

end
