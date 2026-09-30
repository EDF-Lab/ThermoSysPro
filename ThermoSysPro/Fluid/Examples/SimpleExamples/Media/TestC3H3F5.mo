within ThermoSysPro.Fluid.Examples.SimpleExamples.Media;
model TestC3H3F5
  extends ThermoSysPro.UsersGuide.Icons.Example;

  package Medium = ThermoSysPro.Properties.Media.C3H3F5;

  parameter Units.SI.AbsolutePressure p = 1e5;
  parameter Units.SI.SpecificEnthalpy h = 3e5;
  parameter Units.SI.SpecificEntropy s = 1.5e3;
  parameter Medium.ThermodynamicState state_ph = Medium.setState_phX(p, h, {1});
  parameter Medium.ThermodynamicState state_ps = Medium.setState_psX(p, s, {1});
  parameter ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph legacy_ph =
    ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h);
  parameter ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps legacy_ps =
    ThermoSysPro.Properties.C3H3F5.C3H3F5_Ps(p, s);
  parameter Real eps = 1e-6;
equation
  assert(abs(Medium.temperature(state_ph) - legacy_ph.T) < eps,
    "C3H3F5 medium temperature_ph differs from legacy C3H3F5_Ph");
  assert(abs(Medium.density(state_ph) - legacy_ph.d) < eps,
    "C3H3F5 medium density_ph differs from legacy C3H3F5_Ph");
  assert(abs(Medium.specificEntropy(state_ph) - legacy_ph.s) < eps,
    "C3H3F5 medium specificEntropy differs from legacy C3H3F5_Ph");
  assert(abs(Medium.vapourQuality(state_ph) - legacy_ph.x) < 1e-4,
    "C3H3F5 medium vapourQuality differs from legacy C3H3F5_Ph");

  assert(abs(Medium.temperature(state_ps) - legacy_ps.T) < eps,
    "C3H3F5 medium temperature_ps differs from legacy C3H3F5_Ps");
  assert(abs(Medium.density(state_ps) - legacy_ps.d) < eps,
    "C3H3F5 medium density_ps differs from legacy C3H3F5_Ps");
  assert(abs(Medium.specificEnthalpy(state_ps) - legacy_ps.h) < eps,
    "C3H3F5 medium specificEnthalpy_ps differs from legacy C3H3F5_Ps");

  assert(abs(Medium.specificInternalEnergy(state_ph) - (h - p/legacy_ph.d)) < eps,
    "C3H3F5 medium internal energy does not match legacy Fluid assumption u=h-p/d");
  assert(abs(Medium.density_derh_p(state_ph) + 1e6) < eps,
    "C3H3F5 medium density_derh_p does not match legacy Fluid assumption");
  assert(abs(Medium.density_derp_h(state_ph) - 1e-8) < eps,
    "C3H3F5 medium density_derp_h does not match legacy Fluid assumption");
  annotation (experiment(StopTime=1));
end TestC3H3F5;
