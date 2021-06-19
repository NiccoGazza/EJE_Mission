function [t, dv, r_p, v_lam] = entrance_iteration(t1, e)
%Questa funzione restituisce data di partenza, raggio dell'orbita di parcheggio e
%variazione di velocita' dell'orbita interplanetaria ottima data una data di
%arrivo, un'eccentricita' richiesta e un anno di partenza. 
%
%   Dati in ingresso:
%       t1  - Data di arrivo su Giove (datetime)
%       e   - eccentricita' desiderata per l'orbita di parcheggio su Giove
%
%   Dati in uscita:
%       t   - Data di partenza dalla Terra
%       dv  - Variazione ottima di velocita' richiesta per la manovra di parcheggio
%       r_p - Raggio dell'orbita di parcheggio
%

%% Posizione di Giove
global radii

y = year (t1);
m = month (t1);
d = day (t1);
[~, r_jup, ~] = body_elements_and_sv(5, y, m, d, 0, 0, 0);
%vj = [vj(1), vj(2)];
R = radii(5);
%% Traiettoria Terra-Giove

%Inizializzazione
t0 = datetime(2026, 6, 1);
n=0;
t = [];
dv = [];
r_p = [];
v_lam = [];

    %Scandaglio un anno e mezzo
    while n~=547

        y = year(t0);
        m = month(t0);
        d = day(t0);

        %Posizione Terra
        [~, r_e, ~] = body_elements_and_sv(3, y, m, d, 0, 0, 0);

        %Lambert Terra-Giove
        dt1 = between (t0, t1, 'Days');
        t_lam = ( caldays(dt1) ) * 24 * 3600;
        [~ , v2] = lambert (r_e, r_jup, t_lam);
        %v2 = [v2(1), v2(2)];

        %MANOVRA DI ENTRATA IN GIOVE
        %vinf = v2 - v_jup;
        %% Raggio ottimo
        %[deltav, rp] = capture_hyp(5, v2, t1, 'opt', e);
        
        %% Raggio di parcheggio desiderato
        [deltav, rp] = capture_hyp(5, v2, t1, R + 3e5);
        
        if deltav < 5
            v_lam = [v_lam; v2];
            dv = [dv; deltav];
            t = [t; t0];
            r_p = [r_p; rp];
        end
        t0 = t0+1;
        n = n+1;
    end  
end
