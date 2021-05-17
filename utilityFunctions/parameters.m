%    1 = Mercury
%    2 = Venus
%    3 = Earth
%    4 = Mars
%    5 = Jupiter
%    7 = Uranus
%    8 = Neptune
%    9 = Pluto
% Script scritto con l'obiettivo di non sporcare il codice delle singole funzioni
% riempendole di dati noti e fissi. Per utilizzarlo, dichiarare le
% variabili che si intendono utilizzare come globali e chiamare parameters.

addpath(genpath("../M_files_Curtis"));

global mu r T m G
Jy = 31557600; % [s], corrisponde a 365.25 d
AU = 149597870.691; % [km]

G = 6.6742e-20; %[km^3/kg/s^2]

mu = 1.327565122000000e+11; % [km^3/s^2]
r = [0.38709893;
     0.72333199;
     1.00000011;
     1.52366231;
     5.20336301;
     9.53707032;
     19.19126393;
     30.06896348;
     39.48168677;
     ]*AU;             % [km]: sarebbero i semiassi, possono essere usati come
                    %approssimazione dei raggi medi dell'orbita
                    
T = [0.2408467;	
0.61519726;	
1.0000174;	
1.8808476;	
11.862615;	
29.447498;	
84.016846;	
164.79132] * Jy; % [s]                
    
m = 10^24 * [0.330104; %mercurio
                 4.86732; %venere
                 5.97219 %terra
                 0.641693 %marte
                 1898.13 %giove
                 568.319 %saturno
                 86.8100 %urano
                 102.410  %nettuno
                 0.01309 %plutone 
                 0.04800 %europa 
                 1989100];%sole %[kg]

