function [t, dv, r] = entrance_iteration(t1, e)
%Questa funzione restituisce data di partenza, raggio dell'orita di parcheggio e
%variazione di velocità dell'orbita interplanetaria ottima data una data di
%arrivo, un' eccentricità richiesta e un anno di partenza. 
%
%   Dati in ingrasso:
%       t1  - Data di arrivo su Giove
%       e   - eccentricità desiderata per l'orbita di parcheggio su Giove
%
%   Dati in uscita:
%       t   - Data di partenza dalla Terra
%       dv  - Variazione ottima di velocità richiesta per la manovra di parcheggio
%       r   - Ragio dell'orbita di parcheggio
%

%% Posizione di Giove
y = year (t1);
m = month (t1);
d = day (t1);
[~, rj, vj , ~] = body_elements_and_sv(5, y, m, d, 0, 0, 0);
%vj = [vj(1), vj(2)];

%% Traiettoria Terra-Giove

%Inizializzazione
t0 = datetime(2025, 6, 1);
n=0;
t= datetime(2010, 1, 1);
dv = 10;
r= 0;

%Scandaglio un anno e mezzo
while n~=547
    
    y = year(t0);
    m = month(t0);
    d = day(t0);
    
    %Posizione Terra
    [~, re, ~, ~] = body_elements_and_sv(3, y, m, d, 0, 0, 0);
    
    %Lambert Terra-Giove
    dt1 = between (t0, t1, 'Days');
    t_lam = (caldays(dt1))*24*3600;
    [~ , v2] = lambert (re, rj, t_lam);
    %v2 = [v2(1), v2(2)];
    
    %MANOVRA DI ENTRATA IN GIOVE
    vinf = v2 - vj;
    [deltav, rp] = entrance_bodyEccentrity (5, vinf, 'opt', e);
    
    if deltav < 4.2
        dv = [dv, deltav];
        t = [t, t0];
        r = [r, rp];
    end
    t0 = t0+1;
    n = n+1;
end  
end
