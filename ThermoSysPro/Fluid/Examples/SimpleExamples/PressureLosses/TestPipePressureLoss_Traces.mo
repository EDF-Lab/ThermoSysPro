within ThermoSysPro.Fluid.Examples.SimpleExamples.PressureLosses;
model TestPipePressureLoss_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam (extraPropertiesNames={"Trace"}, C_nominal={0.1}, C_default={0.2});
  ThermoSysPro.Fluid.PressureLosses.PipePressureLoss pipePressureLoss(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium, SubC0={0.3})
                                                                                                         annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(pipePressureLoss.C2, sink.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(pipePressureLoss.C1, sourcePQ.C) annotation (Line(points={{-10,0},{-30,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestPipePressureLoss_Traces;
