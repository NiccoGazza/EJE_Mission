%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [t, dv, r, dv_esc_earth] = earth_departure(t1, t2)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Questa funzione trova una data di partenza per Lambert pre flyby su Marte in modo
% da far coincidere le velocita'  relative di entrata e uscita, minimizzando
% il deltav di uscita dalla terra. 
%
%  Dati in igresso:
%      t1 - data del Fly_by (fissata) su Marte
%      t2 - data di arrivo del Lambert post Fly-by su Terra
%
%  Dati in uscita:
%      t       - tempo plausibile di partenza da planet_id0 per il Lambert pre
%                Fly-by
%      dv      - Deltav del Fly-by su planet_id1 
%      r       - Raggio al periasse dell'iperbole di flyby
%      DVU     - Deltav di uscita dalla terra


    global radii
    %% TRAGITTO MARTE-TERRA POST FLYBY

    % Data di flyby su Marte
    y1 = year(t1);
    m1 = month(t1);
    d1 = day(t1);

    % Data di arrivo sulla Terra post flyby
    y2 = year(t2);
    m2 = month(t2);
    d2 = day(t2);

    %Posizioni relative dei pianeti
    [~, r_mars, v_mars, ~] = body_elements_and_sv(4, y1, m1, d1, 0, 0, 0);
    [~, r_earth2, ~, ~] = body_elements_and_sv(3, y2, m2, d2, 0, 0, 0);

    %Lambert fra Marte e Terra post Flyby
    dt = between (t1, t2, 'Days');
    t_volo = (caldays(dt))* 24 *3600;
    [v_dep, ~] = lambert (r_mars, r_earth2, t_volo);

    %Valutazione della velocita'  relativa post Flyby rispetto a Marte
    norm_vout = norm((v_dep-v_mars),2);

    %% TRAGITTO TERRA-MARTE PRE FLYBY

    %Inizializzazione dati dell'iterazione
    t0 = datetime (2023, 1, 1);
    n=0;
    toll = 1.5;
    t = [];
    dv = [];
    r = [];
    dv_esc_earth = [];

    %Analizzo due anni
    while n ~= 730
        y = year(t0);
        m = month(t0);
        d = day(t0);

        %Posizione della Terra
        [~, r_earth, ~, ~] = body_elements_and_sv(3, y, m, d, 0, 0, 0);

        %Traiettoria Terra-Marte 
        dt1 = between (t0, t1, 'Days');
        t_lam = (caldays(dt1))*24*3600;
        [v1, v2] = lambert (r_earth, r_mars, t_lam);

        %Valutazione velocita'  relativa di uscita dal Flyby rispetto a Marte
        norm_vin = norm((v2-v_mars),2);

        %Se norm_vin e norm_vout sono comparabili posso considerare fattibile
        %il Flyby su Marte
        diff = abs(norm_vout-norm_vin);

        if diff < toll 
            %FLYBY
            [deltav, ~, ~, ~, ~, r_p] = flyby (4, v2, v_mars, v_dep);

            %Se la manovra di Flyby è fattibile calcolo il deltav di uscita
            %dalla Terra
            if r_p > radii(4) + 50
                %MANOVRA DI USCITA
                [dvu, ~] = escape_hyp (3, v1, 200, t0, 23.5);
                t = [t, t0];
                dv = [dv, deltav];
                r = [r, r_p];
                dv_esc_earth = [dv_esc_earth, dvu];
            end
        end
        t0 = t0+1;
        n = n+1; 
    end
end
