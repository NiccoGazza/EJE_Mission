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



global mu r T
Jy = 31557600; % [s], corrisponde a 365.25 d
AU = 149597870.691; % [km]

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
    


