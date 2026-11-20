within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeBTh
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.WaterSteam;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,38})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeBTh volumeBTh(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,0})));
  Thermal.BoundaryConditions.HeatSource heatSource annotation (Placement(transformation(extent={{-10,-22},{10,-42}})));
equation
  connect(sourcePQ.C, volumeBTh.Ce1) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,0}));
  connect(volumeBTh.Ce2, sourceQ.C) annotation (Line(points={{10,0},{21,0},{21,7.21645e-16},{32,7.21645e-16}}, color={0,0,0}));
  connect(volumeBTh.Cs1, sink.C) annotation (Line(points={{0,10},{0,19},{-5.55112e-16,19},{-5.55112e-16,28}}, color={0,0,0}));
  connect(heatSource.C[1], volumeBTh.Cth) annotation (Line(points={{0,-22.2},{0,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeBTh;
