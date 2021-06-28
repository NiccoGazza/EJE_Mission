%Questo script ha l'obiettivo di calcolare le date caratteristiche della
%missione, fissata la data di arrivo su Giove.

t_arr_jup = datetime(2030, 04, 11);

%% Primo Step: 
%cercare date per il secondo flyby (Terra-Marte)


% Abbiamo scelto un'altezza dell'orbita di cattura tale che il raggio
% all'apoasse sia di circa 600 000km, ben lontano dalla sfera di influenza
% di Europa. Converrebbe scegliere un raggio al periasse maggiore, ma
% vogliamo evitare possibili problemi di collisione.
[t_earth2, delta_park_jup, ~] = earth_flyby(t_arr_jup, 80000, 0.6);

if( isempty(t_earth2) )
    fprintf("No date found for second flyby earth->jupiter \n");
    return;
end

                                         
%% Secondo Step:
%fissata la data di partenza dalla Terra post-flyby, cercare una data di
%partenza da Marte (post primo flyby) in modo che il flyby sulla Terra sia
%effettivamente fattibile

t_departure = []; dv_esc = [];
t_mars_fb = []; 
t_earth_fb_min = [];

for k = 1 : length(t_earth2)
     t_earth_fb = t_earth2(k);
     % mars_flyby restituisce date di partenza da Marte, e le
     % caratteristiche del flyby sulla Terra
    [t_mars1, dv_fb2, r_p_fb2] = mars_flyby(t_earth_fb, t_arr_jup);

    if ( isempty(t_mars1) ) 
        %fprintf("No date found for departure from mars \n");
        continue;
    else
        % dobbiamo fissare una data di flyby su Marte per cercare quelle di
        % partenza: il criterio è scegliere quella che garantisca un flyby
        % con delta_v massimo.
        [dv_fb2, j] = max(dv_fb2);
        t_mars1 = t_mars1(j);                                        
        %% Terzo Step:
        %fissata la data di partenza da Marte post-flyby, cercare una data di
        %partenza dalla Terra (a seguito della manovra di fuga) in modo che il
        %flyby su Marte sia effettivamente fattibile
        [t_dep_earth, ~, ~, dv_esc_earth] = earth_departure( ...
                                                          t_mars1, ...
                                                          t_earth_fb);
        if ( isempty(t_dep_earth) )
            %fprintf("No date found for departure from earth \n");
            continue;
        else
            %dobbiamo fissare la data di partenza dalla Terra: il criterio
            %è scegliere quella con delta_v di uscita minimo.
            [dv_esc_earth_min, i] = min(dv_esc_earth); 
            t_dep_earth_min = t_dep_earth(i);
            
            %salviamo i dati che ci hanno portato a tale risultato
            t_departure = [t_departure; t_dep_earth_min];
            t_mars_fb = [t_mars_fb; t_mars1];
            t_earth_fb_min = [t_earth_fb_min; t_earth_fb];
            dv_esc = [dv_esc; dv_esc_earth_min];
        end
    end                                                           
end

%% Scelta Date
[dv_min, index_min] = min(dv_esc);
t_departure = t_departure(index_min);
t_mars_fb = t_mars_fb(index_min);
t_earth_fb = t_earth_fb_min(index_min);

%end %mission_dates%