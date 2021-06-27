clc;
%% Input initialization
global radii color
R = radii(11);

begin_date = datetime(2024, 10, 30);
[t_attesa, t_manovra, ~] =  hohmann_phasing(3, 5, begin_date);

number_of_days = t_manovra;

begin_date = begin_date + t_attesa;
end_date = begin_date + number_of_days;

time_vector = generate_time(begin_date, end_date); 

[~, ~, target_vel, ~] = body_elements_and_sv(3, time_vector(1, 1),...
                                                  time_vector(1, 2),...
                                                  time_vector(1, 3), 0, 0, 0);

[normalized_dv, ~] =  hohmann_transfer(3, 5);
dv_hohmann = normalized_dv * norm(target_vel);

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

%k = 0.2952; %normalized_dv_1 !! 
%v0 = (k+1)*planet_dep(4:6); %stesso problema descritto all'inizio

 for days = 1:1:number_of_days
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
j_posz(:) = 0;

%% Graphical setup
close all
axis equal
grid on
hold on
%Decommentare se si vuole vedere l'orientazione degli assi
line([0 2*25*R],   [0 0],   [0 0]); text(2*25*R,   0,   0, 'X')
line(  [0 0], [0 2*25*R],   [0 0]); text(  0, 2*25*R,   0, 'Y')
line(  [0 0],   [0 0], [0 2*25*R]); text(  0,   0, 2*25*R, 'Z')

view(43, 30);
fig = gca;
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];
sun_pos = [0, 0, 0]; %origine sdr eliocentrico
body_sphere(11, sun_pos);

%% Animation
h1 = animatedline('Color', color(5));
h2 = animatedline('Color', 'b');
h3 = animatedline('Color', '#D95319');

%NOTA: se i limiti non vengono settati in anticipo, la velocità
%dell'animazione è variabile in quanto deve aggiornare anche assi e grid!
xlim([-9e8, 3e8]);
ylim([-2e8, 7.5e8]);
zlim([-1e8, 1e8]);

pause();
for k = 1 : number_of_days
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
    
end   

close all
[dv2, ~] = capture_hyp(5, vf, end_date, 1, 8e4, 0.6);

fprintf('\n Delta_v analysis:\n Escape Delta_v = %g [km/s]', dv1)
fprintf('\n Capture Delta_v = %g [km/s]', dv2)
fprintf('\n Total Delta_v = %g [km/s]\n', dv1 + dv2)

fprintf('\n Time analysis:\n Time of Flight = %g days \n', number_of_days)

% end %hohmann_transfer_plot%
