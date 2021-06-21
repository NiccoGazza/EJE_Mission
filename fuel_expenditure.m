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
date0 = datetime(2024,10,30); %1) partenza Terra
y0 = year(date0);
m0 =month(date0);
d0 =day(date0);

date1 = datetime(2025,3,4); %2) flyby Marte
y1 = year(date1);
m1 =month(date1);
d1 =day(date1);

date2 = datetime(2027,11,19); %3) flyby Terra 
y2 = year(date2);
m2 =month(date2);
d2 =day(date2);

date3 = datetime(2031,1,1); %4) arrivo Giove 
y3 = year(date3);
m3 =month(date3);
d3 =day(date3);

%date4 = datetime(yyyy,mm,dd); %5) partenza da Giove 
%y4 = year(date4);
%m4 =month(date4);
%d4 =day(date4);

%date5 = datetime(yyyy,mm,dd); %4) arrivo su Europa 
%y5 = year(date5);
%m5 =month(date5);
%d5 =day(date5);


%V1 : velocità eliocentrica della sonda, di uscita dalla SOI delle Terra (inizio primo Lambert)
%V2 : velocità di ingresso alla SOI di Marte (fine primo Lambert)
%V3 : velocità di uscita dalla SOI di Marte (inizio secondo Lambert)
%V4 : velocità di ingresso alla SOI della Terra (fine secondo Lambert)
%V5 : velocità di ingresso alla SOI di Giove
%V6 : velocità di partenza dall'orbita attorno a Giove
%V7 : velocita' eliocentrica della sonda, in arrivo alla SOI di Europa (fine ultimo lambert (o Hohmann, da decidere)

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
[V1, V2] = lambert(r_earth1, r_mars1, t_a);

%% 1) Iperbole di uscita dalla SOI terrestre
%V1 - velocità di inizio Lambert
[delta_v1,~] = escape_hyp (3, V1, 200, date0, 0); %incl=0?


%% 3) Flyby su Marte
[delta_v2, deltav_inf2, ~] = flyby ( 4, V2, V_mars1, V3);

%% 6) Tasferimento Lambert Terra-Giove
[~, r_jupiter1, ~] = body_elements_and_sv(5, y3, m3, d3, 0, 0, 0);
T_c = between (date2, date3, 'Days'); %[days]
t_c = (caldays(T_c)) * 24 * 3600; %[sec]
[V4, V5] = lambert(r_earth2, r_jupiter1, t_c);

%% 5) Flyby sulla Terra
[delta_v3, deltav_inf3, ~] = flyby (3, V4, V_earth2, V5);


%% 7) Iperbole di ingresso nella SOI gioviana
% 8) Parcheggio sull'orbita attorno a Giove
%[delta_v4, ~] = capture_hyp(5, V5, date3, 8e5, 0.7);


%% 9) Trasferimento Lambert Giove-Europa
[~, r_jupiter2, ~] = body_elements_and_sv(5, y4, m4, d4, 0, 0, 0);
[~, r_europe, ~] = body_elements_and_sv(10, y5, m5 , d5, 0, 0, 0);
T_d = between (date4, date5, 'Days'); %[days]
t_d = (caldays(T_d)) * 24 * 3600; %[sec]
[V6, V7] = lambert(r_jupiter2, r_europe, t_d);

%% 10)Parcheggio sull'orbita attorno a Europa
[delta_v5, r_p] = capture_hyp(10, V7, date5, 100 , 0);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DeltaVTot = delta_v1 +delta_v2 +delta_v3 +delta_v4 +delta_v5;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

