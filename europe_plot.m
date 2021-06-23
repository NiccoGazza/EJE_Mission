%% Graphical Setup
begin_date = datetime(2031, 01, 01);
end_date = begin_date + 12;

global radii pl_mu incl_body
R = radii(5);

hold on	
axis equal;
grid on;
view(74, 21);
fig = gca;
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];

jup_pos = [0, 0, 0]; %origine sdr zeuscentrico
body_sphere(5, jup_pos);

% X-axis
xlim([-7e5, 14e5]);
line([0 2.5*R],   [0 0],   [0 0], 'Color', 'white'); 
text(2.5*R,   0,   0, 'X', 'Color', 'white', 'FontSize', 6)

%Y-axis
ylim([-7.5e5, 7.5e5]);
line(  [0 0], [0 2.5*R],   [0 0], 'Color', 'white');
text(  0, 2.5*R,   0, 'Y', 'Color', 'white', 'FontSize', 6)

%Z-axis
%zlim([-1e8, 1e8]);
line(  [0 0],   [0 0], [0 2.5*R], 'Color', 'white');
text(  0,   0, 2.5*R, 'Z', 'Color', 'white', 'FontSize', 6)

%% Trajectory computation
tf = caldays(between(begin_date, end_date, 'Days')) * 24;
rad = pi/180;
mu_p = pl_mu(5);
incl = incl_body(5);
R_x = [1 0 0; 0 cos(incl*rad) -sin(incl*rad); 0 sin(incl*rad) cos(incl*rad)];
r_p = 80000 + radii(5);
e_park = 0.6;
v_p_park = sqrt(mu_p * (1 + e_park) / r_p);

r0 = (R_x * [-r_p, 0, 0]')';
v0 = (R_x * [0, -v_p_park, 0]')';


[probe_pos, probe_vel] = gen_jupiter_park_orbit( r0, v0, tf);
io_pos = gen_io_traj(begin_date, end_date);
europe_pos = gen_europe_traj(begin_date, end_date);

%% Animation
h1 = animatedline('Color', '#A2142F');
h2 = animatedline('Color', 'yellow');
h3 = animatedline('Color', '[0.0745    0.6235    1.0000]'); 
len = size(europe_pos(:, 1));

pause()
for k = 1 : len
    if (k == 1)
        europe = plot3(europe_pos(k, 1), europe_pos(k, 2), europe_pos(k, 3),...
                'o','Color','#A2142F', 'MarkerSize', 6,...
                'MarkerFaceColor','#A2142F');
        io = plot3(io_pos(k, 1), io_pos(k, 2), io_pos(k, 3),...
                'o','Color','yellow', 'MarkerSize', 6,...
                'MarkerFaceColor','yellow');
        probe = plot3(io_pos(k, 1), io_pos(k, 2), io_pos(k, 3),...
                'o','Color','[0.0745    0.6235    1.0000]', 'MarkerSize', 3,...
                'MarkerFaceColor','[0.0745    0.6235    1.0000]');
    else
        europe.XData = europe_pos(k, 1);
        europe.YData = europe_pos(k, 2);
        europe.ZData = europe_pos(k, 3);
        
        io.XData = io_pos(k, 1);
        io.YData = io_pos(k, 2);
        io.ZData = io_pos(k, 3);
        
        probe.XData = probe_pos(k, 1);
        probe.YData = probe_pos(k, 2);
        probe.ZData = probe_pos(k, 3);
    end
    addpoints(h1, europe_pos(k, 1), europe_pos(k, 2), europe_pos(k, 3));
    addpoints(h2, io_pos(k, 1), io_pos(k, 2), io_pos(k, 3));
    addpoints(h3, probe_pos(k, 1), probe_pos(k, 2), probe_pos(k, 3));
    drawnow  
end