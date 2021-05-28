%primo script di prova: voglio plottare l'orbita con relativo movimento 
%della Terra, aggiornato giornalmente
clc;
clear all;
addpath(genpath("M_files_Curtis"));

global mu R
mu = 1.327124e11;
R = 6.96e5;  %raggio del Sole: provo a inserirlo nel plot

number_of_days = 200;
target = 3; %Earth_id
k = 1;
movie_fps = 20;
body_linewidth = 1;

begin_date = datetime(2021, 04, 28);
end_date = begin_date + number_of_days;

time_vector = generate_time(begin_date, end_date); 


hold on
	
axis equal;
grid on;
view(45, 35);

% xlim([-xy_lim, xy_lim]);
% ylim([-xy_lim, xy_lim]);
% zlim([-z_lim, z_lim]);
	
% 	if spinlon == 0 && spinlat == 0
% 		if d == 1
% 			view(View(1, 1), View(1, 2));
% 		end
% 	else
% 		view(View(1, 1) + spinlon * d/n_days, View(1, 2) + spinlat* d/n_days);
% 	end
% 	xlabel('X [km]');
% 	ylabel('Y [km]');
% 	zlabel('Z [km]');
%plot_orbit(target, time_vector(1,1), linewidth); 
%plot_orbit(5, time_vector(1,1), linewidth); %Jupiter
%plot_orbit(4, time_vector(1,1), linewidth); %Venus
 
 e_posx = []; m_posx = [];
 e_posy = []; m_posy = [];
 e_posz = []; m_posz = [];

 for day = 1:1:number_of_days
    [~, target_pos, ~,~] = body_elements_and_sv(target, time_vector(day, 1),...
                                                  time_vector(day, 2),...
                                                  time_vector(day, 3), 0, 0, 0);
    e_posx = [e_posx; target_pos(1)];
    e_posy = [e_posy; target_pos(2)];
    e_posz = [e_posz; target_pos(3)];
    
   [~, m_target_pos, ~,~] = body_elements_and_sv(4, time_vector(day, 1),...
                                                  time_vector(day, 2),...
                                                  time_vector(day, 3), 0, 0, 0);
    m_posx = [m_posx; m_target_pos(1)];
    m_posy = [m_posy; m_target_pos(2)];
    m_posz = [m_posz; m_target_pos(3)];
          
 end

%  comet3(e_posx, e_posy, e_posz, 0);
%  comet3(m_posx, m_posy, m_posz, 0);
h1 = animatedline('Color', 'r');
h2 = animatedline('Color', 'b');

[xx, yy, zz] = sphere(50);
surf(R*50*xx, R*50*yy, R*50*zz);
line([0 2*50*R],   [0 0],   [0 0]); text(2*50*R,   0,   0, 'X')
line(  [0 0], [0 2*50*R],   [0 0]); text(  0, 2*50*R,   0, 'Y')
line(  [0 0],   [0 0], [0 2*50*R]); text(  0,   0, 2*50*R, 'Z')

for k = 1:number_of_days
    addpoints(h1, m_posx(k), m_posy(k), m_posz(k));
    addpoints(h2, e_posx(k), e_posy(k), e_posz(k));
    drawnow 
end