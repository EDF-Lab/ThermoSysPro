within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeD
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeD volumeD(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{12,22},{32,42}})));
equation
  connect(sourcePQ.C, volumeD.Ce) annotation (Line(points={{-32,0},{-10,0}}, color={0,0,0}));
  connect(volumeD.Cs3, sink.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  connect(volumeD.Cs1, sinkQ.C) annotation (Line(points={{0,10},{0,32},{12,32}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeD;
