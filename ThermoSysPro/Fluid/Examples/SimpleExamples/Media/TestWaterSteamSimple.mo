within ThermoSysPro.Fluid.Examples.SimpleExamples.Media;
model TestWaterSteamSimple
  extends ThermoSysPro.UsersGuide.Icons.Example;

  package Medium = ThermoSysPro.Properties.Media.WaterSteamSimple;

  parameter Units.SI.AbsolutePressure p = 1e5;
  parameter Units.SI.SpecificEnthalpy h = 3e5;
  parameter Units.SI.SpecificEntropy s = 1000;
  parameter Medium.ThermodynamicState state_ph = Medium.setState_phX(p, h, {1});
  parameter Medium.ThermodynamicState state_ps = Medium.setState_psX(p, s, {1});
  parameter ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph legacy_ph =
    ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(p, h, 0);
  parameter ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps legacy_ps =
    ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ps(p, s, 0);
  parameter Real eps = 1e-6;
equation
  assert(abs(Medium.temperature(state_ph) - legacy_ph.T) < eps,
    "WaterSteamSimple medium temperature_ph differs from legacy SimpleWater");
  assert(abs(Medium.density(state_ph) - legacy_ph.d) < eps,
    "WaterSteamSimple medium density_ph differs from legacy SimpleWater");
  assert(abs(Medium.specificEntropy(state_ph) - legacy_ph.s) < eps,
    "WaterSteamSimple medium entropy differs from legacy SimpleWater");
  assert(abs(Medium.temperature(state_ps) - legacy_ps.T) < eps,
    "WaterSteamSimple medium temperature_ps differs from legacy SimpleWater");
  assert(abs(Medium.density(state_ps) - legacy_ps.d) < eps,
    "WaterSteamSimple medium density_ps differs from legacy SimpleWater");
  assert(abs(Medium.specificEnthalpy(state_ps) - legacy_ps.h) < eps,
    "WaterSteamSimple medium enthalpy_ps differs from legacy SimpleWater");
  assert(abs(Medium.density_derh_p(state_ph) - legacy_ph.ddhp) < eps,
    "WaterSteamSimple medium density_derh_p differs from legacy SimpleWater");
  assert(abs(Medium.density_derp_h(state_ph) - legacy_ph.ddph) < eps,
    "WaterSteamSimple medium density_derp_h differs from legacy SimpleWater");
  annotation (experiment(StopTime=1));
end TestWaterSteamSimple;
