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

depart = [3, y0, m0, d0, 0, 0, 0];
arrive = [4, y1, m1, d1, 0, 0, 0];

%Genero la traiettoria della sonda
[planet_dep, ~, traj, ~] = interplanetary(depart, arrive, 0);
r0 = planet_dep(1:3);
v0 = traj(1:3);

first_orbit = [];
for days = 1 : 1 : nod_1 + 700
   [s, ~] = rv_from_r0v0(r0, v0, days*60*60*24); 
   first_orbit = [first_orbit; s];
end
 
fig = figure();
fig.WindowState = 'maximized';
hold on	
axis equal;
grid on;
view(74, 21);
fig = gca;
title('Heliocentric Phase');
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];
sun_pos = [0, 0, 0]; %origine sdr eliocentrico
body_sphere(11, sun_pos);
        
%% Back To Earth
[~, r_earth2, V_earth2, ~] = body_elements_and_sv(3, y2, m2, d2, 0, 0, 0);
T_b = between (begin_date_2, end_date_2, 'Days');                   %[days]
t_b = (caldays(T_b)) * 24 * 3600;                                   %[sec]
[V2_b, V3_a] = lambert(r_mars1, r_earth2, t_b);

%generate trajectory (back) to earth
[e_pos_2, m_pos_2, j_pos_2, s_pos_2, nod_2] = ... 
    gen_patched_conic_orbit(begin_date_2, end_date_2, 4, 3);

%Genero la traiettoria della sonda
depart = [4, y1, m1, d1, 0, 0, 0];
arrive = [3, y2, m2, d2, 0, 0, 0];

[planet_dep, ~, traj, ~] = interplanetary(depart, arrive, 0);
r0 = planet_dep(1:3);
v0 = traj(1:3);

second_orbit = [];
for days = 1 : 1 : nod_1 + nod_2 + 1000
   [l, ~] = rv_from_r0v0(r0, v0, days*60*60*24); 
   second_orbit = [second_orbit; l];
end

%% To Jupiter
[~, r_jupiter1, ~] = body_elements_and_sv(5, y3, m3, d3, 0, 0, 0);
T_c = between (begin_date_3, end_date_3, 'Days');                   %[days]
t_c = (caldays(T_c)) * 24 * 3600;                                   %[sec]
[V3_b, V4] = lambert(r_earth2, r_jupiter1, t_c);

%generate trajectory to jupiter
[e_pos_3, m_pos_3, j_pos_3, s_pos_3, nod_3] = ...
    gen_patched_conic_orbit(begin_date_3, end_date_3, 3, 5);


%% Heliocentric Trajectory Generation

s_posx = [s_pos_1(:,1); s_pos_2(:,1); s_pos_3(:,1)] * 2;
s_posy = [s_pos_1(:,2); s_pos_2(:,2); s_pos_3(:,2)] * 2;
s_posz = [s_pos_1(:,3); s_pos_2(:,3); s_pos_3(:,3)] * 2;

plot3(first_orbit(:, 1), first_orbit(:, 2), first_orbit(:, 3), ...
        '--', 'Color', '[1 0 1]');
    
len = length(second_orbit);
plot3(second_orbit(:, 1), second_orbit(:, 2), second_orbit(:, 3), ...
        'r.', 'MarkerIndices', [1 : 20 : len]);
    
plot3(s_posx, s_posy, s_posz, 'Color', 'yellow');
    
% plot3(s_posx(1 : nod_1), s_posy(1 : nod_1), s_posz(1 : nod_1), ...
%         'Color', '[1 0 1]');
% plot3(s_posx(nod_1 : nod_1 + nod_2), s_posy(nod_1 : nod_1 + nod_2), ...
%       s_posz(nod_1 : nod_1 + nod_2), 'Color', 'yellow');
% nod = nod_1 + nod_2;
% plot3(s_posx(nod : end), s_posy(nod : end), s_posz(nod : end), ...
%         'Color', 'r');