within ThermoSysPro.Properties.C3H3F5;

function C3H3F5_Ph "11133-C3H3F5 physical properties as a function of P and h"
  input Units.SI.AbsolutePressure P "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  output ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro annotation(
    Placement(transformation(extent = {{-100, 80}, {-80, 100}}, rotation = 0)));
protected
  Units.SI.Temperature Tsat "Saturation temperature";
  Units.SI.AbsolutePressure Psc "Critical pressure";
  Units.SI.AbsolutePressure Pcalc "Variable for the computation of the pressure";
  Units.SI.SpecificEnthalpy hcalc "Variable for the computation of the specific  enthalpy";
  Units.SI.SpecificEnthalpy hsatL "Boiling specific enthalpy";
  Units.SI.SpecificEnthalpy hsatV "Condensation specific enthalpy";
  Units.SI.SpecificEntropy ssatL "Boiling specific entropy";
  Units.SI.SpecificEntropy ssatV "Condensation specific entropy";
  Units.SI.Density rhoSatL "Boiling density";
  Units.SI.Density rhoSatV "Condensation density";
  Real A1;
  Real B1;
  Real C1;
  Real A2;
  Real B2;
  Real C2;
  Real D2;
  Real A3;
  Real B3;
  Real C3;
  Real dhsatL "Derivative of hsatL wrt. Pcalc (kJ/kg/bar)";
  Real dhsatV "Derivative of hsatV wrt. Pcalc (kJ/kg/bar)";
  Real drhoSatL "Derivative of rhoSatL wrt. Pcalc (kg/m3/bar)";
  Real drhoSatV "Derivative of rhoSatV wrt. Pcalc (kg/m3/bar)";
  Real dxdh "Derivative of x wrt. hcalc (1/(kJ/kg))";
  Real dxdp "Derivative of x wrt. Pcalc (1/bar)";
  Real dddh "Derivative of the density wrt. hcalc at constant Pcalc (kg/m3/(kJ/kg))";
  Real dddp "Derivative of the density wrt. Pcalc at constant hcalc (kg/m3/bar)";
  Units.SI.SpecificHeatCapacity cpL "Specific heat capacity of the saturated liquid";
  Units.SI.SpecificHeatCapacity cpV "Specific heat capacity of the saturated vapour";
algorithm
/* Critical pressure */
  Psc := 3640000;
/* Tests : the function is only valid for P > 0, P < Pcritique, h > 100 kJ/kg and h < 640 kJ/kg */
  if (P > Psc) then
    Pcalc := Psc/100000;
  elseif (P <= 0) then
    Pcalc := 1/100000;
  else
    Pcalc := P/100000;
  end if;
  if (h > 640000) then
    hcalc := 640;
  elseif (h < 100000) then
    hcalc := 100;
  else
    hcalc := h/1000;
  end if;
/* Properties on the saturation line */
  hsatV := -0.00000274*Pcalc^6 + 0.00032217*Pcalc^5 - 0.01489673*Pcalc^4 + 0.34258030*Pcalc^3 - 4.15381744*Pcalc^2 + 27.64876596*Pcalc + 385.22149853;
  hsatL := -0.0000039275*Pcalc^6 + 0.0004780040*Pcalc^5 - 0.0227439765*Pcalc^4 + 0.5370471515*Pcalc^3 - 6.6496487588*Pcalc^2 + 46.8685173786*Pcalc + 166.7823742593;
  ssatV := 1000*(0.0000000017*Pcalc^6 - 0.0000002159*Pcalc^5 + 0.0000102230*Pcalc^4 - 0.0002295813*Pcalc^3 + 0.0023692545*Pcalc^2 - 0.0062966866*Pcalc + 1.7667560947);
  ssatL := 1000*(-0.0000000164*Pcalc^6 + 0.0000019814*Pcalc^5 - 0.0000934768*Pcalc^4 + 0.0021827510*Pcalc^3 - 0.0265228817*Pcalc^2 + 0.1740890297*Pcalc + 0.8685336198);
  rhoSatL := 0.0000057803*Pcalc^6 - 0.0007528646*Pcalc^5 + 0.0377373800*Pcalc^4 - 0.9314090824*Pcalc^3 + 11.9184348938*Pcalc^2 - 89.9582798898*Pcalc + 1467.5902188299;
  rhoSatV := 0.00000207*Pcalc^6 - 0.00019163*Pcalc^5 + 0.00675913*Pcalc^4 - 0.10924667*Pcalc^3 + 0.84661954*Pcalc^2 + 2.83415571*Pcalc + 2.12959146;
  Tsat := -0.0000033655*Pcalc^6 + 0.0004044854*Pcalc^5 - 0.0190328128*Pcalc^4 + 0.4443722095*Pcalc^3 - 5.4337547883*Pcalc^2 + 36.7572359309*Pcalc + 246.4280421048;
/* Derivatives of the saturation polynomials wrt. Pcalc */
  dhsatV := -6*0.00000274*Pcalc^5 + 5*0.00032217*Pcalc^4 - 4*0.01489673*Pcalc^3 + 3*0.34258030*Pcalc^2 - 2*4.15381744*Pcalc + 27.64876596;
  dhsatL := -6*0.0000039275*Pcalc^5 + 5*0.0004780040*Pcalc^4 - 4*0.0227439765*Pcalc^3 + 3*0.5370471515*Pcalc^2 - 2*6.6496487588*Pcalc + 46.8685173786;
  drhoSatL := 6*0.0000057803*Pcalc^5 - 5*0.0007528646*Pcalc^4 + 4*0.0377373800*Pcalc^3 - 3*0.9314090824*Pcalc^2 + 2*11.9184348938*Pcalc - 89.9582798898;
  drhoSatV := 6*0.00000207*Pcalc^5 - 5*0.00019163*Pcalc^4 + 4*0.00675913*Pcalc^3 - 3*0.10924667*Pcalc^2 + 2*0.84661954*Pcalc + 2.83415571;
