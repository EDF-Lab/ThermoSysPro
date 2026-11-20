within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeB
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{20,28},{40,48}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeB volumeB(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,0})));
equation
  connect(sourcePQ.C, volumeB.Ce1) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,0}));
  connect(volumeB.Ce2, sourceQ.C) annotation (Line(points={{10,0},{21,0},{21,7.21645e-16},{32,7.21645e-16}}, color={0,0,0}));
  connect(volumeB.Cs1, sink.C) annotation (Line(points={{0,10},{0,38},{20,38}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeB;
