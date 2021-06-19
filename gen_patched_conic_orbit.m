function [e_pos, m_pos, j_pos, s_pos, number_of_days] = ...
         gen_patched_conic_orbit(begin_date, end_date, dep_body_id, arr_body_id)     
%Questa funzione genera la traiettoria di una sonda che parte in data
%begin_date dal pianeta dep_body_id e arriva in data end_date al pianeta
%arr_body_id. Genera inoltre, nello stesso intervallo di tempo, anche la
%traiettoria di Terra, Marte e Giove, i pianeti di interesse per la
%missione EJE. Viene utilizzata la funzione interplanetary che risolve il
%problema di Lambert.
       
    %% Generazione traiettorie
    number_of_days = caldays( between(begin_date, end_date, 'Days') );
    time_vector = generate_time(begin_date, end_date); 
    e_posx = []; m_posx = []; s_posx = []; j_posx = [];
    e_posy = []; m_posy = []; s_posy = []; j_posy = [];
    e_posz = []; m_posz = []; s_posz = []; j_posz = [];


    %Genero i dati in ingresso a interplanetary
    y_d = year(begin_date);
    m_d = month(begin_date);
    d_d = day(begin_date);

    y_a = year(end_date);
    m_a = month(end_date);
    d_a = day(end_date);

    depart = [dep_body_id, y_d, m_d, d_d, 0, 0, 0];
    arrive = [arr_body_id, y_a, m_a, d_a, 0, 0, 0];

    %Genero la traiettoria della sonda
    [planet_dep, ~, traj, ~] = interplanetary(depart, arrive);
    r0 = planet_dep(1:3);
    v0 = traj(1:3);

     for days = 1:1:number_of_days
        [~, target_pos, ~,~] = body_elements_and_sv(3, time_vector(days, 1),...
                                                      time_vector(days, 2),...
                                                      time_vector(days, 3), 0, 0, 0);
        e_posx = [e_posx; target_pos(1)];
        e_posy = [e_posy; target_pos(2)];
        e_posz = [e_posz; target_pos(3)];

       [~, m_target_pos, ~,~] = body_elements_and_sv(4, time_vector(days, 1),...
                                                      time_vector(days, 2),...
                                                      time_vector(days, 3), 0, 0, 0);
        m_posx = [m_posx; m_target_pos(1)];
        m_posy = [m_posy; m_target_pos(2)];
        m_posz = [m_posz; m_target_pos(3)];

       [~, j_target_pos, ~,~] = body_elements_and_sv(5, time_vector(days, 1),...
                                                      time_vector(days, 2),...
                                                      time_vector(days, 3), 0, 0, 0);
       j_posx = [j_posx; j_target_pos(1)];
       j_posy = [j_posy; j_target_pos(2)];
       j_posz = [j_posz; j_target_pos(3)];

       [s_pos, ~] = rv_from_r0v0(r0, v0, days*60*60*24); %calcolo la nuova posizione giornalmente
                                                          %coerentemente con gli
                                                          %altri pianeti
        s_posx = [s_posx; s_pos(1)];
        s_posy = [s_posy; s_pos(2)];
        s_posz = [s_posz; s_pos(3)];

     end

    %scalo i valori per migliorare il rendering del plot
    e_posx = e_posx/2; e_posy = e_posy/2; e_posz = e_posz/2;
    m_posx = m_posx/2; m_posy = m_posy/2; m_posz = m_posz/2;
    j_posx = j_posx/2; j_posy = j_posy/2; j_posz = j_posz/2;
    s_posx = s_posx/2; s_posy = s_posy/2; s_posz = s_posz/2;

    
    %% Output 
    e_pos = [e_posx, e_posy, e_posz];
    m_pos = [m_posx, m_posy, m_posz];
    j_pos = [j_posx, j_posy, j_posz];
    s_pos = [s_posx, s_posy, s_posz];

end