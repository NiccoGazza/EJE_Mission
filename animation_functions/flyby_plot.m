function flyby_plot(body_id, r_p, v_inf)

%RICORDA: I SDR PLANETOCENTRICI HANNO INCLINAZIONE DIVERSA RISPETTO
%ALL'ECLITTICA. AD ESEMPIO: TERRA => 23.5 DEG
%SE ASSUMIAMO DI LAVORARE SUL PIANO DELL'ECLITTICA, DEVO TENERE IN
%CONSIDERAZIONE IL FATTO SOPRA. LE TRAIETTORIE DI CATTURA SARANNO DUNQUE
%INCLINATE DI UN ANGOLO PARI A incl_body, MISURATO RISPETTO ALL'ECLITTICA

%% Definizione Input
    rad = pi/180;
    global incl_body pl_mu radii
    incl = incl_body(body_id);
    mu_p = pl_mu(body_id);
    R = radii(body_id);
    %matrice di rotazione: viene utilizzata non come cambio di coordinate 
    %ma per mappare una rotazione rigida 
    R_x = [1 0 0; 0 cos(incl*rad) -sin(incl*rad); 0 sin(incl*rad) cos(incl*rad)];
    
    %% Ramo di ingresso
    v_hyp = sqrt(v_inf^2 + 2*mu_p / r_p);
    r0 = (R_x*[r_p, 0, 0]')';
    v0 = (R_x*[0, v_hyp, 0]')'; %velocità al periasse
    
    %Integro utilizzando rates
    hours = 3600;
    t0 = 0;
    tf = 1*hours;
    y0 = [r0, v0]';
    [t,y] = rkf45(@rates, [t0 tf], y0);
    
    %TRICK:per plottare inverto gli elementi di y  
    len = size(y,1);
    for i = 1 : len/2
        tmp = y(i, :);
        y(i, :) = y(len + 1 - i, :);
        y(len + 1 - i, :) = tmp;
    end
    first_orbit = y;
    
    %% Ramo di uscita
    r0_new = r0; 
    v0_new = (R_x*[0, -v_hyp, 0]')';
    
    %Integro utilizzando rates
    t0 = 0;
    tf = 1*hours;
    y0 = [r0_new v0_new]';
    [t_new ,y_new] = rkf45(@rates, [t0 tf], y0);
    
    t = [t; t_new];
    y = [first_orbit; y_new];
      
    % Output the results
    output
    
return
  
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

ax   = -mu_p*x/r^3;
ay   = -mu_p*y/r^3;
az   = -mu_p*z/r^3;

dydt = [vx vy vz ax ay az]';  

end %rates
 
 
% ~~~~~~~~~~~~~
function output
% ~~~~~~~~~~~~~
%{
  This function computes the maximu_pm and minimu_pm radii, the times they
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
 
fig = figure();
hold on
fig = gca;
fig.Color = [0, 0.1686, 0.4196];
fig.GridColor = [0.9020, 0.9020, 0.9020];
obj_pos = [0, 0, 0];
body_sphere(body_id, obj_pos);
grid on
grid minor

 
%   Draw and label the X, Y and Z axes
line([0 2*R/1.5],   [0 0],   [0 0]); text(2*R/1.5,   0,   0, 'X')
line(  [0 0], [0 2*R/1.5],   [0 0]); text(  0, 2*R/1.5,   0, 'Y')
line(  [0 0],   [0 0], [0 2*R/1.5]); text(  0,   0, 2*R/1.5, 'Z')
  
%   Specify some properties of the graph
axis equal
xlabel('km')
%xlim([-6e5, 6e5])
ylabel('km')
zlabel('km')
view( [-23 , 26] )
h = animatedline('Color', [1, 0.93333, 0]);

pause();
for k = 1:size(y,1)
    
    %INEFFICIENTE
    %     if(k ~= 1)
    %         delete(sonda)
    %     end
    
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
    drawnow limitrate 
    pause(0.03)
end
end %output
 
end %flyby_plot
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~