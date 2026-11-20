within ThermoSysPro.Fluid.Examples.SimpleExamples.BoundaryConditions;
model TestRefH_Traces
  extends TestRefH(
    redeclare package Medium = Properties.Media.WaterSteam(
      extraPropertiesNames={"Trace"},
      C_nominal={0.1},
      C_default={0.2}),
    volumeA(
      dynamic_energy_balance=true,
      dynamic_mass_balance=true,
      steady_state=false,
      P0=2000000,
      h0=2600e3));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestRefH_Traces;
