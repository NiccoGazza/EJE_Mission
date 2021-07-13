% Object identifiers :
%    1 = Mercury
%    2 = Venus
%    3 = Earth
%    4 = Mars
%    5 = Jupiter
%    7 = Uranus
%    8 = Neptune
%    9 = Pluto
%    10 = Europe
%    11 = Sun
% Script scritto con l'obiettivo di non sporcare il codice delle singole funzioni
% riempendole di dati noti e fissi. Per utilizzarlo, dichiarare le
% variabili che si intendono utilizzare come globali e chiamare parameters.


%% Genero i percorsi per tutte le funzioni
addpath(genpath("M_files_Curtis"));
addpath(genpath("computation_functions"));
addpath(genpath("animation_functions"));
addpath(genpath("ephemerides"));

%% Variabili Globali
global mu radii distances T masses G AU  pl_mu incl_body color

G = 6.6742e-20; %[km^3/kg/s^2]
Jy = 31557600; % [s], corrisponde a 365.25 d
AU = 149597870.691; % [km]
mu = 1.327565122000000e+11; % [km^3/s^2] //PARAMETRO MU DEL SOLE
    
    masses = 10^24 * [0.330104      %mercurio
                      4.86732       %venere
                      5.97219       %terra
                      0.641693      %marte
                      1898.13       %giove
                      568.319       %saturno
                      86.8100       %urano
                      102.410       %nettuno
                      0.01309       %plutone 
                      0.04800       %europa 
                      1989100       %sole
                      0.089];       %io         %[kg]
   
	radii = [2439.7     %mercurio
             6051.8     %venere
             6371       %terra
             3389.5     %marte
             71490      %giove
             60232      %saturno
             25362      %urano
             24622      %nettuno
             1188.3     %plutone
             1560.8     %europa
             695508     %sole
             1821] ;    %io                  %[km] 

	distances = [57909175   %mercurio
                 108208930  %venere
                 149598262  %terra
                 227936640  %marte
                 778412010  %giove 
                 1426666422 %saturno
                 2870658186 %urano
                 4498396441 %nettuno
                 5906440628 %plutone
                 671034];   %europa - distanza del corpo dal proprio fuoco [km]
                    
	T = [0.2408467;	
		0.61519726;	
		1.0000174;	
		1.8808476;	
		11.862615;	
		29.447498;	
		84.016846;	
		164.79132;
        248;
        0] * Jy; % [s] 
    T(10) = 3.551181041 * 24 * 60 * 60; 
    
    incl_body = [ 0.0;	
                  177.3;
                  23.45;
                  25.19;
                  3.12;
                  26.73;
                  97.86;
                  29.58;
                  122.53;
                  0.47]; %[deg] : rappresenta l'inclinazione ASSIALE, ovvero
                          %        l'inclinazione dell'asse di rotazione
                          %        rispetto alla perpendicolare al piano
                          %        orbitale. Viene utilizzata nel plot
                          %        delle manovre orbitali, dal momento che
                          %        si sceglie come sdr planetocentrico
                          %        quello equatoriale. Avendo inoltre i
                          %        pianeti di interesse un'inclinazione
                          %        trascurabile dell'orbita rispetto
                          %        all'eclittica (ordine di circa 1°),
                          %        questi valori possono essere visti anche
                          %        come inclinazioni rispetto all'equatore
                          %        celeste.
                    
    
	pl_mu = G * masses ; %[km^3/s^2]

    color = ["g"          %green
          "m"          %magenta
          "b"          %blue
          "r"          %red
          "#A2142F"    %darker red
          "#7E2F8E"    %purple
          "#4DBEEE"    %darker cyan
          "c"          %(bright) cyan
          "#D95319"    %orange
          "#77AC30"    %darker green
          "#EDB120"    %ochre
          "#D95319"];
    