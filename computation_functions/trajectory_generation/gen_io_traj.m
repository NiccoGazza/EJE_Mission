%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [eur_pos] = gen_io_traj(begin_date, end_date)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Questa funzione genera la traiettoria di Europa, nel sdr zeuscentrico, a
%partire dalla data begin_date fino alla data end_date, integrando
%l'equazione della dinamica con il metodo numerico Range-Kutta a step
%variabile. La posizione iniziale viene ricavata utilizzando le effemeridi
%in data begin_date. Si è scelto di integrare numericamente le equazioni, e
%di non utilizzare ad esempio i coefficienti di Lagrange, perchè i
%risultati forniti risultano essere migliori.
%input:
%    -begin_date: [datetime]
%    -end_date:   [datetime]
    
    global masses G
    
    %% Inizializzazione input: 
    y0 = year(begin_date);
    m0 = month(begin_date);
    d0 = day(begin_date);
    number_of_days = caldays( between(begin_date, end_date, 'Days') );

    hours = 3600;
    m1 = masses(5);
    m2 = masses(12);

    [~, r0, v0, ~] = body_elements_and_sv(12, y0, m0, d0, 0, 0, 0);

    t0 = 0;
    tf = number_of_days*24*hours;

    %% Integrazione numerica:
    mu    = G * (m1 + m2);
    y0    = [r0 v0]';
    [t,y] = rkf1_4(@rates, [t0 tf], y0, 60, 4);
    %[t,y] = rkf45(@rates, [t0 tf], y0);
    eur_pos = y(: , 1:3); %prelevo soltanto la parte di posizione 
  
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
end %gen_io_traj

