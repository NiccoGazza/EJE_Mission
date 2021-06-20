%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function lambert_phasing(dep_body, arr_body, t0)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%lambert_phasing ha l'obiettivo di impostare una traiettoria eliocentrica
%basandosi sulla risoluzione del problema di Lambert. In particolare, dati
%in ingresso i pianeti dep_body e arr_body e la data t0 di partenza 
%calcola la traiettoria che permette il trasferimento.
%Questo avviene selezionando, come tempo di trasferimento da utilizzare come
%input del problema di Lambert, frazioni del tempo che sarebbe impiegato 
%mediante una manovra di Hohmann (ignorando ovviamente il phasing).
%   dep_body, arr_body- body identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto

    global distances 
    parameters;
    
    dep_year = year(t0);
    dep_month = month(t0);
    dep_day = day(t0);
    
    %dati pianeta di partenza
    [~, r0_dep_body, vc1, ~] = body_elements_and_sv(dep_body, dep_year, dep_month,...
                                            dep_day, 0, 0, 0);
                                        
    theta0_dep_body = atan2(r0_dep_body(2), r0_dep_body(1));
    r_dep_body = distances(dep_body);
    
    %dati pianeta di arrivo
    [~, r0_arr_body, ~] = body_elements_and_sv(arr_body, dep_year, dep_month,...
                                           dep_day, 0, 0, 0);                                   
                                       
    theta0_arr_body = atan2(r0_arr_body(2), r0_arr_body(1));
    r_arr_body = distances(arr_body);

    [deltaV_h, deltaT_h] = hohmann_transfer(dep_body, arr_body);
    %MENGALI 8.2.3 => posso usare direttamente i dati 'reali'
%     theta0 = theta0_arr_body - theta0_dep_body; 
%     vc1_h = sqrt(mu/r_dep_body); %utilizzo approx. traiettoria circolare
%     vc2_h = sqrt(mu/r_arr_body);
         
    deltaV_h = deltaV_h * norm(vc1); %per confrontare con Lambert mi serve il Av effettivo
    x = [];
    y = [];
    
    deltaT = 0.1*deltaT_h;
    
    for t = deltaT : deltaT : deltaT_h
%   MENGALI 8.2.3 
%          theta_t = theta0 + (2*pi*t)/T(arr_body);
%          %ricavo la posizione finale di arr_body
%          r1 = [r_arr_body*cos(theta0_arr_body + theta_t); ...
%                r_arr_body*sin(theta0_arr_body + theta_t); 0];
       
        %aggiorno la data per calcolare la posizione del pianeta di arrivo
        t0 = t0 + seconds(deltaT); 
        t_year = year(t0);
        t_month = month(t0);
        t_day = day(t0);
        
        [~, r2, vc2] = body_elements_and_sv(arr_body, t_year, t_month, ...
                                              t_day, 0, 0, 0);
                                          
        [v1, v2] = lambert([r0_dep_body(1); r0_dep_body(2);  0] ,...
                            [r2(1); r2(2); 0] , t, 'pro');
                        
        deltaV1 = norm(v1 - vc1');
        deltaV2 = norm(v2 - vc2');
        deltaV_L = deltaV1 + deltaV2; %deltaV totale richiesto da Lambert
        
        %inserisco i dati per il plot
        x = [x; t];
        y = [y; deltaV_L]; 
    end
        
        %plot normalizzato in base ai valori di Hohmann
        plot(x/deltaT_h, y/deltaV_h); 
        grid on;
        hold on;
end
%NOTA IMPORTANTE: l'andamento che ci aspettiamo e' quello di una funzione
%che raggiunge il suo minimo (teoricamente pari a 1) per deltaT coincidente
%con il tempo che impiegherebbe Lambert: questo e' vero soltanto se la
%partenza avviene con un deltaTheta pari a theta_H!! (VEDI MENGALI CAP.8)
