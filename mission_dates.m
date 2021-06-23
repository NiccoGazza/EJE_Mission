%% Primo Step: 
%fissare data di arrivo su Giove e cercare delle date per il secondo flyby
%(Terra-Marte)
%TODO: si potrebbe provare ad iterare anche sulla data di arrivo

t_arr_jup = datetime(2031, 01, 01);

% Abbiamo scelto un'altezza dell'orbita di cattura tale che il raggio
% all'apoasse sia di circa 600 000km, ben lontano dalla sfera di influenza
% di Europa. Converrebbe scegliere un raggio al periasse maggiore, ma per
% evitare possibili problemi di collisione per ora la scelta è questa.
[t_earth2, delta_park_jup, ~,  v_lam] = earth_flyby(t_arr_jup, 80000, 0.6);

if( isempty(t_earth2) )
    fprintf("No date found for second flyby earth->jupiter \n");
    return;
end

%Ricavo la data con il delta_v2 minore
[dv_jup_min, k] = min(delta_park_jup);
%Va = v_lam(k, :);
%capture_hyp(5, Va, t_arr_jup, 1, 80000, 0.6);
% dv_jup_min
t_earth2 = t_earth2(k);                                        %%19-11-2027
            

                                      
%% Secondo Step:
%fissata la data di partenza dalla Terra post-flyby, cercare una data di
%partenza da Marte (post primo flyby) in modo che il flyby sulla Terra sia
%effettivamente fattibile 

[t_mars, dv_fb2, ~] = mars_flyby(t_earth2, t_arr_jup);

if ( isempty(t_mars) ) 
    fprintf("No date found for departure from mars \n");
    return;
end

%Prima questione: quale data scelgo? Il delta_v garantito dal flyby, essendo
% """gratis""", è meglio che sia piccolo o grande?
[dv_fb2, j] = max(dv_fb2);
t_mars = t_mars(j);                                            %%04-03-2025  

%% Terzo step:
%fissata la data di partenza da Marte post-flyby, cercare una data di
%partenza dalla Terra (a seguito della manovra di fuga) in modo che il
%flyby su Marte sia effettivamente fattibile
[t_dep_earth, dv_fb1, ~, dv_esc_earth] = earth_departure( ...
                                                          t_mars, ...
                                                          t_earth2);
                                                             
if ( isempty(t_dep_earth) )
    fprintf("No date found for departure from earth \n");
    return;
end
                                                             
[dv_esc_earth, i] = min(dv_esc_earth); 
t_dep_earth = t_dep_earth(i);                                  %%30-10-2024
dv_fb1 = dv_fb1(i);




