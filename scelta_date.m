%% QUESTO SCRIPT NON FUNZIONA (vede t_earth_flyby come scalare e non come vettore) %%

clc; clear all;

% inizializzazione
soi_t = soi_compute(3, 11);
soi_m = soi_compute(4, 11);
dv_mission = 15;
parameters;

%Data di arrivo e eccentricità orbita di arrivo
t_jupiter = datetime(2031, 1, 1);
e = 0;

%Traiettorie possibili Terra-Giove
[t_earth_flyby, dv_entrance, rp_entrance] = entrance_iteration(t_jupiter, e);

for i = 2:length(t_earth_flyby)
    
    
    %L'elemento del vettore dei tempi deve essere diverso dal tempo di default 
    if t_earth_flyby(i) ~= datetime(2010, 1, 1)
        
        
        %Traiettorie possibili Marte-Terra in modo che il Flyby sia
        %plausibile
        [epsilon2, t_mars, dv_flyby_earth, r_flyby_earth] = iterazione_flyby(t_earth_flyby(i), t_jupiter, soi_t);
        
        %Secondo ciclo sulle traiettorie Marte-Terra
        for k = 2:length(t_mars)
            
            
            if t_mars(k) ~= datetime(2010, 1, 1)
                
                
                %Traiettorie possibili Terra-Marte in modo che il Flyby sia
                %plausibile
                [epsilon1, t_earth_escape, dv_flyby_mars, r_flyby_mars, dv_escape] = iterazione_primo_flyby (t_mars(k), t_earth_flyby(i), soi_m);
                
                %Terzo ciclo Terra-Marte
                for j = 2:1:length(t_earth_escape)
                    
                    
                    if t_earth_escape(j) ~= datetime(2010, 1, 1)
                        
                        
                        %Calcolo deltavTOT
                        deltav_TOT = dv_entrance(i) + dv_escape(j);
                        
                        %Aggiorno i dati della missione solo per la
                        %missione più vantaggiosa in termini di deltav
                        if deltav_TOT < dv_mission
                            
                            
                            dv_mission = deltav_TOT;
                            t_mission = [t_jupiter, t_earth_flyby(i), t_mars(k), t_earth_escape(j)];
                            dv_flyby2 = dv_flyby_earth(k);
                            dv_flyby1 = dv_flyby_mars(j);
                            r_flyby1 = r_flyby_mars(j);
                            r_flyby2 = r_flyby_earth(k);
                            r_jupiter = r_entrance(i);
                            
                        end
                    end
                end
            end
        end
    end
end
