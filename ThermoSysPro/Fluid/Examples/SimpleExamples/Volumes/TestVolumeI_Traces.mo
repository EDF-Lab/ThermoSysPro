within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeI_Traces
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam (
      extraPropertiesNames={"Trace"},
      C_nominal={0.1},
      C_default={0.2});
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(redeclare replaceable package Medium = Medium) annotation (Placement(transformation(extent={{20,20},{40,40}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    Q0=100,
    SubC0={0.5}) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeI volumeI(
    redeclare package Medium = Medium,
    V=1,
    dynamic_mass_balance=false) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(
    redeclare replaceable package Medium = Medium,
    Q0=100,
    SubC0={0.5}) annotation (Placement(transformation(extent={{-56,18},{-36,38}})));
equation
  connect(volumeI.Cs1, sink.C) annotation (Line(points={{8,8},{8,30},{20,30}}, color={0,0,0}));
  connect(sourcePQ.C, volumeI.Ce2) annotation (Line(points={{-30,0},{-12,0}}, color={0,0,0}));
  connect(sourceQ.C, volumeI.Ce1) annotation (Line(points={{-36,28},{-12,28},{-12,8}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeI_Traces;
