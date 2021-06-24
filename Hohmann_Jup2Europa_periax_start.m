function [delta_v1, delta_t_H_hours, e_hyp, a_hyp, a_H, e_H, delta_v2, delta_v_tot] = Hohmann_Jup2Europa_periax_start(r_periax, e_init)

global mu radii distances T masses G AU  pl_mu incl_body

r_2 = distances(10);                        %raggio orbita Europa
mu_j = pl_mu(5);                            %mu di Giove

r_1 = r_periax*(e_init + 1)/(1 - e_init);   %calcolo raggio apogeo dell'ellissi di partenza
a_1 = (r_periax + r_1)/2;                   %coefficiente a dell'orbita di parcheggio

a_H = (r_periax + r_2)/2;                        %coefficiente a dell'ellisse di Hohmann
e_H = (r_2 - r_periax)/(r_2 + r_periax);         %eccentricità ellissi Hohmann

v_init = sqrt(2*mu_j/r_periax - mu_j/a_1)        %velocità all'apogeo dell'orbita di parcheggio intorno a Giove

v_trans_p = sqrt(2*mu_j/r_periax - mu_j/a_H);    %velocità al perigeo dell'orbita di Hohmann

delta_v1 = v_trans_p - v_init;                   %delta v per portarsi sull'orbita di Hohmann

v_trans_a = sqrt(2*mu_j/r_2 - mu_j/a_H);           %velocità all'apogeo dell'orbita di Hohmann

v_EU = sqrt(mu_j/r_2);                             %velocità Europa sulla sua orbita

v_inf = v_EU - v_trans_a;                          %velocità relativa della sonda rispetto a Europa

delta_t_H = pi*sqrt((r_periax+r_2)^3/(8*mu_j));    %tempo per la manovra di Hohmann secondi
delta_t_H_hours = delta_t_H/3600;                  %tempo Hohmann in ore

%Iperbole di cattura. Dalle specifiche di progetto è richiesta un'orbita
%circolare intorno ad Europa con un'altezza di 100 km. Il raggio di
%parcheggio è fissato, anche il coefficiente a (dipende da v_inf), quindi è fissata anche
%l'eccentricità.

mu_EU = pl_mu(10);                             %mu di Europa

r_park_EU = 100 + radii(10);                   %raggio di parcheggio introno ad Europa
r_p_hyp = r_park_EU;                           %raggio al periasse dell'iperbole deve coincidere con il raggio di parcheggio

a_hyp = -mu_EU/(v_inf)^2;                           %coefficiente a dell'iperbole
e_hyp = 1 - r_park_EU/a_hyp;                   %eccentricità iperbole di cattura

v_park_EU = sqrt(mu_EU/r_park_EU);             %velocità della sonda sull'orbita di parcheggio di Europa
v_p_hyp = sqrt(2*mu_EU/r_p_hyp + v_inf^2);     %velocità dell'iperbole di cattura al perigeo

delta_v2 = v_p_hyp - v_park_EU;                %delta v per portarsi sull'orbita di parcheggio circolare intorno ad Europa

delta_v_tot = delta_v1 + delta_v2;             %delta v totale

%phasing Europa

teta_H = pi*(1- sqrt(((1+r_periax/r_2)/2)^3))     %angolo a cui si deve trovare Europa alla partenza della sonda
