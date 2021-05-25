%Svolgimento del trasferimento alla Hohmann della sonda dall'orbita di parcheggio attorno a Giove, fino a un'orbita attorno a Europa
%Specifiche della fase :
%il satellite arriva in un'orbita circolare -equatoriale- a 100km di altezza.
%Data di partenza dall'orbita planetostazionaria: a piacere
%raggio dell'orbita di partenza : rp ottimizzante energeticamente

%capire quando partire da giove
%requirements per poter effettuare la manovra :
%	~phasing
%planet_elements_and_sv.m

addpath(genpath("utilityFunctions"));
parameters
global pl_mu rp radii G masses

%data di arrivo sull'orbita planetostazionaria attorno a Giove : 01/01/2030
%ipotizzo di rimanere sull'orbita almeno 10gg


%FASE ZEUSCENTRICA
t0 = datetime(2030, 1, 15);
%[delta_t_A, delta_T_h] = hohmann_phasing(5, 10, t0); 
[~,rp]=entrance_planetEccentrity(5,vinfG, rp , 0);
[deltaV_h, deltaT_h] = hohmann_transfer(5, 10, rp); %rp calcolato con entrance_planetEccentrity/Period di ingresso a Giove

%FASE DI INGRESSO NELLA SOI DI EUROPA

mu_E = pl_mu(10);
vc_E = sqrt(mu_E/100); %velocità circolare della sonda sull'orbita attorno a Europa, rispetto a Giove

t1 =t0+delta_T_h;
t1_con = datetime(datenum(t0) + delta_T_h);
[~, ~, pl_v, ~] = planet_elements_and_sv ...
                (10, year(t1), month(t1), day(t1), hour(t1), minute(t1), second(t1));

vinfE= vc_E - pl_v;
r_orb = 100 + radii(10); %100km di altezza dalla superficie di Europa
[delta_v] = entrance_planetEccentrity(10, vinf, r_orb); % orbita circolare all'arrivo su Europa





%trasferimento alla Hohmann
%Il rapporto r_soiE/aE è molto piccolo pertanto la sfer  



