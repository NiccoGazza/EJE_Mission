%% Graphical Setup
begin_date = datetime(2031, 01, 01);
end_date = begin_date + 12;

global radii
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
%xlim([-4.5e8, 1.5e8]);
line([0 2.5*R],   [0 0],   [0 0], 'Color', 'white'); 
text(2.5*R,   0,   0, 'X', 'Color', 'white', 'FontSize', 6)

%Y-axis
%ylim([-4e8, 4e8]);
line(  [0 0], [0 2.5*R],   [0 0], 'Color', 'white');
text(  0, 2.5*R,   0, 'Y', 'Color', 'white', 'FontSize', 6)

%Z-axis
%zlim([-1e8, 1e8]);
line(  [0 0],   [0 0], [0 2.5*R], 'Color', 'white');
text(  0,   0, 2.5*R, 'Z', 'Color', 'white', 'FontSize', 6)

%% Trajectory computation
europe_pos = gen_europe_traj(begin_date, end_date);

%% Animation
h = animatedline('Color', '#A2142F');
len = size(europe_pos(:, 1));

for k = 1 : len
    if (k == 1)
        europe = plot3(europe_pos(k, 1), europe_pos(k, 2), europe_pos(k, 3),...
                'o','Color','#A2142F', 'MarkerSize', 6,...
                'MarkerFaceColor','#A2142F');
    else
        europe.XData = europe_pos(k, 1);
        europe.YData = europe_pos(k, 2);
        europe.ZData = europe_pos(k, 3);
    end
    addpoints(h, europe_pos(k, 1), europe_pos(k,2), europe_pos(k,3));
    drawnow
end