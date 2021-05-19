
function  [delta_v, coe] = iperbole_uscita (V1, time)
%Questa funzione calcola le caratteristiche dell'iperbole di uscita dal SOI
%del pianeta Terra fissata un orbita di parcheggio circolare di raggio 
%200 Km attorno alla Terra
%
%   dati in igresso:
%   V1 = vettore velocità in ingresso a lambert
%   time = data di partenza dell'orbita di Lambert dati come vettore 'datetime'
%
%   dati in uscita:
%   delta_v = delta di velocità per entrare nell'iperbole di uscita
%   h    - modulo del momento angolare (km^2/s)
%   incl - inclinazione (rad)
%   RA   - ascensione retta (rad)
%   e    - eccentricità (magnitude of E)
%   w    - argomento del perigeo (rad)
%   TA   - anomalia vera (rad)
%   a    - semiasse maggiore (km)
%   coe  = vettore degli elementi orbitali [h e RA incl w TA a]

%parametri orbitali 
global mu_t R
mu_t = 398600.4418; %(km^3/s^2)
R  = 6378; %raggio terra
r_p = 200; %(km) raggio orbita di parcheggio

% calcolo velocità in uscita da SOI
d = day(time);
y = year(time);
m = month(time);
[~, ~, v, ~] = planet_elements_and_sv (3, y, m, d, 0, 0, 0); %v velocità della terra 
                                                             %nel sistema eliocentrico
v_inf = norm ((V1-v),2);                                     %velocità fuori da SOI                                


%velocità e delta v
vel_p = sqrt(mu_t/(r_p+R));                    %velocità di parcheggio
vel_f = sqrt(2*(mu_t)/(r_p+R)+ (v_inf)^2);     %velocità di ingresso nell'iperbole

delta_v = vel_f - vel_p;                         


%iperbole dati caratteristici rispetto a un sistema di riferimento 
%geocentrico equatoriale con asse y diretto nella direzione della velocità 
%della Terra

a = - mu_t/((v_inf)^2);      %semiasse maggiore 
e = 1 - r_p/a;               %eccentricità 
betha = 1/e;                 %angolo di controllo iperbole di uscita
theta = pi + betha;          %argomento del perigeo
h = vel_f*r_p;               % modulo del momento angolare

coe = [h e 0 23.5 theta 0 a];

