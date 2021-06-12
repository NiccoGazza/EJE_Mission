%% TEST FLYBY FUNCTION
%scelta dei tempi
global pl_mu
mu_m = pl_mu(4);

%% DATI DI PARTENZA: DA EUROPA CLIPPER MISSION
dep_time = datetime(2024, 10, 1);   %partenza
t_arr_mars = datetime (2025, 2, 1); %arrivo su Marte per il Flyby

%% APPLICAZIONE DI LAMBERT PER TRAIETTORIA TERRA-MARTE
dt1 = between(dep_time, t_arr_mars, 'Days');  %numero di giorni fra le due date
[~, R_earth, V_earth, ~] = body_elements_and_sv (3, 2024, 10, 1, 0, 0 ,0);
[~, R_mars, V_mars, ~] = body_elements_and_sv (4, 2025, 2, 1, 0, 0 ,0);

time_lamb1 = (caldays(dt1))*24*3600; %in secondi
[v_dep, v_mars_in] = lambert (R_earth, R_mars, time_lamb1);

%% APPLICAZIONE DI LAMBERT PER TRAIETTORIA MARTE TERRA:
%mi serve per calcolare la velocità con cui voglio uscire dal flyby
dt2 = between(t_mars, t_earth2, 'Days');

[~, R_earth2, V_earth2, ~] = body_elements_and_sv (3, 2026, 12, 1, 0, 0 ,0);
time_lamb2 = (caldays(dt2))*24*3600; %in secondi
[v_mars_out, v_earth_in] = lambert (R_mars, R_earth2, time_lamb2);

%% FLYBY TEST
[deltav_fb1, e_fb1, a_fb1, delta_fb1, r_pfb1] = flyby ( v_mars_in, V_mars,...
                                                        v_mars_out, mu_m);
                                                    
                                                    