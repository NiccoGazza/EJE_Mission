%Calcolo del DeltaV necessario per l'intera missione
%
% 1) Iperbole di uscita dalla SOI terrestre
% 2) Trasferimento Lambert Terra-Marte
% 3) Flyby su Marte
% 4) Trasferimento Lambert Marte-Terra
% 5) Flyby sulla Terra
% 6) Tasferimento Lambert Terra-Giove
% 7) Iperbole di ingresso nella SOI gioviana
% 8) Parcheggio sull'orbita attorno a Giove
% 9) Trasferimento Lambert Giove-Europa
% 10)Parcheggio sull'orbita attorno a Europa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

date0 = datetime(2024, 10, 30); %1) partenza Terra
y0 = year(date0);
m0 = month(date0);
d0 = day(date0);

date1 = datetime(2025, 3, 4); %2) flyby Marte
y1 = year(date1);
m1 = month(date1);
d1 = day(date1);

date2 = datetime(2027, 11, 19); %3) flyby Terra 
y2 = year(date2);
m2 = month(date2);
d2 = day(date2);

date3 = datetime(2031, 1, 1); %4) arrivo Giove 
y3 = year(date3);
m3 = month(date3);
d3 = day(date3);

date4 = datetime(2031, 1, 8); %5) partenza da Giove 
y4 = year(date4);
m4 = month(date4);
d4 = day(date4);

date5 = datetime(2031, 1, 10); %4) arrivo su Europa 
y5 = year(date5);
m5 = month(date5);
d5 = day(date5);


%V1 : velocita'† eliocentrica della sonda, di uscita dalla SOI delle Terra (inizio primo Lambert)
%V2 : velocita'† di ingresso alla SOI di Marte (fine primo Lambert)
%V3 : velocita'† di uscita dalla SOI di Marte (inizio secondo Lambert)
%V4 : velocita'† di ingresso alla SOI della Terra (fine secondo Lambert)
%V5 : velocita' di ingresso alla SOI di Giove
%V6 : velocita'† di partenza dall'orbita attorno a Giove
%V7 : velocita'†eliocentrica della sonda, in arrivo alla SOI di Europa 
%    (fine ultimo lambert (o Hohmann, da decidere))

%delta_v1 : per uscire dalla SOI della Terra e immettersi nell'orbita di trasferimento Terra-Marte
%delta_v2 : per uscire dalla SOI di Marte e immettersi nell'orbita di trasferimento Marte-Terra (flyby1)
%delta_v3 : per uscire dalla SOI della Terra e immettersi nell'orbita di trasferimento Terra-Giove (flyby2)
%delta_v4 : per parcheggiare sull'orbita attorno a Giove
%NO ---delta_v5 : per effettuare il trasferimento Giove-Europa--- NO
%delta_v6 : per parcheggiare sull'orbita attorno a Europa

%% 2) Trasferimento Lambert Terra-Marte
[~, r_earth1, ~] = body_elements_and_sv(3, y0, m0, d0, 0, 0, 0);
[~, r_mars1, V_mars1 , ~] = body_elements_and_sv(4, y1, m1, d1, 0, 0, 0);
T_a = between (date0, date1, 'Days'); %[days]
t_a = (caldays(T_a)) * 24 * 3600; %[sec]
[V1, V2_a] = lambert(r_earth1, r_mars1, t_a);

%% 1) Iperbole di uscita dalla SOI terrestre
%V1 - velocita'† di inizio Lambert
[delta_v1,~] = escape_hyp (3, V1, 200, date0, 23.5); %incl = 23.5 Ë un parametro utilizzato solo dal plot

%% 4) Trasferimento Lambert Marte-Terra
[~, r_earth2, V_earth2,~] = body_elements_and_sv(3, y2, m2, d2, 0, 0, 0);
T_b = between (date1, date2, 'Days'); %[days]
t_b = (caldays(T_b)) * 24 * 3600; %[sec]
[V2_b, V3_a] = lambert(r_mars1, r_earth2, t_b);

%% 3) Primo Flyby -  su Marte
[delta_v2, deltav_inf2, ~] = flyby ( 4, V2_a, V_mars1, V2_b);
norm(V2_a)
norm(V2_b)

%% 6) Tasferimento Lambert Terra-Giove
[~, r_jupiter1, ~] = body_elements_and_sv(5, y3, m3, d3, 0, 0, 0);
T_c = between (date2, date3, 'Days'); %[days]
t_c = (caldays(T_c)) * 24 * 3600; %[sec]
[V3_b, V4] = lambert(r_earth2, r_jupiter1, t_c);

%% 5) Secondo Flyby - sulla Terra
[delta_v3, deltav_inf3, ~] = flyby (3, V3_a, V_earth2, V3_b);
norm(V3_a)
norm(V3_b)


%% 7) Iperbole di ingresso nella SOI gioviana
% 8) Parcheggio sull'orbita attorno a Giove

[delta_v4, rp_jupiter] = capture_hyp(5, V4, date3, 0, 8e4, 0.6);


%% 9) Trasferimento Lambert Giove-Europa
% %[~, r_jupiter2, ~] = body_elements_and_sv(5, y4, m4, d4, 0, 0, 0); no buono perch√® la funzione lambert la usiamo gioviocentrica
% r_jupiter2 = [ -rp_jupiter, 0 , 0 ];
% [~, r_europe, ~] = body_elements_and_sv(10, y5, m5 , d5, 0, 0, 0);
% T_d = between (date4, date5, 'Days'); %[days]
% t_d = (caldays(T_d)) * 24 * 3600; %[sec]
% [V6, V7] = lambert(r_jupiter2, r_europe, t_d);
% 
% %% 10)Parcheggio sull'orbita attorno a Europa
% [delta_v5, rp_europe] = capture_hyp(10, V7, date5, 0, 100 , 0);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DeltaVTot = delta_v1 +delta_v2 +delta_v3 +delta_v4 +delta_v5;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

