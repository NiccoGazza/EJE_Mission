%hohmann_phasing restituisce il tempo di attesa e il tempo totale (che
%comprende il primo più il tempo necessario ad eseguire la manovra di
%Hohmann) necessari ad eseguire appunto una manovra di Hohmann a partire
%dal pianeta dep_body per arrivare ad arr_body, e a partire dalla data
%t0. Il tempo di attesa delta_t_A è definito come l'intervallo di tempo in
%giorni a partire da t0 che deve trascorrere per poter iniziare la manovra.
%   dep_body, arr_body- body identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto
%               10=Europe

function [delta_t_A, delta_t_H, delta_t_tot] = hohmann_phasing(dep_body, arr_body, t0)
    global mu distances T
    parameters
    
    dep_year = year(t0);
    dep_month = month(t0);
    dep_day = day(t0);

    [~, r_dep, ~] = body_elements_and_sv(dep_body, dep_year, dep_month, dep_day, 0, 0, 0);
    [~, r_arr, ~] = body_elements_and_sv(arr_body, dep_year, dep_month, dep_day, 0, 0, 0);

    TA_dep_body = atan2(r_dep(2), r_dep(1)); %rad
    %è la posizione iniziale di arr_body
    TA_arr_body = atan2(r_arr(2), r_arr(1));  %rad

    if(TA_dep_body < 0)
        TA_dep_body = 2*pi - abs(TA_dep_body);
    end
    
    %prelevo informazioni per applicare l'algoritmo
    r_dep_body = distances(dep_body);
    T_dep_body = T(dep_body);
    r_arr_body = distances(arr_body);
    T_arr_body = T(arr_body);
    
    theta_0 = (TA_arr_body - TA_dep_body);
    theta_H = pi*(1 - sqrt(((1 + r_dep_body/r_arr_body)/2)^3));
    delta_theta = theta_0 - theta_H;
    
    if(delta_theta < 0) %questo è da verificare
        delta_theta = delta_theta + 2*pi;
    end

    delta_t_A = delta_theta/((2*pi*(1/T_dep_body - 1/T_arr_body)));%s
    delta_t_H = pi/(sqrt(mu))*((r_dep_body + r_arr_body)/2)^(3/2); %s
    
    delta_t_A = delta_t_A/(60*60*24); %days
    delta_t_H = delta_t_H/(60*60*24); %days

    delta_t_tot = delta_t_A + delta_t_H;
end
