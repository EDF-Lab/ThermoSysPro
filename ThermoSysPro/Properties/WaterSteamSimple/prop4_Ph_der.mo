within ThermoSysPro.Properties.WaterSteamSimple;

function prop4_Ph_der
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  input Real p_der "derivative of Pressure";
  input Real h_der "derivative of Specific enthalpy";
  output ThermoSysPro.Properties.WaterSteamSimple.ThermoProperties_ph der_pro "Derivative";
protected
  Units.SI.SpecificEnthalpy h1sat "Specific enthalpy at liquid saturation";
  Units.SI.SpecificEnthalpy h2sat "Specific enthalpy at vapor saturation";
  ThermoSysPro.Units.SI.MassFraction x "Vapor mass fraction";
  Real dxh "Derivative of quality wrt. enthalpy";
  Real dxp "Derivative of quality wrt. pressure";
  Real x_der "Derivative of quality wrt. time";
  Units.SI.Density d1sat "Density at liquid saturation";
  Units.SI.Density d2sat "Density at vapor saturation";
  Units.SI.SpecificEnergy u1sat "Specific inner energy at liquid saturation";
  Units.SI.SpecificEnergy u2sat "Specific inner energy at vapor saturation";
  Units.SI.SpecificEntropy s1sat "Specific entropy at liquid saturation";
  Units.SI.SpecificEntropy s2sat "Specific entropy at vapor saturation";
  Units.SI.SpecificHeatCapacity cp1sat "Specific heat capacity at liquid saturation";
  Units.SI.SpecificHeatCapacity cp2sat "Specific heat capacity at vapor saturation";
  Units.SI.DerDensityByPressure dd1satp "Derivative of density at liquid saturation wrt. pressure";
  Units.SI.DerDensityByPressure dd2satp "Derivative of density at vapor saturation wrt. pressure";
  Real du1satp "Derivative of specific inner energy at liquid saturation wrt. pressure";
  Real du2satp "Derivative of specific inner energy at vapor saturation wrt. pressure";
  Real ds1satp "Derivative of specific entropy at liquid saturation wrt. pressure";
  Real ds2satp "Derivative of specific entropy at vapor saturation wrt. pressure";
  Real dcp1satp "Derivative of specific heat capacity at liquid saturation wrt. pressure";
  Real dcp2satp "Derivative of specific heat capacity at vapor saturation wrt. pressure";
  Real dh1satp "Derivative of specific enthalpy at liquid saturation wrt. pressure";
  Real dh2satp "Derivative of specific enthalpy at vapor saturation wrt. pressure";
  Real d2h1satpp;
  Real d2h2satpp;
  Real u1sat_der "Derivative of specific inner energy at liquid saturation wrt. time";
  Real u2sat_der "Derivative of specific inner energy at vapor saturation wrt. time";
  Real d1sat_der "Derivative of density at liquid saturation wrt. time";
  Real d2sat_der "Derivative of density at vapor saturation wrt. time";
  Real s1sat_der "Derivative of specific entropy at liquid saturation wrt. time";
  Real s2sat_der "Derivative of specific entropy at vapor saturation wrt. time";
  Real cp1sat_der "Derivative of specific heat capacity at liquid saturation wrt. time";
  Real cp2sat_der "Derivative of specific heat capacity at vapor saturation wrt. time";
  Units.SI.Density d "Density";
  Real d_der "Derivative of density wrt. time";
  Units.SI.Temperature T1sat "Temperature at liquid saturation";
  Units.SI.Temperature T2sat "Temperature at vapor saturation";
  Real T1sat_der "Derivative of temperature at liquid saturation wrt. time";
  Real T2sat_der "Derivative of temperature at vapor saturation wrt. time";
  Real d2xhp "Second derivative of quality wrt. enthalpy and pressure";
  Real d2xhh "Second derivative of quality wrt. enthalpy";
  Real d2xpp "Second derivative of quality wrt. pressure";
  Real dxh_der;
  Real dxp_der;
  Real d2d1satpp;
  Real d2d2satpp;
  Real dd1satp_der;
  Real dd2satp_der;
  Real du1satp_der;
  Real du2satp_der;
  Real d2u1satpp "Second derivative of specific inner energy at liquid saturation wrt. pressure, along the saturation line";
  Real d2u2satpp "Second derivative of specific inner energy at vapor saturation wrt. pressure, along the saturation line";
  Real vp "Derivative of specific volume wrt. pressure at constant specific enthalpy";
  Real vp_der "Derivative of vp wrt. time";
algorithm
  h1sat := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.h1sat_P(p);
  h2sat := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.h2sat_P(p);
  dh1satp := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.dh1satp_P(p);
  dh2satp := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.dh2satp_P(p);
  d2h1satpp := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.d2h1satpp_P(p);
  d2h2satpp := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.d2h2satpp_P(p);
  x := (h - h1sat)/(h2sat - h1sat);
  dxh := 1/(h2sat - h1sat);
  dxp := -(dh1satp + x*(dh2satp - dh1satp))/(h2sat - h1sat);
  d2xhp := -dxh^2*(dh2satp - dh1satp);
  d2xhh := 0;
  d2xpp := (-(d2h1satpp + dxp*(dh2satp - dh1satp) + x*(d2h2satpp - d2h1satpp)) - dxp*(dh2satp - dh1satp))/(h2sat - h1sat);
