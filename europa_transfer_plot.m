clc; close all;

%% Input Initialization
global radii

begin_date = datetime(2030, 04, 11); %Data di arrivo su Giove
end_date = begin_date + 5;
%Parametri scelti per l'orbita di parcheggio
r_p = 8e4 + radii(5);
e_park = 0.6;

[probe_pos, io_pos, europa_pos, t_dep, t_man, delta_v5, transfer_traj, ...
 v2_probe_eur, v2_eur] ... 
    = ...
    europa_phasing(begin_date, end_date, r_p, e_park); 


%% Graphical Setup 
fig = figure();
fig.WindowState = 'maximized';
hold on	
axis equal;
grid on;
view(74, 21);
fig = gca;
fig.Color = [0, 0, 0];
fig.GridColor = [0.9020, 0.9020, 0.9020];

R = radii(5);
jup_pos = [0, 0, 0]; %origine sdr zeuscentrico
body_sphere(5, jup_pos);

%X-axis
xlim([-7e5, 14e5]);
line([0 2*R],   [0 0],   [0 0], 'Color', 'white'); 
text(2*R,   0,   0, 'X', 'Color', 'white', 'FontSize', 6)

%Y-axis
ylim([-7.5e5, 7.5e5]);
line(  [0 0], [0 2*R],   [0 0], 'Color', 'white');
text(  0, 2*R,   0, 'Y', 'Color', 'white', 'FontSize', 6)

%Z-axis
%zlim([-1e8, 1e8]);
line(  [0 0],   [0 0], [0 2*R], 'Color', 'white');
text(  0,   0, 2*R, 'Z', 'Color', 'white', 'FontSize', 6)

%% Animation
h1 = animatedline('Color', '#A2142F');
h2 = animatedline('Color', 'yellow');
h3 = animatedline('Color', '[0.0745    0.6235    1.0000]'); 
%len = size(probe_pos(:, 1));

pause()
for k = 1 : t_dep + t_man
    
    if (k == 1)
        europe = plot3(europa_pos(k, 1), europa_pos(k, 2), europa_pos(k, 3),...
                'o','Color','#A2142F', 'MarkerSize', 6,...
                'MarkerFaceColor','#A2142F');
            
        io = plot3(io_pos(k, 1), io_pos(k, 2), io_pos(k, 3),...
                'o','Color','yellow', 'MarkerSize', 6,...
                'MarkerFaceColor','yellow');
            
        probe = plot3(probe_pos(k, 1), probe_pos(k, 2), probe_pos(k, 3),...
                'o','Color','[0.0745    0.6235    1.0000]', 'MarkerSize', 3,...
                'MarkerFaceColor','[0.0745    0.6235    1.0000]');
            
    elseif(k <= t_dep)
        europe.XData = europa_pos(k, 1);
        europe.YData = europa_pos(k, 2);
        europe.ZData = europa_pos(k, 3);
        
        io.XData = io_pos(k, 1);
        io.YData = io_pos(k, 2);
        io.ZData = io_pos(k, 3);
        
        probe.XData = probe_pos(k, 1);
        probe.YData = probe_pos(k, 2);
        probe.ZData = probe_pos(k, 3);
        
        addpoints(h3, probe_pos(k, 1), probe_pos(k, 2), probe_pos(k, 3));
    else
        europe.XData = europa_pos(k, 1);
        europe.YData = europa_pos(k, 2);
        europe.ZData = europa_pos(k, 3);
        
        io.XData = io_pos(k, 1);
        io.YData = io_pos(k, 2);
        io.ZData = io_pos(k, 3);
        
        probe.XData = transfer_traj(k - t_dep, 1);
        probe.YData = transfer_traj(k - t_dep, 2);
        probe.ZData = transfer_traj(k - t_dep, 3);
        
        addpoints(h3, transfer_traj(k - t_dep, 1), transfer_traj(k - t_dep, 2), transfer_traj(k - t_dep, 3));
    end
    
    addpoints(h1, europa_pos(k, 1), europa_pos(k, 2), europa_pos(k, 3));
    addpoints(h2, io_pos(k, 1), io_pos(k, 2), io_pos(k, 3));
    drawnow limitrate
  
end

[delta_v6, ~] = capture_hyp(10, v2_probe_eur, begin_date, 1, 100, 0, v2_eur);

