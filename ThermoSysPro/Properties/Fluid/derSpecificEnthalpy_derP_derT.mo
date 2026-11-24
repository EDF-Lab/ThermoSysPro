within ThermoSysPro.Properties.Fluid;

function derSpecificEnthalpy_derP_derT "der(Specific enthalpy) computation for all fluids (inputs: P, h, der(P), der(T), fluid)"
  input Units.SI.AbsolutePressure P "Pressure (Pa)";
  input Units.SI.Temperature T "Temperature (K)";
  input Integer fluid "<html>Fluid number: <br>1 - Water/Steam <br>2 - C3H3F5 <br>3 - FlueGases <br>4 - MoltenSalt <br>5 - Oil <br>6 - DryAirIdealGas <br>7 - WaterSteamSimple </html>";
  input Integer mode "IF97 region - 0:automatic computation";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";
  input Real der_P "Pressure time derivative";
  input Real der_T "Temperature time derivative";
  input Real der_Xco2 = 0 "CO2 mass fraction time derivative";
  input Real der_Xh2o = 0 "H2O mass fraction time derivative";
  input Real der_Xo2 = 0 "O2 mass fraction time derivative";
  input Real der_Xso2 = 0 "SO2 mass fraction time derivative";
  output Real der_h "Specific enthalpy time derivative";
protected
  Units.SI.AbsolutePressure dP = 1e-6*max(abs(P), 1e5) "Pressure step for finite differences";
  Units.SI.TemperatureDifference dT = 1e-6*max(abs(T), 100) "Temperature step for finite differences";
  Real eps "Step along the mass fraction derivatives for finite differences";
algorithm
  // Each branch differentiates the function called by the same branch of SpecificEnthalpy_PT
  if fluid == 1 then
    der_h := ThermoSysPro.Properties.WaterSteam.IF97.SpecificEnthalpy_PT_der(p = P, T = T, mode = mode, p_der = der_P, T_der = der_T);
  elseif fluid == 2 then
    assert(false, "For fluid = 2 (C3H3F5), function SpecificEnthalpy_PT is not available");
  elseif fluid == 3 then
    // No analytic derivative available: central finite differences of the partial derivatives
    der_h := (SpecificEnthalpy_PT(P + dP, T, fluid, mode, Xco2, Xh2o, Xo2, Xso2) - SpecificEnthalpy_PT(P - dP, T, fluid, mode, Xco2, Xh2o, Xo2, Xso2))/(2*dP)*der_P + (SpecificEnthalpy_PT(P, T + dT, fluid, mode, Xco2, Xh2o, Xo2, Xso2) - SpecificEnthalpy_PT(P, T - dT, fluid, mode, Xco2, Xh2o, Xo2, Xso2))/(2*dT)*der_T;
    if max({abs(der_Xco2), abs(der_Xh2o), abs(der_Xo2), abs(der_Xso2)}) > 0 then
      eps := 1e-6/max({abs(der_Xco2), abs(der_Xh2o), abs(der_Xo2), abs(der_Xso2)});
      der_h := der_h + (SpecificEnthalpy_PT(P, T, fluid, mode, Xco2 + eps*der_Xco2, Xh2o + eps*der_Xh2o, Xo2 + eps*der_Xo2, Xso2 + eps*der_Xso2) - SpecificEnthalpy_PT(P, T, fluid, mode, Xco2 - eps*der_Xco2, Xh2o - eps*der_Xh2o, Xo2 - eps*der_Xo2, Xso2 - eps*der_Xso2))/(2*eps);
    end if;
  elseif fluid == 4 then
    der_h := ThermoSysPro.Properties.MoltenSalt.derSpecificEnthalpy_derT(T = T, der_temp = der_T);
  elseif fluid == 5 then
    der_h := ThermoSysPro.Properties.Oil_TherminolVP1.Enthalpy_derT(temp = T, der_temp = der_T);
  elseif fluid == 6 then
    der_h := ThermoSysPro.Properties.DryAirIdealGas.derSpecificEnthalpy_derT(T = T, der_T = der_T);
  elseif fluid == 7 then
    der_h := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.SpecificEnthalpy_PT_der(p = P, T = T, mode = mode, p_der = der_P, T_der = der_T);
  else
    assert(false, "derSpecificEnthalpy_derP_derT: incorrect fluid number");
  end if;
  annotation(
    Documentation(info = "## Copyright © EDF 2002 - 2025

## ThermoSysPro Version 4.2

    "));
end derSpecificEnthalpy_derP_derT;
