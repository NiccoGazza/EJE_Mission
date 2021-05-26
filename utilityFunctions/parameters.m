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

addpath(genpath("../M_files_Curtis"));

global mu radii distances T masses G AU  aE_km pl_mu

    %Dati Europa da https://ssd.jpl.nasa.gov/?sat_elem#saturn
 
    aE = 0.004860642; %semiasse maggiore attorno a Giove [AU]
    aE_km = aE *AU;
    eE = 0.0094; %eccentricità
    wE = 88.970; %argomento al pericentro - omega [deg]
    ME = 171.016; %anomalia media [deg]
    iE = 0.466; %inclinazione [deg]
    RAE = 268.084; %ascensione retta [deg]
    w_hatE = RAE + wE; % longitudine al pericentro[deg]
    OmegaE = 219.106; %node [deg] longitudine del nodo ascendente
    PwE = 1.394; %[yr] periodo di precessione dell'argomento del pericentro omega	
    PnodeE = 30.184; %[yr] periodo di precesisone della longitudine del nodo ascendente Omega
    tildeomegaE =OmegaE + wE;
    LE = ME + tildeomegaE -360;

   %centennial rates:
    dot_aE = 0;
    dot_eE =  0;
    dot_iE = 0;
    dot_RAE = 0.00014620; %(preso uguale a quello di Vesta perchè parametro introvabile)
    dot_w_hatE = 0.00588261; %(preso uguale a quello di Vesta perchè parametro introvabile)
    dot_tildeomegaE = 360 /( PwE/100) + 360 / (PnodeE /100);
    dot_OmegaE = 101.3747242 * 365.25*100; % n  longitude rate [deg/day]2[degcy]
    dot_LE = dot_tildeomegaE + dot_OmegaE;

	J2000Europe =[aE ,eE,iE, RAE, w_hatE, LE];   
 	cent_ratEurope = [dot_aE, dot_eE, dot_iE, dot_RAE, dot_w_hatE, dot_LE];    
    
    masses = 10^24 * [0.330104 %mercurio
                      4.86732 %venere
                      5.97219 %terra
                      0.641693 %marte
                      1898.13 %giove
                      568.319 %saturno
                      86.8100 %urano
                      102.410  %nettuno
                      0.01309 %plutone 
                      0.04800 %europa 
                      1989100];%sole %[kg]
   
	radii = [2439.7 %mercurio
             6051.8 %venere
             6371 %terra
             3389.5 %marte
             71490 %giove
             60232 %saturno
             25362 %urano
             24622 %nettuno
             1188.3 %plutone
             1560.8 %europa  	
             695508] ;%sole; %[km] 

	distances = [57909227 %mercurio
                 108209475 %venere
                 149598262 %terra
                 227943824 %marte
                 778340821 %giove 
                 1426666422 %saturno
                 2870658186 %urano
                 4498396441 %nettuno
                 5906440628 %plutone
                 aE_km ];%europa - distanza del corpo dal proprio fuoco [km]
    
	G = 6.6742e-20; %[km^3/kg/s^2]
	Jy = 31557600; % [s], corrisponde a 365.25 d
	AU = 149597870.691; % [km]
	mu = 1.327565122000000e+11; % [km^3/s^2] //PARAMETRO MU DEL SOLE

                    
	T = [0.2408467;	
		0.61519726;	
		1.0000174;	
		1.8808476;	
		11.862615;	
		29.447498;	
		84.016846;	
		164.79132] * Jy; % [s]                
    
	pl_mu = G * masses ; %[km^3/s^2]

