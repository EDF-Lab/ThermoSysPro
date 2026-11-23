within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeCTh_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = Properties.Media.FlueGases;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeCTh volumeCTh(redeclare package Medium = Medium, h(start=2.83057e6)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Thermal.BoundaryConditions.HeatSource heatSource(T0={573.15}) annotation (Placement(transformation(extent={{-10,-24},{10,-44}})));
equation
  connect(sourcePQ.C, volumeCTh.Ce1) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,0}));
  connect(sink.C, volumeCTh.Cs) annotation (Line(points={{30,0},{10,0}}, color={0,0,0}));
  connect(volumeCTh.Ce2, sourceQ.C) annotation (Line(points={{0,10},{0,30},{-30,30}}, color={0,0,0}));
  connect(heatSource.C[1], volumeCTh.Cth) annotation (Line(points={{0,-24.2},{0,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeCTh_FlueGases;
