begin_date = datetime(2031, 01, 01);
end_date = begin_date + 70;

global radii pl_mu incl_body mu distances
R = radii(5);
tf = caldays(between(begin_date, end_date, 'Days'))*24;
rad = pi/180;
mu_p = pl_mu(5);
mu = mu_p;
incl = incl_body(5);
R_x = [1 0 0; 0 cos(incl*rad) -sin(incl*rad); 0 sin(incl*rad) cos(incl*rad)];
r_p = 80000 + radii(5);
e_park = 0.6;
v_p_park = sqrt(mu_p * (1 + e_park) / r_p);

r0 = (R_x * [-r_p, 0, 0]')';
v0 = (R_x * [0, -v_p_park, 0]')';
% step integrazione: 1 minuto
[probe_pos, probe_vel] = gen_jupiter_park_orbit( r0, v0, tf);
io_pos = gen_io_traj(begin_date, end_date);

theta_H = pi * ( 1 - sqrt( ((1 + r_p / distances(10))/2)^3 ) );
[europe_pos, europe_vel] = gen_europe_traj(begin_date, end_date);

% Parametri orbita di parcheggio
a = r_p / (1 - e_park); %semiasse maggiore [km]
T_s = 2 * pi * sqrt(a^3 / mu_p); %periodo [s] (circa un giorno e mezzo)
r_a = r_p * (1 + e_park) / (1 - e_park); %raggio all'apoasse

T_s = ceil(T_s / 60); %minuti

delta_t = 1*24*60; %minuti
DV = [];
DV_TOT = [];
dvmin = 6.3;
t_per_sonda = 0;

%%
for dt = 1 : T_s : 45*T_s
    r1 = probe_pos(dt, :);
    v_sonda = probe_vel(dt, :);
    r1(3) = 0;
    v_sonda(3) = 0;
    for delta_t_lam = 0.5 * delta_t : 0.1 * delta_t : 1.5 * delta_t
        r2 = europe_pos(dt + delta_t_lam, :);
        v_eur = europe_vel(dt + delta_t_lam, :);
        v_eur(3) = 0;
        r2(3) = 0;
        [v1, v2] = lambert(r1, r2, delta_t_lam*60);
        dv1 = norm(v1 - v_sonda);
        dv2 = norm(v2 - v_eur);
        %dvtot = dv1 + dv2;
        dvtot = dv1;
        if(dvtot <= dvmin)
            dvmin = dvtot;
            t_manovra = delta_t_lam; %minuti
            t_per_sonda = dt;
            v0_jup_to_eur = v1;
            v2_in_eur = v2;
        end
    end
end

r0_jup_to_eur = probe_pos(t_per_sonda, :);
[jup_to_eur_traj,] = gen_jupiter_park_orbit(r0_jup_to_eur, v0_jup_to_eur, ...
                                         t_manovra/60);
%%    
hold on	
axis equal;
grid on;
view(74, 21);
fig = gca;
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];

jup_pos = [0, 0, 0]; %origine sdr zeuscentrico
body_sphere(5, jup_pos);

%X-axis
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

% Animation
h1 = animatedline('Color', '#A2142F');
h2 = animatedline('Color', 'yellow');
h3 = animatedline('Color', '[0.0745    0.6235    1.0000]'); 
len = size(europe_pos(:, 1));

pause()
for k = 1 : t_per_sonda + t_manovra
    if (k == 1)
        europe = plot3(europe_pos(k, 1), europe_pos(k, 2), europe_pos(k, 3),...
                'o','Color','#A2142F', 'MarkerSize', 6,...
                'MarkerFaceColor','#A2142F');
        io = plot3(io_pos(k, 1), io_pos(k, 2), io_pos(k, 3),...
                'o','Color','yellow', 'MarkerSize', 6,...
                'MarkerFaceColor','yellow');
        probe = plot3(probe_pos(k, 1), probe_pos(k, 2), probe_pos(k, 3),...
                'o','Color','[0.0745    0.6235    1.0000]', 'MarkerSize', 3,...
                'MarkerFaceColor','[0.0745    0.6235    1.0000]');
    elseif(k <= t_per_sonda)
        europe.XData = europe_pos(k, 1);
        europe.YData = europe_pos(k, 2);
        europe.ZData = europe_pos(k, 3);
        
        io.XData = io_pos(k, 1);
        io.YData = io_pos(k, 2);
        io.ZData = io_pos(k, 3);
        
        probe.XData = probe_pos(k, 1);
        probe.YData = probe_pos(k, 2);
        probe.ZData = probe_pos(k, 3);
    else
        europe.XData = europe_pos(k, 1);
        europe.YData = europe_pos(k, 2);
        europe.ZData = europe_pos(k, 3);
        
        io.XData = io_pos(k, 1);
        io.YData = io_pos(k, 2);
        io.ZData = io_pos(k, 3);
        
        probe.XData = jup_to_eur_traj(k - t_per_sonda, 1);
        probe.YData = jup_to_eur_traj(k - t_per_sonda, 2);
        probe.ZData = jup_to_eur_traj(k - t_per_sonda, 3);
    end
    addpoints(h1, europe_pos(k, 1), europe_pos(k, 2), europe_pos(k, 3));
    addpoints(h2, io_pos(k, 1), io_pos(k, 2), io_pos(k, 3));
    if(k <= t_per_sonda)
        addpoints(h3, probe_pos(k, 1), probe_pos(k, 2), probe_pos(k, 3));
    else
        addpoints(h3, jup_to_eur_traj(k - t_per_sonda, 1), jup_to_eur_traj(k - t_per_sonda, 2), jup_to_eur_traj(k - t_per_sonda, 3));
    end
    drawnow limitrate
    pause(0.0001)

end

%[dv2, ~] = capture_hyp(10, v2_in_eur, begin_date, 1, 100, 0, europe_vel(t_per_sonda + t_manovra, :));

