clc; close all;

%% Input initialization
initializeEJE

%Data di partenza
begin_date_1 = datetime(2024, 10, 16);
y0 = year(begin_date_1);
m0 = month(begin_date_1);
d0 = day(begin_date_1);

%Flyby su Marte
end_date_1 = datetime(2025, 03, 03);
begin_date_2 = end_date_1;
y1 = year(begin_date_2);
m1 = month(begin_date_2);
d1 = day(begin_date_2);

%Flyby su Terra
end_date_2 = datetime(2026, 12, 07);
begin_date_3 = end_date_2;
y2 = year(begin_date_3);
m2 = month(begin_date_3);
d2 = day(begin_date_3);

%%Arrivo su Giove
end_date_3 = datetime(2030, 04, 11);
y3 = year(end_date_3);
m3 = month(end_date_3);
d3 = day(end_date_3);


%% Escape Hyperbola and To Mars
[~, r_earth1, ~] = body_elements_and_sv(3, y0, m0, d0, 0, 0, 0);
[~, r_mars1, V_mars1 , ~] = body_elements_and_sv(4, y1, m1, d1, 0, 0, 0);

T_a = between (begin_date_1, begin_date_2, 'Days');                 %[days]
t_a = (caldays(T_a)) * 24 * 3600;                                   %[sec]
[V1, V2_a] = lambert(r_earth1, r_mars1, t_a);


%generate trajectory to mars
[e_pos_1, m_pos_1, j_pos_1, s_pos_1, nod_1] = ...
    gen_patched_conic_orbit(begin_date_1, end_date_1, 3, 4);


%% Back To Earth
[~, r_earth2, V_earth2, ~] = body_elements_and_sv(3, y2, m2, d2, 0, 0, 0);
T_b = between (begin_date_2, end_date_2, 'Days');                   %[days]
t_b = (caldays(T_b)) * 24 * 3600;                                   %[sec]
[V2_b, V3_a] = lambert(r_mars1, r_earth2, t_b);

%generate trajectory (back) to earth
[e_pos_2, m_pos_2, j_pos_2, s_pos_2, nod_2] = ... 
    gen_patched_conic_orbit(begin_date_2, end_date_2, 4, 3);


%% To Jupiter
[~, r_jupiter1, ~] = body_elements_and_sv(5, y3, m3, d3, 0, 0, 0);
T_c = between (begin_date_3, end_date_3, 'Days');                   %[days]
t_c = (caldays(T_c)) * 24 * 3600;                                   %[sec]
[V3_b, V4] = lambert(r_earth2, r_jupiter1, t_c);

%generate trajectory to jupiter
[e_pos_3, m_pos_3, j_pos_3, s_pos_3, nod_3] = ...
    gen_patched_conic_orbit(begin_date_3, end_date_3, 3, 5);


%% Heliocentric Trajectory Generation
e_posx = [e_pos_1(:,1); e_pos_2(:,1); e_pos_3(:,1)];
e_posy = [e_pos_1(:,2); e_pos_2(:,2); e_pos_3(:,2)];
e_posz = [e_pos_1(:,3); e_pos_2(:,3); e_pos_3(:,3)];

m_posx = [m_pos_1(:,1); m_pos_2(:,1); m_pos_3(:,1)];
m_posy = [m_pos_1(:,2); m_pos_2(:,2); m_pos_3(:,2)];
m_posz = [m_pos_1(:,3); m_pos_2(:,3); m_pos_3(:,3)];

j_posx = [j_pos_1(:,1); j_pos_2(:,1); j_pos_3(:,1)];
j_posy = [j_pos_1(:,2); j_pos_2(:,2); j_pos_3(:,2)];
j_posz = [j_pos_1(:,3); j_pos_2(:,3); j_pos_3(:,3)];
 
s_posx = [s_pos_1(:,1); s_pos_2(:,1); s_pos_3(:,1)];
s_posy = [s_pos_1(:,2); s_pos_2(:,2); s_pos_3(:,2)];
s_posz = [s_pos_1(:,3); s_pos_2(:,3); s_pos_3(:,3)];


%% Plot escape hyperbola
[delta_v1, ~] = escape_hyp (3, V1, 200, begin_date_1, 1);
pause();
esc_plot = gcf;
close(esc_plot);
fprintf('\n/*-----------------------------------------------*/')
fprintf('\nDeparture Date from Earth: %s\n', datestr(begin_date_1))
fprintf('\nDelta_V required for escape hyperbola is: %g [km/s]\n', delta_v1)

%% Graphical Setup for heliocentric phase     
global radii color
R = radii(11);
fig = figure();
fig.WindowState = 'maximized';
hold on	
axis equal;
grid on;

%NOTA: se i limiti non vengono settati in anticipo, la velocità
%dell'animazione è variabile in quanto deve aggiornare anche assi e grid!

view(74, 21);
fig = gca;
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];