/* Coefficients of the steam temperature polynomial (also used for cp of the saturated vapour) */
  A1 := 0.0000698*Pcalc - 0.0008618;
  B1 := -0.0858201*Pcalc + 1.8849272;
/* Determination of the property zone (liquid, two-phase or steam) and compuation of the properties */
  if ((hcalc >= hsatL) and (hcalc <= hsatV)) then
/* Two-phase zone */
    pro.T := Tsat;
    pro.x := (hcalc - hsatL)/(hsatV - hsatL);
    pro.d := rhoSatL*(1 - pro.x) + rhoSatV*pro.x;
    pro.s := ssatL*(1 - pro.x) + ssatV*pro.x;
    dxdh := 1/(hsatV - hsatL);
    dxdp := -(dhsatL + pro.x*(dhsatV - dhsatL))/(hsatV - hsatL);
    dddh := (rhoSatV - rhoSatL)*dxdh;
    dddp := drhoSatL*(1 - pro.x) + drhoSatV*pro.x + (rhoSatV - rhoSatL)*dxdp;
    // cp of the saturated liquid and vapour, mixed as in WaterSteam.Common.water_ph_r4
    cpL := 1000/(-2*0.0005311*hsatL + 0.9990391);
    cpV := 1000/(2*A1*hsatV + B1);
    pro.cp := (1 - pro.x)*cpL + pro.x*cpV;
  elseif (hcalc < hsatL) then
/* Liquid zone */
    pro.T := -0.0005311*hcalc^2 + 0.9990391*hcalc + 93.9602333;
    if (pro.T > Tsat) then
      pro.T := Tsat;
    end if;
    pro.x := 0;
    // cp = (dh/dT)_p = 1/(dT/dh)_p from the temperature polynomial (hcalc in kJ/kg)
    pro.cp := 1000/(-2*0.0005311*hcalc + 0.9990391);
    pro.d := -0.0000154*hcalc^3 + 0.0095634*hcalc^2 - 3.8184877*hcalc + 1916.6958695;
    dddh := -3*0.0000154*hcalc^2 + 2*0.0095634*hcalc - 3.8184877;
    dddp := 0;
    if (pro.d < rhoSatL) then
      pro.d := rhoSatL;
      dddh := 0;
      dddp := drhoSatL;
    end if;
    pro.s := 1000*(-0.0000037*hcalc^2 + 0.0051600*hcalc + 0.1002293);
    if (pro.s > ssatL) then
      pro.s := ssatL;
    end if;
  else
/* Steam zone */
    C1 := 27.0570743*Pcalc - 353.7594967;
    pro.T := A1*hcalc^2 + B1*hcalc + C1;
    if (pro.T < Tsat) then
      pro.T := Tsat;
    end if;
    pro.x := 1;
    // cp = (dh/dT)_p = 1/(dT/dh)_p from the temperature polynomial (hcalc in kJ/kg)
    pro.cp := 1000/(2*A1*hcalc + B1);
    A2 := -0.0000000958*Pcalc^2 + 0.0000006742*Pcalc - 0.0000002691;
    B2 := 0.0001689*Pcalc^2 - 0.0011644*Pcalc + 0.0004690;
    C2 := -0.0995131*Pcalc^2 + 0.6639841*Pcalc - 0.2724718;
    D2 := 19.6224804*Pcalc^2 - 121.4944333*Pcalc + 52.8361115;
    pro.d := A2*hcalc^3 + B2*hcalc^2 + C2*hcalc + D2;
    dddh := 3*A2*hcalc^2 + 2*B2*hcalc + C2;
    dddp := (-2*0.0000000958*Pcalc + 0.0000006742)*hcalc^3 + (2*0.0001689*Pcalc - 0.0011644)*hcalc^2 + (-2*0.0995131*Pcalc + 0.6639841)*hcalc + 2*19.6224804*Pcalc - 121.4944333;
    if (pro.d > rhoSatV) then
      pro.d := rhoSatV;
      dddh := 0;
      dddp := drhoSatV;
    end if;
    A3 := -0.0000000032*Pcalc^2 + 0.0000001779*Pcalc - 0.0000037134;
    B3 := 0.0000034*Pcalc^2 - 0.0001957*Pcalc + 0.0064718;
    C3 := -0.0001958*Pcalc^2 + 0.0194928*Pcalc - 0.1696592;
    pro.s := 1000*(A3*hcalc^2 + B3*hcalc + C3);
    if (pro.s < ssatV) then
      pro.s := ssatV;
    end if;
  end if;
/* Fields of ThermoProperties_ph that were not assigned (u, cp above, ddhp, ddph, duph, duhp).
   ddhp and ddph are the derivatives of the density polynomials (hcalc in kJ/kg, Pcalc in bar);
   duph and duhp follow from u = h - P/d, as in WaterSteam.Common.gibbsToProps_ph */
  pro.ddhp := dddh/1000;
  pro.ddph := dddp/100000;
  pro.u := h - P/pro.d;
  pro.duph := -1/pro.d + P/(pro.d*pro.d)*pro.ddph;
  pro.duhp := 1 + P/(pro.d*pro.d)*pro.ddhp;
  annotation(
    smoothOrder = 2,
    Documentation(info = "
## Copyright © EDF 2002 - 2026  


## ThermoSysPro Version 4.2  

    "));
end C3H3F5_Ph;