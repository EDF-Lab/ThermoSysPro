within ThermoSysPro.Properties.WaterSteamSimple.Enthalpy;

function d2h2satpp_P "derivative of specific enthalpy at vapor saturation wrt. pressure"
  input Units.SI.Pressure p "pressure";
  output Real d2hpp "derivative of enthalpy";
protected
  h2sat_P_coef1 coef1;
  h2sat_P_coef2 coef2;
  h2sat_P_coef3 coef3;
algorithm
  if p < 8.7075e5 then
    d2hpp := coef1.a*coef1.b*(coef1.b - 1)*abs(p)^(coef1.b - 2);
  else
    if p < 93.285e5 then
      d2hpp := ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_x_order5_derivative2(coef2, p);
    else
      d2hpp := ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_x_order7_derivative2(coef3, p);
    end if;
  end if;
  annotation(
    Documentation(info = "## Copyright © EDF 2002 - 2025

## ThermoSysPro Version 4.2

    "));
end d2h2satpp_P;