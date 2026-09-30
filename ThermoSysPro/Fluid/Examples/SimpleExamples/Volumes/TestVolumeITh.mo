within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeITh
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam;

  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeITh volumeITh(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Thermal.BoundaryConditions.HeatSource heatSource annotation (Placement(transformation(extent={{-10,-24},{10,-44}})));
equation
  connect(volumeITh.Cs3, sink.C) annotation (Line(points={{10,-8},{20,-8},{20,0},{30,0}}, color={0,0,0}));
  connect(sourcePQ.C, volumeITh.Ce2) annotation (Line(points={{-32,0},{-10,0}}, color={0,0,0}));
  connect(sourceQ.C, volumeITh.Ce1) annotation (Line(points={{-30,20},{-10,20},{-10,8}}, color={0,0,0}));
  connect(heatSource.C[1], volumeITh.Cth) annotation (Line(points={{0,-24.2},{0,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeITh;
