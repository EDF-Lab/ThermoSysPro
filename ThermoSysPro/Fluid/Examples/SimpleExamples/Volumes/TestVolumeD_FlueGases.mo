within ThermoSysPro.Fluid.Examples.SimpleExamples.Volumes;
model TestVolumeD_FlueGases
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases;
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{26,16},{46,36}})));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ sourcePQ(
    redeclare replaceable package Medium = Medium,
    P0=4500000,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  ThermoSysPro.Fluid.Volumes.VolumeD volumeD(redeclare package Medium = Medium,h(start=2.83057e6)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ(
    redeclare replaceable package Medium = Medium,
    T0=573.15,
    option_temperature=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,0})));
equation
  connect(volumeD.Cs1, sink.C) annotation (Line(points={{0,10},{0,26},{26,26}}, color={0,0,0}));
  connect(sourcePQ.C, volumeD.Ce) annotation (Line(points={{-30,0},{-10,0}}, color={0,0,0}));
  connect(volumeD.Cs3, sinkQ.C) annotation (Line(points={{10,0},{30,0}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestVolumeD_FlueGases;
