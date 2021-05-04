%Raggi medi (approssimazione orbite circolari)
R_earth = 150e6; %km 
R_mars =  228e6; %km
%Periodi 
T_earth = 365.25636; %day
T_mars = 686.97959; %day

global mu
mu = 1.327124e11;

[~, r_earth, ~] = planet_elements_and_sv(3, 2021, 04, 28, 0, 0, 0);
[~, r_mars, ~] = planet_elements_and_sv(4, 2021, 04, 28, 0, 0, 0);

TA_earth = atan2(r_earth(2), r_earth(1)); %rad
TA_mars = atan2(r_mars(2), r_mars(1));    %rad

if(TA_earth < 0)
    TA_earth = 2*pi - abs(TA_earth);
end

theta_0 = (TA_mars - TA_earth);
theta_H = pi*(1 - sqrt(((1 + R_earth/R_mars)/2)^3));
Delta_theta = theta_0 - theta_H;
if(Delta_theta < 0)
    Delta_theta = Delta_theta + 2*pi;
end

delta_t_A = Delta_theta/((2*pi*(1/T_earth - 1/T_mars))); %days
delta_t_H = pi/(sqrt(mu))*((R_earth+R_mars)/2)^(3/2); %s!!

delta_t_H = delta_t_H/(60*60*24);

delta_t_tot = delta_t_A + delta_t_H;    

