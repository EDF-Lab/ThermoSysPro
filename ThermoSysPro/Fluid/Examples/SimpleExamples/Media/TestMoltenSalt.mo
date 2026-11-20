within ThermoSysPro.Fluid.Examples.SimpleExamples.Media;
model TestMoltenSalt
  extends ThermoSysPro.UsersGuide.Icons.Example;

  package Medium = ThermoSysPro.Properties.Media.MoltenSalt;

  parameter Units.SI.AbsolutePressure p = 1e5;
  parameter Units.SI.Temperature T = 600;
  parameter Units.SI.SpecificEnthalpy h =
    ThermoSysPro.Properties.Fluid.SpecificEnthalpy_PT(p, T, 4, 0, 0, 0, 0, 0);
  parameter Medium.ThermodynamicState state = Medium.setState_phX(p, h, {1});
  parameter Real eps = 1e-6;
equation
  assert(abs(Medium.temperature(state) -
    ThermoSysPro.Properties.Fluid.Temperature_Ph(p, h, 4, 0, 0, 0, 0, 0)) < eps,
    "MoltenSalt medium temperature differs from legacy Fluid wrapper");
  assert(abs(Medium.density(state) -
    ThermoSysPro.Properties.Fluid.Density_Ph(p, h, 4, 0, 0, 0, 0, 0)) < eps,
    "MoltenSalt medium density differs from legacy Fluid wrapper");
  assert(abs(Medium.specificEnthalpy_pTX(p, T, {1}) - h) < eps,
    "MoltenSalt medium specificEnthalpy_pTX differs from legacy Fluid wrapper");
  assert(abs(Medium.specificInternalEnergy(state) -
    ThermoSysPro.Properties.Fluid.SpecificInternalEnergy_Ph_DO_NOT_USE(p, h, 4, 0, 0, 0, 0, 0)) < eps,
    "MoltenSalt medium internal energy differs from legacy Fluid assumption");
  assert(abs(Medium.density_derh_p(state) -
    ThermoSysPro.Properties.Fluid.Density_derh_Ph(p, h, 4, 0, 0, 0, 0, 0)) < eps,
    "MoltenSalt medium density_derh_p differs from legacy Fluid wrapper");
  assert(abs(Medium.density_derp_h(state) -
    ThermoSysPro.Properties.Fluid.Density_derp_Ph(p, h, 4, 0, 0, 0, 0, 0)) < eps,
    "MoltenSalt medium density_derp_h differs from legacy Fluid wrapper");
  annotation (experiment(StopTime=1));
end TestMoltenSalt;
