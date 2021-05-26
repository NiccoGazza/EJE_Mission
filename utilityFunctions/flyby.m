function [deltav, e, a, delta, r_p] = flyby ( v1, V, v2, mu)
% Questa funzione calcola i parametri dell'ipeebole di flyby e il deltav
% dovuto alla manovra.
% Grandezze in entrata:
%   v1 = velocità della sonda in entrata al SOI del pianeta (da Lambert);
%   V  = velocità del pianeta (da body_elements_and_sv);
%   v2 = velocità in uscita da SOI del pianeta (da Lambert);
%   mu = costante gravitazionele del pianeta
%
% Grandezze in uscita:
%   deltav = accelerazione dovuta al flyby;
%   e      = eccemtricità dell'iperbole di flyby;
%   a      = semiasse maggiore dell'iperbole di flyby;
%   delta  = angolo caratteristico di flyby;
%   r_p    = raggio del periasse dell'iperbole di flyby;
%

v_inf1 = v1 - V;
v_inf2 = v2 - V;

delta_rad = acos(dot(v_inf1, v_inf2)/(norm(v_inf1)*norm(v_inf2)));
delta = rad2deg (delta_rad);
r_p = (mu/((norm(v_inf1))^2))*(1/(sin(delta_rad/2))-1);

e = 1+r_p *norm(v_inf1)^2/mu;
a = r_p/(e-1);

deltav = norm(v1,2) - norm(v2,2);
end
