function  [probe_pos, io_pos, europa_pos, t_dep, t_man, dv_min, transfer_traj, ...
           v2_probe_eur, v2_eur] ...
            = ...
           europa_phasing(begin_date, end_date, r_p, e_park)
%Questa funzione calcola la manovra per il trasferimento su Europa, 
%restituendo tutte le informazioni necessarie al plot. La manovra è
%calcolata prendendo a riferimento un tempo base (1 giorno) e risolvendo
%iterativamente dei problemi di Lambert, ricavando quello con Delta_V
%minimo. 
%
%   Dati in ingresso:
%   begin_date      - data di inizio ricerca trasferimento       [datetime]
%   end_date        - data di fine ricerca trasferimento         [datetime]
%   r_p             - raggio al periasse dell'orbita di parcheggio     [km]
%   e_park          - eccentricita' dell'orbita di parcheggio          [km]
%
%   Dati in uscita:
%   probe_pos       - vettore posizione della sonda, calcolato da
%                     begin_date a end_date con passo di integrazione di un
%                     minuto                                           [km]
%   io_pos          - vettore posizione di Io, calcolato come sopra    [km] 
%   europa_pos      - vettore posizione di Europa, calcolato come sopra[km]
%   t_dep           - indice che corrisponde all'inizio del trasferimento
%   t_man           - durata della manovra in minuti
%   dv_min          - delta_v minimo per la manovra orbitale trovata 
%   transfer_traj   - vettore posizione della sonda lungo la traiettoria di
%                      trasferimento                                   [km]
%   v2_prob_eur     - velocità della sonda di ingresso nella SOI di Europa
%                     utile per calcolare l'iperbole di cattura      [km/s]
%   v2_eur          - velocità di Europa nel momento in cui la sonda entra
%                     nella SOI                                      [km/s] 
%

    global pl_mu incl_body mu 

    %Intervallo di integrazione espresso in ore
    tf = caldays(between(begin_date, end_date, 'Days')) * 24; 
                                                            
    rad = pi/180;
    mu_p = pl_mu(5);
    mu = mu_p;
    incl = incl_body(5);
    R_x = [1 0 0; 0 cos(incl*rad) -sin(incl*rad); 0 sin(incl*rad) cos(incl*rad)];
    v_p_park = sqrt(mu_p * (1 + e_park) / r_p);

    r0 = (R_x * [-r_p, 0, 0]')';
    v0 = (R_x * [0, -v_p_park, 0]')';

    %% Trajectory generation
    [probe_pos, probe_vel] = gen_jupiter_park_orbit( r0, v0, tf);
    [io_pos, ~] = gen_io_traj(begin_date, end_date);
    [europa_pos, europa_vel] = gen_europa_traj(begin_date, end_date);

    % Parametri orbita di parcheggio
    a = r_p / (1 - e_park);             %semiasse maggiore             [km]
    T_s = 2 * pi * sqrt(a^3 / mu_p);    %periodo                        [s] 
    
    % Essendo le posizioni e velocita' calcolate minuto per minuto, e'
    % comodo lavorare con periodo espresso in minuti
    T_s = ceil(T_s / 60); %minuti
    
    %Ci aspettiamo che la durata di una manovra plausibile sia circa un
    %giorno; lo esprimiamo in minuti per coerenza con le grandezze trattate
    delta_t = 1*24*60; 
  
    %Periodi contenuti nell'intervallo di tempo considerato: è necessario
    %per non accedere ad indici troppo grandi dei vettori
    stop_time = floor(tf * 60 / T_s);
    
    %Delta_V iniziale: il valore è grande rispetto al Delta_V che ci
    %aspettiamo per la manovra
    dv_min = 5;
    
    %Questa variabile conterrà l'indicazione sull'inizio della manovra
    t_dep = 0; 
    
    %Questa variabile conterrà la durata della manovra di trasferimento
    t_man = 0;

    %% Lambert Phasing
    for dt = 1 : T_s : stop_time * T_s
        r_probe = probe_pos(dt, :);
        v_probe = probe_vel(dt, :);
        r_probe(3) = 0;
        v_probe(3) = 0;
        %Risolviamo un problema di Lambert per possibili diverse durate
        %che vanno da 12 ore a 36 ore
        for delta_t_lam = 0.5 * delta_t : 0.1 * delta_t : 1.5 * delta_t
            r_europa = europa_pos(dt + delta_t_lam, :);
            %v_europa = europa_vel(dt + delta_t_lam, :);
            r_europa(3) = 0;
            [v1, v2] = lambert(r_probe, r_europa, delta_t_lam*60);
            dv1 = norm(v1 - v_probe);
            if(dv1 <= dv_min)
                dv_min = dv1;
                t_man = delta_t_lam; %minuti
                t_dep = dt;
                %Salviamo la velocità con cui sarà necessario iniziare il
                %trasferimento
                v1_probe = v1;
                %Salviamo la velocità della sonda all'arrivo nella SOI di
                %Europa
                v2_probe_eur = v2;

            end
        end
    end
    
    if(dv_min == 5)
        fprintf('\nTransfer to Europa unfeasible in the given dates!\n')
        return;
    end
    
    r0_jup_to_eur = probe_pos(t_dep, :);
    %Generiamo la traiettoria di trasferimento le cui condizioni iniziali
    %sono la posizione della sonda a t_dep e la velocita' ottenuta come
    %output del problema di Lambert
    [transfer_traj,] = gen_jupiter_park_orbit(r0_jup_to_eur, v1_probe, ...
                                              t_man/60);
    
    %Salviamo la velocità di Europa al momento dell'arrivo della
    %sonda, in modo da poter calcolare le caratteristiche
    %dell'iperbole di cattura
    v2_eur = europa_vel(t_dep + t_man, :);
    
end

