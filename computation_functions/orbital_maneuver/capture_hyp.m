function [delta_v, r_p] = capture_hyp(body_id, Va, arr_time, varargin)

%Questa funzione calcola l'iperbole di avvicinamento della sonda 
%in arrivo al pianeta identificato dal body_id e la fa rimanere in
%orbita attorno ad esso ad una distanza rp (distanza che ottimizza l'uso
%di carburante) - presa dal centro del pianeta.
%ATT. questa funzione non permette di scegliere il raggio al periasse
%dell'orbita di cattura.
%
% Dati in ingresso:
%	body_id : numero associato al pianeta al quale la sonda si sta
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
%	Va : velocita'�eliocentrica della sonda, in arrivo alla SOI del pianeta target [m/s]
%
%	arr_time : data di arrivo alla SOI del body_id. [datetime] - (yyyy,mm,dd)
%
%	varargin : campo equivalente a due ingressi come spiegato di seguito.
%		varargin{1} = h : primo input per definire l'ALTEZZA dell'orbita di cattura. L'utente pu� scegliere di utilizzare uno dei due casi: 
%       		(a) varargin = 'opt' . In tal caso questa funzione usa il raggio al periasse che ottimizza il deltaV;
%			(b) float varargin . L'utente assegna un valore numerico all'altezza dell'orbita di parcheggio.
%			=> Qualunque sia la scelta dell'utente, la funzione riporta nuovamente il raggio al periasse (consente di poter richiamare facilmente questa variabile, per comodit�)
%		varargin{2}: secondo input; in entrambi i casi, questo ingresso serve per specificare l'eccentricita' desiderata dell'orbita di parcheggio e_park
%   
    %% Definizione di input e costanti
    validateattributes(Va,{'double'},{'size',[1 3]})
    close all;
    global pl_mu radii  %Costanti globali (contenuti in initializeEJE.m) 
    global R mu_p r_soi     %Parametri che dipendono da costanti globali
    global r_p v_park v_p_hyp  %Variabili necessarie per il plot
    
    R = radii(body_id);
    mu_p = pl_mu(body_id);
    r_soi = compute_soi(body_id, 11); 
    
    %% Calcolo velocita' di eccesso iperbolico v_inf�in entrata alla SOI
    y = year(arr_time);
    m = month(arr_time);
    d = day(arr_time);
    
    [~, ~, V2, ~] = body_elements_and_sv (body_id, y, m, d, 0, 0, 0); 
       
    v_inf = norm((V2 - Va)); 
 
    %% Traiettoria iperbolica:
    	%Calcolo del raggio al periasse ottimo dell'iperbole di ingresso (r_p che minimizza il delta-v);	
	%r_p � anche il punto di manovra per rimanere sull'orbita di parcheggio.
    

    if (varargin{1} == 'opt')   %caso (a)
        e_park = varargin{2}; 
        r_p =  (2*mu_p / v_inf^2)*( (1 - e_park) / (1 + e_park) ); %(Eq.8.67 Curtis)
        e_hyp = 1 + (r_p * v_inf^2) / mu_p;
		if(r_p > r_soi)
			disp('Error! ----> r_p out of SOI <----');
			return
		elseif(r_p < R)
			disp('Error! ----> r_p too small <----');
			return
		end
    elseif (isa(varargin{1}, 'float')) %caso (b)
        if ((varargin{1} + R) > r_soi)
            disp('Error! ----> r_p out of SOI <----');
            return
        else
            r_p = varargin{1} + R;
            e_park = varargin{2};
            
            %NOTA: se viene fissato r_p, l'eccentricit� risulta fissata
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

    %velocita' (scalare) della sonda al periasse della traiettoria iperbolica 
    v_p_hyp = sqrt(v_inf^2 + 2*mu_p / r_p); 

    %velocita' (scalare) della sonda al periasse dell'orbita di cattura
    v_p_park = sqrt(mu_p * (1 + e_park) / r_p);

    %Delta-v delle manovre di entrata
    delta_v = abs(v_p_hyp - v_p_park);  
    
    %% HYPERBOLA PLOT
    %capture_hyp_plot(body_id);

end
