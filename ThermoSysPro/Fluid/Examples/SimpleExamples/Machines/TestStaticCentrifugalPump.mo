within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestStaticCentrifugalPump
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump staticCentrifugalPump(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(staticCentrifugalPump.C2, sink.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(staticCentrifugalPump.C1, sourcePQ.C) annotation (Line(points={{-10,0},{-30,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticCentrifugalPump;
