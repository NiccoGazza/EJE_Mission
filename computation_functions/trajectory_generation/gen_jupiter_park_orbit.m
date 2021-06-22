function [probe_pos, probe_vel] = gen_jupiter_park_orbit(r0, v0, tf)
%Questa funzione genera la traiettoria di parcheggio di una sonda attorno a
%Giove, date le condizioni iniziali. Potrà (dovrà) successivamente essere
%utilizzata anche per generare la traiettoria di trasferimento da Giove a
%Europa.
% input: 
%      -r0: posizione iniziale nel sdr zeuscentrico [km]
%      -v0: velocità iniziale nel sdr zeuscentrico  [km/s]
%      -tf: ore (da rivedere)

    global masses G
    
    %% Inizializzazione input: 
    hours = 3600;
    m1 = 1000;   %massa della sonda [kg]
    m2 = masses(5);
    
    t0 = 0;
    tf = tf * hours;
    
    %% Integrazione numerica:
    mu    = G * (m1 + m2);
    %mu = G * m2;
    y0    = [r0 v0]';
    %[t,y] = rkf45(@rates, [t0 tf], y0);
    [t,y] = rkf1_4(@rates, [t0 tf], y0, 60, 4);
    probe_pos = y(: , 1:3); %prelevo soltanto la parte di posizione 
    probe_vel = y(: , 4:6); 
return
 
% ~~~~~~~~~~~~~~~~~~~~~~~~
function dydt = rates(t,f)
% ~~~~~~~~~~~~~~~~~~~~~~~~
%{
  This function calculates the acceleration vector using Equation 2.22
  
  t          - time
  f          - column vector containing the position vector and the
               velocity vector at time t
  x, y, z    - components of the position vector r
  r          - the magnitude of the the position vector
  vx, vy, vz - components of the velocity vector v
  ax, ay, az - components of the acceleration vector a
  dydt       - column vector containing the velocity and acceleration
               components
%}
% ------------------------
x    = f(1);
y    = f(2);
z    = f(3);
vx   = f(4);
vy   = f(5);
vz   = f(6);
 
r    = norm([x y z]);
 
ax   = -mu*x/r^3;
ay   = -mu*y/r^3;
az   = -mu*z/r^3;
    
dydt = [vx vy vz ax ay az]';    
end %rates
% ~~~~~~~~~~~~~
end %gen_jupiter_park_orbit