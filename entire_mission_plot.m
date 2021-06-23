%% Input initialization
begin_date_1 = datetime(2024, 10, 30);
end_date_1 = datetime(2025, 03, 04);
begin_date_2 = end_date_1;
end_date_2 = datetime(2027, 11, 19);
begin_date_3 = end_date_2;
end_date_3 = datetime(2031, 01, 01);

%% To Mars 
[e_pos_1, m_pos_1, j_pos_1, s_pos_1, nod_1] = gen_patched_conic_orbit(begin_date_1, end_date_1, 3, 4);
%pause();

%% Back To Earth 
[e_pos_2, m_pos_2, j_pos_2, s_pos_2, nod_2] = gen_patched_conic_orbit(begin_date_2, end_date_2, 4, 3);
%pause();

%% To Jupiter
[e_pos_3, m_pos_3, j_pos_3, s_pos_3, nod_3] = gen_patched_conic_orbit(begin_date_3, end_date_3, 3, 5);

%% Graphical Setup      
global radii color
R = radii(11);
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


%% Animation
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


number_of_days = nod_1 + nod_2 + nod_3;
h1 = animatedline('Color', 'r');
h2 = animatedline('Color', 'b');
h3 = animatedline('Color', [1, 0.93333, 0]);
h4 = animatedline('Color', 'White');
pause();

for k = 1:number_of_days
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
    
    addpoints(h1, m_posx(k), m_posy(k), m_posz(k));
    addpoints(h2, e_posx(k), e_posy(k), e_posz(k));
    addpoints(h3, s_posx(k), s_posy(k), s_posz(k));
    addpoints(h4, j_posx(k), j_posy(k), j_posz(k));
    drawnow %limitrate
    %pause(0.01)
end





