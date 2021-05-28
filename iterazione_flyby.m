function [epsilon, t, dv] = iterazione_flyby (planet_id0, planet_id1, planet_id2, t0, t1, t2)
% Questa funzione trova una data di partenza per Lambert pre flyby in modo
% da far coincidere le velocità relative di entrata e uscita.
%  Dati in igresso:
%      planet_id0 : pianeta di partenza del Lambert pre Fly-by
%      planet_id1 : pianeta su cui fare il Fly-by
%      planet_id2 : pianeta di arrivo del Lambert post Fly-by
%      t0 : data iniziale di partenza del Lambert pre Fly-by (variabile
%      iterata) da planet_id0. Iterata per i 100 giorni successivi
%      t1 : data del Fly_by (fissata) su planet_id1
%      t2 : data di arrivo del Lambert post Fly-by su planet_id2
%
%  Dati in uscita:
%      t : tempo plausibile di partenza da planet_id0 per il Lambert pre
%      Fly-by (nominal value = 0)
%      dv : deltav del Fly-by su planet_id1 (nominal value = 1)
%      epsilon : differenza fra i due moduli delle v infinito (nomianal
%      value = 1)
%


%inizializzazione
global pl_mu
parameters;
 
 %lambert fra terra e Giove 
y1 = year(t1);
m1 = month(t1);
d1 = day(t1);
y2 = year(t2);
m2 = month(t2);
d2 = day(t2);

[~, r_id1, v_id1, ~] = planet_elements_and_sv(planet_id1, y1, m1, d1, 0, 0, 0);
[~, r_id2, v_id2, ~] = planet_elements_and_sv(planet_id2, y2, m2, d2, 0, 0, 0);
dt = between (t1, t2, 'Days');
t_volo = (caldays(dt))*24*3600;
[v_dep, v_arr] = lambert (r_id1, r_id2, t_volo);

modul_vout = norm((v_dep-v_id1),2);

%lambert ottimo tra Terra e Marte 
n=0;
diff=1;
toll = 0.1;
t= datetime(0, 0, 0);
dv=0;
epsilon=1;
while n~=100
   y = year(t0);
   m = month(t0);
   d = day(t0);
   [~, r_id0, v_id0, ~] = planet_elements_and_sv(planet_id0, y, m, d, 0, 0, 0);
   dt1 = between (t0, t1, 'Days');
   t_lam = (caldays(dt1))*24*3600;
   [v1, v2] = lambert (r_id0, r_id1, t_lam);
  
   modul_vin = norm((v2-v_id1),2);
   diff = abs(modul_vout-modul_vin);
   
   if diff<toll 
      [deltav, e, a, delta, r_p] = flyby ( v2, v_id1, v_dep, pl_mu(planet_id1));
      t=t0;
      dv=deltav;
      epsilon=diff;
      break
   else
   t0 = t0+1
   n = n+1
   end  
end
end

  
   
  
   
    
   