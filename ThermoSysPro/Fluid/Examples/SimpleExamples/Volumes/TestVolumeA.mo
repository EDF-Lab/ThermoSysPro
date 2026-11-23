within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeA
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package
      Medium =                                                                           Medium) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare
      replaceable package Medium =                                                               Medium) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeA volumeA(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(redeclare replaceable
      package Medium =                                                                         Medium) annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
equation
  connect(sourcePQ.C,volumeA. Ce1) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,0}));
  connect(volumeA.Ce2, sourceQ.C) annotation (Line(points={{0,10},{0,30},{-30,30}}, color={0,0,0}));
  connect(volumeA.Cs1, sink.C)
    annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeA;