sun_pos = [0, 0, 0]; %origine sdr eliocentrico
body_sphere(11, sun_pos);

% X-axis
xlim([-4.5e8, 1.5e8]);
%line([0 2*50*R],   [0 0],   [0 0], 'Color', 'white'); 
%text(2*R*50,   0,   0, 'X', 'Color', 'white', 'FontSize', 6)

%Y-axis
ylim([-4e8, 4e8]);
%line(  [0 0], [0 2*50*R],   [0 0], 'Color', 'white');
%text(  0, 2*R*50,   0, 'Y', 'Color', 'white', 'FontSize', 6)

%Z-axis
zlim([-1e8, 1e8]);
%line(  [0 0],   [0 0], [0 2*50*R], 'Color', 'white');
%text(  0,   0, 2*R*50, 'Z', 'Color', 'white', 'FontSize', 6)
number_of_days = nod_1 + nod_2 + nod_3;
h1 = animatedline('Color', 'r');
h2 = animatedline('Color', 'b');
h3 = animatedline('Color', [1, 0.93333, 0]);
h4 = animatedline('Color', 'White');

%% Plot heliocentric trajectories
pause();
for k = 1 : number_of_days
    if(k == 1)
        probe = plot3(s_posx(k), s_posy(k), s_posz(k),...
						'o','Color','#D95319', 'MarkerSize', 4,...
						'MarkerFaceColor','#D95319');
                    
        earth = plot3(e_posx(k), e_posy(k), e_posz(k),...
						'o','Color',color(3), 'MarkerSize', 8,...
						'MarkerFaceColor',color(3));
                    
        mars  =	plot3(m_posx(k), m_posy(k), m_posz(k),...
						'o','Color',color(4), 'MarkerSize', 6,...
						'MarkerFaceColor',color(4));
                    
        jupiter = plot3(j_posx(k), j_posy(k), j_posz(k),...
						'o','Color',color(5), 'MarkerSize', 15,...
						'MarkerFaceColor',color(5));
        
    else
        probe.XData = s_posx(k);
        probe.YData = s_posy(k);
        probe.ZData = s_posz(k);
        
        earth.XData = e_posx(k);
        earth.YData = e_posy(k);
        earth.ZData = e_posz(k);
        
        mars.XData = m_posx(k);
        mars.YData = m_posy(k);
        mars.ZData = m_posz(k);
        
        jupiter.XData = j_posx(k);
        jupiter.YData = j_posy(k);
        jupiter.ZData = j_posz(k);
        
        
    end
    
    if(k ==  nod_1)
        [dv_fb1, delta_vinf_1, ~] = flyby ( 4, V2_a, V_mars1, V2_b, 1);
        fprintf('\n/*-----------------------------------------------*/')
        fprintf('\n First flyby => leading side: \n') 
        fprintf(' Heliocentric velocity pre Flyby is: %g [km/s]\n', norm(V2_a))
        fprintf(' Heliocentric velocity post Flyby is: %g [km/s]', norm(V2_b))
        pause();
        mars_flyby = gcf;
        close(mars_flyby);
    end
    if(k == nod_1 + nod_2)
        [dv_fb2, delta_vinf_2, ~] = flyby (3, V3_a, V_earth2, V3_b, 1);
        fprintf('\n\n/*-----------------------------------------------*/')
        fprintf('\n Second flyby => trailing side: \n')
        fprintf(' Heliocentric velocity pre Flyby is: %g [km/s]\n', norm(V3_a))
        fprintf(' Heliocentric velocity post Flyby is: %g [km/s]\n', norm(V3_b))
        pause();
        earth_flyby = gcf;
        close(earth_flyby);
    end
    
    addpoints(h1, m_posx(k), m_posy(k), m_posz(k));
    addpoints(h2, e_posx(k), e_posy(k), e_posz(k));
    addpoints(h3, s_posx(k), s_posy(k), s_posz(k));
    addpoints(h4, j_posx(k), j_posy(k), j_posz(k));
    drawnow limitrate
    %pause(0.01)
end

%% Plot capture hyperbola
pause();
%close all

[delta_v4, rp_jupiter] = capture_hyp(5, V4, end_date_3, 1, 8e4, 0.6);
pause();
cap_hyp = gcf;
close(cap_hyp);
fprintf('\n/*-----------------------------------------------*/')
fprintf('\nArrival Date on Jupiter: %s\n', datestr(end_date_3))
fprintf('\nDelta_V required for parking orbit is: %g [km/s]\n', delta_v4)
fprintf('\n/*-----------------------------------------------*/')
fprintf('\nTotal Delta_V for Earth-Jupiter transfer is: %g [km/s]\n', ...
        delta_v1 + delta_v4)
fprintf('\n/*-----------------------------------------------*/')
fprintf('\nTime of Flight for Earth-Jupiter transfer is: %g [days]\n', number_of_days)    

%% Europa Transfer
europa_transfer_plot;


%end %entire_mission_plot%