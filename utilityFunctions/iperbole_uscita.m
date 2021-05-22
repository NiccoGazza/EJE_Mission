
function  [delta_v, e, a, theta] = iperbole_uscita (V1, time)
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
%   e       - eccentricità (magnitude of E)
%   a       - semiasse maggiore (km)
%   theta   - angolo di partenza della sonda rispetta all'asse X terrestre

%parametri orbitali 
global mu_t R
mu_t = 398600.4418; %(km^3/s^2)
R  = 6378; %raggio terra
r_p = 200; %(km) raggio orbita di parcheggio

% calcolo velocità in uscita da SOI
y = year(time);
m = month(time);
d = day(time);
[~, ~, v, ~] = planet_elements_and_sv (3, y, m, d, 0, 0, 0); %v velocità della terra 
                                                             %nel sistema eliocentrico
v_inf = norm((V1-v),2);                                     %velocità fuori da SOI                                


%velocità e delta v
vel_p = sqrt(mu_t/(r_p+R));                    %velocità di parcheggio
vel_f = sqrt(2*(mu_t)/(r_p+R)+ (v_inf)^2);     %velocità di ingresso nell'iperbole

delta_v = vel_f - vel_p;                         


%iperbole dati caratteristici rispetto a un sistema di riferimento 
%geocentrico equatoriale con asse y diretto nella direzione della velocità 
%della Terra

a = - mu_t/((v_inf)^2);              %semiasse maggiore 
e = 1 - r_p/a;                       %eccentricità 
betha = 1/e;                         %angolo di controllo iperbole di uscita
theta = pi + betha;                  %argomento del perigeo
%h = norm(cross(r_p, vel_f),2);      %modulo del momento angolare

end

