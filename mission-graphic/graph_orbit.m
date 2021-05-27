function jupiter_graph(body_id, y, linewidth)
% funzione che plotta l'orbita del corpo celeste grazie al calcolo iterativo del vettore posizione e velocità di esso durante il suo periodo di rivoluzione  
%
%   body_id   - celestial body identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                6 = Saturn
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto
%               10 = Europe
%               11 = Sun
%
%   y    - year considered

addpath(genpath("../utilityFunctions"));
    %periodo di ogni corpo celeste espresso in giorni terrestri (durata di un periodo di rivoluzione del corpo attorno al proprio fuoco)
    period = [88 
            225 
            365 
            687 
            4330 
            10748 
            30666 
            60148 
            90560 
            3.551181041 
            25];
        
    colors = ["g"          %green
              "m"          %magenta
              "b"          %blue
              "r"          %red
              "#A2142F"    %darker red
              "#7E2F8E"    %purple
              "#4DBEEE"    %darker cyan
              "c"          %(bright) cyan
              "#D95319"    %orange
              "#77AC30"    %darker green
              "#D95319"];  %orange, not visible due to Sun orbit dimensions
 	
          %Starting position at 1/1
    [~, r0, v0, ~] = body_elements_and_sv(body_id,y,1,1,0,0,0);

    pos = [r0];
    for g = 1:period(body_id)
        %Body position day by day
        [r, ~] = rv_from_r0v0(r0, v0, g*60*60*24);
        pos = cat(1,pos,r);
    end

    %Orbit plot
    plot3(pos(:,1),pos(:,2),pos(:,3),'-', 'LineWidth', linewidth, 'Color', colors(body_id))
    
end
