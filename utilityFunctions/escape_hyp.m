function  [vel_f, delta_v, coe, theta] = escape_hyp (V1, r_park, time)
%Questa funzione calcola le caratteristiche dell'iperbole di uscita dal SOI
%del pianeta Terra fissata un orbita di parcheggio circolare di raggio 
%r_p attorno alla Terra
%
%   input:
%   V1 = velocita' eliocentrica della sonda all'uscita della SOI
%   time = data di partenza dell'orbita di Lambert dati come vettore 'datetime'
%   r_park = raggio dell'orbita di parcheggio

%   output:
%   delta_v = deltaV necessario per entrare nell'iperbole di uscita
%   e       - eccentricita'  (magnitude of E)
%   a       - semiasse maggiore (km)
%   theta   - angolo di partenza della sonda rispetta all'asse X terrestre

%parametri orbitali 
global G masses radii
parameters
mu_t = G * masses(3); %(km^3/s^2)
R  = radii(3); %raggio terra

% calcolo velocita'  in uscita da SOI
y = year(time);
m = month(time);
d = day(time);
[~, ~, v, ~] = body_elements_and_sv (3, y, m, d, 0, 0, 0); %v velocita'  della terra 
                                                             %nel sistema eliocentrico
v_inf = norm((V1-v),2);                                      %velocita'  fuori da SOI                                


%velocita'  e delta v
vel_p = sqrt(mu_t/(r_park + R));                    %velocita' di parcheggio
vel_f = sqrt(2*(mu_t)/(r_park + R)+ (v_inf)^2);     %velocita' di ingresso nell'iperbole

delta_v = vel_f - vel_p;                         


%iperbole dati caratteristici rispetto a un sistema di riferimento 
%geocentrico equatoriale con asse y diretto nella direzione della velocita'  
%della Terra

a = - mu_t/((v_inf)^2);             %semiasse maggiore 
e = 1 - (R + r_park)/a;                %eccentricita'  
beta = 1/e;                         %(manca asin?) angolo di controllo iperbole di uscita
theta = pi + beta;                  %argomento del perigeo
h = r_park * sqrt( v_inf^2 + 2 * (mu_t / r_park) );%modulo del momento angolare
% e = 1 + ((R + r_p) * v_inf^2)/mu_t;
% h = (r_p + R) * vel_f;
% beta = acos(1/e);   %rad
% a = (r_p + R) / (e - 1);
% theta = pi + beta; %rad
%% RESTITUISCO COE RELATIVI A SDR PERIFOCALE
TA = 0;
w = 0;
RA = 0;
incl = 0;
coe = [h e RA incl w TA a beta];
end

