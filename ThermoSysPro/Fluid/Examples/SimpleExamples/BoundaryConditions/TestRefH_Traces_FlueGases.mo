within ThermoSysPro.Fluid.Examples.SimpleExamples.BoundaryConditions;
model TestRefH_Traces_FlueGases
  extends TestRefH(
    redeclare package Medium = ThermoSysPro.Properties.Media.FlueGases(
      extraPropertiesNames={"Trace1", "Trace2", "Trace3"},
      C_nominal={0.1,0.2,0.3},
      C_default={0.2,0.3,0.4}),
    volumeA(
      dynamic_energy_balance=true,
      dynamic_mass_balance=true,
      dynamic_composition_balance=true,
      steady_state=true,
      P0=2000000,
      h0=2600e3,
      X0={0.1,0.2,0.3,0.2,0.2}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestRefH_Traces_FlueGases;
