function [Dv_H , Dv_1 , Dv_f , Dt_H, v_in , v_fin] = hohmann (r1, rf)
%% HOHMANN Manovra di Hohman - da un pianeta A a un pianeta B %%
 %massa sole
mu = 1.32712440e+11; %m massa del corpo fuoco di entrambe le orbite (approssimate a circolari)
%% 
% dati per il calcolo della prima variazione di velocità impulsiva
v_c1 = sqrt(mu/r1); %velocità in uscita dalla soi 
v_ph = sqrt(mu/r1*(2-1/(1+rf/r1))); %velocità desiderata affinchè il corpo appartenga all'ellisse di trasferimento
%% 
% dati per il calcolo della seconda variazione di velocità impulsiva
v_c2 = sqrt(mu/rf);
v_ah = sqrt ((2*mu/rf)-mu/(r1+rf));
%% 
% Calcolo dei due impulsi (adimensionali - quindi dv_1/v_c1 e dv_2/v_c2):
dv_1 = sqrt(2*(rf/r1))/sqrt(1+(rf/r1))-1;
dv_f = sqrt(1/(rf/r1)) - sqrt(2/((rf/r1)*(1+rf/r1)));

%calcolo quelli dimensionali 
Dv_1 = dv_1*v_c1;
Dv_f = dv_f*v_c1;
% Delta v totale per il trasferimento
Dv_H = Dv_1 + Dv_f;
%% 
% Tempo totale per il trasferimento:
a= (rf+r1)/2;
dt_H= pi*sqrt(a^3/mu); % tempo di volo [s]
Dt_H = dt_H /(60*60*24); %tempo di volo espresso [days]


%%velocità di inizio e fine trasferimento
v_in= v_c1+v_ph;
v_fin= v_c2+v_ah;