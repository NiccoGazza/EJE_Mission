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

dep_planet = 5 %jupiter
arr_planet = 10 % satellite, Europe
[deltaV_h, deltaT_h] = hohmann_transfer(dep_planet, arr_planet)

