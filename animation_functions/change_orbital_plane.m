% change_orbital_plane plotta il cambio di piano da equatoriale a quello
% dell'eclittica, nel quale poi tutta la missione si svilupperà. Potrebbe
% essere generalizzata, ma essendo una manovra che avviene solo sulla Terra
% si è scelto di farla specificatamente per questo caso.
function y = change_orbital_plane
    %% PARKING ORBIT
    global pl_mu radii 
    
    mu_obj = pl_mu(3);
    R = radii(3);
    r_park = 200; %E' fissato dalle specifiche di progetto
    v_park = sqrt( pl_mu(3) / (R + r_park) );
    
    h = (v_park * (R + r_park)); %essendo traiettoria circolare 
                                        %sono perpendicolari
    e = 0; %circonferenza
    RA = 0; 
    incl = 0;
    w = 0;
    TA = 0;  
    coe_park_orbit = [h e RA incl w TA];
    [r0, v0] = sv_from_coe(coe_park_orbit, mu_obj);
    
    hours = 3600;
    t0 = 0;
    tf = 2*pi*sqrt( (R + r_park)^3 / mu_obj ); %[s]
    %...End input data
 
 
    %...Numerical integration:
    y0    = [r0, v0]';
    [t,y] = rkf45(@rates, [t0 2*tf], y0); %tempo finale: multiplo del periodo
    first_orbit = y;
    len = size(y,1);
    
    %% ORBITAL PLANE CHANGE
    %prelevo r e v dall'ultima iterazione
     r_fin = [ y(len,1), y(len,2), y(len,3) ];
     v_fin = [ y(len,4), y(len,5), y(len,6) ];
     new_incl = 23.5*pi/180;
    
    % i vettori vengono ruotati per evitare possibili incoerenze dovute al
    % fatto che, per orbite circolari, l'anomalia vera non è univocamente
    % definita (dipende da dove viene scelto il perigeo)
    R_incl = [1 0 0; 0 cos(new_incl) -sin(new_incl); 0 sin(new_incl) cos(new_incl)];
    r0_new = R_incl*r_fin';
    v0_new = R_incl*v_fin';

    y0_new = [r0_new; v0_new];
    [t_new, y_new] = rkf45(@rates, [t0 tf], y0_new);
    
    t = [t; t_new];
    y = [first_orbit; y_new];
 
    
    %...Output the results:
    output
 
return 

%%
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
 
ax   = -mu_obj*x/r^3;
ay   = -mu_obj*y/r^3;
az   = -mu_obj*z/r^3;
    
dydt = [vx vy vz ax ay az]';    
end %rates
%%
 
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

fprintf('\n The orbital period is %g s\n', tf)
 

fig = gca;
fig.Color = [0, 0.1686, 0.4196];
fig.GridColor = [0.9020, 0.9020, 0.9020];
obj_pos = [0, 0, 0];
body_sphere(3, obj_pos);
grid on
grid minor


%   Draw and label the X, Y and Z axes
line([0 2*R/1.5],   [0 0],   [0 0]); text(2*R/1.5,   0,   0, 'X')
line(  [0 0], [0 2*R/1.5],   [0 0]); text(  0, 2*R/1.5,   0, 'Y')
line(  [0 0],   [0 0], [0 2*R/1.5]); text(  0,   0, 2*R/1.5, 'Z')
hold on

%   Select a view direction (a vector directed outward from the origin) 
%   Specify some properties of the graph
grid on
axis equal
xlabel('km')
xlim([-1e4, 1e4])
ylabel('km')
ylim([-8e3, 8e3])
zlabel('km')
zlim([-8e3, 8e3])

%view( [128 , 28] )
view( [158, 26] )
h = animatedline('Color', [1, 0.93333, 0]);

pause();
for k = 1:size(y,1)
    if(k == 1)
        sonda = plot3(y(k,1),y(k,2), y(k,3),...
						'o','Color','#A2142F', 'MarkerSize', 5,...
						'MarkerFaceColor','#A2142F');
    else
        sonda.XData = y(k,1);
        sonda.YData = y(k,2);
        sonda.ZData = y(k,3);
    end
    
    addpoints(h, y(k,1), y(k,2), y(k,3));
    drawnow 
    pause(0.01)
end
% ~~~~~~~~~~~~~~~~~~~~~~~ 
end %output
 
end %change_orbital_plane
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~