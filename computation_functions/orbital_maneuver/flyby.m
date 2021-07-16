%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [deltav, deltav_inf, e, a, delta, r_p] = flyby ( body_id, v1, V, v2, plot)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Questa funzione calcola i parametri dell'iperbole di flyby e il deltav
% dovuto alla manovra.
% Dati in ingresso:
%   v1 - velocita'  della sonda in entrata al SOI del pianeta (da Lambert);
%   V  - velocita' del pianeta (da body_elements_and_sv);
%   v2 - velocita'  in uscita da SOI del pianeta (da Lambert);
% plot - flag che, se attivo (ovvero uguale a 1), fa eseguire il plot
%
% Dati in uscita:
%   deltav - accelerazione dovuta al flyby;
%   e      - eccentricita'  dell'iperbole di flyby;
%   a      - semiasse maggiore dell'iperbole di flyby;
%   delta  - angolo caratteristico di flyby;        
%   r_p    - raggio del periasse dell'iperbole di flyby;

    global pl_mu
    mu = pl_mu(body_id);
    
    v_inf1 = v1 - V;
    v_inf2 = v2 - V;

    delta_rad = acos(dot(v_inf1, v_inf2)/(norm(v_inf1) * norm(v_inf2)));
    delta = rad2deg (delta_rad);
    r_p = (mu / ((norm(v_inf1))^2))*(1 / (sin(delta_rad/2)) - 1);

    e = 1 + (r_p * norm(v_inf1)^2) / mu;
    a = r_p / (e-1);

    %ASSERT
    %     if( norm(v_inf1) ~= norm(v_inf2) )
    %         disp('ERRORE: LE v_inf HANNO MODULO DIVERSO');
    %         return;
    %     end
    
    deltav = abs(norm(v1) - norm(v2));
    deltav_inf = norm(v_inf1, 2) - norm(v_inf2, 2);%differenza delle norme (mi aspetto che sia prossima a 0)
    
    if(norm(v1) > norm(v2))
        side = 'leading';
    else
        side = 'trailing';
    end
    
    if(plot == 1)
        flyby_plot(body_id, r_p, norm(v_inf1), side);
    end
end

