%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function  [delta_v, coe] = escape_hyp (body_id, V1, h_park, ...
                                              dep_time, incl)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Questa funzione calcola le caratteristiche dell'iperbole di uscita dalla SOI
%del pianeta body_id fissata un orbita di parcheggio CIRCOLARE di raggio 
%r_p attorno al pianeta body_id
%
%   Dati in ingresso:
%	V1     - velocita' eliocentrica della sonda all'uscita della SOI    [km/s]
%	time   - data di inizio trasferimento interplanetario             [datetime]
%	h_park - altezza dell'orbita di parcheggio dal pianeta body_id       [km]
%	incl   - inclinazione dell'orbita iperbolica di uscita rispetto al piano 
%          equatoriale del pianeta                                          [deg] 

%   Dati di uscita:
%	delta_v - deltaV necessario per entrare nell'iperbole di uscita
%	e       - eccentricita'  (magnitude of E)
%	a       - semiasse maggiore 						[km]
%	theta   - angolo di partenza della sonda rispetta all'asse X terrestre [deg]
    
%% Definizione input
    validateattributes(V1,{'double'},{'size',[1 3]})
    
    global pl_mu radii %Costanti globali (contenuti in parameters.m)
    global mu_p R      %Parametri che dipendono da costanti globali  
    
    global r_soi r_p v_park v_hyp  %variabili necessarie per il plot
    
    mu_p = pl_mu(body_id); %(km^3/s^2)
    R  = radii(body_id); 
    r_soi = compute_soi(body_id, 11); %11: SUN (non dovendo fare l'iperbole
                                      %di uscita di Europa, è l'unico caso 
                                      %di interesse).
    r_p = R + h_park;
    
    if(r_p > r_soi)
        disp('Error! ----> Periapsis radius bigger than SOI of the body chosen <----')
	return
    end
 
    % calcolo velocita' di eccesso iperbolico in uscita da SOI
    y = year(dep_time);
    m = month(dep_time);
    d = day(dep_time);
    
    [~, ~, v, ~] = body_elements_and_sv (body_id, y, m, d, 0, 0, 0); 
                                                                 
    v_inf = norm((V1-v),2);                                                                    

    v_park = sqrt(mu_p/r_p);                    %velocita' di parcheggio
    v_hyp = sqrt(2*(mu_p)/r_p + (v_inf)^2);     %velocita' di ingresso nell'iperbole

    delta_v = abs(v_hyp - v_park);                         

    a = - mu_p / (v_inf^2);                              %semiasse maggiore  
    e = 1 - r_p / a;                                     %eccentricita'  
    beta = 1/e;                         %(manca asin?) angolo di controllo iperbole di uscita
    theta = pi + beta;                          %argomento del perigeo
    h = r_p * v_hyp;                            %modulo del momento angolare
    % e = 1 + ((R + r_p) * v_inf^2)/mu_t;
    % h = (r_p + R) * vel_f;es
    % beta = acos(1/e);   %rad
    % a = (r_p + R) / (e - 1);
    % theta = pi + beta; %rad
    %% RESTITUISCO COE RELATIVI A SDR PERIFOCALE
    TA = 0;
    w = 0;
    RA = 0;
    coe = [h e RA incl w TA a];
    
    %% HYPERBOLA PLOT
    escape_hyp_plot(body_id, incl)
end

