% % %Raggi medi (approssimazione orbite circolari)
% % R_earth = 150e6; %km 
% % R_mars =  228e6; %km
% % %Periodi 
% % T_earth = 365.25636; %day
% % T_mars = 686.97959; %day
%hohmann_phasing restituisce il tempo di attesa e il tempo totale (che
%comprende il primo più il tempo necessario ad eseguire la manovra di
%Hohmann) necessari ad eseguire appunto una manovra di Hohmann a partire
%dal pianeta dep_planet per arrivare ad arr_planet, e a partire dalla data
%t0. Il tempo di attesa delta_t_A è definito come l'intervallo di tempo in
%giorni a partire da t0 che deve trascorrere per poter iniziare la manovra.
%   dep_planet, arr_planet- planet identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto

function [delta_t_A, delta_T_h] = hohmann_phasing(dep_planet, arr_planet, t0)
    global mu r T
    parameters
    dep_year = year(t0);
    dep_month = month(t0);
    dep_day = day(t0);

    [~, r_dep, ~] = planet_elements_and_sv(dep_planet, dep_year, dep_month, dep_day, 0, 0, 0);
    [~, r_arr, ~] = planet_elements_and_sv(arr_planet, dep_year, dep_month, dep_day, 0, 0, 0);

    TA_dep_planet = atan2(r_dep(2), r_dep(1)); %rad
    %è la posizione iniziale di arr_planet
    TA_arr_planet = atan2(r_arr(2), r_arr(1));  %rad

    if(TA_dep_planet < 0)
        TA_dep_planet = 2*pi - abs(TA_dep_planet);
    end
    
    %prelevo informazioni per applicare l'algoritmo
    r_dep_planet = r(dep_planet);
    T_dep_planet = T(dep_planet);
    r_arr_planet = r(arr_planet);
    T_arr_planet = T(arr_planet);
    
    theta_0 = (TA_arr_planet - TA_dep_planet);
    theta_H = pi*(1 - sqrt(((1 + r_dep_planet/r_arr_planet)/2)^3));
    delta_theta = theta_0 - theta_H;
    
    if(delta_theta < 0) %questo è da verificare
        delta_theta = delta_theta + 2*pi;
    end

    delta_t_A = delta_theta/((2*pi*(1/T_earth - 1/T_mars))); %days
    delta_t_H = pi/(sqrt(mu))*((R_earth+R_mars)/2)^(3/2); %s!!

    delta_t_H = delta_t_H/(60*60*24); %days

    delta_t_tot = delta_t_A + delta_t_H;
end