// Saturation properties X(p, hsat(p)), and their first and second derivatives along the saturation line:
// dX/dp = X_p + X_h*hsat', d2X/dp2 = X_pp + 2*X_hp*hsat' + X_hh*hsat'^2 + X_h*hsat''
  d1sat := ThermoSysPro.Properties.WaterSteamSimple.Density.d1_Ph(p, h1sat);
  d2sat := ThermoSysPro.Properties.WaterSteamSimple.Density.d2_Ph(p, h2sat);
  dd1satp := ThermoSysPro.Properties.WaterSteamSimple.Density.dd1ph_Ph(p, h1sat) + ThermoSysPro.Properties.WaterSteamSimple.Density.dd1hp_Ph(p, h1sat)*dh1satp;
  dd2satp := ThermoSysPro.Properties.WaterSteamSimple.Density.dd2ph_Ph(p, h2sat) + ThermoSysPro.Properties.WaterSteamSimple.Density.dd2hp_Ph(p, h2sat)*dh2satp;
  d2d1satpp := ThermoSysPro.Properties.WaterSteamSimple.Density.d2d1pp_Ph(p, h1sat) + 2*ThermoSysPro.Properties.WaterSteamSimple.Density.d2d1hp_Ph(p, h1sat)*dh1satp + ThermoSysPro.Properties.WaterSteamSimple.Density.d2d1hh_Ph(p, h1sat)*dh1satp^2 + ThermoSysPro.Properties.WaterSteamSimple.Density.dd1hp_Ph(p, h1sat)*d2h1satpp;
  d2d2satpp := ThermoSysPro.Properties.WaterSteamSimple.Density.d2d2pp_Ph(p, h2sat) + 2*ThermoSysPro.Properties.WaterSteamSimple.Density.d2d2hp_Ph(p, h2sat)*dh2satp + ThermoSysPro.Properties.WaterSteamSimple.Density.d2d2hh_Ph(p, h2sat)*dh2satp^2 + ThermoSysPro.Properties.WaterSteamSimple.Density.dd2hp_Ph(p, h2sat)*d2h2satpp;
  u1sat := ThermoSysPro.Properties.WaterSteamSimple.Energy.u1_Ph(p, h1sat);
  u2sat := ThermoSysPro.Properties.WaterSteamSimple.Energy.u2_Ph(p, h2sat);
  du1satp := ThermoSysPro.Properties.WaterSteamSimple.Energy.du1ph_Ph(p, h1sat) + ThermoSysPro.Properties.WaterSteamSimple.Energy.du1hp_Ph(p, h1sat)*dh1satp;
  du2satp := ThermoSysPro.Properties.WaterSteamSimple.Energy.du2ph_Ph(p, h2sat) + ThermoSysPro.Properties.WaterSteamSimple.Energy.du2hp_Ph(p, h2sat)*dh2satp;
  d2u1satpp := ThermoSysPro.Properties.WaterSteamSimple.Energy.d2u1pp_Ph(p, h1sat) + 2*ThermoSysPro.Properties.WaterSteamSimple.Energy.d2u1hp_Ph(p, h1sat)*dh1satp + ThermoSysPro.Properties.WaterSteamSimple.Energy.d2u1hh_Ph(p, h1sat)*dh1satp^2 + ThermoSysPro.Properties.WaterSteamSimple.Energy.du1hp_Ph(p, h1sat)*d2h1satpp;
  d2u2satpp := ThermoSysPro.Properties.WaterSteamSimple.Energy.d2u2pp_Ph(p, h2sat) + 2*ThermoSysPro.Properties.WaterSteamSimple.Energy.d2u2hp_Ph(p, h2sat)*dh2satp + ThermoSysPro.Properties.WaterSteamSimple.Energy.d2u2hh_Ph(p, h2sat)*dh2satp^2 + ThermoSysPro.Properties.WaterSteamSimple.Energy.du2hp_Ph(p, h2sat)*d2h2satpp;
  s1sat := ThermoSysPro.Properties.WaterSteamSimple.Entropy.s1_Ph(p, h1sat);
  s2sat := ThermoSysPro.Properties.WaterSteamSimple.Entropy.s2_Ph(p, h2sat);
  ds1satp := ThermoSysPro.Properties.WaterSteamSimple.Entropy.ds1ph_Ph(p, h1sat) + ThermoSysPro.Properties.WaterSteamSimple.Entropy.ds1hp_Ph(p, h1sat)*dh1satp;
  ds2satp := ThermoSysPro.Properties.WaterSteamSimple.Entropy.ds2ph_Ph(p, h2sat) + ThermoSysPro.Properties.WaterSteamSimple.Entropy.ds2hp_Ph(p, h2sat)*dh2satp;
  cp1sat := ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity.cp1_Ph(p, h1sat);
  cp2sat := ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity.cp2_Ph(p, h2sat);
  dcp1satp := ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity.dcp1ph_Ph(p, h1sat) + ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity.dcp1hp_Ph(p, h1sat)*dh1satp;
  dcp2satp := ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity.dcp2ph_Ph(p, h2sat) + ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity.dcp2hp_Ph(p, h2sat)*dh2satp;
  T1sat := ThermoSysPro.Properties.WaterSteamSimple.Temperature.T1_Ph(p, h1sat);
  T2sat := ThermoSysPro.Properties.WaterSteamSimple.Temperature.T2_Ph(p, h2sat);
