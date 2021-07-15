clc; close all;

%% Input initialization
initializeEJE;

global radii color distances
R = radii(11);

begin_date = datetime(2024, 10, 16);
[t_attesa, t_manovra, ~] =  hohmann_phasing(3, 5, begin_date);

number_of_days_h = t_manovra;

begin_date = begin_date + t_attesa;
end_date = begin_date + number_of_days_h;

time_vector = generate_time(begin_date, end_date); 

[~, ~, target_vel, ~] = body_elements_and_sv(3, time_vector(1, 1),...
                                                  time_vector(1, 2),...
                                                  time_vector(1, 3), 0, 0, 0);

[normalized_dv, ~] =  hohmann_transfer(3, 5);
%Valore teorico calcolato con le relative approssimazioni
dv_hohmann = normalized_dv * sqrt(mu / distances(3));

%% Trajectories generation
e_posx = []; j_posx = []; s_posx = [];
e_posy = []; j_posy = []; s_posy = [];
e_posz = []; j_posz = []; s_posz = [];

%Genero i dati in ingresso a interplanetary
y_d = year(begin_date);
m_d = month(begin_date);
d_d = day(begin_date);

y_a = year(end_date);
m_a = month(end_date);
d_a = day(end_date);

depart = [3, y_d, m_d, d_d, 0, 0, 0];
arrive = [5, y_a, m_a, d_a, 0, 0, 0];

%Genero la traiettoria della sonda
[planet_dep, planet_arr, traj, tof] = interplanetary(depart, arrive, 1);
r0 = planet_dep(1:3);
v0 = traj(1:3);
vf = traj(4:6);

[dv1, ~] = escape_hyp(3, v0, 200, begin_date, 1);
pause();
esc_plot = gcf;
close(esc_plot);

 for days = 1 : 1 :number_of_days_h
    [~, e_pos, ~,~] = body_elements_and_sv(3, time_vector(days, 1),...
                                                  time_vector(days, 2),...
                                                  time_vector(days, 3), 0, 0, 0);
    e_posx = [e_posx; e_pos(1)];
    e_posy = [e_posy; e_pos(2)];
    e_posz = [e_posz; e_pos(3)];
    
   [~, j_pos, ~,~] = body_elements_and_sv(5, time_vector(days, 1),...
                                                  time_vector(days, 2),...
                                                  time_vector(days, 3), 0, 0, 0);
    j_posx = [j_posx; j_pos(1)];
    j_posy = [j_posy; j_pos(2)];
    j_posz = [j_posz; j_pos(3)];
    
    [s_pos, ~] = rv_from_r0v0(r0, v0, days*60*60*24); %calcolo la nuova posizione giornalmente
                                                      %coerentemente con gli
                                                      %altri pianeti
    s_posx = [s_posx; s_pos(1)];
    s_posy = [s_posy; s_pos(2)];
    s_posz = [s_posz; s_pos(3)];
    
 end
 
%La traiettoria di Hohmann è calcolata sul piano dell'eclittica:
%per rendere il plot coerente, Giove viene plottato anche'esso sul piano
%dell'eclittica
j_posz(:) = 0;

%% Graphical setup
fig = figure();
fig.WindowState = 'maximized';
hold on
axis equal
grid on
%Decommentare se si vuole vedere l'orientazione degli assi
% line([0 2*25*R],   [0 0],   [0 0]); text(2*25*R,   0,   0, 'X')
% line(  [0 0], [0 2*25*R],   [0 0]); text(  0, 2*25*R,   0, 'Y')
% line(  [0 0],   [0 0], [0 2*25*R]); text(  0,   0, 2*25*R, 'Z')

view(43, 30);
fig = gca;
title('Hohmann Heliocentric Phase');
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];
sun_pos = [0, 0, 0]; %origine sdr eliocentrico
body_sphere(11, sun_pos);

%% Animation
h2 = animatedline('Color', 'b', 'DisplayName', 'Earth');
h3 = animatedline('Color', '[1, 0.93333, 0]', 'DisplayName', 'Probe');
h1 = animatedline('Color', 'White', 'DisplayName', 'Jupiter');
legend([h1, h2, h3], 'TextColor', 'white', 'AutoUpdate', 'off');

%NOTA: se i limiti non vengono settati in anticipo, la velocità
%dell'animazione è variabile in quanto deve aggiornare anche assi e grid!
xlim([-9e8, 3e8]);
ylim([-2e8, 7.5e8]);
zlim([-1e8, 1e8]);

pause();
for k = 1 : number_of_days_h
    if(k == 1)
    probe = plot3(s_posx(k), s_posy(k), s_posz(k),...
                    'o','Color','#D95319', 'MarkerSize', 2,...
                    'MarkerFaceColor','#D95319');

    earth = plot3(e_posx(k), e_posy(k), e_posz(k),...
                    'o','Color',color(3), 'MarkerSize', 4,...
                    'MarkerFaceColor',color(3));

    jupiter = plot3(j_posx(k), j_posy(k), j_posz(k),...
                    'o','Color',color(5), 'MarkerSize', 7,...
                    'MarkerFaceColor',color(5));     
    else
        probe.XData = s_posx(k);
        probe.YData = s_posy(k);
        probe.ZData = s_posz(k);
        
        earth.XData = e_posx(k);
        earth.YData = e_posy(k);
        earth.ZData = e_posz(k);
        
        jupiter.XData = j_posx(k);
        jupiter.YData = j_posy(k);
        jupiter.ZData = j_posz(k);
        
    end
    
    addpoints(h1, j_posx(k), j_posy(k), j_posz(k));
    addpoints(h2, e_posx(k), e_posy(k), e_posz(k));
    addpoints(h3, s_posx(k), s_posy(k), s_posz(k));
    drawnow limitrate
    pause(0.01)
    
end   
pause();
close all;

[dv2, ~] = capture_hyp(5, vf, end_date, 1, 8e4, 0.6);
pause();
cap_plot = gcf;
close(cap_plot);

%Mission info print
fprintf('\n/*-----------------------------------------------*/')
fprintf('\n Departure Date from Earth: %s\n', datestr(begin_date))
fprintf('\n Arrival Date on Jupiter: %s', datestr(end_date))
fprintf('\n/*-----------------------------------------------*/')
fprintf('\n Delta_V analysis:\n Escape Delta_v = %g [km/s]', dv1)
fprintf('\n Capture Delta_V = %g [km/s]', dv2)
fprintf('\n Total Delta_V = %g [km/s]\n', dv1 + dv2)
fprintf('\n Delta_V from theory = %g [km/s]', dv_hohmann) 
fprintf('\n/*-----------------------------------------------*/')
fprintf('\n Time analysis:\n Time of Flight for Hohmann = %g days \n', number_of_days_h)

% end %hohmann_transfer_plot%
