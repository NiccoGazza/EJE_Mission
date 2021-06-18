%primo script di prova: voglio plottare l'orbita con relativo movimento 
%della Terra, aggiornato giornalmente
clc;
%% Inizializzazione
global radii
R = radii(11);

number_of_days = 365;
body_linewidth = 1;

begin_date = datetime(2021, 04, 28);
end_date = begin_date + number_of_days;

time_vector = generate_time(begin_date, end_date); 

%% Setup Grafica
hold on	
axis equal;
grid on;

%NOTA: se i limiti non vengono settati in anticipo, la velocità
%dell'animazione è variabile in quanto deve aggiornare anche assi e grid!
xlim([-2e8, 2e8]);
ylim([-2e8, 2e8]);
zlim([-1e8, 1e8]);

view(45, 35);
fig = gca;
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];

%% Generazione traiettorie
e_posx = []; m_posx = []; s_posx = [];
e_posy = []; m_posy = []; s_posy = [];
e_posz = []; m_posz = []; s_posz = [];

%Genero i dati in ingresso a interplanetary
y_d = year(begin_date);
m_d = month(begin_date);
d_d = day(begin_date);

y_a = year(end_date);
m_a = month(end_date);
d_a = day(end_date);

depart = [3, y_d, m_d, d_d, 0, 0, 0];
arrive = [4, y_a, m_a, d_a, 0, 0, 0];

%Genero la traiettoria della sonda
[planet_dep, planet_arr, traj, tof] = interplanetary(depart, arrive);
r0 = planet_dep(1:3);
v0 = traj(1:3);

 for days = 1:1:number_of_days
    [~, target_pos, ~,~] = body_elements_and_sv(3, time_vector(days, 1),...
                                                  time_vector(days, 2),...
                                                  time_vector(days, 3), 0, 0, 0);
    e_posx = [e_posx; target_pos(1)];
    e_posy = [e_posy; target_pos(2)];
    e_posz = [e_posz; target_pos(3)];
    
   [~, m_target_pos, ~,~] = body_elements_and_sv(4, time_vector(days, 1),...
                                                  time_vector(days, 2),...
                                                  time_vector(days, 3), 0, 0, 0);
    m_posx = [m_posx; m_target_pos(1)];
    m_posy = [m_posy; m_target_pos(2)];
    m_posz = [m_posz; m_target_pos(3)];
    
    [s_pos, ~] = rv_from_r0v0(r0, v0, days*60*60*24); %calcolo la nuova posizione giornalmente
                                                      %coerentemente con gli
                                                      %altri pianeti
    s_posx = [s_posx; s_pos(1)];
    s_posy = [s_posy; s_pos(2)];
    s_posz = [s_posz; s_pos(3)];
    
 end

h1 = animatedline('Color', 'r');
h2 = animatedline('Color', 'b');
h3 = animatedline('Color', [1, 0.93333, 0]);

% [xx, yy, zz] = sphere(50);
% surf(R*50*xx, R*50*yy, R*50*zz);
sun_pos = [0, 0, 0]; %origine sdr eliocentrico
body_sphere(11, sun_pos);

line([0 2*50*R],   [0 0],   [0 0]); text(2*50*R,   0,   0, 'X')
line(  [0 0], [0 2*50*R],   [0 0]); text(  0, 2*50*R,   0, 'Y')
line(  [0 0],   [0 0], [0 2*50*R]); text(  0,   0, 2*50*R, 'Z')

%scalo i valori per migliorare il rendering del plot
e_posx = e_posx/2; e_posy = e_posy/2; e_posz = e_posz/2;
m_posx = m_posx/2; m_posy = m_posy/2; m_posz = m_posz/2;
s_posx = s_posx/2; s_posy = s_posy/2; s_posz = s_posz/2;

for k = 1:number_of_days
    addpoints(h1, m_posx(k), m_posy(k), m_posz(k));
    addpoints(h2, e_posx(k), e_posy(k), e_posz(k));
    addpoints(h3, s_posx(k), s_posy(k), s_posz(k));
    drawnow 
end
