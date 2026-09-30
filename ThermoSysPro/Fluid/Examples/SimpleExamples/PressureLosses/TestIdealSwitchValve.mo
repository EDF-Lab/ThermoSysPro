within ThermoSysPro.Fluid.Examples.SimpleExamples.PressureLosses;
model TestIdealSwitchValve
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.PressureLosses.IdealSwitchValve idealSwitchValve(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Logique.Constante constante annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(idealSwitchValve.C2, sink.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(idealSwitchValve.C1, sourcePQ.C) annotation (Line(points={{-10,0},{-30,0}}, color={0,0,0}));
  connect(constante.yL, idealSwitchValve.Ouv) annotation (Line(points={{-19,40},{0,40},{0,13}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestIdealSwitchValve;
