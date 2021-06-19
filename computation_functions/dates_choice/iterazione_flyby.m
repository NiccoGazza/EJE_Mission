function [t, dv, r, v_dep, v_arr] = iterazione_flyby(t1, t2)
% Questa funzione trova una data di partenza per Lambert pre Flyby su terra in modo
% da far coincidere le velocità relative di entrata e uscita.
%
%  Dati in igresso:
%      t1 - data del Fly_by (fissata) su Terra
%      t2 - data di arrivo del Lambert post Fly-by su Giove
%
%  Dati in uscita:
%      t       - tempo plausibile di partenza da planet_id0 per il Lambert pre
%                Fly-by (nominal value = 0)
%      dv      - deltav del Fly-by su planet_id1 (nominal value = 1)
%      epsilon - differenza fra i due moduli delle v infinito (nominal
%                value = 1)
%      r       - raggio al periasse dell'iperbole di Flyby


%inizializzazione
global radii 
 
%% TRAGITTO TERRA-GIOVE

%Data Flyby su Terra
y1 = year(t1);
m1 = month(t1);
d1 = day(t1);

%Data arrivo su Giove
y2 = year(t2);
m2 = month(t2);
d2 = day(t2);

%Posizione relative dei pianeti
[~, r_earth, v_earth, ~] = body_elements_and_sv(3, y1, m1, d1, 0, 0, 0);
[~, r_jupiter, ~, ~] = body_elements_and_sv(5, y2, m2, d2, 0, 0, 0);
%v_earth = [v_earth(1), v_earth(2)];

%Lambert fra Terra e Giove
dt = between (t1, t2, 'Days');
t_volo = (caldays(dt)) * 24 * 3600;
[v_dep, ~] = lambert (r_earth, r_jupiter, t_volo);
%v_dep = [v_dep(1), v_dep(2)];

%Valutazione della velocità relativa post Flyby su Terra
norm_vout = norm( (v_dep - v_earth) , 2);

v_arr = [];
%% TRAGITTO MARTE-TERRA

%Inizializzazione dati dell'iterazione
t0 = datetime(2024, 1, 1);
n = 0;
toll = 1.5;
t = [];
dv = [];
epsilon = toll;
r = [];

%Scandaglio due anni
while n ~= 730 
    y = year(t0);
    m = month(t0);
    d = day(t0);
    
    %Posizione di Marte
    [~, r_mars, ~, ~] = body_elements_and_sv(4, y, m, d, 0, 0, 0);
    
    %Lambert fra Marte e Terra
    dt1 = between (t0, t1, 'Days');
    t_lam = (caldays(dt1)) * 24 * 3600;
    [~, v2] = lambert (r_mars, r_earth, t_lam);
    %v2 = [v2(1), v2(2)];
    %Valutazione velocità relativa post Flyby rispetto alla Terra
    norm_vin = norm( (v2 - v_earth) , 2);
    
    %Se norm_vin e norm_vout sono comparabili posso considerare fattibile
    %il Flyby su Terra
    diff = abs(norm_vout - norm_vin);
    
    if diff < toll 
        %FLYBY
        [deltav, ~, ~, ~, ~, r_p] = flyby (3, v2, v_earth, v_dep);
        %Aggiornamento delle variabili alla data che approssima in miglior
        %modo le condizioni del Flyby sulle velocità relative        
        if r_p > radii(3) + 150 %Distanza di sicurezza: 150km
            t = [t; t0];
            dv = [dv; deltav];
            r = [r; r_p];
            v_arr = [v_arr; v2];         
        end
    end
    t0 = t0+1;
    n = n+1;
end
end
  
   
  
   
    
   