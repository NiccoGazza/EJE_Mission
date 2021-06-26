%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [t, dv, r_p] = earth_flyby(t1, r_park, e_park)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Questa funzione restituisce data di partenza dalla Terra (post flyby),
%variazione di velocita' dell'orbita interplanetaria ottima e raggio
%dell'orbita di parcheggio, data una data di arrivo t1 e un'eccentricita' e. 
%
%   Dati in ingresso:
%       t1     - Data di arrivo su Giove [datetime]
%       r_park - raggio al periasse dell'orbita di parcheggio su Giove 
%       e_park - eccentricita' desiderata per l'orbita di parcheggio su Giove
%
%   Dati in uscita:
%       t   - Vettore delle date di partenza dalla Terra 
%       dv  - Vettore delle variazioni ottime di velocita' richiesta per la manovra di parcheggio
%       r_p - Vettore dei raggi dell'orbita di parcheggio
%

    %% Posizione di Giove
    global radii

    y = year (t1);
    m = month (t1);
    d = day (t1);
    [~, r_jup, ~] = body_elements_and_sv(5, y, m, d, 0, 0, 0);

    R = radii(5);

    %% Traiettoria Terra-Giove
    %Inizializzazione
    t0 = datetime(2026, 1, 1);
    n=0;
    t = [];
    dv = [];
    r_p = [];

    %Scandaglio due anni
    while n ~= 730

        y = year(t0);
        m = month(t0);
        d = day(t0);

        %Posizione Terra
        [~, r_e, ~] = body_elements_and_sv(3, y, m, d, 0, 0, 0);

        %Lambert Terra-Giove
        dt1 = between (t0, t1, 'Days');
        t_lam = ( caldays(dt1) ) * 24 * 3600;
        [~ , v2] = lambert (r_e, r_jup, t_lam); %v2 vettore velocità finale eliocentrica della sonda
        
        % Raggio ottimo: problema => vengono r_p troppo grandi!
        %[deltav, rp] = capture_hyp(5, v2, t1, 'opt', e_park);
        
        %Raggio di parcheggio desiderato
        [deltav, rp] = capture_hyp(5, v2, t1, 0, r_park, e_park);
        
        if deltav < 4.8
            dv = [dv; deltav];
            t = [t; t0];
            r_p = [r_p; rp];
        end
        t0 = t0+1;
        n = n+1;
    end  
end
