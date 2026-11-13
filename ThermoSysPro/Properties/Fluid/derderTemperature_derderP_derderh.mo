within ThermoSysPro.Properties.Fluid;

function derderTemperature_derderP_derderh "der(der(Temperature)) computation for all fluids (inputs: P, h, der(P), der(h), der(der(P)), der(der(h)), fluid)"
  input Units.SI.AbsolutePressure P "Pressure (Pa)";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  input Integer fluid "<html>Fluid number: <br>1 - Water/Steam <br>2 - C3H3F5 <br>3 - FlueGases <br>4 - MoltenSalt <br>5 - Oil <br>6 - DryAirIdealGas <br>7 - WaterSteamSimple </html>";
  input Integer mode "IF97 region - 0:automatic computation";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";
  input Real der_P "Pressure time derivative (J/(kg*s))";
  input Real der_h "Specific Enthalpy time derivative (J/(kg*s))";
  input Real der_Xco2 = 0 "CO2 mass fraction";
  input Real der_Xh2o = 0 "H2O mass fraction";
  input Real der_Xo2 = 0 "O2 mass fraction";
  input Real der_Xso2 = 0 "SO2 mass fraction";
  input Real der_2_P;
  input Real der_2_h;
  input Real der_2_Xco2 = 0;
  input Real der_2_Xh2o = 0;
  input Real der_2_Xo2 = 0;
  input Real der_2_Xso2 = 0;
  output Real der_2_T "Time derivative of Temperature time derivative (K/s2)";
protected
  Real eps "Step along (der_P, der_h, der_X) for finite differences";
algorithm
  // Not referenced by any annotation: for tools to use it, Temperature_Ph needs, besides
  // derivative = derTemperature_derP_derh, the annotation derivative(order = 2) = derderTemperature_derderP_derderh.
  // der_T = derTemperature_derP_derh(P, h, X, der_P, der_h, der_X) is linear in its derivative inputs, so
  // der(der_T) = d(der_T)/d(P, h, X) along (der_P, der_h, der_X) + der_T evaluated with (der_2_P, der_2_h, der_2_X).
  // The first term is a central finite difference of derTemperature_derP_derh along (der_P, der_h, der_X).
  der_2_T := derTemperature_derP_derh(P, h, fluid, mode, Xco2, Xh2o, Xo2, Xso2, der_2_P, der_2_h, der_2_Xco2, der_2_Xh2o, der_2_Xo2, der_2_Xso2);
  eps := max({abs(der_P)/max(abs(P), 1e5), abs(der_h)/max(abs(h), 1e5), abs(der_Xco2), abs(der_Xh2o), abs(der_Xo2), abs(der_Xso2)});
  if eps > 0 then
    eps := 1e-6/eps;
    der_2_T := der_2_T + (derTemperature_derP_derh(P + eps*der_P, h + eps*der_h, fluid, mode, Xco2 + eps*der_Xco2, Xh2o + eps*der_Xh2o, Xo2 + eps*der_Xo2, Xso2 + eps*der_Xso2, der_P, der_h, der_Xco2, der_Xh2o, der_Xo2, der_Xso2) - derTemperature_derP_derh(P - eps*der_P, h - eps*der_h, fluid, mode, Xco2 - eps*der_Xco2, Xh2o - eps*der_Xh2o, Xo2 - eps*der_Xo2, Xso2 - eps*der_Xso2, der_P, der_h, der_Xco2, der_Xh2o, der_Xo2, der_Xso2))/(2*eps);
  end if;
  annotation(
    Documentation(info = "## Copyright © EDF 2002 - 2025

## ThermoSysPro Version 4.2

    "));
end derderTemperature_derderP_derderh;