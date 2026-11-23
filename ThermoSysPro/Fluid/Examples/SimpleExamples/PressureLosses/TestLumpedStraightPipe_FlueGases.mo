within ThermoSysPro.Fluid.Examples.SimpleExamples.PressureLosses;
model TestLumpedStraightPipe_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases;
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe lumpedStraightPipe(
    redeclare replaceable package Medium = Medium,
    L=10,
    D=0.2) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
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
  connect(lumpedStraightPipe.C2, sink.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(lumpedStraightPipe.C1, sourcePQ.C) annotation (Line(points={{-10,0},{-30,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestLumpedStraightPipe_FlueGases;
