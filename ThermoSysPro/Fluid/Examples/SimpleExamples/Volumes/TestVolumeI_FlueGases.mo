within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeI_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{26,-18},{46,2}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeI volumeI(redeclare package Medium = Medium, h(start=2.83057e6)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,20})));
equation
  connect(sourcePQ.C, volumeI.Ce2) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,0}));
  connect(sourceQ.C, volumeI.Ce1) annotation (Line(points={{-30,20},{-10,20},{-10,8}}, color={0,0,0}));
  connect(volumeI.Cs3, sink.C) annotation (Line(points={{10,-8},{26,-8}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeI_FlueGases;
