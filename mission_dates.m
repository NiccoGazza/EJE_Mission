%% Primo Step: 
%fissare data di arrivo su Giove e cercare delle date per il secondo flyby
%(Terra-Marte)
%TODO: si potrebbe provare ad iterare anche sulla data di arrivo

t_arr_jup = datetime(2030, 04, 11);

% Abbiamo scelto un'altezza dell'orbita di cattura tale che il raggio
% all'apoasse sia di circa 600 000km, ben lontano dalla sfera di influenza
% di Europa. Converrebbe scegliere un raggio al periasse maggiore, ma
% vogliamo evitare possibili problemi di collisione.
[t_earth2, delta_park_jup, ~] = earth_flyby(t_arr_jup, 80000, 0.6);

if( isempty(t_earth2) )
    fprintf("No date found for second flyby earth->jupiter \n");
    return;
end

%Ricavo la data con il delta_v2 minore: potrebbe essere un problema poichè
%i delta_v sono tutti dell'ordine di 4.7 => potrebbe essere limitante
[dv_jup_min, k] = min(delta_park_jup);
%t_earth2 = t_earth2(72);                                        
                                         
%% Secondo Step:
%fissata la data di partenza dalla Terra post-flyby, cercare una data di
%partenza da Marte (post primo flyby) in modo che il flyby sulla Terra sia
%effettivamente fattibile
t_mars_fb = []; dv_mars_fb = []; t_partenza = []; dv_esc = [];
t_earth_fb_x = [];

for k = 1 : length(t_earth2)
     t_earth_fb = t_earth2(k);   
    [t_mars, dv_fb2, r_p_fb2] = mars_flyby(t_earth_fb, t_arr_jup);

    if ( isempty(t_mars) ) 
        %fprintf("No date found for departure from mars \n");
        continue;
        %return;
    else
        [dv_fb2, j] = max(dv_fb2);
        t_mars = t_mars(j);                                         %27-02-2025
        %t_mars_fb = [t_mars_fb; t_mars];
        %dv_mars_fb = [dv_mars_fb; dv_fb2];
        [t_dep_earth, dv_fb1, r_p_fb1, dv_esc_earth] = earth_departure( ...
                                                          t_mars, ...
                                                          t_earth_fb);
        if ( isempty(t_dep_earth) )
            %fprintf("No date found for departure from earth \n");
            continue;
        else
            [dv_esc_earth_min, i] = min(dv_esc_earth); 
            t_dep_earth_min = t_dep_earth(i);
            t_partenza = [t_partenza; t_dep_earth_min];
            t_mars_fb = [t_mars_fb; t_mars];
            t_earth_fb_x = [t_earth_fb_x; t_earth_fb];
            dv_esc = [dv_esc; dv_esc_earth_min];
        end
    end

                                                           
end 
tabella = {t_partenza, t_mars_fb, t_earth_fb_x, dv_esc};
%Prelevo le informazioni: il criterio di scelta è la data il cui flyby
%garantisca il delta_v maggiore.
% [dv_fb2, j] = max(dv_fb2);
% t_mars = t_mars(j);
% r_p_fb2 = r_p_fb2(j);                                           %27-02-2025

%% Terzo step:
%fissata la data di partenza da Marte post-flyby, cercare una data di
%partenza dalla Terra (a seguito della manovra di fuga) in modo che il
%flyby su Marte sia effettivamente fattibile

[t_dep_earth, dv_fb1, r_p_fb1, dv_esc_earth] = earth_departure( ...
                                                          t_mars, ...
                                                          t_earth2);
                                                             
if ( isempty(t_dep_earth) )
    fprintf("No date found for departure from earth \n");
    return;
end

%Prelevo le informazioni: il criterio di scelta à la data il cui flyby
%garantisca un delta_v di uscita dalla SOI della Terra minima.
[dv_esc_earth_min, i] = min(dv_esc_earth); 
t_dep_earth_min = t_dep_earth(i);                              %%15-10-2024
dv_fb1 = dv_fb1(i);                             
r_p_fb1 = r_p_fb1(i);
                                                