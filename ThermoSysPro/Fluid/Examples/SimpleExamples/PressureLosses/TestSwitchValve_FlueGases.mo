within ThermoSysPro.Fluid.Examples.SimpleExamples.PressureLosses;
model TestSwitchValve_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases;
  ThermoSysPro.Fluid.PressureLosses.SwitchValve switchValve(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Logique.Constante constante annotation (Placement(transformation(extent={{-42,30},{-22,50}})));
equation
  connect(switchValve.C2, sink.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(switchValve.C1, sourcePQ.C) annotation (Line(points={{-10,0},{-30,0}}, color={0,0,0}));
  connect(constante.yL, switchValve.Ouv) annotation (Line(points={{-21,40},{0,40},{0,13.2}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestSwitchValve_FlueGases;
