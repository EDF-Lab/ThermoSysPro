within ThermoSysPro.Fluid.Examples.SimpleExamples.PressureLosses;
model TestInvSingularPressureLoss_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases;
  ThermoSysPro.Fluid.PressureLosses.InvSingularPressureLoss invSingularPressureLoss(
    redeclare replaceable package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(invSingularPressureLoss.C2, sinkP.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(invSingularPressureLoss.C1, sourcePQ.C) annotation (Line(points={{-10,0},{-30,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestInvSingularPressureLoss_FlueGases;
