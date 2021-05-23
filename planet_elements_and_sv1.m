function [coe, r, v, jd] = planet_elements_and_sv1 ...
                (planet_id, year, month, day, hour, minute, second)
% PLANET_ELEMENTS_AND_SV calculates the orbital elements and the state  
%   vector of a planet from the date (year, month, day)
%   and universal time (hour, minute, second).
%  
%   mu        - gravitational parameter of the sun (km^3/s^2)
%   deg       - conversion factor between degrees and radians
%   pi        - 3.1415926...
%  
%   coe       - vector of heliocentric orbital elements
%               [h  e  RA  incl  w  TA  a  w_hat  L  M  E],
%               where
%                h     = angular momentum                    (km^2/s)
%                e     = eccentricity
%                RA    = right ascension                     (deg)
%                incl  = inclination                         (deg)
%                w     = argument of perihelion              (deg)
%                TA    = true anomaly                        (deg)
%                a     = semimajor axis                      (km)
%                w_hat = longitude of perihelion ( = RA + w) (deg)
%                L     = mean longitude ( = w_hat + M)       (deg)
%                M     = mean anomaly                        (deg)
%                E     = eccentric anomaly                   (deg)
%  
%   planet_id - planet identifier:
%                1 = Mercury
%                2 = Venus
%                3 = Earth
%                4 = Mars
%                5 = Jupiter
%                6 = Saturn
%                7 = Uranus
%                8 = Neptune
%                9 = Pluto
%               10 = Europe
%               11 = Sun
%  
%   year      - range: 1901 - 2050
%   month     - range: 1 - 12
%   day       - range: 1 - 31
%   hour      - range: 0 - 23
%   minute    - range: 0 - 60
%   second    - range: 0 - 60
%                     
%   j0        - Julian day number of the date at 0 hr UT
%   ut        - universal time in fractions of a day
%   jd        - julian day number of the date and time
%  
%   J2000_coe - row vector of J2000 orbital elements from Table 9.1
%   rates     - row vector of Julian centennial rates from Table 9.1
%   t0        - Julian centuries between J2000 and jd
%   elements  - orbital elements at jd
%  
%   r         - heliocentric position vector
%   v         - heliocentric velocity vector
%  
% User M-functions required:  J0, kepler_E, sv_from_coe
% User subfunctions required: planetary_elements

    %% Constants
    global mu

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
             1151 %plutone
             3122 + 100 %europa  	%%100 È L'ALTEZZA DELL'ORBITA FINALE
             695508] %sole; %[km] 

	distances = [57909227 %mercurio
                 108209475 %venere
                 149598262 %terra
                 227943824 %marte
                 778340821 %giove 
                 1426666422 %saturno
                 2870658186 %urano
                 4498396441 %nettuno
                 5906440628 %plutone
                 78000000];%europa - distanza dal sole [km]
    
    G = 6.6742e-20; %[km^3/kg/s^2]
    
    pl_mu = G * masses(planet_id); %[km^3/s^2]

    %% Algorithm
    global mu

    if((planet_id ~= 10)

        deg    = pi/180;

        %...Equation 5.48:
        j0     = J0(year, month, day);

        ut     = (hour + minute/60 + second/3600)/24;

        %...Equation 5.47
        jd     = j0 + ut;

        %...Obtain the data for the selected planet from Table 8.1:
        [J2000_coe, rates] = planetary_elements(planet_id);

        %...Equation 8.93a:
        t0     = (jd - 2451545)/36525;

        %...Equation 8.93b:
        elements = J2000_coe + rates*t0;

        a      = elements(1);
        e      = elements(2);

        %...Equation 2.71:
        h      = sqrt(mu*a*(1 - e^2));

        %...Reduce the angular elements to within the range 0 - 360 degrees:
        incl   = elements(3);
        RA     = mod(elements(4),360);
        w_hat  = mod(elements(5),360);
        L      = mod(elements(6),360);
        w      = mod(w_hat - RA ,360);
        M      = mod(L - w_hat  ,360);

        %...Algorithm 3.1 (for which M must be in radians)
        E      = kepler_E(e, M*deg); %rad

        %...Equation 3.13 (converting the result to degrees):
        TA     = mod(2*atand(sqrt((1 + e)/(1 - e))*tan(E/2)),360);

        %        [km^2/s,-, rad, rad, rad, rad, km, rad, rad, rad, rad]
        coe    = [h, e, RA*deg, incl*deg, w*deg, TA*deg, a, w_hat, L, M, E];

        %...Algorithm 4.5:
        [r, v] = sv_from_coe(coe, mu);
        return

    elseif(planet_id < 11)

        % Conversions
        au2km = 149597870.700; % [km]
        auday2kms = 149597870.700/86400.0; % [km/s]

        if(planet_id == 10)
            % Data loading
            europe_data = europe_rv();

            % Index calculation based on date
            j0     = J0(year, month, day);
            ut     = (hour + minute/60 + second/3600)/24;
            jd     = j0 + ut;
            t     = jd - 2451544.5 + 1; % +1 because index starts at 1

            % Setting position, velocity, coe
            r = au2km * europe_data(t,1:3);
            v = auday2kms * europe_data(t,4:6);
            coe = coe_from_sv(r,v,pl_mu);

        end

    end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          function [J2000_coe, rates] = planetary_elements(planet_id)
        %{
          This function extracts a planet's J2000 orbital elements and
          centennial rates from Table 8.1.

          planet_id      - 1 through 12, for Mercury through Pluto, plus
                           Vesta, Ceres and the Sun

          J2000_elements - 12 by 6 matrix of J2000 orbital elements for the nine
                           planets Mercury through Pluto, plus Vesta, Ceres
                           and the Sun. The columns of each 
                           row are:
                             a     = semimajor axis (AU)
                             e     = eccentricity
                             i     = inclination (degrees)
                             RA    = right ascension of the ascending
                                     node (degrees)
                             w_hat = longitude of perihelion (degrees)
                             L     = mean longitude (degrees)

          cent_rates     - 12 by 6 matrix of the rates of change of the 
                           J2000_elements per Julian century (Cy). Using "dot"
                           for time derivative, the columns of each row are:
                             a_dot     (AU/Cy)
                             e_dot     (1/Cy)
                             i_dot     (deg/Cy)
                             RA_dot    (deg/Cy)
                             w_hat_dot (deg/Cy)
                             Ldot      (deg/Cy)

          J2000_coe      - row vector of J2000_elements corresponding
                           to "planet_id", with au converted to km
          rates          - row vector of cent_rates corresponding to
                           "planet_id", with au converted to km              

          au             - astronomical unit (149597871 km)
        %}
        % --------------------------------------------------------------------
%Dati Europa da https://ssd.jpl.nasa.gov/?sat_elem#saturn

aE = 0.004860642; %semiasse maggiore attorno a Giove [AU]
eE = 0.0094; %eccentricità
wE = 88.970; %argomento al pericentro - omega [deg]
ME = 171.016; %anomalia media [deg]
iE = 0.466; %inclinazione [deg]
RAE = 268.084; %ascensione retta [deg]
w_hatE = RAE + wE % longitudine al pericentro[deg]
LE = w_hatE + ME %longitudine media [deg]
OmegaE = 219.106; %node [deg] longitudine del nodo ascendente
TE = 3.551; %periodo siderale
PwE = 1.394; %[yr] periodo di precessione dell'argomento del pericentro omega	
PnodeE = 30.184; %[yr] periodo di precesisone della longitudine del nodo ascendente Omega
DecE = 64.506; %[deg] declinazione
TiltE = 0.016; %[deg] angolo tra l'equatore del pianeta e il piano di Laplace
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


        %---- a --------- e -------- i -------- RA --------- w_hat ------- L ------

        J2000_elements = ...
        [0.38709927  0.20563593  7.00497902  48.33076593  77.45779628  252.25032350
         0.72333566  0.00677672  3.39467605  76.67984255 131.60246718  181.97909950 
         1.00000261  0.01671123 -0.00001531   0.0        102.93768193  100.46457166 
         1.52371034  0.09339410  1.84969142  49.55953891 -23.94362959 	-4.55343205
         5.20288700  0.04838624  1.30439695 100.47390909  14.72847983 	34.39644501
         9.53667594  0.05386179  2.48599187 113.66242448  92.59887831 	49.95424423
        19.18916464  0.04725744  0.77263783  74.01692503 170.95427630  313.23810451
        30.06992276  0.00859048  1.77004347 131.78422574  44.96476227  -55.12002969 
	39.48211675  0.24882730 17.14001206 110.30393684 224.06891629  238.92903833
         aE		eE	     iE	        RAE	       w_hatE         LE   
        0.006977376  0.26965557  1.55468744 103.66985200 326.77648848  229.63858632];

        %---- a --------- e -------- i -------- RA --------- w_hat ------- L ------
        cent_rates = ... 
        [0.00000037  0.00001906 -0.00594749 -0.12534081  0.16047689  149472.67411175 
         0.00000390 -0.00004107 -0.00078890 -0.27769418  0.00268329	  58517.81538729  
         0.00000562 -0.00004392 -0.01294668  0.0         0.32327364   35999.37244981  
         0.0001847 	 0.00007882 -0.00813131 -0.29257343  0.44441088   19140.30268499  
        -0.00011607 -0.00013253 -0.00183714  0.20469106	 0.21252668    3034.74612775 
        -0.00125060 -0.00050991  0.00193609 -0.28867794 -0.41897216    1222.49362201
        -0.00196176 -0.00004397 -0.00242939  0.04240589  0.40805281 	428.48202785 
         0.00026291  0.00005105  0.00035372 -0.00508664 -0.32241464 	218.45945325 
        -0.00031596  0.00005170  0.00004818 -0.01183482 -0.04062942 	145.20780515
     	  dot_aE	dot_eE 	   dot_iE      dot_RAE	  dot_w_hatE	   sdot_LE         
         0.0         0.0         0.0         0.0         0.0              0.00000000]; 

        J2000_coe      = J2000_elements(planet_id,:);
        rates          = cent_rates(planet_id,:);

        %...Convert from AU to km:
        au             = 149597871; 
        J2000_coe(1)   = J2000_coe(1)*au;
        rates(1)       = rates(1)*au;

        end %planetary_elements
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end %planet_elements_and_sv
