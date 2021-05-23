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
%addpath(utilityFunctions);
dep_planet = 5 ;%jupiter
arr_planet = 10 ;% satellite, Europe
%data di arrivo sull'orbita planetostazionaria attorno a Giove : 01/01/2030
%ipotizzo di rimanere sull'orbita almeno 10gg
[delta_t_A, delta_T_h] = hohmann_phasing(5, 10, [2030 01 15]);

[deltaV_h, deltaT_h] = hohmann_transfer(5, 10);

m_E = G*masses(10);
vc_s = sqrt(mu_E/100); %velocità circolare della sonda sull'orbita attorno a Europa

deltav_orb = vc_s - v_fin; %v_fin velocità all'apocentro dell'ellisse di trasferimento o velocità circolare DI Europa attorno a Giove??
%CHIEDERE




