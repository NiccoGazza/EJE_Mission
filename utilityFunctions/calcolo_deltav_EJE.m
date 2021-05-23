%% Traiettoria Patch Cones TERRA GIOVE-replica della missione EUROPA CLIPPER %%
function deltav_fin = calcolo_deltav_EJE(t_jupiter)
%
%Questa funzione restituisce il Deltav totale della missione su Giove.
%  dati in ingresso:
%   t_jupiter = data  di arrivo su <Europa(?)>
%  dati in uscita:
%   deltav_fin = delta velocità dell'intera missione


%dati preliminari 
global mu mu_m mu_t       %costanti gravitazionali
mu = 132e9;               %SOLE
mu_m = 42828;             %MARTE
mu_t = 398600.4418;       %TERRA

y = year(t_jupiter);
m = month(t_jupiter);
d = day(t_jupiter);

%scelta dei tempi
dep_time = datetime(2024, 10, 1);   %partenza
t_mars = datetime (2025, 2, 1);     %arrivo su Marte per il Flyby 
t_earth2 = datetime(2026, 12, 1);   %arrivo su Terra per il Flyby

%% Traiettoria Terra-Marte

dt1 = between(dep_time, t_mars, 'Days');  %numero di giorni fra le due date

[~, R_earth, V_earth, ~] = planet_elements_and_sv (3,2024, 10, 1, 0, 0 ,0);
[~, R_mars, V_mars, ~] = planet_elements_and_sv (4,2025, 2, 1, 0, 0 ,0);

time_lamb1 = (day(dt1))*24*3600; %in secondi
[v_dep, v_mars_in] = lambert (R_earth, R_mars, time_lamb1);

%iperbole di uscita
[delta_vu, e_u, a_u, theta_u] = iperbole_uscita (v_dep, dep_time);
delta_vu

%% Traiettoria Marte-Terra

dt2 = between(t_mars, t_earth2, 'Days');

[~, R_earth2, V_earth2, ~] = planet_elements_and_sv (3, 2026, 12, 1, 0, 0 ,0);
time_lamb2 = (day(dt2))*24*3600; %in secondi
[v_mars_out, v_earth_in] = lambert (R_mars, R_earth2, time_lamb2);

% primo flyby
[deltav_fb1, e_fb1, a_fb1, delta_fb1, r_pfb1] = flyby ( v_mars_in, V_mars, v_mars_out, mu_m);
deltav_fb1
%% Traiettoria Terra-Giove

dt3 = between (t_earth2, t_jupiter, 'Days');

[~, R_jupiter, V_jupiter, ~] = planet_elements_and_sv (5, y, m, d, 0, 0 ,0);
time_lamb2 = (day(dt3))*24*3600; %in secondi
[v_earth_out, v_jupiter_in] = lambert (R_earth2, R_jupiter, time_lamb2);

% secondo flyby
[deltav_fb2, e_fb2, a_fb2, delta_fb2, r_pfb2] = flyby ( v_earth_in, V_earth2, v_earth_out, mu_t);
deltav_fb2

%% Entrata in Giove 

v_infJ = v_jupiter_in-V_jupiter;      %velocità relativa della sonda
[delta_ve] = entrance_planetEccentrity(5, v_infJ, 0);
delta_ve

%%Arrivo su Europa
%Script load
jup2europe
[deltaV_h] = hohmann_transfer(5,10);
deltav_orb  %CHIEDERE

%% TOT Delta velocità 

deltav_fin = delta_vu+delta_ve + delta + deltaV_h + deltav_orb; % +deltav del cambio di piano orbitale (da equat. terra a eclittica)
end                                


