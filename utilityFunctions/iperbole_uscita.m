function  [delta_v, coe, theta] = iperbole_uscita (V1, r_p, time)
%Questa funzione calcola le caratteristiche dell'iperbole di uscita dal SOI
%del pianeta Terra fissata un orbita di parcheggio circolare di raggio 
%r_p attorno alla Terra
%
%   dati in igresso:
%   V1 = vettore velocita'  in ingresso a lambert
%   time = data di partenza dell'orbita di Lambert dati come vettore 'datetime'
%   r_p = raggio dell'orbita di parcheggio

%   dati in uscita:
%   delta_v = delta di velocita'  per entrare nell'iperbole di uscita
%   e       - eccentricita'  (magnitude of E)
%   a       - semiasse maggiore (km)
%   theta   - angolo di partenza della sonda rispetta all'asse X terrestre

%parametri orbitali 
global G masses radii
parameters
mu_t = G * masses(3); %(km^3/s^2)
R  = radii(3); %raggio terra
%r_p = 200; %(km) raggio orbita di parcheggio

% calcolo velocita'  in uscita da SOI
y = year(time);
m = month(time);
d = day(time);
[~, ~, v, ~] = body_elements_and_sv (3, y, m, d, 0, 0, 0); %v velocita'  della terra 
                                                             %nel sistema eliocentrico
v_inf = norm((V1-v),2);                                      %velocita'  fuori da SOI                                


%velocita'  e delta v
vel_p = sqrt(mu_t/(r_p + R));                    %velocita' di parcheggio
vel_f = sqrt(2*(mu_t)/(r_p + R)+ (v_inf)^2);     %velocita' di ingresso nell'iperbole

delta_v = vel_f - vel_p;                         


%iperbole dati caratteristici rispetto a un sistema di riferimento 
%geocentrico equatoriale con asse y diretto nella direzione della velocita'  
%della Terra

a = - mu_t/((v_inf)^2);              %semiasse maggiore 
e = 1 - r_p/a;                       %eccentricita'  
betha = 1/e;                         %angolo di controllo iperbole di uscita
theta = pi + betha;                  %argomento del perigeo
%h = norm(cross(r_p, vel_f),2);      %modulo del momento angolare
h = r_p * sqrt( v_inf^2 + 2 * (mu_t / r_p) );
%% PRIMA PROVA: NON SO COME RICAVARE w E RA
TA = 0;
w = 0;
RA = 0;
incl = 23.5;
coe = [h e RA incl w TA];
end

