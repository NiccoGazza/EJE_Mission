%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [delta_v, r_p] = capture_hyp(body_id, Va, arr_time, plot, varargin)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Questa funzione calcola l'iperbole di avvicinamento della sonda 
%in arrivo al pianeta identificato dal body_id e la fa rimanere in
%orbita attorno ad esso ad una distanza rp (distanza che ottimizza l'uso
%di carburante) - presa dal centro del pianeta.
%L'orbita scelta dovrà ovviamente essere chiusa.
%
%   Dati in ingresso:
%	body_id - numero associato al pianeta al quale la sonda si sta
%		avvicinando (sonda giunta alla SOI del pianeta)
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
%	Va       - velocita' eliocentrica della sonda, in arrivo alla SOI del pianeta target [km/s]
%	arr_time - data di arrivo alla SOI del body_id. [datetime] - (yyyy,mm,dd)
%	varargin - campo equivalente a due ingressi come spiegato di seguito.
%		varargin{1} = h : primo input per definire l'ALTEZZA dell'orbita di cattura. L'utente può scegliere di utilizzare uno dei due casi: 
%       		(a) varargin = 'opt' . In tal caso questa funzione usa il raggio al periasse che ottimizza il deltaV;
%			(b) float varargin . L'utente assegna un valore numerico all'altezza dell'orbita di parcheggio.
%			=> Qualunque sia la scelta dell'utente, la funzione riporta nuovamente il raggio al periasse (consente di poter richiamare facilmente questa variabile, per comodità)
%		varargin{2}: secondo input; in entrambi i casi, questo ingresso serve per specificare l'eccentricita' desiderata dell'orbita di parcheggio e_park
%   
%   Dati di uscita:
%	delta_v - deltaV totale della manovra 
%	r_p     - raggio al periasse dell'iperbole di ingressi e dell'orbita di parcheggio (le due, coincidono)
%
    %% Definizione di input e costanti
    validateattributes(Va,{'double'},{'size',[1 3]})
    close all;
    global pl_mu radii  %Costanti globali (contenuti in initializeEJE.m) 
    global R mu_p      %Parametri che dipendono da costanti globali
    global v_p_park v_p_hyp  %Variabili necessarie per il plot
    
    R = radii(body_id);
    mu_p = pl_mu(body_id);
    
    if(body_id ~= 10 && body_id ~= 12)
            r_soi = compute_soi(body_id, 11); 
    elseif (body_id ~= 10 || body_id~=12)
            r_soi = compute_soi(body_id, 5); 
    end 
    
    %% Calcolo velocita' di eccesso iperbolico v_inf in entrata alla SOI
    y = year(arr_time);
    m = month(arr_time);
    d = day(arr_time);
    
    [~, ~, V2, ~] = body_elements_and_sv (body_id, y, m, d, 0, 0, 0); 
       
    v_inf = norm((V2 - Va)); 
 
    %% Traiettoria iperbolica:
    %Calcolo del raggio al periasse ottimo dell'iperbole di ingresso (r_p che minimizza il delta-v);	
	%r_p è anche il punto di manovra per rimanere sull'orbita di parcheggio.
    
	%Definizione di r_p ed e_park
    e_park = varargin{2};
    
    if(e_park < 1 && e_park >=0)
        if (varargin{1} == 'opt')   %caso (a)
            r_p =  (2*mu_p / v_inf^2)*( (1 - e_park) / (1 + e_park) ); %(Eq.8.67 Curtis)
            if(r_p > r_soi)
                disp('Error! ---->  Periapsis radius bigger than SOI of the body chosen <----');
            elseif(r_p < R)
                disp('Error! ---->  Periapsis radius smaller than the radius of the body chosen <----');
            end
        elseif (isa(varargin{1}, 'float')) %caso (b)
            if ((varargin{1} + R) > r_soi)
                disp('Error! ---->  Periapsis radius bigger than SOI of the body chosen <----');
            else
                r_p = varargin{1} + R;
                e_park = varargin{2};
            end
        end
    else
        disp('Error! ----> Cannot keep on orbit around the celestial body choosen <----');
    end
    
    e_hyp = 1 + (r_p * v_inf^2) / mu_p;

    %raggio all'apoasse dell'orbita di cattura
    %ra = 2*mu_body/norm(vinf)^2;

    %velocita' (scalare) della sonda al periasse della traiettoria iperbolica 
    v_p_hyp = sqrt(v_inf^2 + 2*mu_p / r_p); 

    %velocita' (scalare) della sonda al periasse dell'orbita di cattura
    v_p_park = sqrt(mu_p * (1 + e_park) / r_p);

    %Delta-v della manovra di entrata
    delta_v = abs(v_p_hyp - v_p_park);  

    %% HYPERBOLA PLOT
    if(plot == 1)
        capture_hyp_plot(body_id, r_p);
    end

end
