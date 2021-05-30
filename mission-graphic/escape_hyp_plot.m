%escape_hyp_plot plotta l'iperbole di uscita partendo da un'orbita di
%parcheggio di raggio r_park. L'orbita è inclinata di incl; si assume che
%l'orbita di parcheggio dalla quale avviene il cambio sia anch'essa
%inclinata dello stesso angolo; ovvero la manovra di entrata nell'iperbole
%di uscita non prevede un cambio di piano orbitale.
%input:
%   body_id - planet identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                6 = Saturn
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto
%               10 = Europe 
%               11 = Sun
%   V1 = velocita' eliocentrica della sonda all'uscita della SOI     [km/s]
%   time = data di partenza dell'orbita di Lambert               [datetime]
%   r_park = raggio dell'orbita di parcheggio                          [km]
%   incl = inclinazione dell'orbita rispetto al piano planetocentrico [deg]

function escape_hyp_plot(body_id, r_park, V1, time, incl)
    rad = pi/180;
    global pl_mu radii 
    R = radii(body_id); 
    r_p = r_park + R; %raggio al periasse
    v_park = sqrt( pl_mu(3) / r_p );
    [v_p, ~] = escape_hyp(V1, r_park, time);
    mu = pl_mu(body_id);
    r_soi = soi_compute(body_id, 11); %11: SUN
    
    %matrice di rotazione: viene utilizzata non come cambio di coordinate 
    %ma per mappare una rotazione rigida di vettori
    R_x = [1 0 0; 0 cos(incl*rad) -sin(incl*rad); 0 sin(incl*rad) cos(incl*rad)];
    
    %% PARKING ORBIT
    r0 = (R_x*[-r_p, 0, 0]')'; 
    v0 = (R_x*[0, -v_park, 0]')';
    
    %Integro utilizzando rates
    t0 = 0;
    T = 2*pi*sqrt(r_p^3/mu);
    tf = 2.5*T;
    y0 = [r0 v0]';
    [t,y] = rkf45(@rates, [t0 tf], y0);
    first_orbit = y;
    
    %% ESCAPE HYPERBOLA
    %NOTA IMPORTANTE: di fatto la traiettoria iperbolica è calcolata rispetto al sdr
    %planetocentrico, con RA = w = 0. Si tratta di una semplificazione, in
    %quanto in realtà la direzione della v_inf potrebbe portare alla
    %necessita' di un burnout che non avviene in corrispondenza di TA = 0
    %anche per l'orbita circolare.
    
    %Ricavo posizione e velocità nell'istante di burnout, ovvero con TA = 0
    r0_new = (R_x*[r_p, 0, 0]')';
    v0_new = (R_x*[0, v_p, 0]')'; %velocità al periasse
    
    %Integro utilizzando rates
    hours = 3600;
    t0 = 0;
    tf = 2*hours;
    y0_new = [r0_new, v0_new]';
    [t_new,y_new] = rkf45(@rates, [t0 tf], y0_new);
    
    t = [t; t_new];
    y = [first_orbit; y_new];
    
    %controllo di non essere uscito dalla SOI:
    %altrimenti rimuovo gli elementi non coerenti
    for i = 1 : size(y,1)
        if(norm(y(i, 1:3)) > r_soi)
            y = y(1:i-1, :);
            t = t(1:i-1, :);
            break;
        end
    end

    %...Output the results:
    output
 
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
function output
% ~~~~~~~~~~~~~
%{
  This function computes the maximum and minimum radii, the times they
  occur and and the speed at those times. It prints those results to
  the command window and plots the orbit.
 
  r         - magnitude of the position vector at the times in t
  imax      - the component of r with the largest value
  rmax      - the largest value of r
  imin      - the component of r with the smallest value
  rmin      - the smallest value of r
  v_at_rmax - the speed where r = rmax
  v_at_rmin - the speed where r = rmin
 
  User subfunction required: light_gray
%}
% -------------
for i = 1:length(t)
    r(i) = norm([y(i,1) y(i,2) y(i,3)]);
end
 
[rmax, imax] = max(r);
[rmin, imin] = min(r);
 
v_at_rmax   = norm([y(imax,4) y(imax,5) y(imax,6)]);
v_at_rmin   = norm([y(imin,4) y(imin,5) y(imin,6)]);
 
%...Output to the command window:
fprintf('\n\n--------------------------------------------------------\n')
fprintf('\n Earth Orbit\n')
fprintf(' %s\n', datestr(now))
fprintf('\n The initial position is [%g, %g, %g] (km).',...
                                                     r0(1), r0(2), r0(3))
fprintf('\n   Magnitude = %g km\n', norm(r0))
fprintf('\n The initial velocity is [%g, %g, %g] (km/s).',...
                                                     v0(1), v0(2), v0(3))
fprintf('\n   Magnitude = %g km/s\n', norm(v0))
fprintf('\n Initial time = %g h.\n Final time   = %g h.\n',0,tf/hours) 
fprintf('\n The minimum altitude is %g km at time = %g h.',...
            rmin-R, t(imin)/hours)
fprintf('\n The speed at that point is %g km/s.\n', v_at_rmin)
fprintf('\n The maximum altitude is %g km at time = %g h.',...
            rmax-R, t(imax)/hours)
fprintf('\n The speed at that point is %g km/s\n', v_at_rmax)
fprintf('\n--------------------------------------------------------\n\n')
 
%...Plot the results:
%   Draw the planet
[xx, yy, zz] = sphere(100);
surf(R*xx/1.5, R*yy/1.5, R*zz/1.5)
colormap(light_gray)
caxis([-R/100 R/100])
shading interp
 
%   Draw and label the X, Y and Z axes
line([0 2*R/1.5],   [0 0],   [0 0]); text(2*R/1.5,   0,   0, 'X')
line(  [0 0], [0 2*R/1.5],   [0 0]); text(  0, 2*R/1.5,   0, 'Y')
line(  [0 0],   [0 0], [0 2*R/1.5]); text(  0,   0, 2*R/1.5, 'Z')
hold on 
%   Plot the orbit, draw a radial to the starting point
%   and label the starting point (o) and the final point (f)
% hold on
% plot3(  y(:,1),    y(:,2),    y(:,3),'k')
% line([0 r0(1)], [0 r0(2)], [0 r0(3)])
% text(   y(1,1),    y(1,2),    y(1,3), 'o')
% text( y(end,1),  y(end,2),  y(end,3), 'f')
  
%   Specify some properties of the graph
grid on
axis equal
% xlim([-0.7e4, 0.7e4])
% ylim([-2e4, 2e4])
xlabel('km')
ylabel('km')
zlabel('km')
view( [15 , 9] )
h = animatedline('Color', 'b');

for k = 1:size(y,1)
    if(k ~= 1)
        delete(sonda)
    end
    sonda = plot3(y(k,1),y(k,2), y(k,3),...
						'o','Color','#A2142F', 'MarkerSize', 10,...
						'MarkerFaceColor','#A2142F');    
    addpoints(h, y(k,1), y(k,2), y(k,3));
    drawnow 
    pause(0.01)
end
% ~~~~~~~~~~~~~~~~~~~~~~~
function map = light_gray
% ~~~~~~~~~~~~~~~~~~~~~~~
%{
  This function creates a color map for displaying the planet as light
  gray with a black equator.
  
  r - fraction of red
  g - fraction of green
  b - fraction of blue
 
%}
% -----------------------
r = 0.8; g = r; b = r;
map = [r g b
       0 0 0
       r g b];
end %light_gray
 
end %output
 
end %escape_hyp_plot
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