// Quality derivative
  x_der := dxp*p_der + dxh*h_der;
  der_pro.x := x_der;
// Specific inner energy derivative
  u1sat_der := du1satp*p_der;
  u2sat_der := du2satp*p_der;
  der_pro.u := -x_der*u1sat + (1 - x)*u1sat_der + x_der*u2sat + x*u2sat_der;
// Specific entropy derivative
  s1sat_der := ds1satp*p_der;
  s2sat_der := ds2satp*p_der;
  der_pro.s := -x_der*s1sat + (1 - x)*s1sat_der + x_der*s2sat + x*s2sat_der;
// Specific heat capacity derivative
  cp1sat_der := dcp1satp*p_der;
  cp2sat_der := dcp2satp*p_der;
  der_pro.cp := -x_der*cp1sat + (1 - x)*cp1sat_der + x_der*cp2sat + x*cp2sat_der;
// Density derivative: d = 1/v, v = (1 - x)/d1sat + x/d2sat
  d := 1/((1 - x)/d1sat + x/d2sat);
  d1sat_der := dd1satp*p_der;
  d2sat_der := dd2satp*p_der;
  d_der := -d^2*(-x_der/d1sat - (1 - x)*d1sat_der/d1sat^2 + x_der/d2sat - x*d2sat_der/d2sat^2);
  der_pro.d := d_der;
// Temperature derivative
  T1sat_der := (ThermoSysPro.Properties.WaterSteamSimple.Temperature.dT1ph_Ph(p, h1sat) + ThermoSysPro.Properties.WaterSteamSimple.Temperature.dT1hp_Ph(p, h1sat)*dh1satp)*p_der;
  T2sat_der := (ThermoSysPro.Properties.WaterSteamSimple.Temperature.dT2ph_Ph(p, h2sat) + ThermoSysPro.Properties.WaterSteamSimple.Temperature.dT2hp_Ph(p, h2sat)*dh2satp)*p_der;
  der_pro.T := -x_der*T1sat + (1 - x)*T1sat_der + x_der*T2sat + x*T2sat_der;
// Second derivatives: time derivatives of ddhp, ddph, duph, duhp as computed by prop4_Ph
  dxh_der := d2xhp*p_der + d2xhh*h_der;
  dxp_der := d2xpp*p_der + d2xhp*h_der;
  dd1satp_der := d2d1satpp*p_der;
  dd2satp_der := d2d2satpp*p_der;
  du1satp_der := d2u1satpp*p_der;
  du2satp_der := d2u2satpp*p_der;
// ddhp = -d^2*dxh*(1/d2sat - 1/d1sat)
  der_pro.ddhp := -2*d*d_der*(-dxh/d1sat + dxh/d2sat) - d^2*(-dxh_der/d1sat + dxh*d1sat_der/d1sat^2 + dxh_der/d2sat - dxh*d2sat_der/d2sat^2);
// ddph = -d^2*vp
  vp := -dxp/d1sat - (1 - x)*dd1satp/d1sat^2 + dxp/d2sat - x*dd2satp/d2sat^2;
  vp_der := -dxp_der/d1sat + dxp*d1sat_der/d1sat^2 + x_der*dd1satp/d1sat^2 - (1 - x)*(dd1satp_der/d1sat^2 - 2*dd1satp*d1sat_der/d1sat^3) + dxp_der/d2sat - dxp*d2sat_der/d2sat^2 - x_der*dd2satp/d2sat^2 - x*(dd2satp_der/d2sat^2 - 2*dd2satp*d2sat_der/d2sat^3);
  der_pro.ddph := -2*d*d_der*vp - d^2*vp_der;
// duph = -dxp*u1sat + (1 - x)*du1satp + dxp*u2sat + x*du2satp
  der_pro.duph := -dxp_der*u1sat - dxp*u1sat_der - x_der*du1satp + (1 - x)*du1satp_der + dxp_der*u2sat + dxp*u2sat_der + x_der*du2satp + x*du2satp_der;
// duhp = dxh*(u2sat - u1sat)
  der_pro.duhp := -dxh_der*u1sat - dxh*u1sat_der + dxh_der*u2sat + dxh*u2sat_der;
  annotation(
    Documentation(info = "## Copyright © EDF 2002 - 2025

## ThermoSysPro Version 4.2

    "));
end prop4_Ph_der;