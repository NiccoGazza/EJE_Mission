%Svolgimento del trasferimento della sonda dall'orbita di parcheggio attorno a Giove, fino a un'orbita attorno a Europa
%Specifiche della fase :
%il satellite arriva in un'rbita circolare -equatoriale- a 100km di altezza. DEVO CONSIDERARE IL RAGGIO DI EUROPA'?
%Data di partenza dall'orbita planetostazionaria: a piacere
%utilizzo un trasferimento alla Hohmann

%capire quando partire da giove
%requirements per poter effettuare la manovra :
%	~phasing
%	~considerare saturno come una sfera di raggio maggiorato di 100km
%	~dare ulteriore delta-v quando si arriva per far combaciare la velocità circolare di saturno con quella della sonda (=> costringere la sonda ad orbitare attorno a Europa)	
%planet_elements_and_sv1.m
addpath(genpath("utilityFunctions"));
parameters
dep_planet = 5 ;%jupiter
arr_planet = 10 ;% satellite, Europe
%data di arrivo sull'orbita planetostazionaria attorno a Giove : 01/01/2030
%ipotizzo di rimanere sull'orbita almeno 10gg
t0 = datetime(2030, 1, 15);
[delta_t_A, delta_T_h] = hohmann_phasing(dep_planet, arr_planet ,t0);
[deltaV_h, deltaT_h] = hohmann_transfer(dep_planet,arr_planet);

mu_E = G*(m(10));
vc_s = sqrt(mu_E/100); %velocità circolare della sonda sull'orbita attorno a Europa

%deltav_orb = vc_s - v_fin; %v_fin velocità all'apocentro dell'ellisse di trasferimento o velocità circolare DI Europa attorno a Giove??
%CHIEDERE




