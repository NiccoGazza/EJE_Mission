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

delta_t1 = between(date0 , date1, 'Days');  %da uscita dalla SOI terrestre a ingresso nella SOI marziana
delta_t2 = between(date1 , date2, 'Days');  %da uscita dalla SOI marziana a ingresso nella SOI terrestre (post-flyby1)
delta_t3 = between(date2 , date3, 'Days');  %da uscita dalla SOI terrestre a ingresso nella SOI gioviana (post-flyby2)
delta_t4 = 3;				    %tempo speso sull'orbita di parcheggio di Giove [days] DA DECIDERE. PER ORA METTO 3gg
delta_t5 = between(date4 , date5, 'Days');  %da orbita di parcheggio gioviana alla SOI di Europa
%delta_t5b =  %per parcheggiare sull'orbita attorno a Europa NON ESISTE SE CONSIDERIAMO INGRESSO IPERBOLICO ISTANTANEO

%NOTA BENE : i flyby e le manovre di ingresso e uscite iperboliche sono considerati istantanei

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DeltaT = delta_t1 +delta_t2 +delta_t3 +delta_t4 +delta_t5;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

