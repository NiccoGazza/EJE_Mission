%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [epsilon, t, dv, r, DVU] = iterazione_primo_flyby (t1, t2)
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
%                Fly-by (nominal value = 0)
%      dv      - Deltav del Fly-by su planet_id1 (nominal value = 1)
%      epsilon - Differenza fra i due moduli delle v infinito (nomianal
%                value = 1)
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
% v_mars = [v_mars(1), v_mars(2)];

%Lambert fra Marte e Terra post Flyby
dt = between (t1, t2, 'Days');
t_volo = (caldays(dt))* 24 *3600;
[v_dep, ~] = lambert (r_mars, r_earth2, t_volo);
% v_dep = [v_dep(1), v_dep(2)];

%Valutazione della velocita'  relativa post Flyby rispetto a Marte

modul_vout = norm((v_dep-v_mars),2);

%% TRAGITTO TERRA-MARTE PRE FLYBY

%Inizializzazione dati dell'iterazione
t0 = datetime (2023, 1, 1);
n=0;
toll = 1.5;
t = datetime(2010, 1, 1);
%t = [];
dv=0;
%dv = [];
epsilon = 5;
r = 0;
DVU = 10;
%DVU = [];

    %Scandaglio un anno e mezzo
    while n ~= 760
        y = year(t0);
        m = month(t0);
        d = day(t0);

        %Posizione della Terra
        [~, r_earth, ~, ~] = body_elements_and_sv(3, y, m, d, 0, 0, 0);

        %Traiettoria Terra-Marte 
        dt1 = between (t0, t1, 'Days');
        t_lam = (caldays(dt1))*24*3600;
        [v1, v2] = lambert (r_earth, r_mars, t_lam);
        %v1 = [v1(1), v1(2)];
        %v2 = [v2(1), v2(2)];

        %Valutazione velocita'  relativa di uscita dal Flyby rispetto a Marte
        modul_vin = norm((v2-v_mars),2);

        %Se modul_vin e modul_vout sono comparabili posso considerare fattibile
        %il Flyby su Marte
        diff = abs(modul_vout-modul_vin);

        if diff < toll 
            %fprintf("TROVATO");
            %FLYBY
            [deltav, ~, ~, ~, ~, r_p] = flyby (4, v2, v_mars, v_dep);

            %Se la manovra di Flyby è fattibile calcolo il deltav di uscita
            %dalla Terra
            if r_p > radii(4) + 100
                %MANOVRA DI USCITA
                [dvu, ~] = escape_hyp (3, v1, 200, t0, 23.5);

                %Aggiornamento grandezze variabili se la manovra di uscita è
                %piu' vantaggiosa
                t = [t, t0];
                dv = [dv, deltav];
                r = [r, r_p];
                DVU = [DVU, dvu];
            end
        end
        t0 = t0+1;
        n = n+1; 
    end
end
