% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function F = kepler_H(e, M)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  This function uses Newton's method to solve Kepler's equation 
  for the hyperbola  e*sinh(F) - F = M  for the hyperbolic
  eccentric anomaly, given the eccentricity and the hyperbolic
  mean anomaly.
 
  F - hyperbolic eccentric anomaly (radians)
  e - eccentricity, passed from the calling program
  M - hyperbolic mean anomaly (radians), passed from the
      calling program
 
  User M-functions required: none
%}
% ----------------------------------------------
 
%...Set an error tolerance:
error = 1.e-8;
 
%...Starting value for F:
F = M;
 
%...Iterate on Equation 3.45 until F is determined to within
%...the error tolerance:
ratio = 1;
while abs(ratio) > error
    ratio = (e*sinh(F) - F - M)/(e*cosh(F) - 1);
    F = F - ratio;
end
 
end %kepler_H
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
