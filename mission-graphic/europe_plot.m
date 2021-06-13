% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function europe_plot
% ~~~~~~~~~~~~
%{
  This function computes the orbit of a spacecraft by using rkf45 to 
  numerically integrate Equation 2.22.
 
  It also plots the orbit and computes the times at which the maximum
  and minimum radii occur and the speeds at those times.
 
  hours     - converts hours to seconds
  G         - universal gravitational constant (km^3/kg/s^2)
  m1        - planet mass (kg)
  m2        - spacecraft mass (kg)
  mu        - gravitational parameter (km^3/s^2)
  R         - planet radius (km)
  r0        - initial position vector (km)
  v0        - initial velocity vector (km/s)
  t0,tf     - initial and final times (s)
  y0        - column vector containing r0 and v0
  t         - column vector of the times at which the solution is found
  y         - a matrix whose columns are:
                 columns 1, 2 and 3:
                    The solution for the x, y and z components of the 
                    position vector r at the times in t
                 columns 4, 5 and 6:
                    The solution for the x, y and z components of the 
                    velocity vector v at the times in t
  r         - magnitude of the position vector at the times in t
  imax      - component of r with the largest value
  rmax      - largest value of r
  imin      - component of r with the smallest value
  rmin      - smallest value of r
  v_at_rmax - speed where r = rmax
  v_at_rmin - speed where r = rmin
  
  User M-function required:   rkf45
  User subfunctions required: rates, output
%}
% -------------------------------------------------------------------
 
clc; close all; 
global masses radii

hours = 3600;
G     = 6.6742e-20;
 
%...Input data:
%   Earth:
m1 = masses(5);
R  = radii(5);
m2 = masses(10);
 
[~, r0, v0, ~] = body_elements_and_sv(10, 2030, 01, 01, 0, 0, 0);
 
t0 = 0;
tf = 85*hours;
%...End input data
 
 
%...Numerical integration:
mu    = G*(m1 + m2);
y0    = [r0 v0]';
[t,y] = rkf45(@rates, [t0 tf], y0);
 
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
 
[rmax imax] = max(r);
[rmin imin] = min(r);
 
v_at_rmax   = norm([y(imax,4) y(imax,5) y(imax,6)]);
v_at_rmin   = norm([y(imin,4) y(imin,5) y(imin,6)]);
  
%...Plot the results:
%   Draw the planet
[xx, yy, zz] = sphere(100);
surf(R*xx, R*yy, R*zz)
colormap(light_gray)
caxis([-R/100 R/100])
shading interp
 
%   Draw and label the X, Y and Z axes
line([0 2*R],   [0 0],   [0 0]); text(2*R,   0,   0, 'X')
line(  [0 0], [0 2*R],   [0 0]); text(  0, 2*R,   0, 'Y')
line(  [0 0],   [0 0], [0 2*R]); text(  0,   0, 2*R, 'Z')
  
%   Select a view direction (a vector directed outward from the origin) 
view( [15 , 9] )
 
%   Specify some properties of the graph
grid on
axis equal
hold on
% xlim([-0.7e4, 0.7e4])
% ylim([-2e4, 2e4])
xlabel('km')
ylabel('km')
zlabel('km')

h = animatedline('Color', 'b');

for k = 1:size(y,1)
    if(k ~= 1)
        delete(europe)
    end
    europe = plot3(y(k,1),y(k,2), y(k,3),...
						'o','Color','#A2142F', 'MarkerSize', 10,...
						'MarkerFaceColor','#A2142F');    
    addpoints(h, y(k,1), y(k,2), y(k,3));
    drawnow limitrate 
    pause(0.03)
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
 
end %orbit
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~