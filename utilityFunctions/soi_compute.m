function [r_soi] = soi_compute(body_id, focus_id)
%funzione che calcola il raggio della sfera di influenza del corpo celeste dato in ingresso secondo body_id, rispetto al corpo principale focus_id
%   body_id - body identifier:
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
    %% Constants
parameters
    global distances  masses  aE_km
     
%% Algoritmo
if (body_id~=10 || body_id==10 && focus_id==11)
        r_soi = distances(body_id)*(masses(body_id)/masses(focus_id))^(2/5);
elseif (body_id==10 && focus_id==5)
        r_soi = aE_km*(masses(body_id)/masses(focus_id))^(2/5);
        elseif (body_id==10 && focus_id~=11 )
        uiwait(warnglg('Computation not contemplated.'));
 end
	


