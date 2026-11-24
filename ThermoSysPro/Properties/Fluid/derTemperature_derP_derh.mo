within ThermoSysPro.Properties.Fluid;

function derTemperature_derP_derh "der(Temperature) computation for all fluids (inputs: P, h, fluid, der(P), der(h))"
  input Units.SI.AbsolutePressure P "Pressure (Pa)";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  input Integer fluid "<html>Fluid number: <br>1 - Water/Steam <br>2 - C3H3F5 <br>3 - FlueGases <br>4 - MoltenSalt <br>5 - Oil <br>6 - DryAirIdealGas <br>7 - WaterSteamSimple </html>";
  input Integer mode "IF97 region - 0:automatic computation";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";
  input Real der_P "Pressure time derivative (Pa/s)";
  input Real der_h "Specific Enthalpy time derivative (J/(kg*s))";
  input Real der_Xco2 = 0 "CO2 mass fraction time derivative";
  input Real der_Xh2o = 0 "H2O mass fraction time derivative";
  input Real der_Xo2 = 0 "O2 mass fraction time derivative";
  input Real der_Xso2 = 0 "SO2 mass fraction time derivative";
  output Real der_T "Temperature time derivative (K/s)";
protected
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph der_pro "Time derivative of the IF97 properties";
  ThermoSysPro.Properties.WaterSteamSimple.ThermoProperties_ph der_pro_simple "Time derivative of the WaterSteamSimple properties";
  Units.SI.AbsolutePressure dP = 1e-6*max(abs(P), 1e5) "Pressure step for finite differences";
  Units.SI.SpecificEnthalpy dh = 1e-6*max(abs(h), 1e5) "Specific enthalpy step for finite differences";
  Real eps "Step along the mass fraction derivatives for finite differences";
algorithm
  // Each branch differentiates the function called by the same branch of Temperature_Ph
  if fluid == 1 then
    der_pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph_der(p = P, h = h, mode = mode, p_der = der_P, h_der = der_h);
    der_T := der_pro.T;
  elseif fluid == 2 or fluid == 3 then
    // No analytic derivative available: central finite differences of the partial derivatives
    der_T := (Temperature_Ph(P + dP, h, fluid, mode, Xco2, Xh2o, Xo2, Xso2) - Temperature_Ph(P - dP, h, fluid, mode, Xco2, Xh2o, Xo2, Xso2))/(2*dP)*der_P + (Temperature_Ph(P, h + dh, fluid, mode, Xco2, Xh2o, Xo2, Xso2) - Temperature_Ph(P, h - dh, fluid, mode, Xco2, Xh2o, Xo2, Xso2))/(2*dh)*der_h;
    if fluid == 3 and max({abs(der_Xco2), abs(der_Xh2o), abs(der_Xo2), abs(der_Xso2)}) > 0 then
      eps := 1e-6/max({abs(der_Xco2), abs(der_Xh2o), abs(der_Xo2), abs(der_Xso2)});
      der_T := der_T + (Temperature_Ph(P, h, fluid, mode, Xco2 + eps*der_Xco2, Xh2o + eps*der_Xh2o, Xo2 + eps*der_Xo2, Xso2 + eps*der_Xso2) - Temperature_Ph(P, h, fluid, mode, Xco2 - eps*der_Xco2, Xh2o - eps*der_Xh2o, Xo2 - eps*der_Xo2, Xso2 - eps*der_Xso2))/(2*eps);
    end if;
  elseif fluid == 4 then
    der_T := ThermoSysPro.Properties.MoltenSalt.derTemperature_derh(h = h, der_h = der_h);
  elseif fluid == 5 then
    der_T := ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_derh(h = h, der_h = der_h);
  elseif fluid == 6 then
    der_T := ThermoSysPro.Properties.DryAirIdealGas.derTemperature_derh(h = h, der_h = der_h);
  elseif fluid == 7 then
    der_pro_simple := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph_der(p = P, h = h, mode = mode, p_der = der_P, h_der = der_h);
    der_T := der_pro_simple.T;
  else
    assert(false, "derTemperature_derP_derh: incorrect fluid number");
  end if;
  annotation(
    Documentation(info = "## Copyright © EDF 2002 - 2025

## ThermoSysPro Version 4.2

    "));
end derTemperature_derP_derh;
