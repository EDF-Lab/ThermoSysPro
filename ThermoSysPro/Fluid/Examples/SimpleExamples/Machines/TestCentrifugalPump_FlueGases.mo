within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestCentrifugalPump_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases;
  ThermoSysPro.Fluid.Machines.CentrifugalPump centrifugalPump(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(centrifugalPump.C2, sink.C) annotation (Line(points={{14,0},{30,0}}, color={0,0,0}));
  connect(centrifugalPump.C1, sourcePQ.C) annotation (Line(points={{-6,0},{-30,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestCentrifugalPump_FlueGases;
